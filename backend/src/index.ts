import { Hono } from 'hono'
import { jwt, sign } from 'hono/jwt'

type Bindings = {
  DB: D1Database
  NUDGES: KVNamespace
  JWT_SECRET: string
}

type Variables = {
  jwtPayload: {
    id: string
    exp: number
  }
}

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>()
const partnershipRoles = ['owner', 'partner', 'supporter'] as const
type PartnershipRole = (typeof partnershipRoles)[number]
const completedCheckInPoints = 5
const sharedHabitBonusPoints = 5
const streakBadgeThresholds = [10, 100, 1000] as const
const levelTiers = [
  { id: 'newbie', name: 'Newbie', minPoints: 0 },
  { id: 'builder', name: 'Builder', minPoints: 50 },
  { id: 'momentum', name: 'Momentum', minPoints: 150 },
  { id: 'anchor', name: 'Anchor', minPoints: 500 },
  { id: 'legend', name: 'Legend', minPoints: 1000 },
] as const

// --- Helpers ---
async function hashPassword(password: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(password);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

let ensurePartnershipSchemaPromise: Promise<void> | null = null
let ensureGamificationSchemaPromise: Promise<void> | null = null

function normalizeRole(value: unknown): PartnershipRole {
  if (typeof value === 'string' && partnershipRoles.includes(value as PartnershipRole)) {
    return value as PartnershipRole
  }
  return 'partner'
}

async function ensurePartnershipRoleSchema(env: Bindings): Promise<void> {
  if (!ensurePartnershipSchemaPromise) {
    ensurePartnershipSchemaPromise = (async () => {
      const pragma = await env.DB.prepare('PRAGMA table_info(partnerships)').all()
      const columns = (pragma.results ?? []) as Array<{ name?: string }>
      const hasRoleColumn = columns.some((column) => column.name === 'role')
      if (!hasRoleColumn) {
        await env.DB.prepare(
          "ALTER TABLE partnerships ADD COLUMN role TEXT NOT NULL DEFAULT 'partner'"
        ).run()
      }

      await env.DB.prepare(
        "UPDATE partnerships SET role = 'partner' WHERE role IS NULL OR TRIM(role) = ''"
      ).run()
      await env.DB.prepare(
        'CREATE INDEX IF NOT EXISTS idx_partnerships_user_habit_role ON partnerships(user_id, habit_id, role)'
      ).run()
      await env.DB.prepare(
        'CREATE INDEX IF NOT EXISTS idx_partnerships_partner_habit ON partnerships(partner_id, habit_id)'
      ).run()
    })().catch((error) => {
      ensurePartnershipSchemaPromise = null
      throw error
    })
  }

  await ensurePartnershipSchemaPromise
}

async function areAcceptedFriends(env: Bindings, leftUserId: string, rightUserId: string): Promise<boolean> {
  const result = await env.DB.prepare(`
    SELECT id FROM friend_requests
    WHERE status = 'accepted'
    AND ((requester_id = ? AND recipient_id = ?) OR (requester_id = ? AND recipient_id = ?))
    LIMIT 1
  `).bind(leftUserId, rightUserId, rightUserId, leftUserId).first()

  return Boolean(result)
}

async function getHabitOwnerId(env: Bindings, habitId: string): Promise<string | null> {
  const habit = await env.DB.prepare('SELECT user_id FROM habits WHERE id = ?').bind(habitId).first<{ user_id: string }>()
  return habit?.user_id ?? null
}

async function ensureOwnerMembership(env: Bindings, habitId: string, ownerUserId: string): Promise<void> {
  await ensurePartnershipRoleSchema(env)
  await env.DB.prepare(`
    INSERT INTO partnerships (user_id, partner_id, habit_id, role)
    VALUES (?, ?, ?, 'owner')
    ON CONFLICT(user_id, partner_id, habit_id) DO UPDATE SET role = 'owner'
  `).bind(ownerUserId, ownerUserId, habitId).run()
}

async function getViewerHabitRole(env: Bindings, userId: string, habitId: string): Promise<PartnershipRole | null> {
  await ensurePartnershipRoleSchema(env)
  const roleRow = await env.DB.prepare(`
    SELECT role
    FROM partnerships
    WHERE user_id = ? AND habit_id = ?
    ORDER BY
      CASE role
        WHEN 'owner' THEN 0
        WHEN 'partner' THEN 1
        ELSE 2
      END
    LIMIT 1
  `).bind(userId, habitId).first<{ role: string }>()

  return roleRow ? normalizeRole(roleRow.role) : null
}

async function ensureParticipantMembership(
  env: Bindings,
  habitId: string,
  participantUserId: string,
  participantRole: PartnershipRole,
): Promise<void> {
  await ensurePartnershipRoleSchema(env)

  const ownerUserId = await getHabitOwnerId(env, habitId)
  if (!ownerUserId) {
    throw new Error(`Habit ${habitId} not found while attaching participant ${participantUserId}`)
  }

  await ensureOwnerMembership(env, habitId, ownerUserId)

  const participantRows = await env.DB.prepare(`
    SELECT DISTINCT user_id, role
    FROM partnerships
    WHERE habit_id = ?
  `).bind(habitId).all()

  const roleByUserId = new Map<string, PartnershipRole>()
  roleByUserId.set(ownerUserId, 'owner')

  for (const row of (participantRows.results ?? []) as Array<{ user_id?: string; role?: string }>) {
    if (!row.user_id) continue
    const normalized = row.user_id === ownerUserId ? 'owner' : normalizeRole(row.role)
    const current = roleByUserId.get(row.user_id)
    if (current === 'owner') continue
    roleByUserId.set(row.user_id, normalized)
  }

  await env.DB.prepare(`
    INSERT INTO partnerships (user_id, partner_id, habit_id, role)
    VALUES (?, ?, ?, ?)
    ON CONFLICT(user_id, partner_id, habit_id) DO UPDATE SET role = excluded.role
  `).bind(participantUserId, participantUserId, habitId, participantRole).run()

  for (const [existingUserId, existingRole] of roleByUserId.entries()) {
    if (existingUserId === participantUserId) continue

    await env.DB.prepare(`
      INSERT INTO partnerships (user_id, partner_id, habit_id, role)
      VALUES (?, ?, ?, ?), (?, ?, ?, ?)
      ON CONFLICT(user_id, partner_id, habit_id) DO UPDATE SET role = excluded.role
    `).bind(
      existingUserId, participantUserId, habitId, existingRole,
      participantUserId, existingUserId, habitId, participantRole,
    ).run()
  }

  if (participantRole === 'supporter') {
    await unlockAchievement(env, ownerUserId, 'first_supporter', `supporter:${habitId}:${participantUserId}`)
  }
}

function deriveLevel(totalPoints: number) {
  return [...levelTiers].reverse().find((tier) => totalPoints >= tier.minPoints) ?? levelTiers[0]
}

function toLogDate(value: string): string {
  const parsed = new Date(value)
  if (Number.isNaN(parsed.getTime())) return value.slice(0, 10)
  return parsed.toISOString().slice(0, 10)
}

async function ensureGamificationSchema(env: Bindings): Promise<void> {
  if (!ensureGamificationSchemaPromise) {
    ensureGamificationSchemaPromise = (async () => {
      const userPragma = await env.DB.prepare('PRAGMA table_info(users)').all()
      const userColumns = (userPragma.results ?? []) as Array<{ name?: string }>
      if (!userColumns.some((column) => column.name === 'total_score')) {
        await env.DB.prepare('ALTER TABLE users ADD COLUMN total_score INTEGER NOT NULL DEFAULT 0').run()
      }

      await env.DB.prepare(`
        CREATE TABLE IF NOT EXISTS user_score_events (
          user_id TEXT NOT NULL,
          source_event_id TEXT NOT NULL,
          points INTEGER NOT NULL,
          reason TEXT NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (user_id, source_event_id)
        )
      `).run()
      await env.DB.prepare(`
        CREATE TABLE IF NOT EXISTS user_achievements (
          user_id TEXT NOT NULL,
          achievement_id TEXT NOT NULL,
          unlocked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          source_event_id TEXT NOT NULL,
          PRIMARY KEY (user_id, achievement_id)
        )
      `).run()
      await env.DB.prepare('CREATE INDEX IF NOT EXISTS idx_habit_logs_user_habit_status_date ON habit_logs(user_id, habit_id, status, logged_at)').run()
      await env.DB.prepare('CREATE INDEX IF NOT EXISTS idx_score_events_user_created ON user_score_events(user_id, created_at)').run()
      await env.DB.prepare('CREATE INDEX IF NOT EXISTS idx_achievements_user_unlocked ON user_achievements(user_id, unlocked_at)').run()
      await env.DB.prepare('CREATE INDEX IF NOT EXISTS idx_users_score ON users(total_score DESC)').run()
    })().catch((error) => {
      ensureGamificationSchemaPromise = null
      throw error
    })
  }

  await ensureGamificationSchemaPromise
}

async function awardScoreEvent(
  env: Bindings,
  userId: string,
  sourceEventId: string,
  points: number,
  reason: string,
): Promise<boolean> {
  await ensureGamificationSchema(env)
  const result = await env.DB.prepare(`
    INSERT INTO user_score_events (user_id, source_event_id, points, reason)
    VALUES (?, ?, ?, ?)
    ON CONFLICT(user_id, source_event_id) DO NOTHING
  `).bind(userId, sourceEventId, points, reason).run()

  if ((result.meta.changes ?? 0) === 0) return false

  await env.DB.prepare('UPDATE users SET total_score = total_score + ? WHERE id = ?').bind(points, userId).run()
  return true
}

async function unlockAchievement(
  env: Bindings,
  userId: string,
  achievementId: string,
  sourceEventId: string,
): Promise<boolean> {
  await ensureGamificationSchema(env)
  const result = await env.DB.prepare(`
    INSERT INTO user_achievements (user_id, achievement_id, source_event_id)
    VALUES (?, ?, ?)
    ON CONFLICT(user_id, achievement_id) DO NOTHING
  `).bind(userId, achievementId, sourceEventId).run()

  return (result.meta.changes ?? 0) > 0
}

async function getCompletedStreak(env: Bindings, userId: string, habitId: string): Promise<number> {
  const { results } = await env.DB.prepare(`
    SELECT DISTINCT date(logged_at) as log_date
    FROM habit_logs
    WHERE user_id = ? AND habit_id = ? AND status = 'completed'
    ORDER BY log_date DESC
  `).bind(userId, habitId).all()

  const dates = (results ?? [])
    .map((row) => String((row as { log_date?: unknown }).log_date ?? ''))
    .filter(Boolean)
  const dateSet = new Set(dates)
  if (dateSet.size === 0) return 0

  let streak = 0
  const cursor = new Date(`${dates[0]}T00:00:00.000Z`)
  while (dateSet.has(cursor.toISOString().slice(0, 10))) {
    streak += 1
    cursor.setUTCDate(cursor.getUTCDate() - 1)
  }
  return streak
}

async function unlockStreakBadges(env: Bindings, userId: string, habitId: string, logId: string): Promise<void> {
  const streak = await getCompletedStreak(env, userId, habitId)
  for (const threshold of streakBadgeThresholds) {
    if (streak >= threshold) {
      await unlockAchievement(env, userId, `${threshold}_streak`, `streak:${threshold}:${habitId}:${logId}`)
    }
  }
}

async function awardSharedHabitBonusIfReady(env: Bindings, habitId: string, logDate: string): Promise<void> {
  await ensurePartnershipRoleSchema(env)
  const participantResult = await env.DB.prepare(`
    SELECT DISTINCT user_id
    FROM partnerships
    WHERE habit_id = ? AND user_id = partner_id AND role IN ('owner', 'partner')
  `).bind(habitId).all()

  const participantIds = (participantResult.results ?? [])
    .map((row) => String((row as { user_id?: unknown }).user_id ?? ''))
    .filter(Boolean)

  if (participantIds.length < 2) return

  const completedResult = await env.DB.prepare(`
    SELECT DISTINCT user_id
    FROM habit_logs
    WHERE habit_id = ? AND status = 'completed' AND date(logged_at) = ?
  `).bind(habitId, logDate).all()
  const completedUserIds = new Set(
    (completedResult.results ?? []).map((row) => String((row as { user_id?: unknown }).user_id ?? '')),
  )

  if (!participantIds.every((participantId) => completedUserIds.has(participantId))) return

  for (const participantId of participantIds) {
    await awardScoreEvent(
      env,
      participantId,
      `shared_bonus:${habitId}:${logDate}`,
      sharedHabitBonusPoints,
      'shared_habit_all_participants_completed',
    )
  }
}

async function getGamificationPayload(env: Bindings, userId: string) {
  await ensureGamificationSchema(env)
  const user = await env.DB.prepare('SELECT total_score FROM users WHERE id = ?').bind(userId).first<{ total_score: number }>()
  const totalPoints = Number(user?.total_score ?? 0)
  const level = deriveLevel(totalPoints)
  const { results: achievements } = await env.DB.prepare(`
    SELECT achievement_id, unlocked_at, source_event_id
    FROM user_achievements
    WHERE user_id = ?
    ORDER BY unlocked_at DESC
  `).bind(userId).all()
  const { results: newlyUnlocked } = await env.DB.prepare(`
    SELECT achievement_id, unlocked_at, source_event_id
    FROM user_achievements
    WHERE user_id = ? AND datetime(unlocked_at) >= datetime('now', '-1 day')
    ORDER BY unlocked_at DESC
    LIMIT 10
  `).bind(userId).all()

  return {
    total_points: totalPoints,
    level: level.name,
    level_id: level.id,
    badges: achievements ?? [],
    newly_unlocked_badges: newlyUnlocked ?? [],
  }
}

// 1. Auth Endpoints
app.post('/api/auth/register', async (c) => {
  const { username, password, email } = await c.req.json();

  if (!username || !password || !email) {
    return c.json({ error: 'Missing username, password, or email' }, 400);
  }

  // Check if username or email exists
  const existingUser = await c.env.DB.prepare('SELECT id FROM users WHERE username = ? OR email = ?').bind(username, email).first();
  if (existingUser) {
    return c.json({ error: 'Username or email already exists' }, 409);
  }

  const id = crypto.randomUUID();
  const avatar_url = `https://api.dicebear.com/7.x/avataaars/svg?seed=${username}`;
  const password_hash = await hashPassword(password);

  await c.env.DB.prepare(
    'INSERT INTO users (id, username, email, password_hash, avatar_url, total_score) VALUES (?, ?, ?, ?, ?, ?)'
  ).bind(id, username, email, password_hash, avatar_url, 0).run();

  const payload = {
    id: id,
    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30, // 30 days
  };
  const secret = c.env.JWT_SECRET || 'fallback_local_secret';
  const token = await sign(payload, secret);

  return c.json({ token, user_id: id, username, email, avatar_url });
});

app.post('/api/auth/request-pin', async (c) => {
  const { email } = await c.req.json();
  if (!email) return c.json({ error: 'Missing email' }, 400);
  
  const user = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?').bind(email).first();
  if (!user) return c.json({ error: 'Email not found' }, 404);

  const pin = Math.floor(100000 + Math.random() * 900000).toString(); // 6 digits
  const pinHash = await hashPassword(pin);
  const expiresAt = Math.floor(Date.now() / 1000) + 10 * 60; // 10 minutes from now
  
  await c.env.DB.prepare(
    'INSERT INTO auth_pins (email, pin_hash, expires_at) VALUES (?, ?, ?) ON CONFLICT(email) DO UPDATE SET pin_hash = excluded.pin_hash, expires_at = excluded.expires_at'
  ).bind(email, pinHash, expiresAt).run();

  console.log(`\n\n================================\n[auth] Password Reset PIN for ${email}: ${pin}\n================================\n\n`);
  
  return c.json({ success: true, message: 'PIN generated and printed to server logs' });
});

app.post('/api/auth/reset-password', async (c) => {
  const { email, pin, new_password } = await c.req.json();
  if (!email || !pin || !new_password) return c.json({ error: 'Missing fields' }, 400);

  const pinRecord = await c.env.DB.prepare('SELECT pin_hash, expires_at FROM auth_pins WHERE email = ?').bind(email).first() as any;
  if (!pinRecord) return c.json({ error: 'No PIN requested or it expired' }, 400);

  const now = Math.floor(Date.now() / 1000);
  if (pinRecord.expires_at < now) {
    return c.json({ error: 'PIN expired' }, 400);
  }

  const expectedHash = await hashPassword(pin);
  if (expectedHash !== pinRecord.pin_hash) {
    return c.json({ error: 'Invalid PIN' }, 400);
  }

  const newPasswordHash = await hashPassword(new_password);
  await c.env.DB.prepare('UPDATE users SET password_hash = ? WHERE email = ?').bind(newPasswordHash, email).run();
  await c.env.DB.prepare('DELETE FROM auth_pins WHERE email = ?').bind(email).run();

  return c.json({ success: true });
});

app.post('/api/auth/login', async (c) => {
  const { username, password, user_id } = await c.req.json()

  if (user_id) {
    // Backwards compatibility for twin-app testing (auto-login via SEED_USER_ID)
    const user = await c.env.DB.prepare('SELECT id, username, avatar_url FROM users WHERE id = ?').bind(user_id).first()
    if (!user) return c.json({ error: 'User not found' }, 404)

    const payload = { id: user_id, exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30 }
    const secret = c.env.JWT_SECRET || 'fallback_local_secret'
    const token = await sign(payload, secret)
    return c.json({ token, user_id, username: user.username, avatar_url: user.avatar_url })
  }

  if (!username || !password) {
    return c.json({ error: 'Missing username or password' }, 400)
  }

  const user = await c.env.DB.prepare('SELECT id, password_hash, username, avatar_url FROM users WHERE username = ?').bind(username).first()
  if (!user) {
    return c.json({ error: 'Invalid username or password' }, 401)
  }

  const password_hash = await hashPassword(password);
  if (user.password_hash !== password_hash) {
    return c.json({ error: 'Invalid username or password' }, 401)
  }

  const payload = {
    id: user.id,
    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30, // 30 days
  }
  const secret = c.env.JWT_SECRET || 'fallback_local_secret'
  const token = await sign(payload, secret)
  
  return c.json({ token, user_id: user.id, username: user.username, avatar_url: user.avatar_url })
})

app.use('/api/user/*', async (c, next) => {
  const secret = c.env.JWT_SECRET || 'fallback_local_secret'
  const jwtMiddleware = jwt({ secret, alg: 'HS256' })
  return jwtMiddleware(c, next)
})

app.put('/api/user/avatar', async (c) => {
  const payload = c.get('jwtPayload')
  const { avatar_url } = await c.req.json()
  if (!avatar_url) return c.json({ error: 'Missing avatar_url' }, 400)
  
  await c.env.DB.prepare('UPDATE users SET avatar_url = ? WHERE id = ?').bind(avatar_url, payload.id).run()
  return c.json({ success: true, avatar_url })
})
// Apply JWT middleware to all protected routes
app.use('/api/social/*', async (c, next) => {
  const secret = c.env.JWT_SECRET || 'fallback_local_secret'
  const jwtMiddleware = jwt({ secret, alg: 'HS256' })
  return jwtMiddleware(c, next)
})

app.use('/api/sync/*', async (c, next) => {
  const secret = c.env.JWT_SECRET || 'fallback_local_secret'
  const jwtMiddleware = jwt({ secret, alg: 'HS256' })
  return jwtMiddleware(c, next)
})

app.get('/api/social/user/:id/profile', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  const payload = c.get('jwtPayload')
  const viewerUserId = payload.id
  const targetUserId = c.req.param('id')

  const user = await c.env.DB.prepare('SELECT id, username, avatar_url, total_score FROM users WHERE id = ?').bind(targetUserId).first()
  if (!user) return c.json({ error: 'User not found' }, 404)

  let activeHabits: unknown[] = []
  if (viewerUserId === targetUserId) {
    const result = await c.env.DB.prepare(`
      SELECT h.id, h.title, h.target_duration, h.color_hex, hp.current_duration, 'owner' as role
      FROM habits h
      LEFT JOIN habit_progress hp ON hp.habit_id = h.id AND hp.user_id = h.user_id
      WHERE h.user_id = ? AND h.status = 'active'
    `).bind(targetUserId).all()
    activeHabits = result.results ?? []
  } else {
    const isFriend = await areAcceptedFriends(c.env, viewerUserId, targetUserId)
    if (!isFriend) {
      return c.json({ error: 'Unauthorized: Not accepted friends' }, 403)
    }

    const result = await c.env.DB.prepare(`
      SELECT DISTINCT
        h.id,
        h.title,
        h.target_duration,
        h.color_hex,
        hp.current_duration,
        p.role
      FROM habits h
      JOIN partnerships p
        ON p.habit_id = h.id
       AND p.user_id = ?
       AND p.partner_id = ?
      LEFT JOIN habit_progress hp
        ON hp.habit_id = h.id
       AND hp.user_id = h.user_id
      WHERE h.status = 'active'
    `).bind(viewerUserId, targetUserId).all()
    activeHabits = result.results ?? []
  }

  return c.json({
    user,
    habits: activeHabits
  })
})

// Friend Requests
app.get('/api/social/friend-request', async (c) => {
  const payload = c.get('jwtPayload')
  const userId = payload.id

  const { results: friendRequests } = await c.env.DB.prepare(`
    SELECT fr.id, fr.requester_id, u.username as requester_username, u.avatar_url as requester_avatar, fr.status, fr.created_at
    FROM friend_requests fr
    JOIN users u ON fr.requester_id = u.id
    WHERE fr.recipient_id = ? AND fr.status = 'pending'
  `).bind(userId).all()

  return c.json({ friend_requests: friendRequests })
})

app.post('/api/social/friend-request', async (c) => {
  const payload = c.get('jwtPayload')
  const sender_id = payload.id
  const { target_user_id } = await c.req.json()

  if (!target_user_id) return c.json({ error: 'Missing target_user_id' }, 400)

  const id = crypto.randomUUID()
  await c.env.DB.prepare(
    'INSERT INTO friend_requests (id, requester_id, recipient_id) VALUES (?, ?, ?)'
  ).bind(id, sender_id, target_user_id).run()

  return c.json({ success: true, request_id: id })
})

app.post('/api/social/friend-request/accept', async (c) => {
  const payload = c.get('jwtPayload')
  const recipient_id = payload.id
  const { request_id } = await c.req.json()

  if (!request_id) return c.json({ error: 'Missing request_id' }, 400)

  // Update status to accepted
  const result = await c.env.DB.prepare(
    'UPDATE friend_requests SET status = "accepted" WHERE id = ? AND recipient_id = ?'
  ).bind(request_id, recipient_id).run()

  if (result.meta.changes === 0) {
    return c.json({ error: 'Request not found or unauthorized' }, 404)
  }

  return c.json({ success: true })
})

// Mutual Habit Tracking (Partnerships)
app.post('/api/social/partnerships', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  const payload = c.get('jwtPayload')
  const sender_id = payload.id
  const { target_user_id, habit_id } = await c.req.json()

  if (!target_user_id || !habit_id) {
    return c.json({ error: 'Missing target_user_id or habit_id' }, 400)
  }

  // Authorize: Must be accepted friends
  const ownerUserId = await getHabitOwnerId(c.env, habit_id)
  if (ownerUserId !== sender_id) {
    return c.json({ error: 'Unauthorized: Only owners can add partners' }, 403)
  }

  const isFriend = await areAcceptedFriends(c.env, sender_id, target_user_id)
  if (!isFriend) {
    return c.json({ error: 'Unauthorized: Not accepted friends' }, 403)
  }

  await ensureParticipantMembership(c.env, habit_id, target_user_id, 'partner')

  return c.json({ success: true })
})

// Send Nudge
app.post('/api/social/nudge', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  const payload = c.get('jwtPayload')
  const sender_id = payload.id
  const { target_user_id } = await c.req.json()

  if (!target_user_id) {
    return c.json({ error: 'Missing target_user_id' }, 400)
  }

  const permissionRow = await c.env.DB.prepare(`
    SELECT role
    FROM partnerships
    WHERE user_id = ? AND partner_id = ?
    ORDER BY
      CASE role
        WHEN 'owner' THEN 0
        WHEN 'partner' THEN 1
        ELSE 2
      END
    LIMIT 1
  `).bind(sender_id, target_user_id).first<{ role: string }>()

  const senderRole = permissionRow ? normalizeRole(permissionRow.role) : null
  if (!senderRole) {
    return c.json({ error: 'Unauthorized: Not a participant in a shared habit' }, 403)
  }

  const key = `nudge:${target_user_id}:${sender_id}`
  
  // Set in KV with 24 hours TTL (86400 seconds)
  await c.env.NUDGES.put(key, new Date().toISOString(), { expirationTtl: 86400 })
  await unlockAchievement(c.env, sender_id, 'first_nudge', `nudge:${sender_id}:${target_user_id}`)

  return c.json({ success: true, message: 'Nudge sent successfully' })
})

// Private Messages
app.post('/api/social/private-message', async (c) => {
  const payload = c.get('jwtPayload')
  const sender_id = payload.id
  const { target_user_id, message, milestone_type } = await c.req.json()

  if (!target_user_id || !message) {
    return c.json({ error: 'Missing target_user_id or message' }, 400)
  }

  const id = crypto.randomUUID()
  await c.env.DB.prepare(
    'INSERT INTO private_messages (id, sender_id, recipient_id, message, milestone_type) VALUES (?, ?, ?, ?, ?)'
  ).bind(id, sender_id, target_user_id, message, milestone_type || null).run()

  return c.json({ success: true, message_id: id })
})

// Habit Invitations
app.post('/api/social/habit-invitation', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  const payload = c.get('jwtPayload')
  const requester_id = payload.id
  const { target_user_id, habit_id } = await c.req.json()

  if (!target_user_id || !habit_id) {
    return c.json({ error: 'Missing target_user_id or habit_id' }, 400)
  }
  if (target_user_id === requester_id) {
    return c.json({ error: 'Cannot invite yourself' }, 400)
  }

  const ownHabit = await c.env.DB.prepare(
    'SELECT id FROM habits WHERE id = ? AND user_id = ?'
  ).bind(habit_id, requester_id).first()
  if (!ownHabit) {
    return c.json({ error: 'Habit not found or unauthorized' }, 404)
  }

  const requesterRole = await getViewerHabitRole(c.env, requester_id, habit_id)
  if (requesterRole !== 'owner') {
    return c.json({ error: 'Unauthorized: Only owners can invite partners' }, 403)
  }

  const isFriend = await areAcceptedFriends(c.env, requester_id, target_user_id)
  if (!isFriend) {
    return c.json({ error: 'Unauthorized: Not accepted friends' }, 403)
  }

  const existing = await c.env.DB.prepare(`
    SELECT id, status FROM habit_invitations
    WHERE requester_id = ? AND recipient_id = ? AND habit_id = ? AND status = 'pending'
  `).bind(requester_id, target_user_id, habit_id).first()
  if (existing) {
    return c.json({ success: true, invitation_id: existing.id, status: existing.status })
  }

  const id = crypto.randomUUID()
  await c.env.DB.prepare(
    'INSERT INTO habit_invitations (id, requester_id, recipient_id, habit_id) VALUES (?, ?, ?, ?)'
  ).bind(id, requester_id, target_user_id, habit_id).run()

  return c.json({ success: true, invitation_id: id })
})

app.post('/api/social/habit-invitation/accept', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  const payload = c.get('jwtPayload')
  const recipient_id = payload.id
  const { invitation_id } = await c.req.json()

  if (!invitation_id) return c.json({ error: 'Missing invitation_id' }, 400)

  // 1. Fetch invitation
  const invite = await c.env.DB.prepare(
    'SELECT requester_id, habit_id FROM habit_invitations WHERE id = ? AND recipient_id = ? AND status = "pending"'
  ).bind(invitation_id, recipient_id).first<{ requester_id: string; habit_id: string }>()

  if (!invite) return c.json({ error: 'Invitation not found or already processed' }, 404)

  // 2. Update status to accepted
  await c.env.DB.prepare(
    'UPDATE habit_invitations SET status = "accepted" WHERE id = ?'
  ).bind(invitation_id).run()

  await ensureParticipantMembership(c.env, invite.habit_id, recipient_id, 'partner')

  return c.json({ success: true })
})

app.post('/api/social/habit-invitation/decline', async (c) => {
  const payload = c.get('jwtPayload')
  const recipient_id = payload.id
  const { invitation_id } = await c.req.json()

  if (!invitation_id) return c.json({ error: 'Missing invitation_id' }, 400)

  const result = await c.env.DB.prepare(
    'UPDATE habit_invitations SET status = "declined" WHERE id = ? AND recipient_id = ? AND status = "pending"'
  ).bind(invitation_id, recipient_id).run()

  if (result.meta.changes === 0) {
    return c.json({ error: 'Invitation not found or already processed' }, 404)
  }

  return c.json({ success: true })
})

// Habit Sync
app.post('/api/sync/habit', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const { habit_id, title, target_duration, color_hex, status, created_at, updated_at } = await c.req.json()

  if (!habit_id || !title || target_duration === undefined) {
    return c.json({ error: 'Missing required habit fields' }, 400)
  }

  const existingHabit = await c.env.DB.prepare('SELECT user_id FROM habits WHERE id = ?').bind(habit_id).first<{ user_id: string }>()
  if (existingHabit && existingHabit.user_id !== userId) {
    return c.json({ error: 'Unauthorized: Only owners can update or archive a habit' }, 403)
  }

  await c.env.DB.prepare(`
    INSERT INTO habits (id, user_id, title, target_duration, color_hex, status, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      title = excluded.title,
      target_duration = excluded.target_duration,
      color_hex = excluded.color_hex,
      status = excluded.status,
      updated_at = excluded.updated_at
  `).bind(
    habit_id, userId, title, target_duration, color_hex || null, status || 'active',
    created_at || new Date().toISOString(), updated_at || new Date().toISOString()
  ).run()
  await ensureOwnerMembership(c.env, habit_id, userId)

  return c.json({ success: true })
})

app.post('/api/sync/log', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  await ensureGamificationSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const { log_id, habit_id, status, logged_at } = await c.req.json()

  if (!log_id || !habit_id || !status) {
    return c.json({ error: 'Missing required log fields' }, 400)
  }

  const viewerRole = await getViewerHabitRole(c.env, userId, habit_id)
  if (viewerRole !== 'owner' && viewerRole !== 'partner') {
    return c.json({ error: 'Unauthorized: Only owners or partners can log progress' }, 403)
  }

  const resolvedLoggedAt = logged_at || new Date().toISOString()

  // Insert log
  const insertResult = await c.env.DB.prepare(`
    INSERT INTO habit_logs (id, user_id, habit_id, status, logged_at)
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(id) DO NOTHING
  `).bind(log_id, userId, habit_id, status, resolvedLoggedAt).run()

  const isNewLog = (insertResult.meta.changes ?? 0) > 0

  if (isNewLog && status === 'completed') {
    await c.env.DB.prepare(`
      INSERT INTO habit_progress (user_id, habit_id, current_duration)
      VALUES (?, ?, 1)
      ON CONFLICT(user_id, habit_id) DO UPDATE SET
        current_duration = current_duration + 1
    `).bind(userId, habit_id).run()
    await awardScoreEvent(c.env, userId, `check_in:${log_id}`, completedCheckInPoints, 'completed_check_in')
    await unlockAchievement(c.env, userId, 'first_check_in', `check_in:${log_id}`)
    await unlockStreakBadges(c.env, userId, habit_id, log_id)
    await awardSharedHabitBonusIfReady(c.env, habit_id, toLogDate(resolvedLoggedAt))
  }

  return c.json({ success: true, accepted: isNewLog })
})

// Sync Daily
app.get('/api/sync/daily', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  await ensureGamificationSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id

  // 1. Fetch Partnerships from D1
  const { results } = await c.env.DB.prepare(`
    SELECT 
      u.username, 
      u.avatar_url, 
      hp.current_duration,
      EXISTS(
        SELECT 1
        FROM habit_logs hl
        WHERE hl.user_id = p.partner_id
          AND hl.habit_id = p.habit_id
          AND date(hl.logged_at) = date('now')
          AND hl.status = 'completed'
      ) as has_completed_today,
      h.title,
      h.color_hex,
      h.target_duration,
      p.habit_id,
      p.partner_id,
      p.role
    FROM partnerships p
    JOIN users u ON p.partner_id = u.id
    LEFT JOIN habit_progress hp ON p.partner_id = hp.user_id AND p.habit_id = hp.habit_id
    LEFT JOIN habits h ON p.habit_id = h.id
    WHERE p.user_id = ?
      AND p.partner_id != ?
  `).bind(userId, userId).all()

  // 2. Fetch Nudges from KV
  const nudgePrefix = `nudge:${userId}:`
  const nudgeList = await c.env.NUDGES.list({ prefix: nudgePrefix })
  
  const nudges = []
  for (const key of nudgeList.keys) {
    const senderId = key.name.replace(nudgePrefix, '')
    const timestamp = await c.env.NUDGES.get(key.name)
    nudges.push({ senderId, timestamp })
    
    // Nudges are ephemeral, so we delete them after they are consumed
    await c.env.NUDGES.delete(key.name)
  }

  // 3. Fetch Private Messages
  const { results: messages } = await c.env.DB.prepare(`
    SELECT id, sender_id, message, milestone_type, created_at
    FROM private_messages
    WHERE recipient_id = ?
  `).bind(userId).all()

  // 4. Fetch Habit Invitations
  const { results: invitations } = await c.env.DB.prepare(`
    SELECT id, requester_id, habit_id, status, created_at
    FROM habit_invitations
    WHERE recipient_id = ? AND status = 'pending'
  `).bind(userId).all()

  // 5. Fetch Friend Requests
  const { results: friendRequests } = await c.env.DB.prepare(`
    SELECT fr.id, fr.requester_id, u.username as requester_username, u.avatar_url as requester_avatar, fr.status, fr.created_at
    FROM friend_requests fr
    JOIN users u ON fr.requester_id = u.id
    WHERE fr.recipient_id = ? AND fr.status = 'pending'
  `).bind(userId).all()

  // 6. Fetch Accepted Friends
  const { results: acceptedFriends } = await c.env.DB.prepare(`
    SELECT DISTINCT u.id as friend_id, u.username, u.avatar_url
    FROM friend_requests fr
    JOIN users u ON (
      (fr.requester_id = ? AND u.id = fr.recipient_id) OR
      (fr.recipient_id = ? AND u.id = fr.requester_id)
    )
    WHERE fr.status = 'accepted'
  `).bind(userId, userId).all()

  const gamification = await getGamificationPayload(c.env, userId)

  return c.json({
    partners: results,
    nudges: nudges,
    messages: messages,
    invitations: invitations,
    friend_requests: friendRequests,
    accepted_friends: acceptedFriends,
    gamification: gamification
  })
})

// --- New Leaderboard & Search Endpoints ---

app.get('/api/social/leaderboard', async (c) => {
  // Return top 100 users ordered by score
  const { results } = await c.env.DB.prepare(`
    SELECT id, username, avatar_url, total_score
    FROM users
    ORDER BY total_score DESC
    LIMIT 100
  `).all()

  return c.json({ leaderboard: results })
})

app.get('/api/social/search', async (c) => {
  const query = c.req.query('q')
  if (!query || query.length < 2) {
    return c.json({ results: [] })
  }

  const { results } = await c.env.DB.prepare(`
    SELECT id, username, avatar_url, total_score
    FROM users
    WHERE username LIKE ?
    LIMIT 20
  `).bind(`${query}%`).all()

  return c.json({ results })
})

app.post('/api/sync/score', async (c) => {
  return c.json({ error: 'Client score sync is deprecated; use /api/sync/log and /api/sync/daily gamification.' }, 410)
})

export default app
