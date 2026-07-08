# 01: Schema & Core Logic Specification

**Target Stack:** Flutter (Client) / Cloudflare Workers (API) / Cloudflare D1 & KV (Database)
**Agent Instructions:** Use this document to generate the core Dart models, the Cloudflare Worker API routes, and the database schemas. Do not build UI components yet.

## 1. The Habit Engine Logic (Dart Models & API)

The core logic governs how habits are calculated and penalized.

* **Duration Math:** 
  * Default habits must inherit a `base_duration` of either 21 or 66 days.
  * Custom habits must accept an integer `custom_duration`.
* **The "Mud" Coefficient:** The backend does not calculate resistance; it only tracks the current day. The Flutter client will compute the `resistance_coefficient` locally.

* **The Penalty Engine:**
  * If a day (00:00 to 23:59 local time) passes without a `COMPLETED` or `SKIPPED` log, the habit enters an `OVERDUE` state.
  * When the user executes a `SKIP` action, the `total_duration` integer increments by `+2`.
  * A `SKIP` action *must* enforce a non-null `journal_entry` string payload to be accepted by the API.

## 2. Database Schema Parity (D1 & Drift)

Both the local Drift (SQLite) database and the remote Cloudflare D1 (SQL) database must mirror this schema exactly. 
**Crucially, all tables must include the `updated_at` (Timestamp) column** to enable "Last Write Wins" conflict resolution. Local Drift tables must additionally include an `is_synced` (Boolean) column.

### A. Core Tables (D1 & Drift)

* **`users` table:** `user_id` (UUID, Primary Key), `username` (String), `created_at` (Timestamp), `updated_at` (Timestamp), `total_score` (Int).
* **`habits` table:** `habit_id` (UUID, PK), `user_id` (FK), `title` (String), `is_custom` (Boolean), `target_duration` (Int), `current_duration` (Int - dynamic, updates on penalties), `status` (Enum: ACTIVE, COMPLETED, ABANDONED), `updated_at` (Timestamp).
* **`logs` table:** `log_id` (UUID, PK), `habit_id` (FK), `action_date` (Timestamp), `status` (Enum: COMPLETED, SKIPPED), `journal_note` (Text, nullable), `updated_at` (Timestamp).
* **`partnerships` table:** `partnership_id` (UUID, PK), `habit_id` (FK), `partner_user_id` (FK), `updated_at` (Timestamp).

### B. Cloudflare KV (Key-Value) - High-Speed Transient Data

* **Partner Nudges:** Keys structured as `nudge:{user_id}:{partner_id}`. TTL (Time to Live) set to 24 hours. 
* **Daily Streaks Cache:** Keys structured as `streak:{user_id}:{habit_id}` to serve the home screen instantly upon app launch.

## 3. API Endpoints (Cloudflare Workers - TypeScript/Hono)

* `POST /api/habits/create` - Initializes a new habit and optional partnership.
* `POST /api/habits/log` - Submits a daily completion or a skip (with mandatory journal payload). Updates D1 and increments/resets the KV streak cache.
* `GET /api/sync/daily` - A single payload fetched on app launch to populate the user's current day, partner statuses, and daily encouraging quote.
