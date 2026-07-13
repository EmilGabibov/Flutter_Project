import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { jwt, sign } from 'hono/jwt'

type Bindings = {
  DB: D1Database
  NUDGES: KVNamespace
  JWT_SECRET: string
  ENVIRONMENT?: string
  MIN_SUPPORTED_APP_VERSION?: string
  MIN_SUPPORTED_SERVICE_WORKER_VERSION?: string
  EMAIL_WORKER?: {
    fetch: (input: RequestInfo | URL, init?: RequestInit) => Promise<Response>
  }
  CLOUDFLARE_ACCOUNT_ID?: string
  PRIVATE_CLOUDFLARE_EMAIL_API_TOKEN?: string
  PRIVATE_EMAIL_SENDER?: string
}

type Variables = {
  jwtPayload: {
    id: string
    exp: number
  }
}

type DailyQuotePayload = {
  text: string
  author?: string
  source: 'quotable' | 'cache'
  fetched_at: string
}

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>()
const allowedCorsOrigins = new Set([
  'https://hable.pages.dev',
  'http://localhost',
  'http://127.0.0.1',
])
const partnershipRoles = ['owner', 'partner', 'supporter'] as const
type PartnershipRole = (typeof partnershipRoles)[number]
const completedCheckInPoints = 5
const sharedHabitBonusPoints = 5
const nudgeAssistPoints = 2
const streakBadgeThresholds = [10, 100, 1000] as const
const forcedClientResetToken = '2026-07-13-shared-habit-cache-reset-1'
const forcedClientResetReason =
  'We temporarily cleared local Hable data to recover from a shared-habit cache issue. Please sign in again.'
const levelTiers = [
  { id: 'newbie', name: 'Newbie', minPoints: 0 },
  { id: 'builder', name: 'Builder', minPoints: 50 },
  { id: 'momentum', name: 'Momentum', minPoints: 150 },
  { id: 'anchor', name: 'Anchor', minPoints: 500 },
  { id: 'legend', name: 'Legend', minPoints: 1000 },
] as const
const quotableDailyQuoteUrl = 'https://api.quotable.io/quotes/random?tags=inspirational'

// --- Helpers ---
async function hashPassword(password: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(password);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

async function hashToken(token: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(token);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

function generateCalendarToken(): string {
  return crypto.randomUUID() + '-' + crypto.randomUUID();
}

function normalizeEmail(email: unknown): string {
  return String(email ?? '').trim().toLowerCase()
}

function isValidEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

function normalizeAvatar(value: unknown): string {
  return String(value ?? '').trim()
}

const defaultAvatarEmojis = ['🌱', '🌞', '🌊', '🍀', '🪴', '🧠', '🧭', '🔥', '⭐', '🌻', '🦊', '👺'] as const

function hashString(value: string): number {
  let hash = 0
  for (const char of value) {
    hash = ((hash * 31) + char.codePointAt(0)!) >>> 0
  }
  return hash
}

function defaultAvatarForUsername(username: string): string {
  return defaultAvatarEmojis[hashString(username.trim().toLowerCase()) % defaultAvatarEmojis.length]
}

function normalizeOptionalString(value: unknown): string | null {
  const normalized = String(value ?? '').trim()
  return normalized.length === 0 ? null : normalized
}

function todayUtcKey(now = new Date()): string {
  return now.toISOString().slice(0, 10)
}

function normalizeQuotableQuotePayload(value: unknown): DailyQuotePayload | null {
  const candidate = Array.isArray(value) ? value[0] : value
  if (!candidate || typeof candidate !== 'object') return null
  const record = candidate as Record<string, unknown>
  const text = normalizeOptionalString(record.content)
  if (!text) return null
  const author = normalizeOptionalString(record.author) ?? undefined
  return {
    text,
    ...(author ? { author } : {}),
    source: 'quotable',
    fetched_at: new Date().toISOString(),
  }
}

async function fetchQuotableDailyQuote(): Promise<DailyQuotePayload | null> {
  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 2500)
  try {
    const response = await fetch(quotableDailyQuoteUrl, {
      signal: controller.signal,
      headers: { 'Accept': 'application/json' },
    })
    if (!response.ok) return null
    return normalizeQuotableQuotePayload(await response.json())
  } catch {
    return null
  } finally {
    clearTimeout(timeout)
  }
}

async function getDailyQuote(env: Bindings): Promise<DailyQuotePayload | null> {
  const cacheKey = `quote:daily:${todayUtcKey()}`
  const cached = await env.NUDGES.get(cacheKey)
  if (cached) {
    try {
      const parsed = JSON.parse(cached) as DailyQuotePayload
      if (normalizeOptionalString(parsed.text)) {
        return { ...parsed, source: 'cache' }
      }
    } catch {}
  }

  const quote = await fetchQuotableDailyQuote()
  if (!quote) return null

  await env.NUDGES.put(cacheKey, JSON.stringify(quote), { expirationTtl: 172800 })
  return quote
}

function jsonError(
  c: any,
  status: number,
  code: string,
  message: string,
) {
  return c.json(
    {
      error: {
        code,
        message,
      },
    },
    status,
  )
}

function parseServiceWorkerVersion(scriptContents: string): string | null {
  const match = scriptContents.match(/serviceWorkerVersion:\s*["']([^"']+)["']/)
  return match?.[1] ?? null
}

async function readDeployedWebVersionStatus(requestUrl: string) {
  const versionUrl = new URL('/version.json', requestUrl).toString()
  const bootstrapUrl = new URL('/flutter_bootstrap.js', requestUrl).toString()

  let currentVersion: string | null = null
  let currentBuildNumber: string | null = null
  let currentServiceWorkerVersion: string | null = null

  try {
    const response = await fetch(versionUrl, {
      headers: {
        'Cache-Control': 'no-store',
        'Pragma': 'no-cache',
      },
    })
    if (response.ok) {
      const data = await response.json<{ version?: unknown; build_number?: unknown }>()
      currentVersion = normalizeOptionalString(data.version)
      currentBuildNumber = normalizeOptionalString(data.build_number)
    }
  } catch {}

  try {
    const response = await fetch(bootstrapUrl, {
      headers: {
        'Cache-Control': 'no-store',
        'Pragma': 'no-cache',
      },
    })
    if (response.ok) {
      currentServiceWorkerVersion = parseServiceWorkerVersion(await response.text())
    }
  } catch {}

  return {
    currentVersion,
    currentBuildNumber,
    currentServiceWorkerVersion,
  }
}

function isAllowedEmojiAvatar(value: string): boolean {
  if (!value || value.length > 16) return false
  if (/https?:|data:|\/|\\|<|>|\{|\}/i.test(value)) return false

  const nonEmojiSyntax = value.replace(/[\p{Extended_Pictographic}\p{Emoji_Modifier}\uFE0F\u200D]/gu, '')
  return nonEmojiSyntax.trim().length === 0
}

function isLocalRequest(url: string): boolean {
  const hostname = new URL(url).hostname
  return hostname === 'localhost' || hostname === '127.0.0.1' || hostname === '0.0.0.0'
}

function shouldLogPins(env: Bindings, requestUrl: string): boolean {
  return env.ENVIRONMENT === 'development' || isLocalRequest(requestUrl)
}

async function sendPinEmail(
  env: Bindings,
  to: string,
  pin: string,
  purpose: 'password-reset' | 'profile-activation',
): Promise<void> {
  const purposeLabel = purpose === 'password-reset' ? 'password reset' : 'profile activation'
  const subject = purpose === 'password-reset'
    ? 'Your Hable password reset PIN'
    : 'Activate sync for your Hable profile'
  const text = `Your Hable ${purposeLabel} PIN is ${pin}. It expires in 10 minutes.`
  const html = `
    <div style="font-family: Arial, sans-serif; color: #111827; line-height: 1.5;">
      <p>Your Hable ${purposeLabel} PIN is:</p>
      <p style="font-size: 28px; font-weight: 700; letter-spacing: 0.2em;">${pin}</p>
      <p>This PIN expires in 10 minutes. If you did not request it, you can ignore this email.</p>
    </div>
  `

  if (env.EMAIL_WORKER) {
    const response = await env.EMAIL_WORKER.fetch('https://mailer.internal/send', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        to,
        subject,
        html,
        text,
      }),
    })
    const details = await response.text().catch(() => '')
    if (!response.ok) {
      throw new Error(`Email Worker failed with ${response.status}: ${details}`)
    }
    return
  }

  const sender = env.PRIVATE_EMAIL_SENDER
  if (!sender) {
    throw new Error('Cloudflare email sender is not configured.')
  }

  const accountId = env.CLOUDFLARE_ACCOUNT_ID
  const apiToken = env.PRIVATE_CLOUDFLARE_EMAIL_API_TOKEN
  if (!accountId || !apiToken) {
    throw new Error('Cloudflare email binding and REST credentials are both unavailable.')
  }

  const response = await fetch(`https://api.cloudflare.com/client/v4/accounts/${accountId}/email/sending/send`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from: sender,
      to,
      subject,
      html,
      text,
    }),
  })

  if (!response.ok) {
    const details = await response.text().catch(() => '')
    throw new Error(`Cloudflare Email Sending failed with ${response.status}: ${details}`)
  }
}

app.use('/api/*', cors({
  origin: (origin) => {
    if (!origin) return null
    try {
      const url = new URL(origin)
      const normalizedOrigin = `${url.protocol}//${url.hostname}${url.port ? `:${url.port}` : ''}`
      if (allowedCorsOrigins.has(normalizedOrigin)) return origin
      if (url.hostname.endsWith('.hable.pages.dev')) return origin
      if ((url.hostname === 'localhost' || url.hostname === '127.0.0.1') && url.protocol === 'http:') {
        return origin
      }
    } catch {
      return null
    }
    return null
  },
  allowHeaders: ['Content-Type', 'Authorization'],
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  maxAge: 600,
}))

app.get('/api/app/version-status', async (c) => {
  const deployed = await readDeployedWebVersionStatus(c.req.url)

  return c.json({
    platform: 'web',
    current_version: deployed.currentVersion,
    current_build_number: deployed.currentBuildNumber,
    current_service_worker_version: deployed.currentServiceWorkerVersion,
    min_supported_version: normalizeOptionalString(c.env.MIN_SUPPORTED_APP_VERSION),
    min_supported_service_worker_version: normalizeOptionalString(
      c.env.MIN_SUPPORTED_SERVICE_WORKER_VERSION,
    ),
    force_client_reset_token: forcedClientResetToken,
    force_client_reset_reason: forcedClientResetReason,
    force_refresh_on_mismatch: true,
  })
})

let ensurePartnershipSchemaPromise: Promise<void> | null = null
let ensureGamificationSchemaPromise: Promise<void> | null = null
let ensureCalendarFeedSchemaPromise: Promise<void> | null = null
let ensureAuthSchemaPromise: Promise<void> | null = null
let ensureUsageDiagnosticsSchemaPromise: Promise<void> | null = null
let ensureFriendRequestSchemaPromise: Promise<void> | null = null
let ensureHabitDescriptionSchemaPromise: Promise<void> | null = null

function normalizeRole(value: unknown): PartnershipRole {
  if (typeof value === 'string' && partnershipRoles.includes(value as PartnershipRole)) {
    return value as PartnershipRole
  }
  return 'partner'
}

async function ensureCalendarFeedSchema(env: Bindings): Promise<void> {
  if (!ensureCalendarFeedSchemaPromise) {
    ensureCalendarFeedSchemaPromise = (async () => {
      const pragma = await env.DB.prepare('PRAGMA table_info(calendar_feed_tokens)').all()
      const columns = (pragma.results ?? []) as Array<{ name?: string }>
      const hasTable = columns.length > 0
      if (!hasTable) {
        await env.DB.prepare(`
          CREATE TABLE IF NOT EXISTS calendar_feed_tokens (
              user_id TEXT PRIMARY KEY,
              token TEXT NOT NULL,
              token_hash TEXT NOT NULL,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              rotated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              revoked_at DATETIME
          )
        `).run()
        await env.DB.prepare(`
          CREATE INDEX IF NOT EXISTS idx_calendar_feed_tokens_hash
          ON calendar_feed_tokens(token_hash)
        `).run()
      }
    })().catch((error) => {
      ensureCalendarFeedSchemaPromise = null
      throw error
    })
  }

  await ensureCalendarFeedSchemaPromise
}

async function ensureAuthSchema(env: Bindings): Promise<void> {
  if (!ensureAuthSchemaPromise) {
    ensureAuthSchemaPromise = (async () => {
      const userPragma = await env.DB.prepare('PRAGMA table_info(users)').all()
      const userColumns = (userPragma.results ?? []) as Array<{ name?: string }>
      const hasUserColumn = (name: string) => userColumns.some((column) => column.name === name)

      if (!hasUserColumn('email')) {
        await env.DB.prepare('ALTER TABLE users ADD COLUMN email TEXT').run()
      }
      if (!hasUserColumn('email_verified_at')) {
        await env.DB.prepare('ALTER TABLE users ADD COLUMN email_verified_at DATETIME').run()
      }
      if (!hasUserColumn('password_hash')) {
        await env.DB.prepare('ALTER TABLE users ADD COLUMN password_hash TEXT').run()
      }
      if (!hasUserColumn('total_score')) {
        await env.DB.prepare('ALTER TABLE users ADD COLUMN total_score INTEGER NOT NULL DEFAULT 0').run()
      }

      await env.DB.prepare('CREATE INDEX IF NOT EXISTS idx_users_username_lower ON users(lower(username))').run()
      await env.DB.prepare('CREATE INDEX IF NOT EXISTS idx_users_email_lower ON users(lower(email))').run()
      await env.DB.prepare(`
        CREATE TABLE IF NOT EXISTS auth_pins (
            email TEXT PRIMARY KEY,
            pin_hash TEXT NOT NULL,
            expires_at INTEGER NOT NULL
        )
      `).run()
    })().catch((error) => {
      ensureAuthSchemaPromise = null
      throw error
    })
  }

  await ensureAuthSchemaPromise
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

async function ensureHabitDescriptionSchema(env: Bindings): Promise<void> {
  if (!ensureHabitDescriptionSchemaPromise) {
    ensureHabitDescriptionSchemaPromise = (async () => {
      const pragma = await env.DB.prepare('PRAGMA table_info(habits)').all()
      const columns = (pragma.results ?? []) as Array<{ name?: string }>
      const hasDescriptionColumn = columns.some((column) => column.name === 'description')
      if (!hasDescriptionColumn) {
        await env.DB.prepare('ALTER TABLE habits ADD COLUMN description TEXT').run()
      }
    })().catch((error) => {
      ensureHabitDescriptionSchemaPromise = null
      throw error
    })
  }

  await ensureHabitDescriptionSchemaPromise
}

function isDevUsageDiagnosticsAllowed(env: Bindings, requestUrl: string): boolean {
  return env.ENVIRONMENT === 'development' || isLocalRequest(requestUrl)
}

function escapeHtml(value: unknown): string {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;')
}

async function ensureUsageDiagnosticsSchema(env: Bindings): Promise<void> {
  if (!ensureUsageDiagnosticsSchemaPromise) {
    ensureUsageDiagnosticsSchemaPromise = (async () => {
      await env.DB.prepare(`
        CREATE TABLE IF NOT EXISTS usage_aggregate_buckets (
          bucket_date TEXT NOT NULL,
          platform TEXT NOT NULL,
          build_channel TEXT NOT NULL,
          screen_name TEXT NOT NULL,
          metric_name TEXT NOT NULL,
          count INTEGER NOT NULL DEFAULT 0,
          total_duration_ms INTEGER NOT NULL DEFAULT 0,
          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (bucket_date, platform, build_channel, screen_name, metric_name)
        )
      `).run()
      await env.DB.prepare(`
        CREATE INDEX IF NOT EXISTS idx_usage_aggregate_buckets_date
        ON usage_aggregate_buckets(bucket_date, platform, build_channel)
      `).run()
    })().catch((error) => {
      ensureUsageDiagnosticsSchemaPromise = null
      throw error
    })
  }

  await ensureUsageDiagnosticsSchemaPromise
}

async function ensureFriendRequestSchema(env: Bindings): Promise<void> {
  if (!ensureFriendRequestSchemaPromise) {
    ensureFriendRequestSchemaPromise = (async () => {
      await env.DB.prepare(`
        CREATE INDEX IF NOT EXISTS idx_friend_requests_recipient_status_created
        ON friend_requests(recipient_id, status, created_at)
      `).run()
      await env.DB.prepare(`
        CREATE INDEX IF NOT EXISTS idx_friend_requests_requester_status_created
        ON friend_requests(requester_id, status, created_at)
      `).run()
      await env.DB.prepare(`
        CREATE INDEX IF NOT EXISTS idx_friend_requests_pair_status
        ON friend_requests(requester_id, recipient_id, status)
      `).run()
    })().catch((error) => {
      ensureFriendRequestSchemaPromise = null
      throw error
    })
  }

  await ensureFriendRequestSchemaPromise
}

async function areAcceptedFriends(env: Bindings, leftUserId: string, rightUserId: string): Promise<boolean> {
  await ensureFriendRequestSchema(env)
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

app.post('/api/dev/usage-aggregate', async (c) => {
  if (!isDevUsageDiagnosticsAllowed(c.env, c.req.url)) {
    return c.json({ error: 'Development usage diagnostics are disabled.' }, 403)
  }

  await ensureUsageDiagnosticsSchema(c.env)
  const body = await c.req.json().catch(() => ({})) as {
    buckets?: Array<Record<string, unknown>>
  }
  const buckets = Array.isArray(body.buckets) ? body.buckets : []
  if (buckets.length == 0) {
    return c.json({ error: 'Missing aggregate buckets' }, 400)
  }

  const allowedScreens = new Set(['app', 'auth', 'home', 'profile', 'social_hub', 'habit_form', 'onboarding'])
  const allowedMetrics = new Set(['app_open', 'screen_visit', 'screen_visible_ms'])
  const allowedPlatforms = new Set(['android', 'ios', 'macos', 'windows', 'linux', 'web', 'fuchsia'])

  for (const bucket of buckets) {
    const bucketDate = String(bucket.bucket_date ?? '').trim()
    const platform = String(bucket.platform ?? '').trim()
    const buildChannel = String(bucket.build_channel ?? '').trim()
    const screenName = String(bucket.screen_name ?? '').trim()
    const metricName = String(bucket.metric_name ?? '').trim()
    const count = Number(bucket.count ?? 0)
    const totalDurationMs = Number(bucket.total_duration_ms ?? 0)

    if (!/^\d{4}-\d{2}-\d{2}$/.test(bucketDate)) {
      return c.json({ error: 'Invalid bucket_date' }, 400)
    }
    if (!allowedPlatforms.has(platform)) {
      return c.json({ error: 'Invalid platform' }, 400)
    }
    if (!buildChannel || buildChannel.length > 32) {
      return c.json({ error: 'Invalid build_channel' }, 400)
    }
    if (!allowedScreens.has(screenName)) {
      return c.json({ error: 'Invalid screen_name' }, 400)
    }
    if (!allowedMetrics.has(metricName)) {
      return c.json({ error: 'Invalid metric_name' }, 400)
    }
    if (!Number.isInteger(count) || count < 0 || count > 100000) {
      return c.json({ error: 'Invalid count' }, 400)
    }
    if (!Number.isInteger(totalDurationMs) || totalDurationMs < 0 || totalDurationMs > 86400000) {
      return c.json({ error: 'Invalid total_duration_ms' }, 400)
    }
    if (metricName === 'screen_visible_ms' && totalDurationMs % 5000 !== 0) {
      return c.json({ error: 'Visible durations must be rounded to 5-second buckets' }, 400)
    }
    if (count === 0 && totalDurationMs === 0) {
      continue
    }

    await c.env.DB.prepare(`
      INSERT INTO usage_aggregate_buckets (
        bucket_date,
        platform,
        build_channel,
        screen_name,
        metric_name,
        count,
        total_duration_ms,
        updated_at
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
      ON CONFLICT(bucket_date, platform, build_channel, screen_name, metric_name)
      DO UPDATE SET
        count = usage_aggregate_buckets.count + excluded.count,
        total_duration_ms = usage_aggregate_buckets.total_duration_ms + excluded.total_duration_ms,
        updated_at = CURRENT_TIMESTAMP
    `).bind(
      bucketDate,
      platform,
      buildChannel,
      screenName,
      metricName,
      count,
      totalDurationMs,
    ).run()
  }

  return c.json({ ok: true })
})

app.get('/api/dev/usage-report', async (c) => {
  if (!isDevUsageDiagnosticsAllowed(c.env, c.req.url)) {
    return c.text('Development usage diagnostics are disabled.', 403)
  }

  await ensureUsageDiagnosticsSchema(c.env)
  const format = c.req.query('format')
  const { results } = await c.env.DB.prepare(`
    SELECT
      bucket_date,
      platform,
      build_channel,
      screen_name,
      metric_name,
      count,
      total_duration_ms,
      updated_at
    FROM usage_aggregate_buckets
    WHERE count >= 2 OR total_duration_ms >= 10000
    ORDER BY bucket_date DESC, platform ASC, build_channel ASC, screen_name ASC, metric_name ASC
    LIMIT 500
  `).all()

  if (format === 'json') {
    return c.json({ rows: results ?? [] })
  }

  const rows = (results ?? []) as Array<Record<string, unknown>>
  const rowsHtml = rows.length > 0
    ? rows.map((row) => `
        <tr>
          <td>${escapeHtml(row.bucket_date)}</td>
          <td>${escapeHtml(row.platform)}</td>
          <td>${escapeHtml(row.build_channel)}</td>
          <td>${escapeHtml(row.screen_name)}</td>
          <td>${escapeHtml(row.metric_name)}</td>
          <td>${escapeHtml(row.count)}</td>
          <td>${escapeHtml(row.total_duration_ms)}</td>
          <td>${escapeHtml(row.updated_at)}</td>
        </tr>
      `).join('')
    : '<tr><td colspan="8">No aggregate buckets met the minimum privacy threshold yet.</td></tr>'

  return c.html(`
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Hable Dev Usage Report</title>
        <style>
          :root {
            color-scheme: light;
            --bg: #f4f1e8;
            --card: rgba(255, 255, 255, 0.78);
            --ink: #1d2b24;
            --muted: #61706a;
            --line: rgba(29, 43, 36, 0.12);
            --accent: #8aa17b;
          }
          body {
            margin: 0;
            font-family: "SF Pro Display", "Segoe UI", sans-serif;
            background:
              radial-gradient(circle at top left, rgba(138, 161, 123, 0.24), transparent 28%),
              linear-gradient(135deg, #f6f3eb, #ebe4d6);
            color: var(--ink);
          }
          .wrap {
            max-width: 1120px;
            margin: 0 auto;
            padding: 40px 20px 72px;
          }
          .hero {
            padding: 28px;
            border-radius: 28px;
            background: var(--card);
            backdrop-filter: blur(14px);
            box-shadow: 0 18px 48px rgba(48, 63, 54, 0.08);
          }
          h1 {
            margin: 0 0 8px;
            font-size: clamp(2rem, 4vw, 3.6rem);
            line-height: 0.96;
          }
          p {
            margin: 0;
            color: var(--muted);
            max-width: 64ch;
          }
          .table-card {
            margin-top: 20px;
            padding: 18px;
            border-radius: 24px;
            background: var(--card);
            backdrop-filter: blur(14px);
            box-shadow: 0 18px 48px rgba(48, 63, 54, 0.08);
            overflow: auto;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
          }
          th, td {
            text-align: left;
            padding: 12px 10px;
            border-bottom: 1px solid var(--line);
            white-space: nowrap;
          }
          th {
            font-size: 12px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--muted);
          }
          .pill {
            display: inline-block;
            margin-top: 14px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(138, 161, 123, 0.16);
            color: var(--ink);
            font-size: 12px;
            font-weight: 600;
          }
        </style>
      </head>
      <body>
        <main class="wrap">
          <section class="hero">
            <h1>Hable<br/>Dev Usage Report</h1>
            <p>Aggregate-only diagnostics for development. This report omits identifiers, hides low-volume buckets, and shows only coarse counts plus rounded visible duration totals.</p>
            <div class="pill">Development-only surface</div>
          </section>
          <section class="table-card">
            <table>
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Platform</th>
                  <th>Channel</th>
                  <th>Screen</th>
                  <th>Metric</th>
                  <th>Count</th>
                  <th>Total Duration Ms</th>
                  <th>Updated</th>
                </tr>
              </thead>
              <tbody>${rowsHtml}</tbody>
            </table>
          </section>
        </main>
      </body>
    </html>
  `)
})

// 1. Auth Endpoints
app.post('/api/auth/register', async (c) => {
  await ensureAuthSchema(c.env)
  const body = await c.req.json().catch(() => ({})) as { username?: unknown; password?: unknown; email?: unknown }
  const username = String(body.username ?? '').trim()
  const password = String(body.password ?? '')
  const email = normalizeEmail(body.email)

  if (!username || !password) {
    return jsonError(c, 400, 'auth_missing_credentials', 'Enter a username and password.')
  }
  if (email && !isValidEmail(email)) {
    return jsonError(c, 400, 'auth_invalid_email', 'Enter a valid email address.')
  }
  if (password.length < 6) {
    return jsonError(c, 400, 'auth_password_too_short', 'Password must be at least 6 characters.')
  }

  // Check if username or email exists
  const existingUser = email
    ? await c.env.DB.prepare('SELECT id FROM users WHERE lower(username) = lower(?) OR lower(email) = lower(?)').bind(username, email).first()
    : await c.env.DB.prepare('SELECT id FROM users WHERE lower(username) = lower(?)').bind(username).first()
  if (existingUser) {
    return jsonError(
      c,
      409,
      email ? 'auth_duplicate_username_or_email' : 'auth_duplicate_username',
      email ? 'That username or email is already in use.' : 'That username is already in use.',
    )
  }

  const id = crypto.randomUUID();
  const avatar_url = defaultAvatarForUsername(username)
  const password_hash = await hashPassword(password);

  await c.env.DB.prepare(
    'INSERT INTO users (id, username, email, email_verified_at, password_hash, avatar_url, total_score) VALUES (?, ?, ?, ?, ?, ?, ?)'
  ).bind(id, username, email || null, email ? new Date().toISOString() : null, password_hash, avatar_url, 0).run();

  const payload = {
    id: id,
    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30, // 30 days
  };
  const secret = c.env.JWT_SECRET || 'fallback_local_secret';
  const token = await sign(payload, secret);

  return c.json({ token, user_id: id, username, email, avatar_url });
});

app.post('/api/auth/request-pin', async (c) => {
  await ensureAuthSchema(c.env)
  const body = await c.req.json().catch(() => ({})) as { email?: unknown }
  const email = normalizeEmail(body.email)
  if (!email) return jsonError(c, 400, 'auth_missing_email', 'Enter your email address.')
  if (!isValidEmail(email)) return jsonError(c, 400, 'auth_invalid_email', 'Enter a valid email address.')
  
  const user = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?').bind(email).first();
  if (!user) return jsonError(c, 404, 'auth_email_not_found', 'No account was found for that email.')

  const pin = Math.floor(100000 + Math.random() * 900000).toString(); // 6 digits
  const pinHash = await hashPassword(pin);
  const expiresAt = Math.floor(Date.now() / 1000) + 10 * 60; // 10 minutes from now
  
  await c.env.DB.prepare(
    'INSERT INTO auth_pins (email, pin_hash, expires_at) VALUES (?, ?, ?) ON CONFLICT(email) DO UPDATE SET pin_hash = excluded.pin_hash, expires_at = excluded.expires_at'
  ).bind(email, pinHash, expiresAt).run();

  if (shouldLogPins(c.env, c.req.url)) {
    console.log(`\n\n================================\n[auth] Development Password Reset PIN for ${email}: ${pin}\n================================\n\n`);
    return c.json({ success: true, message: 'Development PIN generated and printed to server logs' });
  }

  try {
    await sendPinEmail(c.env, email, pin, 'password-reset')
  } catch (error) {
    await c.env.DB.prepare('DELETE FROM auth_pins WHERE email = ?').bind(email).run()
    const detail = error instanceof Error ? error.message : String(error)
    console.error(`[auth] Failed to deliver password reset PIN for ${email}: ${detail}`)
    return jsonError(c, 502, 'auth_email_delivery_failed', 'We could not send the verification email right now. Please try again.')
  }
  
  return c.json({ success: true, message: 'Verification PIN sent' });
});

app.post('/api/auth/reset-password', async (c) => {
  await ensureAuthSchema(c.env)
  const body = await c.req.json().catch(() => ({})) as { email?: unknown; pin?: unknown; new_password?: unknown }
  const email = normalizeEmail(body.email)
  const pin = String(body.pin ?? '').trim()
  const new_password = String(body.new_password ?? '')
  if (!email || !pin || !new_password) return jsonError(c, 400, 'auth_reset_missing_fields', 'Enter your email, PIN, and new password.')
  if (!isValidEmail(email)) return jsonError(c, 400, 'auth_invalid_email', 'Enter a valid email address.')
  if (!/^\d{6}$/.test(pin)) return jsonError(c, 400, 'auth_invalid_pin_format', 'PIN must be 6 digits.')
  if (new_password.length < 6) return jsonError(c, 400, 'auth_password_too_short', 'Password must be at least 6 characters.')

  const pinRecord = await c.env.DB.prepare('SELECT pin_hash, expires_at FROM auth_pins WHERE email = ?').bind(email).first() as any;
  if (!pinRecord) return jsonError(c, 400, 'auth_pin_missing_or_expired', 'Request a new PIN and try again.')

  const now = Math.floor(Date.now() / 1000);
  if (pinRecord.expires_at < now) {
    return jsonError(c, 400, 'auth_pin_expired', 'That PIN expired. Request a new one and try again.')
  }

  const expectedHash = await hashPassword(pin);
  if (expectedHash !== pinRecord.pin_hash) {
    return jsonError(c, 400, 'auth_invalid_pin', 'That PIN does not look right.')
  }

  const newPasswordHash = await hashPassword(new_password);
  await c.env.DB.prepare('UPDATE users SET password_hash = ? WHERE email = ?').bind(newPasswordHash, email).run();
  await c.env.DB.prepare('DELETE FROM auth_pins WHERE email = ?').bind(email).run();

  return c.json({ success: true });
});

app.post('/api/auth/login', async (c) => {
  await ensureAuthSchema(c.env)
  const body = await c.req.json().catch(() => ({})) as { username?: unknown; password?: unknown; user_id?: unknown }
  const username = String(body.username ?? '').trim()
  const password = String(body.password ?? '')
  const user_id = String(body.user_id ?? '').trim()

  if (user_id) {
    // Backwards compatibility for twin-app testing (auto-login via SEED_USER_ID)
    const user = await c.env.DB.prepare('SELECT id, username, avatar_url, email, email_verified_at FROM users WHERE id = ?').bind(user_id).first()
    if (!user) return jsonError(c, 404, 'auth_user_not_found', 'That test user was not found.')

    const payload = { id: user_id, exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30 }
    const secret = c.env.JWT_SECRET || 'fallback_local_secret'
    const token = await sign(payload, secret)
    return c.json({ token, user_id, username: user.username, avatar_url: user.avatar_url, email: user.email, email_verified_at: user.email_verified_at })
  }

  if (!username || !password) {
    return jsonError(c, 400, 'auth_missing_credentials', 'Enter a username and password.')
  }

  const user = await c.env.DB.prepare('SELECT id, password_hash, username, avatar_url, email, email_verified_at FROM users WHERE lower(username) = lower(?)').bind(username).first()
  if (!user) {
    return jsonError(c, 401, 'auth_invalid_credentials', 'That username or password does not match.')
  }

  const password_hash = await hashPassword(password);
  if (user.password_hash !== password_hash) {
    return jsonError(c, 401, 'auth_invalid_credentials', 'That username or password does not match.')
  }

  const payload = {
    id: user.id,
    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30, // 30 days
  }
  const secret = c.env.JWT_SECRET || 'fallback_local_secret'
  const token = await sign(payload, secret)
  
  return c.json({ token, user_id: user.id, username: user.username, avatar_url: user.avatar_url, email: user.email, email_verified_at: user.email_verified_at })
})

app.use('/api/user/*', async (c, next) => {
  const secret = c.env.JWT_SECRET || 'fallback_local_secret'
  const jwtMiddleware = jwt({ secret, alg: 'HS256' })
  return jwtMiddleware(c, next)
})

app.post('/api/user/email/request-pin', async (c) => {
  await ensureAuthSchema(c.env)
  const payload = c.get('jwtPayload')
  const body = await c.req.json().catch(() => ({})) as { email?: unknown }
  const email = normalizeEmail(body.email)

  if (!email) return jsonError(c, 400, 'auth_missing_email', 'Enter your email address.')
  if (!isValidEmail(email)) return jsonError(c, 400, 'auth_invalid_email', 'Enter a valid email address.')

  const existing = await c.env.DB.prepare(
    'SELECT id FROM users WHERE lower(email) = lower(?) AND id != ?'
  ).bind(email, payload.id).first()
  if (existing) {
    return jsonError(c, 409, 'auth_email_already_attached', 'That email is already attached to another account.')
  }

  const pin = Math.floor(100000 + Math.random() * 900000).toString()
  const pinHash = await hashPassword(pin)
  const expiresAt = Math.floor(Date.now() / 1000) + 10 * 60

  await c.env.DB.prepare(
    'INSERT INTO auth_pins (email, pin_hash, expires_at) VALUES (?, ?, ?) ON CONFLICT(email) DO UPDATE SET pin_hash = excluded.pin_hash, expires_at = excluded.expires_at'
  ).bind(email, pinHash, expiresAt).run()

  if (shouldLogPins(c.env, c.req.url)) {
    console.log(`\n\n================================\n[auth] Development Profile Activation PIN for ${email}: ${pin}\n================================\n\n`)
    return c.json({ success: true, message: 'Development PIN generated and printed to server logs' })
  }

  try {
    await sendPinEmail(c.env, email, pin, 'profile-activation')
  } catch (error) {
    await c.env.DB.prepare('DELETE FROM auth_pins WHERE email = ?').bind(email).run()
    const detail = error instanceof Error ? error.message : String(error)
    console.error(`[auth] Failed to deliver profile activation PIN for ${email}: ${detail}`)
    return jsonError(c, 502, 'auth_email_delivery_failed', 'We could not send the verification email right now. Please try again.')
  }

  return c.json({ success: true, message: 'Verification PIN sent' })
})

app.post('/api/user/email/verify-pin', async (c) => {
  await ensureAuthSchema(c.env)
  const payload = c.get('jwtPayload')
  const body = await c.req.json().catch(() => ({})) as { email?: unknown; pin?: unknown }
  const email = normalizeEmail(body.email)
  const pin = String(body.pin ?? '').trim()

  if (!email || !pin) return jsonError(c, 400, 'auth_verify_missing_fields', 'Enter your email and PIN.')
  if (!isValidEmail(email)) return jsonError(c, 400, 'auth_invalid_email', 'Enter a valid email address.')
  if (!/^\d{6}$/.test(pin)) return jsonError(c, 400, 'auth_invalid_pin_format', 'PIN must be 6 digits.')

  const existing = await c.env.DB.prepare(
    'SELECT id FROM users WHERE lower(email) = lower(?) AND id != ?'
  ).bind(email, payload.id).first()
  if (existing) {
    return jsonError(c, 409, 'auth_email_already_attached', 'That email is already attached to another account.')
  }

  const pinRecord = await c.env.DB.prepare(
    'SELECT pin_hash, expires_at FROM auth_pins WHERE email = ?'
  ).bind(email).first<{ pin_hash: string; expires_at: number }>()
  if (!pinRecord) return jsonError(c, 400, 'auth_pin_missing_or_expired', 'Request a new PIN and try again.')

  const now = Math.floor(Date.now() / 1000)
  if (pinRecord.expires_at < now) {
    return jsonError(c, 400, 'auth_pin_expired', 'That PIN expired. Request a new one and try again.')
  }

  const expectedHash = await hashPassword(pin)
  if (expectedHash !== pinRecord.pin_hash) {
    return jsonError(c, 400, 'auth_invalid_pin', 'That PIN does not look right.')
  }

  const verifiedAt = new Date().toISOString()
  await c.env.DB.prepare(
    'UPDATE users SET email = ?, email_verified_at = ? WHERE id = ?'
  ).bind(email, verifiedAt, payload.id).run()
  await c.env.DB.prepare('DELETE FROM auth_pins WHERE email = ?').bind(email).run()

  const user = await c.env.DB.prepare(
    'SELECT id, username, email, email_verified_at, avatar_url FROM users WHERE id = ?'
  ).bind(payload.id).first()

  return c.json({
    success: true,
    user_id: user?.id ?? payload.id,
    username: user?.username,
    email: user?.email,
    email_verified_at: user?.email_verified_at,
    avatar_url: user?.avatar_url,
  })
})

app.put('/api/user/avatar', async (c) => {
  const payload = c.get('jwtPayload')
  const { avatar_url } = await c.req.json()
  const avatar = normalizeAvatar(avatar_url)
  if (!avatar) return jsonError(c, 400, 'auth_avatar_missing', 'Choose an avatar first.')
  if (!isAllowedEmojiAvatar(avatar)) {
    return jsonError(c, 400, 'auth_avatar_invalid', 'Pick an emoji from the Hable avatar set.')
  }
  
  await c.env.DB.prepare('UPDATE users SET avatar_url = ? WHERE id = ?').bind(avatar, payload.id).run()
  return c.json({ success: true, avatar_url: avatar })
})

app.get('/api/user/calendar-feed', async (c) => {
  await ensureCalendarFeedSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id

  let token = await c.env.DB.prepare(
    'SELECT token FROM calendar_feed_tokens WHERE user_id = ? AND revoked_at IS NULL'
  ).bind(userId).first<{ token: string }>()

  if (!token?.token) {
    const newToken = generateCalendarToken()
    const tokenHash = await hashToken(newToken)
    await c.env.DB.prepare(`
      INSERT INTO calendar_feed_tokens (user_id, token, token_hash)
      VALUES (?, ?, ?)
      ON CONFLICT(user_id) DO UPDATE SET
        token = excluded.token,
        token_hash = excluded.token_hash,
        rotated_at = CURRENT_TIMESTAMP,
        revoked_at = NULL
    `).bind(userId, newToken, tokenHash).run()
    token = { token: newToken }
  }

  return c.json({
    feed_url: new URL(c.req.url).origin + `/calendar/${token.token}.ics`
  })
})

app.post('/api/user/calendar-feed/rotate', async (c) => {
  await ensureCalendarFeedSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id

  const newToken = generateCalendarToken()
  const tokenHash = await hashToken(newToken)

  await c.env.DB.prepare(`
    UPDATE calendar_feed_tokens
    SET token = ?, token_hash = ?, rotated_at = CURRENT_TIMESTAMP
    WHERE user_id = ?
  `).bind(newToken, tokenHash, userId).run()

  return c.json({
    feed_url: new URL(c.req.url).origin + `/calendar/${newToken}.ics`
  })
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
  await ensureHabitDescriptionSchema(c.env)
  const payload = c.get('jwtPayload')
  const viewerUserId = payload.id
  const targetUserId = c.req.param('id')

  const user = await c.env.DB.prepare('SELECT id, username, avatar_url, total_score FROM users WHERE id = ?').bind(targetUserId).first()
  if (!user) return c.json({ error: 'User not found' }, 404)
  const userWithLevel = {
    ...user,
    level_name: deriveLevel(Number((user as { total_score?: unknown }).total_score ?? 0)).name,
  }

  let activeHabits: unknown[] = []
  if (viewerUserId === targetUserId) {
    const result = await c.env.DB.prepare(`
      SELECT h.id, h.title, h.description, h.target_duration, h.color_hex, hp.current_duration, 'owner' as role
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
        h.description,
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
    user: userWithLevel,
    habits: activeHabits
  })
})

// Friend Requests
app.get('/api/social/friend-request', async (c) => {
  await ensureFriendRequestSchema(c.env)
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
  await ensureFriendRequestSchema(c.env)
  const payload = c.get('jwtPayload')
  const senderId = payload.id
  const { target_user_id } = await c.req.json()
  const targetUserId = String(target_user_id ?? '').trim()

  if (!targetUserId) return jsonError(c, 400, 'friend_request_missing_target', 'Choose a friend first.')
  if (targetUserId === senderId) {
    return jsonError(c, 400, 'friend_request_self', "You can't send a friend request to yourself.")
  }

  const target = await c.env.DB.prepare(
    'SELECT id FROM users WHERE id = ?'
  ).bind(targetUserId).first<{ id: string }>()

  if (!target?.id) {
    return jsonError(c, 404, 'friend_request_target_not_found', 'That user could not be found.')
  }

  const existing = await c.env.DB.prepare(`
    SELECT id, requester_id, recipient_id, status
    FROM friend_requests
    WHERE status IN ('pending', 'accepted')
      AND (
        (requester_id = ? AND recipient_id = ?)
        OR (requester_id = ? AND recipient_id = ?)
      )
    ORDER BY CASE status WHEN 'accepted' THEN 0 ELSE 1 END, created_at DESC
    LIMIT 1
  `).bind(senderId, targetUserId, targetUserId, senderId).first<{
    id: string
    requester_id: string
    recipient_id: string
    status: string
  }>()

  if (existing) {
    const relationshipState = existing.status === 'accepted'
      ? 'accepted'
      : existing.requester_id === senderId
        ? 'pending_outgoing'
        : 'pending_incoming'

    return c.json({
      success: true,
      request_id: existing.id,
      relationship_state: relationshipState,
    })
  }

  const id = crypto.randomUUID()
  await c.env.DB.prepare(
    'INSERT INTO friend_requests (id, requester_id, recipient_id) VALUES (?, ?, ?)'
  ).bind(id, senderId, targetUserId).run()

  return c.json({ success: true, request_id: id, relationship_state: 'pending_outgoing' })
})

app.post('/api/social/friend-request/accept', async (c) => {
  await ensureFriendRequestSchema(c.env)
  const payload = c.get('jwtPayload')
  const recipient_id = payload.id
  const { request_id } = await c.req.json()

  if (!request_id) return jsonError(c, 400, 'friend_request_missing_request_id', 'Pick a valid friend request first.')

  const request = await c.env.DB.prepare(`
    SELECT id, requester_id, recipient_id, status
    FROM friend_requests
    WHERE id = ? AND recipient_id = ?
  `).bind(request_id, recipient_id).first<{
    id: string
    requester_id: string
    recipient_id: string
    status: string
  }>()

  if (!request) {
    return jsonError(c, 404, 'friend_request_not_found', 'That friend request is no longer available.')
  }
  if (request.status === 'accepted') {
    return c.json({ success: true, relationship_state: 'accepted' })
  }
  if (request.status !== 'pending') {
    return jsonError(c, 409, 'friend_request_not_pending', 'That request is no longer pending.')
  }

  const result = await c.env.DB.prepare(
    'UPDATE friend_requests SET status = "accepted" WHERE id = ? AND recipient_id = ?'
  ).bind(request_id, recipient_id).run()

  if (result.meta.changes === 0) {
    return jsonError(c, 404, 'friend_request_not_found', 'That friend request is no longer available.')
  }

  return c.json({ success: true, relationship_state: 'accepted' })
})

app.post('/api/social/friend-request/decline', async (c) => {
  await ensureFriendRequestSchema(c.env)
  const payload = c.get('jwtPayload')
  const recipient_id = payload.id
  const { request_id } = await c.req.json()

  if (!request_id) return jsonError(c, 400, 'friend_request_missing_request_id', 'Pick a valid friend request first.')

  const request = await c.env.DB.prepare(`
    SELECT id, status
    FROM friend_requests
    WHERE id = ? AND recipient_id = ?
  `).bind(request_id, recipient_id).first<{ id: string; status: string }>()

  if (!request) {
    return jsonError(c, 404, 'friend_request_not_found', 'That friend request is no longer available.')
  }
  if (request.status === 'accepted') {
    return jsonError(c, 409, 'friend_request_already_accepted', "That friendship is already active.")
  }
  if (request.status === 'declined' || request.status === 'rejected') {
    return c.json({ success: true, relationship_state: 'none' })
  }

  await c.env.DB.prepare(
    'UPDATE friend_requests SET status = "declined" WHERE id = ? AND recipient_id = ?'
  ).bind(request_id, recipient_id).run()

  return c.json({ success: true, relationship_state: 'none' })
})

app.post('/api/social/friend-request/revoke', async (c) => {
  await ensureFriendRequestSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const { target_user_id } = await c.req.json()
  const targetUserId = String(target_user_id ?? '').trim()

  if (!targetUserId) return jsonError(c, 400, 'friend_revoke_missing_target', 'Choose a friend first.')
  if (targetUserId === userId) {
    return jsonError(c, 400, 'friend_revoke_self', "You can't remove yourself from your own friends list.")
  }

  const result = await c.env.DB.prepare(`
    UPDATE friend_requests
    SET status = 'revoked'
    WHERE status = 'accepted'
      AND (
        (requester_id = ? AND recipient_id = ?)
        OR (requester_id = ? AND recipient_id = ?)
      )
  `).bind(userId, targetUserId, targetUserId, userId).run()

  if (result.meta.changes === 0) {
    return jsonError(c, 404, 'friend_revoke_not_found', 'That friendship was already gone.')
  }

  return c.json({ success: true, relationship_state: 'none' })
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
  const requestBody = await c.req.json()
  const target_user_id = requestBody.target_user_id
  const habit_id = typeof requestBody.habit_id === 'string' && requestBody.habit_id.trim()
    ? requestBody.habit_id.trim()
    : null

  if (!target_user_id) {
    return c.json({ error: 'Missing target_user_id' }, 400)
  }

  const permissionSql = `
    SELECT role
    FROM partnerships
    WHERE user_id = ? AND partner_id = ?
      ${habit_id ? 'AND habit_id = ?' : ''}
    ORDER BY
      CASE role
        WHEN 'owner' THEN 0
        WHEN 'partner' THEN 1
        ELSE 2
      END
    LIMIT 1
  `
  const permissionRow = habit_id
    ? await c.env.DB.prepare(permissionSql).bind(sender_id, target_user_id, habit_id).first<{ role: string }>()
    : await c.env.DB.prepare(permissionSql).bind(sender_id, target_user_id).first<{ role: string }>()

  const senderRole = permissionRow ? normalizeRole(permissionRow.role) : null
  if (!senderRole) {
    return c.json({ error: 'Unauthorized: Not a participant in a shared habit' }, 403)
  }

  const today = new Date().toISOString().split('T')[0]
  const capKey = habit_id
    ? `nudge_limit:${sender_id}:${target_user_id}:${habit_id}:${today}`
    : `nudge_limit:${sender_id}:${target_user_id}:any:${today}`

  if (await c.env.NUDGES.get(capKey)) {
    return c.json({ success: true, message: 'Nudge already sent today' })
  }

  const key = habit_id
    ? `nudge:${target_user_id}:${sender_id}:${habit_id}`
    : `nudge:${target_user_id}:${sender_id}`
  
  // Set in KV with 24 hours TTL (86400 seconds)
  await c.env.NUDGES.put(key, new Date().toISOString(), { expirationTtl: 86400 })
  await c.env.NUDGES.put(capKey, '1', { expirationTtl: 86400 })
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
  await ensureHabitDescriptionSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const {
    habit_id,
    title,
    description,
    target_duration,
    color_hex,
    status,
    created_at,
    updated_at,
    reset_progress,
  } = await c.req.json()

  if (!habit_id || !title || target_duration === undefined) {
    return c.json({ error: 'Missing required habit fields' }, 400)
  }

  const existingHabit = await c.env.DB.prepare('SELECT user_id FROM habits WHERE id = ?').bind(habit_id).first<{ user_id: string }>()
  if (existingHabit && existingHabit.user_id !== userId) {
    return c.json({ error: 'Unauthorized: Only owners can update or archive a habit' }, 403)
  }

  if (reset_progress === true) {
    const participantCountResult = await c.env.DB.prepare(
      'SELECT COUNT(*) as participant_count FROM partnerships WHERE habit_id = ?'
    ).bind(habit_id).first<{ participant_count: number | string | null }>()
    const participantCount = Number(participantCountResult?.participant_count ?? 0)

    if (participantCount > 1) {
      return c.json({ error: 'Reset progress is only supported for solo habits' }, 409)
    }

    await c.env.DB.prepare('DELETE FROM habit_logs WHERE habit_id = ?').bind(habit_id).run()
    await c.env.DB.prepare('DELETE FROM habit_progress WHERE user_id = ? AND habit_id = ?').bind(userId, habit_id).run()
  }

  await c.env.DB.prepare(`
    INSERT INTO habits (id, user_id, title, description, target_duration, color_hex, status, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      title = excluded.title,
      description = excluded.description,
      target_duration = excluded.target_duration,
      color_hex = excluded.color_hex,
      status = excluded.status,
      updated_at = excluded.updated_at
  `).bind(
    habit_id, userId, title, description || null, target_duration, color_hex || null, status || 'active',
    created_at || new Date().toISOString(), updated_at || new Date().toISOString()
  ).run()
  await ensureOwnerMembership(c.env, habit_id, userId)

  return c.json({ success: true })
})

app.delete('/api/sync/habit/:habitId', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const habitId = c.req.param('habitId')

  const habit = await c.env.DB.prepare(
    'SELECT id, user_id FROM habits WHERE id = ?'
  ).bind(habitId).first<{ id: string; user_id: string }>()

  if (!habit) {
    return c.json({ success: true, deleted: false })
  }
  if (habit.user_id !== userId) {
    return c.json({ error: 'Unauthorized: Only owners can delete a habit' }, 403)
  }

  await c.env.DB.prepare('DELETE FROM habit_logs WHERE habit_id = ?').bind(habitId).run()
  await c.env.DB.prepare('DELETE FROM partnerships WHERE habit_id = ?').bind(habitId).run()
  await c.env.DB.prepare('DELETE FROM habit_invitations WHERE habit_id = ?').bind(habitId).run()
  await c.env.DB.prepare('DELETE FROM habits WHERE id = ?').bind(habitId).run()

  return c.json({ success: true, deleted: true })
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

    // Check for assist points (nudge within 4 hours)
    const nudgePrefix = `nudge:${userId}:`
    const nudgeList = await c.env.NUDGES.list({ prefix: nudgePrefix })
    for (const key of nudgeList.keys) {
      const parts = key.name.slice(nudgePrefix.length).split(':')
      const senderId = parts[0]
      const nudgeHabitId = parts.length > 1 ? parts[1] : null
      
      if (!nudgeHabitId || nudgeHabitId === habit_id) {
        const nudgedAtStr = await c.env.NUDGES.get(key.name)
        if (nudgedAtStr) {
          const nudgedAt = new Date(nudgedAtStr)
          const loggedAtDate = new Date(resolvedLoggedAt)
          const diffMs = loggedAtDate.getTime() - nudgedAt.getTime()
          if (diffMs > 0 && diffMs <= 4 * 60 * 60 * 1000) {
            await awardScoreEvent(c.env, senderId, `assist:${log_id}:${senderId}`, nudgeAssistPoints, 'nudge_assist')
            await c.env.NUDGES.delete(key.name)
          }
        }
      }
    }
  }

  return c.json({ success: true, accepted: isNewLog })
})

// Sync Daily
app.get('/api/sync/daily', async (c) => {
  await ensurePartnershipRoleSchema(c.env)
  await ensureFriendRequestSchema(c.env)
  await ensureGamificationSchema(c.env)
  await ensureHabitDescriptionSchema(c.env)
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
      h.description,
      h.color_hex,
      h.target_duration,
      h.status,
      MAX(h.target_duration - COALESCE(vhp.current_duration, 0), 0) as viewer_remaining_days,
      p.habit_id,
      p.partner_id,
      p.role
    FROM partnerships p
    JOIN users u ON p.partner_id = u.id
    LEFT JOIN habit_progress hp ON p.partner_id = hp.user_id AND p.habit_id = hp.habit_id
    LEFT JOIN habit_progress vhp ON p.user_id = vhp.user_id AND p.habit_id = vhp.habit_id
    LEFT JOIN habits h ON p.habit_id = h.id
    WHERE p.user_id = ?
      AND p.partner_id != ?
  `).bind(userId, userId).all()

  // 2. Fetch Nudges from KV
  const nudgePrefix = `nudge:${userId}:`
  const nudgeList = await c.env.NUDGES.list({ prefix: nudgePrefix })
  
  const nudges = []
  for (const key of nudgeList.keys) {
    const [senderId, habitId] = key.name.slice(nudgePrefix.length).split(':')
    if (!senderId) continue
    const timestamp = await c.env.NUDGES.get(key.name)
    nudges.push({ senderId, ...(habitId ? { habitId } : {}), timestamp })
    
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
  const quote = await getDailyQuote(c.env)

  return c.json({
    partners: results,
    nudges: nudges,
    messages: messages,
    invitations: invitations,
    friend_requests: friendRequests,
    accepted_friends: acceptedFriends,
    gamification: gamification,
    ...(quote ? { quote } : {})
  })
})

// --- New Leaderboard & Search Endpoints ---

app.get('/api/social/leaderboard', async (c) => {
  await ensureFriendRequestSchema(c.env)
  await ensureGamificationSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const { results } = await c.env.DB.prepare(`
    WITH friend_ids AS (
      SELECT ? AS user_id
      UNION
      SELECT DISTINCT CASE
        WHEN requester_id = ? THEN recipient_id
        ELSE requester_id
      END AS user_id
      FROM friend_requests
      WHERE status = 'accepted'
        AND (requester_id = ? OR recipient_id = ?)
    )
    SELECT id, username, avatar_url, total_score
    FROM users
    WHERE id IN (SELECT user_id FROM friend_ids)
    ORDER BY total_score DESC, username COLLATE NOCASE ASC
    LIMIT 100
  `).bind(userId, userId, userId, userId).all()

  const leaderboard = (results ?? []).map((row) => {
    const typedRow = row as {
      id?: unknown
      username?: unknown
      avatar_url?: unknown
      total_score?: unknown
    }
    const totalScore = Number(typedRow.total_score ?? 0)
    return {
      ...typedRow,
      total_score: totalScore,
      level_name: deriveLevel(totalScore).name,
    }
  })

  return c.json({ leaderboard })
})

app.get('/api/social/search', async (c) => {
  await ensureFriendRequestSchema(c.env)
  const payload = c.get('jwtPayload')
  const userId = payload.id
  const query = c.req.query('q')?.trim().toLowerCase()
  if (!query || query.length < 2) {
    return c.json({ results: [] })
  }

  const { results } = await c.env.DB.prepare(`
    SELECT
      u.id AS id,
      u.id AS user_id,
      u.username,
      u.avatar_url,
      CASE
        WHEN EXISTS (
          SELECT 1 FROM friend_requests fr
          WHERE fr.status = 'accepted'
            AND (
              (fr.requester_id = ? AND fr.recipient_id = u.id)
              OR (fr.requester_id = u.id AND fr.recipient_id = ?)
            )
        ) THEN 'accepted'
        WHEN EXISTS (
          SELECT 1 FROM friend_requests fr
          WHERE fr.status = 'pending'
            AND fr.requester_id = ?
            AND fr.recipient_id = u.id
        ) THEN 'pending_outgoing'
        WHEN EXISTS (
          SELECT 1 FROM friend_requests fr
          WHERE fr.status = 'pending'
            AND fr.requester_id = u.id
            AND fr.recipient_id = ?
        ) THEN 'pending_incoming'
        ELSE 'none'
      END AS relationship_state
    FROM users u
    WHERE u.id != ?
      AND lower(u.username) LIKE ?
    ORDER BY lower(u.username) ASC
    LIMIT 20
  `).bind(userId, userId, userId, userId, userId, `${query}%`).all()

  return c.json({ results })
})

app.post('/api/sync/score', async (c) => {
  return c.json({ error: 'Client score sync is deprecated; use /api/sync/log and /api/sync/daily gamification.' }, 410)
})

// --- Public Calendar Feed Route (no JWT required) ---

app.get('/calendar/:token.ics', async (c) => {
  await ensureCalendarFeedSchema(c.env)
  const tokenParam = c.req.param('token')

  const tokenRecord = await c.env.DB.prepare(`
    SELECT user_id FROM calendar_feed_tokens
    WHERE token = ? AND revoked_at IS NULL
  `).bind(tokenParam).first<{ user_id: string }>()

  if (!tokenRecord?.user_id) {
    return c.text('Not Found', 404)
  }

  const userId = tokenRecord.user_id

  // Fetch active habits for the user (live progress)
  const { results: habits } = await c.env.DB.prepare(`
    SELECT
      h.id,
      h.title,
      h.target_duration,
      COALESCE(hp.current_duration, 0) as completed_count
    FROM habits h
    LEFT JOIN habit_progress hp ON h.id = hp.habit_id AND hp.user_id = h.user_id
    WHERE h.user_id = ? AND h.status = 'active'
  `).bind(userId).all()

  // Fetch user info for calendar event
  const user = await c.env.DB.prepare(
    'SELECT username FROM users WHERE id = ?'
  ).bind(userId).first<{ username: string }>()

  const username = user?.username || 'Hable User'

  // Generate ICS content
  const now = new Date()
  const prodId = '-//Hable//Hable Calendar//EN'

  const tzParam = c.req.query('tz') || 'UTC'
  const alarmHourStr = c.req.query('alarmHour')
  const alarmMinuteStr = c.req.query('alarmMinute')

  let icsContent = 'BEGIN:VCALENDAR\r\n'
  icsContent += 'VERSION:2.0\r\n'
  icsContent += `PRODID:${prodId}\r\n`
  icsContent += 'CALSCALE:GREGORIAN\r\n'
  icsContent += `X-WR-CALNAME:${escapeIcsText(username)}'s Habits\r\n`
  icsContent += `X-WR-TIMEZONE:${tzParam}\r\n`

  const today = new Date()
  const endDate = new Date(today)
  endDate.setDate(endDate.getDate() + 30)

  for (let d = new Date(today); d <= endDate; d.setDate(d.getDate() + 1)) {
    const dateStr = d.toISOString().split('T')[0]
    const events = habits as Array<{id: string; title: string; target_duration: number; completed_count: number}>

    for (const habit of events) {
      const summary = habit.title
      const description = `${habit.title}: ${habit.completed_count}/${habit.target_duration} completed`
      const uid = `${dateStr}-${habit.id}@hable.local`
      const dtstamp = formatIcsDate(now)

      icsContent += 'BEGIN:VEVENT\r\n'
      icsContent += `UID:${uid}\r\n`
      icsContent += `DTSTAMP:${dtstamp}\r\n`
      icsContent += `DTSTART;VALUE=DATE:${dateStr.replace(/-/g, '')}\r\n`
      icsContent += `SUMMARY:${escapeIcsText(summary)}\r\n`
      icsContent += `DESCRIPTION:${escapeIcsText(description)}\r\n`
      icsContent += 'STATUS:CONFIRMED\r\n'

      if (alarmHourStr) {
        const h = parseInt(alarmHourStr) || 20
        const m = parseInt(alarmMinuteStr || '0') || 0
        icsContent += 'BEGIN:VALARM\r\n'
        icsContent += 'ACTION:DISPLAY\r\n'
        icsContent += 'DESCRIPTION:Habit Reminder\r\n'
        icsContent += `TRIGGER;RELATED=START:PT${h}H${m > 0 ? m + 'M' : ''}\r\n`
        icsContent += 'END:VALARM\r\n'
      }

      icsContent += 'END:VEVENT\r\n'
    }
  }

  icsContent += 'END:VCALENDAR\r\n'

  c.header('Content-Type', 'text/calendar; charset=utf-8')
  c.header('Content-Disposition', `attachment; filename="${username}-habits.ics"`)
  return c.text(icsContent)
})

function escapeIcsText(text: string): string {
  return text
    .replace(/\\/g, '\\\\')
    .replace(/;/g, '\\;')
    .replace(/,/g, '\\,')
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '')
}

function formatIcsDate(date: Date): string {
  const year = date.getUTCFullYear()
  const month = String(date.getUTCMonth() + 1).padStart(2, '0')
  const day = String(date.getUTCDate()).padStart(2, '0')
  const hours = String(date.getUTCHours()).padStart(2, '0')
  const minutes = String(date.getUTCMinutes()).padStart(2, '0')
  const seconds = String(date.getUTCSeconds()).padStart(2, '0')
  return `${year}${month}${day}T${hours}${minutes}${seconds}Z`
}

export default app
