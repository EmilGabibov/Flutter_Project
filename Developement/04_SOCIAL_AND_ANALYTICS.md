# 04: Social, Gamification, and Analytics

**Target Stack:** Flutter / Cloudflare Workers (API) / Cloudflare KV (Ephemeral Storage) / `fl_chart` / Drift / Riverpod

## 1. Privacy-First Data Scoping (API Logic)

The backend must never expose a user's entire profile or habit list. Social data is strictly compartmentalized on a per-habit basis.

* **The Partnership Junction:** The Cloudflare Worker must resolve social queries using the `partnerships` D1 table, where each directed row carries the viewer's role for that habit: `owner`, `partner`, or `supporter`.
* **Data Payload Masking:** When syncing (`GET /api/sync/daily`), the API must only return the `username`, `avatar_url`, `current_duration`, and habit metadata (`title`, `color_hex`, `target_duration`) of the specific shared habit. Journal entries are strictly private.
* **Role Enforcement:** Ownership and participation are enforced server-side. Only `owner` may update/archive a habit, `owner` and `partner` may log completion/skip, and nudges require an actual shared-habit participation row rather than accepted friendship alone.

### Friend Search & Habit Partner Invitations

* **Friend Search:** Users can search by username or exact user code. Search results must expose only safe fields: `user_id`, `username`, `avatar_url`, and relationship state (`none`, `pending`, `accepted`).
* **Friend Request Gate:** A user must be an accepted friend before receiving a habit-partner invite.
* **Accepted Friend Cache:** `GET /api/sync/daily` returns accepted friends so Flutter can cache safe friend fields in Drift and render the habit creation partner picker offline.
* **Habit Invite Flow:** From habit creation surfaces, users can choose accepted friends from the local cache and enqueue a pending invite for one specific habit after the habit has been created locally.
* **Invite Authorization:** `POST /api/social/habit-invitation` verifies requester ownership of the habit, rejects self-invites, requires an accepted friendship, and treats duplicate pending invites as idempotent.
* **Acceptance Behavior:** Accepting a habit invite creates the recipient `partner` self-row plus directed rows to existing participants, while the creator remains `owner`. Declining leaves no partnership and exposes no habit progress.
* **Sync Behavior:** Pending habit invites should arrive through background sync and be rendered from Drift, never from a direct Home-screen network call. Home startup triggers the shared sync service to pull `/api/sync/daily`; create/accept/decline actions flush the local sync queue immediately when the HTTP endpoint is reachable.

## 2. The Ephemeral "Nudge" System (Cloudflare KV)

All nudges are treated as ephemeral, transient data using Cloudflare KV.

* **Sending a Nudge:** 
  * The flutter app writes the `NUDGE` action to the local sync queue.
  * The background worker calls `POST /api/social/nudge`.
  * The backend authorizes the request only when the sender has a directed partnership row to the target on at least one shared habit.
  * The backend writes a key to KV: `nudge:{target_user_id}:{sender_id}` with a **TTL of 24 hours**.
* **Receiving a Nudge:**
  * During the background sync, the Worker checks KV for any active nudges.
  * Passed to the Flutter client in the sync payload, then immediately deleted from KV.

## 3. The "Partner Whisper" UI

* **Primary Surface:** The main social status surface now lives inside each habit card, not in a detached global ticker. Each card renders up to four partner/supporter avatars for that specific habit.
* **Payload Fields:** `GET /api/sync/daily` should provide `role` plus a daily completion bit (`has_completed_today`) for each partner snapshot so Flutter can render rings and role labels from Drift without guessing.
* **Status Indicators:** Completed-today partners use the habit-colored ring; incomplete partners are muted; supporters carry a softer read-only tint. Overflow beyond four avatars collapses to `+N`.
* **In-App Notification:** Sending a nudge should still produce a lightweight in-app snackbar, never an OS-level push notification in this MVP.

## 4. The Daily Quote Engine

* **Online:** Worker fetches one quote per day from an external API, caches it in KV, and serves it in the daily sync.
* **Offline:** Flutter app falls back to `fallback_quotes.dart` containing local curated strings if the network is unavailable.

## 5. Scoring & Leaderboard

* **Authority:** Scoring is owned by the Cloudflare Worker and D1, not the Flutter client. The client-writable `/api/sync/score` path is deprecated and must not update leaderboard totals.
* **Algorithm:** +5 base points per newly accepted completed check-in. When all active `owner`/`partner` participants complete the same shared habit on the same date, each eligible participant receives a +5 shared-habit bonus. Skips award no points.
* **Idempotency:** Score writes use `user_score_events(user_id, source_event_id)` so duplicate offline log replays do not double count.
* **Achievements:** Backend events unlock `first_check_in`, `10_streak`, `100_streak`, `1000_streak`, `first_nudge`, and `first_supporter` in `user_achievements`.
* **Daily Payload:** `/api/sync/daily` returns `gamification.total_points`, `level`, `level_id`, `badges`, and `newly_unlocked_badges`.
* **Leaderboard:** Exists on the Social Hub screen. Users are ranked by backend-owned `total_score`. The global top 100 is fetched, and users can be searched.

## 6. Analytics Visualization (Profile View)

* **Component 1: Completion Distribution (Pie Chart).** Render ratio of `COMPLETED` vs `SKIPPED` vs `OVERDUE` states across all habits.
* **Component 2: Historical Progression (Line Chart).** Render a 30-day trailing window of daily point accumulation.
* **Achievement State:** Discrete icon badges representing historical success for `COMPLETED` habits.

## 7. Waterfall Onboarding Sequence

* **Step 1:** Profile Initialization (username, UUID).
* **Step 2:** Core Selection (standard or custom).
* **Step 3:** Duration Setting.
* **Step 4:** Commit & Sync. Route client to Home Screen.
