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
  PRIVATE_EMAIL_SENDER_HABLE?: string
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

const hableLogoDataUri = `data:image/png;base64,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`

function buildPinEmailHtml(pin: string, purposeLabel: string): string {
  return `
    <div style="margin:0;padding:0;background:#eef4f3;">
      <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#eef4f3;margin:0;padding:0;width:100%;">
        <tr>
          <td align="center" style="padding:40px 16px;">
            <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="max-width:560px;width:100%;margin:0 auto;background:#ffffff;border:1px solid #d8e4e1;border-radius:24px;overflow:hidden;box-shadow:0 18px 50px rgba(15,23,42,0.08);">
              <tr>
                <td style="padding:0;height:8px;background:linear-gradient(90deg,#1a7f72 0%,#4da6a1 55%,#f4a259 100%);font-size:0;line-height:0;">&nbsp;</td>
              </tr>
              <tr>
                <td align="center" style="padding:36px 36px 18px;">
                  <img src="${hableLogoDataUri}" alt="Hable" width="92" style="display:block;width:92px;max-width:92px;height:auto;margin:0 auto 18px;border:0;outline:none;text-decoration:none;" />
                  <div style="display:inline-block;padding:8px 14px;border-radius:999px;background:#e7f4f2;color:#1a7f72;font-family:Arial,sans-serif;font-size:12px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;">
                    ${purposeLabel}
                  </div>
                  <h1 style="margin:18px 0 0;color:#0f172a;font-family:Arial,sans-serif;font-size:28px;line-height:1.2;font-weight:700;letter-spacing:-0.02em;">
                    Your Hable PIN
                  </h1>
                  <p style="margin:12px 0 0;color:#475569;font-family:Arial,sans-serif;font-size:16px;line-height:1.7;">
                    Use the code below to continue with ${purposeLabel}. It expires in 10 minutes.
                  </p>
                </td>
              </tr>
              <tr>
                <td align="center" style="padding:8px 36px 28px;">
                  <div style="display:inline-block;padding:18px 24px;border-radius:18px;background:#0f172a;color:#f8fafc;font-family:'Courier New',Courier,monospace;font-size:32px;line-height:1;font-weight:700;letter-spacing:0.28em;">
                    ${pin}
                  </div>
                  <p style="margin:18px 0 0;color:#64748b;font-family:Arial,sans-serif;font-size:14px;line-height:1.7;">
                    If you did not request this code, you can safely ignore this email.
                  </p>
                </td>
              </tr>
              <tr>
                <td style="padding:0 36px 34px;">
                  <div style="border-top:1px solid #e2e8f0;padding-top:18px;color:#94a3b8;font-family:Arial,sans-serif;font-size:12px;line-height:1.6;text-align:center;">
                    Hable security email
                  </div>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </div>
  `
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
  const html = buildPinEmailHtml(pin, purposeLabel)

  const sender = env.PRIVATE_EMAIL_SENDER_HABLE
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
      from: { email: sender, name: 'Hable' },
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
