# 04: Social, Gamification, and Analytics

**Target Stack:** Flutter / Cloudflare Workers (API) / Cloudflare KV (Ephemeral Storage) / `fl_chart` / Drift / Riverpod

> [!NOTE]
> This document covers the **current production social and analytics contracts**. For the long-term social vision (3D habit environments, private messaging, milestone wishes), see [`ux_social_vision.md`](ux_social_vision.md) — vision sections are marked `[VISION]` there.

## 1. Privacy-First Data Scoping (API Logic)

The backend must never expose a user's entire profile or habit list. Social data is strictly compartmentalized on a per-habit basis.

* **The Partnership Junction:** The Cloudflare Worker must resolve social queries using the `partnerships` D1 table, where each directed row carries the viewer's role for that habit: `owner`, `partner`, or `supporter`.
* **Data Payload Masking:** When syncing (`GET /api/sync/daily`), the API must only return the `username`, `avatar_url`, `current_duration`, and habit metadata (`title`, `color_hex`, `target_duration`) of the specific shared habit. Journal entries are strictly private.
* **Role Enforcement:** Ownership and participation are enforced server-side. Only `owner` may update/archive a habit, `owner` and `partner` may log completion/skip, and nudges require an actual shared-habit participation row rather than accepted friendship alone.

### Friend Search & Habit Partner Invitations

* **Navigation Ownership:** Social is a primary destination in the three-tab shell. Home should not own hidden Social navigation buttons; social obligations belong in Social and notification-center entry points.
* **Friend Search:** Users can search by username prefix. Search results expose only safe fields: `user_id`, `username`, `avatar_url`, and relationship state (`none`, `pending_incoming`, `pending_outgoing`, `accepted`). Search must not expose score totals, habit metadata, logs, journal text, or private messages.
* **Friend Request API:** `POST /api/social/friend-request` rejects self-requests and missing users, treats duplicate pending/accepted pairs idempotently, and returns the current relationship state. `POST /api/social/friend-request/accept` is recipient-scoped and idempotent for already accepted rows. `POST /api/social/friend-request/decline` is recipient-scoped and clears only pending requests.
* **Friend Request Gate:** A user must be an accepted friend before receiving a habit-partner invite.
* **Accepted Friend Cache:** `GET /api/sync/daily` returns accepted friends and pending incoming requests so Flutter can cache safe friend fields in Drift (`accepted_friends` and `friend_relationships`) and render friend/request state without exposing habit data.
* **Habit Invite Flow:** From habit creation surfaces, users can choose accepted friends from the local cache and enqueue a pending invite for one specific habit after the habit has been created locally.
* **Invite Authorization:** `POST /api/social/habit-invitation` verifies requester ownership of the habit, rejects self-invites, requires an accepted friendship, and treats duplicate pending invites as idempotent.
* **Acceptance Behavior:** Accepting a habit invite creates the recipient `partner` self-row plus directed rows to existing participants, while the creator remains `owner`. Declining leaves no partnership and exposes no habit progress.
* **Sync Behavior:** Pending habit invites should arrive through background sync and be rendered from Drift, never from a direct Home-screen network call. Home startup triggers the shared sync service to pull `/api/sync/daily`; create/accept/decline actions flush the local sync queue immediately when the HTTP endpoint is reachable.

## 2. The Ephemeral "Nudge" System (Cloudflare KV)

All nudges are treated as ephemeral, transient data using Cloudflare KV.

* **Sending a Nudge:** 
  * The flutter app writes the `NUDGE` action to the local sync queue.
  * The background worker calls `POST /api/social/nudge`.
  * The backend authorizes the request only when the sender has a directed partnership row to the target. If the request includes `habit_id`, authorization is narrowed to that exact shared habit.
  * The backend writes a key to KV with a **TTL of 24 hours**. New habit-scoped nudges use `nudge:{target_user_id}:{sender_id}:{habit_id}`; legacy sender-only nudges may still use `nudge:{target_user_id}:{sender_id}`.
* **Receiving a Nudge:**
  * During the background sync, the Worker checks KV for any active nudges.
  * Passed to the Flutter client in the sync payload with `senderId`, optional `habitId`, and `timestamp`, then immediately deleted from KV.
  * Flutter should normalize the received nudge into a local `notification_events` row so the user can revisit it from the notification center after the ephemeral KV event has been consumed.
  * Flutter should also coalesce the card state into `PartnerSnapshots.lastNudgeAt` for the matching sender/habit so Home can show a bounded ring pulse and "Nudged by X" chip after app restart.

## 3. The "Partner Whisper" UI

* **Primary Surface:** The main social status surface now lives inside each habit card, not in a detached global ticker. Each card renders up to four partner/supporter avatars for that specific habit.
* **Payload Fields:** `GET /api/sync/daily` should provide `role` plus a daily completion bit (`has_completed_today`) for each partner snapshot so Flutter can render rings and role labels from Drift without guessing.
* **Status Indicators:** Completed-today partners use the habit-colored ring; incomplete partners are muted; supporters carry a softer read-only tint. Overflow beyond four avatars collapses to `+N`.
* **Profile vs Nudge Targeting:** Partner identity taps open the friend's profile. Nudge/encourage is a separate hand action inside the relevant habit card or friend habit row and enqueues `SyncAction.sendNudge`.
* **Nudge Visibility:** Received nudges should show on the relevant card for a bounded 24-hour window using local Drift state. Repeated nudges from the same sender/habit should coalesce rather than stack duplicate chips or notification rows.
* **Friend Profile Privacy:** `GET /api/social/user/:id/profile` must stay authenticated and accepted-friend scoped. It may return only safe identity fields and allowed active shared-habit metadata; `Follow` in Flutter pre-fills local habit creation and does not create remote follow state.
* **In-App Notification:** Sending a nudge should produce card-local queued feedback plus a lightweight snackbar, never an OS-level push notification in this MVP.
* **Unified Social Notification Stream:** Friend requests, accepted-friend events, private messages, habit invitations, and nudges all fan into the Drift-backed `NotificationEvents` table. The Social → Activity tab presents this as a unified chronological feed. Home's bell icon switches to this tab. The former standalone Notification Center and Inbox surfaces are retired as primary entry points.

## 4. The Daily Quote Engine

* **Online:** Worker fetches one quote per day from an external API, caches it in KV, and serves it in the daily sync.
* **Offline:** Flutter app falls back to `fallback_quotes.dart` containing local curated strings if the network is unavailable.

## 5. Scoring & Leaderboard

* **Authority:** Scoring is owned by the Cloudflare Worker and D1, not the Flutter client. The client-writable `/api/sync/score` path is deprecated and must not update leaderboard totals.
* **Algorithm:** +5 base points per newly accepted completed check-in. When all active `owner`/`partner` participants complete the same shared habit on the same date, each eligible participant receives a +5 shared-habit bonus. Skips award no points.
* **Idempotency:** Score writes use `user_score_events(user_id, source_event_id)` so duplicate offline log replays do not double count.
* **Achievements:** Backend events unlock `first_check_in`, `10_streak`, `100_streak`, `1000_streak`, `first_nudge`, and `first_supporter` in `user_achievements`.
* **Daily Payload:** `/api/sync/daily` returns `gamification.total_points`, `level`, `level_id`, `badges`, and `newly_unlocked_badges`.
* **Leaderboard:** Exists on the Social → Leaderboard tab. Users are ranked by backend-owned `total_score`, scoped to the current user plus accepted friends, and fetched separately from friend search so search results stay privacy-limited.

## 6. Analytics Visualization (Profile View)

* **Component 1: Completion Distribution (Pie Chart).** Render ratio of `COMPLETED` vs `SKIPPED` vs `OVERDUE` states across all habits.
* **Component 2: Historical Progression (Line Chart).** Render a 30-day trailing window of daily point accumulation.
* **Achievement State:** Discrete icon badges representing historical success for `COMPLETED` habits.

## 7. Anonymous Development Diagnostics

* **Scope:** Hable may collect only coarse development aggregates for `app_open`, `screen_visit`, and rounded `screen_visible_ms`. Allowlisted screen labels are static (`auth`, `home`, `profile`, `social_hub`, `notification_center`, `habit_form`, `onboarding`) and must never include usernames, habit titles, route arguments, or free-form text.
* **Storage Rules:** Flutter stores aggregate buckets in Drift. Optional remote upload writes only to `usage_aggregate_buckets` in D1. No user ID, email, username, auth token, device/install/session ID, IP address, user agent, cookie, localStorage identifier, fingerprinting probe, or raw event timeline belongs in diagnostics data.
* **Remote Upload Gate:** Remote diagnostics are disabled by default and require an explicit compile-time flag. The client should upload without auth headers so aggregate data cannot be linked back to accounts.
* **Report Surface:** The Worker may expose a development-only aggregate report (`/api/dev/usage-report`) that shows coarse totals only and hides low-volume buckets. This is not a product analytics dashboard and must not become a per-user drilldown tool.
* **Tooling Boundary:** The `21st-dev` React/shadcn dashboard component is explicitly out of scope for the Flutter app because there is no compatible admin shell in this repo. A future dedicated admin-web task can revisit that stack if needed.

## 8. Waterfall Onboarding Sequence

* **Step 1:** Profile Initialization (username, UUID).
* **Step 2:** Core Selection (standard or custom).
* **Step 3:** Duration Setting.
* **Step 4:** Commit & Sync. Route client to Home Screen.
