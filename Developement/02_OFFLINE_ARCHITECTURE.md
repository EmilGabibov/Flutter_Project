# 02: Offline-First Architecture & State Management

**Target Stack:** Flutter / Riverpod (State Management) / Drift (Local SQLite Database)
**Agent Instructions:** Use this document to build the local database schema, the background sync engine, and the state management providers. Ensure all state changes update the UI instantaneously via optimistic updates.

## 1. The Local-First Principle (Drift SQLite)

The app must read **only** from the local device database to render the UI. Network requests should never directly drive the UI on the Home Screen.

* **Database Parity:** Use **Drift** to create local tables (`users`, `habits`, `logs`) that mirror the D1 schema exactly, including `updated_at`.
* **Web Storage:** On Flutter web, Drift uses browser-backed storage via `WebDatabase('hable_db')`; the same local-first rules still apply, but the executor changes by platform.
* **Sync Metadata:** Every local table must include one extra column specifically for Drift:
  * `is_synced` (Boolean): Defaults to `false` when a user makes a local change.
* **Account activation state:** Local `users` rows cache optional `email` and `email_verified_at` fields. The app can start with username/password auth only; Profile activation later verifies email through the backend and updates Drift so recovery/cloud-sync status renders offline.

## 2. The Sync Engine (Background Worker)

Implement a reliable synchronization queue using packages like `connectivity_plus` (to check network status) and `workmanager` (for background execution).

* **Outbound Mutations (Habit Creation, Completions, Skips, Nudges, Habit Invites):** When the user creates a habit, completes/skips a habit, sends a poke, or invites an accepted friend to a habit:
  1. Write the mutation (e.g., the `COMPLETED` log, or a queued `NUDGE` intent) to the local Drift database/queue.
  2. Immediately update the UI locally.
  3. Push a sync task to the background queue.
  4. Habit edit/archive/restore actions should also enqueue the full habit payload, including `status`, so the backend can persist the same lifecycle state that Drift shows locally.
  5. For habit partner invites, create the local habit first, enqueue the full habit sync payload, then enqueue one `sendHabitInvitation` item per accepted friend.
* **The Background Queue:** 
  * If the device is online, trigger the queue immediately to push data to Cloudflare Workers.
  * If offline, store the tasks. The queue must automatically begin processing when `connectivity_plus` detects a restored internet connection.
  * Treat `connectivity_plus` as a retry hint, not a hard gate. ADB-reversed local development can report no Wi-Fi/mobile network while `http://127.0.0.1:8787` is reachable, so foreground sync attempts should rely on the HTTP result and retry failures later.
* **Inbound Sync (Social & Quotes):** To handle partner nudges, accepted friends, habit invitations, and feeds, poll the Cloudflare `GET /api/sync/daily` endpoint silently in the background when the app is opened, updating the local database. Riverpod will dynamically refresh the UI.
  * `HomeScreen` initializes the sync service and pulls daily sync after login so accepted-friend chips, invitation banners, and partner snapshots are populated from Drift without direct Home-screen network reads.
  * `SyncService.pullDailySync` should normalize `nudges`, private messages, habit invitations, friend requests, and accepted-friend changes into local `notification_events` rows before the UI renders badges or inbox state. The notification center reads that unified local stream rather than special-casing backend payloads in multiple screens.
  * Received nudges should also update `PartnerSnapshots.lastNudgeAt` for the matching `(habit_id, partner_id)` when `habit_id` is present, so Home can render card-local nudge state from Drift after the ephemeral KV event has been consumed. Legacy sender-only nudges may update all matching partner snapshots as a backward-compatible fallback.
  * Completion and skip actions on Home should also flush the sync queue immediately after writing the optimistic local log so shared progress moves cross-app without waiting for a later connectivity callback.
  * Partner snapshots now cache the backend `role` field as well. Flutter may render optimistically, but the Worker remains authoritative: an owner-only mutation that reaches the sync queue from a stale client must fail visibly instead of being inferred locally as allowed.
  * Shared-habit reconciliation must update the local habit row with backend status and the viewer's remaining days, not force every inbound shared habit back to `active` with zero progress.
  * Partner-side shared-habit check-ins should write the daily log and decrement the viewer's remaining days without marking the local shared card `completed`; the card must remain in `watchActiveHabits` so the collaboration stays visible after check-in.
  * Server progression also arrives through `/api/sync/daily`. Flutter caches `total_points`, `level`, and achievement unlocks in Drift; client-side `syncScore` queue items are deprecated and ignored locally so stale score posts cannot block newer mutations.
* **Local Reminder State:** Daily reminder preferences live locally in Drift and only schedule OS notifications after an explicit user action. Reminder enablement is a device-local concern; unsupported platforms such as web should preserve the setting in-app without pretending push exists.
* **Anonymous Development Diagnostics:** Usage diagnostics run beside the sync engine but remain separate from auth/social payloads. Flutter records only local aggregate buckets for allowlisted screens (`auth`, `home`, `profile`, `social_hub`, `notification_center`, `habit_form`, `onboarding`) plus `app_open`; it rounds visible time to 5-second buckets before persisting. Remote upload is off by default and only occurs when an explicit compile-time flag enables `POST /api/dev/usage-aggregate`.

## 3. State Management (Riverpod)

* **Stream Providers:** Use Riverpod `StreamProvider` to listen directly to Drift database queries. When the background sync engine updates data, Riverpod automatically pushes the update to the UI.
* **Accepted Friend Picker:** Habit creation watches the local Drift accepted-friends cache through Riverpod. It must not block on a live network search from Home/Profile.
* **Home Creation Entry:** Home opens the shared `HabitFormSheet` only. It must not insert habits directly or create a second mutation path; new habits still flow through `habitActionsProvider`, Drift, and the sync queue.
* **Role-Aware Card Reads:** Per-habit partner/supporter rows and Profile habit-management affordances should read cached `PartnerSnapshots` through habit-scoped Riverpod providers. Role/status polish must stay local-first and must not trigger direct card-level network calls.
* **Usage Screen Instrumentation:** Because Hable uses direct widget swaps and `Navigator` pushes rather than a named-route table, usage diagnostics should instrument top-level screens with explicit wrappers/lifecycle hooks instead of storing route strings or screen arguments.
* **Notification Center Reads:** The unread bell count, notification list, and reminder-setting card should all read from Drift-backed Riverpod providers so app restart and account relaunch restore the same local state without direct network dependencies.
* **The Resistance State Isolation:** Create a specific `StateNotifier` to handle the `current_day` math. **This isolates the logic for the "Mud" animation coefficient so the UI thread doesn't calculate physics.** The UI widget will only read the final scalar outputs from this notifier.

## 4. Conflict Resolution

* **Optimistic UI:** The user must never see a "syncing" spinner block their actions. All actions are assumed successful locally.
* **Last Write Wins:** If a user logs a habit on two offline devices, the backend Cloudflare Worker must resolve conflicts by accepting the payload with the most recent `updated_at` timestamp.
