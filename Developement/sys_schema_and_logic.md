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

> [!IMPORTANT]
> The Mud resistance math is a **specialized, physics-driven interaction unique to Hable**. The coefficient computation is intentionally client-side and must remain isolated in a Riverpod `StateNotifier`. See [`ux_mud_and_animations.md §3`](ux_mud_and_animations.md) for the canonical mathematical model and Flutter implementation blueprint. Do NOT simplify or inline this logic.

* **The Penalty Engine:**
  * If a day (00:00 to 23:59 local time) passes without a `COMPLETED` or `SKIPPED` log, the habit enters an `OVERDUE` state.
  * When the user executes a `SKIP` action, the `total_duration` integer increments by `+2`.
  * A `SKIP` action *must* enforce a non-null `journal_entry` string payload to be accepted by the API.

## 2. Database Schema Parity (D1 & Drift)

Both the local Drift (SQLite) database and the remote Cloudflare D1 (SQL) database must mirror this schema exactly. 
**Crucially, all tables must include the `updated_at` (Timestamp) column** to enable "Last Write Wins" conflict resolution. Local Drift tables must additionally include an `is_synced` (Boolean) column.

### A. Core Tables (D1 & Drift)

* **`users` table:** `user_id` (UUID, Primary Key), `username` (String), optional `email` (String), optional `email_verified_at` (Timestamp), `password_hash` (String), `avatar_url` (String), `total_score` (Int).
* **`habits` table:** `id` (UUID, PK), `user_id` (FK), `title` (String), optional `description` (String), `target_duration` (Int), `color_hex` (String), `status` (Enum: active, abandoned), `created_at` (Timestamp), `updated_at` (Timestamp). On the Flutter side, any legacy local `completed` rows should be treated as archived-history rows until they are normalized.
* **`habit_logs` table:** `id` (UUID, PK), `user_id` (FK), `habit_id` (FK), `status` (Enum), `logged_at` (Timestamp).
* **`habit_progress` table:** `user_id` (FK), `habit_id` (FK), `current_duration` (Int).
* **`partnerships` table:** `user_id` (FK), `partner_id` (FK), `habit_id` (FK), `role` (Enum: `owner`, `partner`, `supporter`). This is a directed graph over one shared habit: self-rows (`user_id = partner_id`) represent the participant's own role, and non-self rows drive which other participants they can see in daily sync.
* **`user_score_events` table:** `user_id`, `source_event_id`, `points`, `reason`, `created_at`, with `(user_id, source_event_id)` as the idempotency key for backend-owned score awards.
* **`user_achievements` table:** `user_id`, `achievement_id`, `unlocked_at`, `source_event_id`, with `(user_id, achievement_id)` as the idempotency key for backend-owned badge unlocks.
* **`friend_requests` table:** `id` (PK), `requester_id` (FK), `recipient_id` (FK), `status` (Enum), `created_at` (Timestamp).
* **`habit_invitations` table:** `id` (PK), `requester_id`, `recipient_id`, `habit_id`, `status`, `created_at`. Pending duplicates for the same requester/recipient/habit are idempotent.
* **`accepted_friends` table:** Drift-only cache of accepted friends (`friend_user_id`, `username`, `avatar_url`) populated from daily sync for offline habit-invite pickers.
* **`friend_relationships` table:** Drift-only cache of safe friend/search state (`user_id`, `username`, `avatar_url`, `relationship_state`, optional `request_id`) used by Social Hub labels and pending incoming request rows. It must never store habit metadata, logs, journal text, or private message content.
* **`notification_events` table:** Drift-only unified in-app notification read model keyed by a stable `notification_id`, with `user_id`, `type`, `source_type`, `source_id`, `title`, `body`, optional route/payload metadata, `created_at`, optional `expires_at`, optional `read_at`, and `updated_at`. Sync normalization must upsert this table idempotently instead of letting each feature surface parse raw event payloads on its own.
* **`reminder_settings` table:** Drift-only per-user local reminder schedule rows (`user_id`, `type`, `is_enabled`, `hour`, `minute`, `updated_at`). One reminder family can own multiple rows, and each row keeps a stable local scheduling identity so add/edit/delete/restore do not overwrite sibling reminders or turn reminder preferences into a server push-subscription feature.
* **`SearchDocuments` table:** Local Drift-only metadata for offline search (id, title, author, source, etc).
* **`UsageAggregateBuckets` table (Drift-only):** Coarse development diagnostics buckets keyed by `bucket_date`, `platform`, `build_channel`, `screen_name`, and `metric_name`, with aggregate `count`, aggregate `total_duration_ms`, and local upload-watermark columns. This table must never include user IDs, emails, usernames, auth tokens, device/session/install IDs, IPs, user agents, habit titles, or route parameters.
* **`usage_aggregate_buckets` table (D1-only):** Remote development aggregate sink keyed by the same coarse dimensions. Stores only rolled-up counts and rounded duration totals for `app_open`, `screen_visit`, and `screen_visible_ms`. Upload is disabled by default and requires an explicit compile-time flag.

### B. Cloudflare KV (Key-Value) - High-Speed Transient Data

* **Partner Nudges:** Keys structured as `nudge:{target_user_id}:{sender_id}`. TTL (Time to Live) set to 24 hours.

## 3. API Endpoints (Cloudflare Workers - TypeScript/Hono)

* `POST /api/auth/register` & `/api/auth/login` - Authenticates users and issues JWTs. Registration starts with username/password only; login matches usernames case-insensitively while preserving the stored display casing.
* `POST /api/user/email/request-pin` & `/verify-pin` - Authenticated Profile activation flow for users who want a verified email for recoverable cloud progress and password reset support.
* `PUT /api/user/avatar` - Authenticated emoji-only avatar update. The Worker must reject URL/data-upload values; uploaded profile photos belong to a separate future storage task.
* `POST /api/auth/request-pin` & `/reset-password` - Password recovery for accounts with an attached email. Local development logs the PIN; production must send email or return a clear delivery failure.
* `POST /api/sync/habit` - Initializes or updates habit metadata, including the optional description and color. Only the habit owner may update/archive an existing habit; the route also ensures the owner self-row exists in `partnerships`. When the client sends `reset_progress: true`, the Worker must allow it only for solo habits and clear the owner's remote habit logs/progress before re-activating the challenge.
* `POST /api/sync/log` - Submits a daily completion or a skip. Only `owner` and `partner` roles may create logs. New completed logs award backend-owned progression points and badges; duplicate `log_id` replays do not re-award.
* `GET /api/sync/daily` - A single payload fetched silently in background to populate partner snapshots, nudges, friend invitations, notification-event normalization inputs, and the authoritative `gamification` object.
* `GET /api/social/search` & `GET /api/social/leaderboard` - Used by the Social Hub UI.
* `POST /api/social/friend-request`, `/accept`, `/decline`, and `GET /api/social/friend-request` - Friend request lifecycle with self-request guards, idempotent duplicate handling, recipient-scoped accept/decline, and privacy-safe relationship state.
* `POST /api/social/habit-invitation`, `/accept`, and `/decline` - Habit partner invitation lifecycle. Creating an invitation requires an accepted friendship and requester ownership of the habit. Accepting an invite adds the recipient as `partner` and fans out directed partnership rows to existing participants.
* `POST /api/social/nudge` - Habit-scoped or legacy shared-habit nudge. Authorization requires a directed shared-habit participation row and optional `habit_id` narrows the permission check to that habit.
* `POST /api/dev/usage-aggregate` - Development-only anonymous aggregate upsert endpoint. Accepts only allowlisted screen labels plus rounded counts/duration totals and must reject any user-linked dimensions.
* `GET /api/dev/usage-report` - Development-only HTML/JSON report for aggregate buckets. It must show only coarse totals and hide low-volume buckets rather than exposing a user-level event stream.

### Error Envelope Reference

Worker routes should converge on this safe structured error shape:

```json
{
  "error": {
    "code": "machine_readable_code",
    "message": "Safe user-facing message."
  }
}
```

Legacy `{ "error": "..." }` responses may remain temporarily while routes migrate, but new or touched routes should prefer the structured envelope so Flutter can normalize failures consistently.
