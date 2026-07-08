# 02: Offline-First Architecture & State Management

**Target Stack:** Flutter / Riverpod (State Management) / Drift (Local SQLite Database)
**Agent Instructions:** Use this document to build the local database schema, the background sync engine, and the state management providers. Ensure all state changes update the UI instantaneously via optimistic updates.

## 1. The Local-First Principle (Drift SQLite)

The app must read **only** from the local device database to render the UI. Network requests should never directly drive the UI on the Home Screen.

* **Database Parity:** Use **Drift** to create local tables (`users`, `habits`, `logs`) that mirror the D1 schema exactly, including `updated_at`.
* **Sync Metadata:** Every local table must include one extra column specifically for Drift:
  * `is_synced` (Boolean): Defaults to `false` when a user makes a local change.

## 2. The Sync Engine (Background Worker)

Implement a reliable synchronization queue using packages like `connectivity_plus` (to check network status) and `workmanager` (for background execution).

* **Outbound Mutations (Completions, Skips, Nudges):** When the user completes a habit or sends a poke:
  1. Write the mutation (e.g., the `COMPLETED` log, or a queued `NUDGE` intent) to the local Drift database/queue.
  2. Immediately update the UI locally.
  3. Push a sync task to the background queue.
* **The Background Queue:** 
  * If the device is online, trigger the queue immediately to push data to Cloudflare Workers.
  * If offline, store the tasks. The queue must automatically begin processing when `connectivity_plus` detects a restored internet connection.
* **Inbound Sync (Social & Quotes):** To handle partner nudges and feeds, poll the Cloudflare `GET /api/sync/daily` endpoint silently in the background when the app is opened, updating the local database. Riverpod will dynamically refresh the UI.

## 3. State Management (Riverpod)

* **Stream Providers:** Use Riverpod `StreamProvider` to listen directly to Drift database queries. When the background sync engine updates data, Riverpod automatically pushes the update to the UI.
* **The Resistance State Isolation:** Create a specific `StateNotifier` to handle the `current_day` math. **This isolates the logic for the "Mud" animation coefficient so the UI thread doesn't calculate physics.** The UI widget will only read the final scalar outputs from this notifier.

## 4. Conflict Resolution

* **Optimistic UI:** The user must never see a "syncing" spinner block their actions. All actions are assumed successful locally.
* **Last Write Wins:** If a user logs a habit on two offline devices, the backend Cloudflare Worker must resolve conflicts by accepting the payload with the most recent `updated_at` timestamp.
