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

// --- Helpers ---
async function hashPassword(password: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(password);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
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
  const targetUserId = c.req.param('id')
  
  const user = await c.env.DB.prepare('SELECT id, username, avatar_url, total_score FROM users WHERE id = ?').bind(targetUserId).first()
  if (!user) return c.json({ error: 'User not found' }, 404)

  const { results: activeHabits } = await c.env.DB.prepare(`
    SELECT h.id, h.title, h.target_duration, h.color_hex, hp.current_duration
    FROM habits h
    LEFT JOIN habit_progress hp ON hp.habit_id = h.id AND hp.user_id = h.user_id
    WHERE h.user_id = ? AND h.status = 'active'
  `).bind(targetUserId).all()

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
  const payload = c.get('jwtPayload')
  const sender_id = payload.id
  const { target_user_id, habit_id } = await c.req.json()

  if (!target_user_id || !habit_id) {
    return c.json({ error: 'Missing target_user_id or habit_id' }, 400)
  }

  // Authorize: Must be accepted friends
  const isFriend = await c.env.DB.prepare(`
    SELECT id FROM friend_requests 
    WHERE status = 'accepted' 
    AND ((requester_id = ? AND recipient_id = ?) OR (requester_id = ? AND recipient_id = ?))
  `).bind(sender_id, target_user_id, target_user_id, sender_id).first()

  if (!isFriend) {
    return c.json({ error: 'Unauthorized: Not accepted friends' }, 403)
  }

  // Insert symmetric partnership rows
  await c.env.DB.prepare(`
    INSERT OR IGNORE INTO partnerships (user_id, partner_id, habit_id) 
    VALUES (?, ?, ?), (?, ?, ?)
  `).bind(sender_id, target_user_id, habit_id, target_user_id, sender_id, habit_id).run()

  return c.json({ success: true })
})

// Send Nudge
app.post('/api/social/nudge', async (c) => {
  const payload = c.get('jwtPayload')
  const sender_id = payload.id
  const { target_user_id } = await c.req.json()

  if (!target_user_id) {
    return c.json({ error: 'Missing target_user_id' }, 400)
  }

  // Authorize: check if they are accepted friends OR partners
  const isFriend = await c.env.DB.prepare(`
    SELECT id FROM friend_requests 
    WHERE status = 'accepted' 
    AND ((requester_id = ? AND recipient_id = ?) OR (requester_id = ? AND recipient_id = ?))
  `).bind(sender_id, target_user_id, target_user_id, sender_id).first()

  const isPartner = await c.env.DB.prepare(`
    SELECT user_id FROM partnerships 
    WHERE (user_id = ? AND partner_id = ?) OR (user_id = ? AND partner_id = ?)
  `).bind(sender_id, target_user_id, target_user_id, sender_id).first()

  if (!isFriend && !isPartner) {
     return c.json({ error: 'Unauthorized: Not friends or partners' }, 403)
  }

  const key = `nudge:${target_user_id}:${sender_id}`
  
  // Set in KV with 24 hours TTL (86400 seconds)
  await c.env.NUDGES.put(key, new Date().toISOString(), { expirationTtl: 86400 })

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

  const isFriend = await c.env.DB.prepare(`
    SELECT id FROM friend_requests
    WHERE status = 'accepted'
    AND ((requester_id = ? AND recipient_id = ?) OR (requester_id = ? AND recipient_id = ?))
  `).bind(requester_id, target_user_id, target_user_id, requester_id).first()
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
  const payload = c.get('jwtPayload')
  const recipient_id = payload.id
  const { invitation_id } = await c.req.json()

  if (!invitation_id) return c.json({ error: 'Missing invitation_id' }, 400)

  // 1. Fetch invitation
  const invite = await c.env.DB.prepare(
    'SELECT requester_id, habit_id FROM habit_invitations WHERE id = ? AND recipient_id = ? AND status = "pending"'
  ).bind(invitation_id, recipient_id).first()

  if (!invite) return c.json({ error: 'Invitation not found or already processed' }, 404)

  // 2. Update status to accepted
  await c.env.DB.prepare(
    'UPDATE habit_invitations SET status = "accepted" WHERE id = ?'
  ).bind(invitation_id).run()

  // 3. Insert symmetric partnership rows
  await c.env.DB.prepare(`
    INSERT OR IGNORE INTO partnerships (user_id, partner_id, habit_id) 
    VALUES (?, ?, ?), (?, ?, ?)
  `).bind(invite.requester_id, recipient_id, invite.habit_id, recipient_id, invite.requester_id, invite.habit_id).run()

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
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const { habit_id, title, target_duration, color_hex, status, created_at, updated_at } = await c.req.json()

  if (!habit_id || !title || target_duration === undefined) {
    return c.json({ error: 'Missing required habit fields' }, 400)
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

  return c.json({ success: true })
})

app.post('/api/sync/log', async (c) => {
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const { log_id, habit_id, status, logged_at } = await c.req.json()

  if (!log_id || !habit_id || !status) {
    return c.json({ error: 'Missing required log fields' }, 400)
  }

  // Insert log
  await c.env.DB.prepare(`
    INSERT INTO habit_logs (id, user_id, habit_id, status, logged_at)
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(id) DO NOTHING
  `).bind(log_id, userId, habit_id, status, logged_at || new Date().toISOString()).run()

  // Update habit_progress (current_duration)
  // For simplicity, we just increment current_duration by 1 if status is completed, or similar logic.
  // Wait, drift UI uses target_duration / current_duration. The 'status' here might be 'completed'.
  // We can let the UI push the updated score in a separate sync, or increment it here.
  // Actually, we don't strictly need to update habit_progress table if we aren't using it yet, but let's do it for consistency.
  if (status === 'completed') {
    await c.env.DB.prepare(`
      INSERT INTO habit_progress (user_id, habit_id, current_duration)
      VALUES (?, ?, 1)
      ON CONFLICT(user_id, habit_id) DO UPDATE SET
        current_duration = current_duration + 1
    `).bind(userId, habit_id).run()
  }

  return c.json({ success: true })
})

// Sync Daily
app.get('/api/sync/daily', async (c) => {
  const payload = c.get('jwtPayload')
  const userId = payload.id

  // 1. Fetch Partnerships from D1
  const { results } = await c.env.DB.prepare(`
    SELECT 
      u.username, 
      u.avatar_url, 
      hp.current_duration,
      h.title,
      h.color_hex,
      h.target_duration,
      p.habit_id,
      p.partner_id
    FROM partnerships p
    JOIN users u ON p.partner_id = u.id
    LEFT JOIN habit_progress hp ON p.partner_id = hp.user_id AND p.habit_id = hp.habit_id
    LEFT JOIN habits h ON p.habit_id = h.id
    WHERE p.user_id = ?
  `).bind(userId).all()

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

  return c.json({
    partners: results,
    nudges: nudges,
    messages: messages,
    invitations: invitations,
    friend_requests: friendRequests,
    accepted_friends: acceptedFriends
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
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const { total_score } = await c.req.json()

  if (total_score === undefined) {
    return c.json({ error: 'Missing total_score' }, 400)
  }

  // Update user's score in D1
  await c.env.DB.prepare(
    'UPDATE users SET total_score = ? WHERE id = ?'
  ).bind(total_score, userId).run()

  return c.json({ success: true })
})

export default app
