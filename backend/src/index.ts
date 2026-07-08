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

// 1. Auth Endpoint (MVP testing login)
app.post('/api/auth/login', async (c) => {
  const { user_id } = await c.req.json()
  
  if (!user_id) {
    return c.json({ error: 'Missing user_id' }, 400)
  }

  // Ensure user exists in DB
  const user = await c.env.DB.prepare('SELECT id FROM users WHERE id = ?').bind(user_id).first()
  if (!user) {
    return c.json({ error: 'User not found' }, 404)
  }

  // Create token valid for 30 days
  const payload = {
    id: user_id,
    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30, // 30 days
  }
  
  // Use a fallback secret for local dev if not set
  const secret = c.env.JWT_SECRET || 'fallback_local_secret'
  const token = await sign(payload, secret)
  
  return c.json({ token, user_id })
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

// Friend Requests
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
      p.habit_id,
      p.partner_id
    FROM partnerships p
    JOIN users u ON p.partner_id = u.id
    JOIN habit_progress hp ON p.partner_id = hp.user_id AND p.habit_id = hp.habit_id
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

  return c.json({
    partners: results,
    nudges: nudges
  })
})

export default app
