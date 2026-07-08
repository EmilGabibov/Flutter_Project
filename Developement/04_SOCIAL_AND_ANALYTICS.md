# 04: Social, Gamification, and Analytics

**Target Stack:** Flutter / Cloudflare Workers (API) / Cloudflare KV (Ephemeral Storage) / `fl_chart` / Drift / Riverpod

## 1. Privacy-First Data Scoping (API Logic)

The backend must never expose a user's entire profile or habit list. Social data is strictly compartmentalized on a per-habit basis.

* **The Partnership Junction:** The Cloudflare Worker must resolve social queries using the `partnerships` D1 table.
* **Data Payload Masking:** When syncing (`GET /api/sync/daily`), the API must only return the `username`, `avatar_url`, and the `current_duration` of the specific shared habit. Journal entries are strictly private.

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
* **Leaderboard:** Exists on the Profile screen. Compares points ONLY against explicit friends via partnerships. Sorted by Total Points (descending), then Current Streak (descending).

## 6. Analytics Visualization (Profile View)

* **Component 1: Completion Distribution (Pie Chart).** Render ratio of `COMPLETED` vs `SKIPPED` vs `OVERDUE` states across all habits.
* **Component 2: Historical Progression (Line Chart).** Render a 30-day trailing window of daily point accumulation.
* **Achievement State:** Discrete icon badges representing historical success for `COMPLETED` habits.

## 7. Waterfall Onboarding Sequence

* **Step 1:** Profile Initialization (username, UUID).
* **Step 2:** Core Selection (standard or custom).
* **Step 3:** Duration Setting.
* **Step 4:** Commit & Sync. Route client to Home Screen.
