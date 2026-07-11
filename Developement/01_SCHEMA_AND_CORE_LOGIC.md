# 01: Schema & Core Logic Specification

**Target Stack:** Flutter (Client) / Cloudflare Workers (API) / Cloudflare D1 & KV (Database)
**Agent Instructions:** Use this document to generate the core Dart models, the Cloudflare Worker API routes, and the database schemas. Do not build UI components yet.

## 1. The Habit Engine Logic (Dart Models & API)

The core logic governs how habits are calculated and penalized.

* **Duration Math:** 
  * Habit `target_duration` and `current_duration` are stored as days.
  * Default/preset habits use shared Flutter preset metadata and default to 21 days unless the user changes the duration.
  * Custom habits must accept an integer day duration.
* **The "Mud" Coefficient:** The backend does not calculate resistance; it only tracks the current day. The Flutter client will compute the `resistance_coefficient` locally.

* **The Penalty Engine:**
  * If a day (00:00 to 23:59 local time) passes without a `COMPLETED` or `SKIPPED` log, the habit enters an `OVERDUE` state.
  * When the user executes a `SKIP` action, the `total_duration` integer increments by `+2`.
  * A `SKIP` action *must* enforce a non-null `journal_entry` string payload to be accepted by the API.

## 2. Database Schema Parity (D1 & Drift)

Both the local Drift (SQLite) database and the remote Cloudflare D1 (SQL) database must mirror this schema exactly. 
**Crucially, all tables must include the `updated_at` (Timestamp) column** to enable "Last Write Wins" conflict resolution. Local Drift tables must additionally include an `is_synced` (Boolean) column.

### A. Core Tables (D1 & Drift)

* **`users` table:** `user_id` (UUID, Primary Key), `username` (String), `password_hash` (String), `avatar_url` (String), `total_score` (Int).
* **`habits` table:** `id` (UUID, PK), `user_id` (FK), `title` (String), `target_duration` (Int), `color_hex` (String), `status` (Enum: active, abandoned), `created_at` (Timestamp), `updated_at` (Timestamp).
* **`habit_logs` table:** `id` (UUID, PK), `user_id` (FK), `habit_id` (FK), `status` (Enum), `logged_at` (Timestamp).
* **`habit_progress` table:** `user_id` (FK), `habit_id` (FK), `current_duration` (Int).
* **`partnerships` table:** `user_id` (FK), `partner_id` (FK), `habit_id` (FK), `role` (Enum: `owner`, `partner`, `supporter`). This is a directed graph over one shared habit: self-rows (`user_id = partner_id`) represent the participant's own role, and non-self rows drive which other participants they can see in daily sync.
* **`user_score_events` table:** `user_id`, `source_event_id`, `points`, `reason`, `created_at`, with `(user_id, source_event_id)` as the idempotency key for backend-owned score awards.
* **`user_achievements` table:** `user_id`, `achievement_id`, `unlocked_at`, `source_event_id`, with `(user_id, achievement_id)` as the idempotency key for backend-owned badge unlocks.
* **`friend_requests` table:** `id` (PK), `requester_id` (FK), `recipient_id` (FK), `status` (Enum), `created_at` (Timestamp).
* **`habit_invitations` table:** `id` (PK), `requester_id`, `recipient_id`, `habit_id`, `status`, `created_at`. Pending duplicates for the same requester/recipient/habit are idempotent.
* **`accepted_friends` table:** Drift-only cache of accepted friends (`friend_user_id`, `username`, `avatar_url`) populated from daily sync for offline habit-invite pickers.
* **`SearchDocuments` table:** Local Drift-only metadata for offline search (id, title, author, source, etc).

### B. Cloudflare KV (Key-Value) - High-Speed Transient Data

* **Partner Nudges:** Keys structured as `nudge:{target_user_id}:{sender_id}`. TTL (Time to Live) set to 24 hours.

## 3. API Endpoints (Cloudflare Workers - TypeScript/Hono)

* `POST /api/auth/register` & `/api/auth/login` - Authenticates users and issues JWTs.
* `POST /api/sync/habit` - Initializes or updates habit metadata and color. Only the habit owner may update/archive an existing habit; the route also ensures the owner self-row exists in `partnerships`.
* `POST /api/sync/log` - Submits a daily completion or a skip. Only `owner` and `partner` roles may create logs. New completed logs award backend-owned progression points and badges; duplicate `log_id` replays do not re-award.
* `GET /api/sync/daily` - A single payload fetched silently in background to populate partner snapshots, nudges, friend invitations, and the authoritative `gamification` object.
* `GET /api/social/search` & `GET /api/social/leaderboard` - Used by the Social Hub UI.
* `POST /api/social/friend-request` & `/accept` & `GET /api/social/friend-request` - Friend request lifecycle.
* `POST /api/social/habit-invitation`, `/accept`, and `/decline` - Habit partner invitation lifecycle. Creating an invitation requires an accepted friendship and requester ownership of the habit. Accepting an invite adds the recipient as `partner` and fans out directed partnership rows to existing participants.
