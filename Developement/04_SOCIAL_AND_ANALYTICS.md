# 04: Social, Gamification, and Analytics

**Target Stack:** Flutter / Cloudflare Workers (API) / Cloudflare KV (Ephemeral Storage) / `fl_chart` / Drift / Riverpod

## 1. Privacy-First Data Scoping (API Logic)

The backend must never expose a user's entire profile or habit list. Social data is strictly compartmentalized on a per-habit basis.

* **The Partnership Junction:** The Cloudflare Worker must resolve social queries using the `partnerships` D1 table.
* **Data Payload Masking:** When syncing (`GET /api/sync/daily`), the API must only return the `username`, `avatar_url`, `current_duration`, and habit metadata (`title`, `color_hex`, `target_duration`) of the specific shared habit. Journal entries are strictly private.

### Friend Search & Habit Partner Invitations

* **Friend Search:** Users can search by username or exact user code. Search results must expose only safe fields: `user_id`, `username`, `avatar_url`, and relationship state (`none`, `pending`, `accepted`).
* **Friend Request Gate:** A user must be an accepted friend before receiving a habit-partner invite.
* **Accepted Friend Cache:** `GET /api/sync/daily` returns accepted friends so Flutter can cache safe friend fields in Drift and render the habit creation partner picker offline.
* **Habit Invite Flow:** From habit creation surfaces, users can choose accepted friends from the local cache and enqueue a pending invite for one specific habit after the habit has been created locally.
* **Invite Authorization:** `POST /api/social/habit-invitation` verifies requester ownership of the habit, rejects self-invites, requires an accepted friendship, and treats duplicate pending invites as idempotent.
* **Acceptance Behavior:** Accepting a habit invite creates symmetric `partnerships` rows for that habit. Declining leaves no partnership and exposes no habit progress.
* **Sync Behavior:** Pending habit invites should arrive through background sync and be rendered from Drift, never from a direct Home-screen network call. Home startup triggers the shared sync service to pull `/api/sync/daily`; create/accept/decline actions flush the local sync queue immediately when the HTTP endpoint is reachable.

## 2. The Ephemeral "Nudge" System (Cloudflare KV)

All nudges are treated as ephemeral, transient data using Cloudflare KV.

* **Sending a Nudge:** 
  * The flutter app writes the `NUDGE` action to the local sync queue.
  * The background worker calls `POST /api/social/nudge`.
  * The backend writes a key to KV: `nudge:{target_user_id}:{sender_id}` with a **TTL of 24 hours**.
* **Receiving a Nudge:**
  * During the background sync, the Worker checks KV for any active nudges.
  * Passed to the Flutter client in the sync payload, then immediately deleted from KV.

## 3. The "Partner Whisper" UI

* **UI Component (`PartnerTicker`):** A horizontally scrolling list of small, circular avatars at the bottom of the home screen.
* **Status Indicators:** Glowing border if completed today; desaturated if not.
* **In-App Notification:** Show a gentle in-app snackbar or a small badge on the Partner Ticker (never an OS-level push notification).

## 4. The Daily Quote Engine

* **Online:** Worker fetches one quote per day from an external API, caches it in KV, and serves it in the daily sync.
* **Offline:** Flutter app falls back to `fallback_quotes.dart` containing local curated strings if the network is unavailable.

## 5. Scoring & Leaderboard

* **Algorithm:** +10 base points per completion. +1% multiplier per consecutive day. No point deduction for skipping.
* **Leaderboard:** Exists on the Social Hub screen. Users are ranked by Total Points. The global top 100 is fetched, and users can be searched.

## 6. Analytics Visualization (Profile View)

* **Component 1: Completion Distribution (Pie Chart).** Render ratio of `COMPLETED` vs `SKIPPED` vs `OVERDUE` states across all habits.
* **Component 2: Historical Progression (Line Chart).** Render a 30-day trailing window of daily point accumulation.
* **Achievement State:** Discrete icon badges representing historical success for `COMPLETED` habits.

## 7. Waterfall Onboarding Sequence

* **Step 1:** Profile Initialization (username, UUID).
* **Step 2:** Core Selection (standard or custom).
* **Step 3:** Duration Setting.
* **Step 4:** Commit & Sync. Route client to Home Screen.
