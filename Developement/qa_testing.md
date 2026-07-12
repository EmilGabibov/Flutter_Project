# 08: Testing Procedures & Smoke Tests

**Target Stack:** Flutter / ADB / Integration Tests

## 1. ADB Twin-App Smoke Test

> [!NOTE]
> For the standalone step-by-step operational guide (preferred for manual passes), see [`qa_twin_test_harness.md`](qa_twin_test_harness.md). This section documents the full checklist and execution history.

Because Hable involves mutual habit tracking and a offline-first sync engine, it is necessary to test interactions between two distinct users on physical hardware.

### Pre-requisites
1. A physical Android device connected via ADB (`adb devices`).
2. Cloudflare Worker backend running locally (`npm run dev` in `backend/`).
3. Local D1 schema applied: `npm run db:setup` in `backend/`.
4. Port forwarding active: `adb reverse tcp:8787 tcp:8787`.
5. Normal debug auth now uses `http://127.0.0.1:8787` by default; use `--dart-define=HABLE_API_BASE_URL=...` only when targeting a non-default host such as `10.0.2.2` on an emulator.

### Execution
1. Install the primary app (Alice):
   `flutter build apk --debug --flavor primary --dart-define=SEED_USER_ID=local-user-1 --dart-define=SEED_USERNAME=Alice`
   `adb install build/app/outputs/flutter-apk/app-primary-debug.apk`
2. Install the friend app (Bob):
   `flutter build apk --debug --flavor friend --dart-define=SEED_USER_ID=local-user-2 --dart-define=SEED_USERNAME=Bob`
   `adb install build/app/outputs/flutter-apk/app-friend-debug.apk`

### Smoke Verification Checklist
- **Unauthenticated State:** Ensure logged-out users are routed to `AuthScreen` and cannot access Home, Profile, or Social Hub.
- **Friend Requests:** Use the search icon in the Social Hub header to open the Find Friends sheet, search for "Bob" (from Alice's app), send a friend request, and verify duplicate taps stay idempotent.
- **Request Actions:** In Bob's app, open Social Hub → Friends tab, verify inline pending request section shows Accept and Decline for incoming requests, and accept Alice's request for the main habit-sharing pass.
- **Habit Sync:** Create a new habit in Alice's app. Verify it syncs to the Cloudflare Worker.
- **Role Authorization:** After Bob accepts the habit invite, verify Alice can still edit/archive the shared habit, Bob can complete/skip it but cannot edit/archive it, and a future supporter account cannot complete/skip it.
- **Three-Tab Shell:** Verify authenticated users land in a shell with exactly Home, Social, and Profile as primary destinations. Android back from Social/Profile should return to Home before exiting.
- **Home Habit Creation:** From Home, tap the persistent **Habit** FAB and verify it opens `HabitFormSheet`. In the empty state, tap **Add habit** and verify it opens the same sheet. After creating a habit, verify the suggested preset strip no longer crowds the active habit card.
- **Nested Settings:** From Profile, tap the gear icon and verify Settings opens with account/avatar, cloud activation, daily reminder, accessibility/language placeholders, and sign out. Settings must not appear as a fourth tab.
- **Preset Habit Partner Invite:** Create a preset habit in Alice's app, select Bob from the accepted-friend chips, verify the queued habit sync runs before `sendHabitInvitation`, then open Bob's app and accept/decline the invitation banner.
- **Shared Check-In Retention:** After Bob accepts Alice's habit invite, have Bob complete the shared habit on his app. Verify Bob's shared habit card remains visible on Home after check-in instead of disappearing from active habits.
- **Nudges:** Tap the separate hand/nudge action on a partnered habit card to enqueue a habit-scoped nudge. Wait for background sync and verify the receiving twin app shows a card-local ring pulse/chip such as "Nudged by Alice" and also records the notification-center row.
- **Notification Center:** After sending a nudge, message, invite, or friend request, verify the receiver's Home bell switches to Social → Activity tab showing the event. Verify the unread badge clears after "Mark all read" is tapped.
- **Daily Reminder:** From Profile, enable the daily reminder, grant OS permission, choose a time, restart the app, and verify the setting persists locally and restores scheduling without another prompt. Then disable it and verify the scheduled reminder is canceled.
- **Friend Profile Drilldown:** From a habit card, tap a partner identity and verify it opens the friend's profile. Tap the separate hand/nudge action and verify a `sendNudge` queue item is created for that partner without navigating away. From the friend profile, tap `Follow` on an active habit and verify `HabitFormSheet` opens with the title prefilled; tap encourage and verify it uses the same queued nudge path.

*(Note: Automated Flutter `integration_test` scripts are currently known to time out during the ADB install phase on physical devices, so this manual twin-harness remains the primary smoke procedure.)*

## 2. ADB Smoke Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. **Unauthenticated Pass:** Clearing the app data and launching the app defaults to the `AuthScreen`. Without setting the test identities, the user cannot access the Home, Profile, or Social Hub screens, confirming that the unauthenticated gates work correctly.
2. **Primary (Alice) Pass:** 
   - Installed `app-primary-debug.apk` with `SEED_USER_ID=local-user-1`.
   - The app bypassed the Auth screen and successfully seeded the Drift DB.
   - Searching for "Bob" originally returned a 500 error due to a schema mismatch on the backend (the `total_score` column was missing in the local SQLite state).
   - After applying `ALTER TABLE users ADD COLUMN total_score INTEGER NOT NULL DEFAULT 0;` to the local D1 SQLite state, the search API successfully returned Bob.
   - Clicked "Add Friend", and the API successfully created a `pending` friend request.
3. **Friend (Bob) Pass:**
   - Installed `app-friend-debug.apk` with `SEED_USER_ID=local-user-2`.
   - Navigated to Social Hub -> Requests tab.
   - Alice's pending friend request successfully appeared in the UI.
   - Clicked "Accept", and the API successfully changed the friend request status to `accepted` in the database.

**Failures Encountered & Resolved:**
- **Auto-Backup Issue:** Android auto-backup restored production tokens causing a `401 Unauthorized` loop. Resolved by adding logic to `AuthProvider` to wipe secure storage and Drift DB when `kDebugMode` is true.
- **D1 Schema Mismatch:** The local D1 state was missing the `total_score` column added in a recent task. Resolved by manually applying the ALTER TABLE statement to the local `.wrangler` state files.

- The `.gitignore` was missing `backend/.wrangler/` and `.env`. These have been appended to prevent committing local database states and environment variables.

---

## 3. ADB 3D Environment & Inbox Features Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. **App Installation & Startup:**
   - Both `app-primary-release.apk` (Alice) and `app-friend-release.apk` (Bob) were successfully built and installed over ADB.
   - Using `adb reverse tcp:8787 tcp:8787`, both instances successfully connected to the local Cloudflare D1 environment.
2. **3D Abstract Habit Environment:**
   - Evaluated the `HomeScreen` UI. The new `HabitEnvironmentVisualizer` is now successfully rendered on the homescreen above the invitation banner.
   - Rendering verified: The `CustomPainter` efficiently renders the pseudo-3D abstract space on the physical Android device without significant UI thread locking or jitter.
    - The newly merged **Activity** tab (Social → Activity) serves as the unified notification and message feed. The former **Inbox** tab is no longer a standalone surface.
   - The **Find Friends** search is now a bottom sheet triggered by the search icon in the Social header, no longer a separate tab.
4. **Overall Pass:** 
   - All newly built features are integrated successfully into the primary app flow, meeting the multi-user social features acceptance criteria.

---

## 4. ADB Preset Habit Invite Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. Applied `backend/schema.sql` with `npm run db:setup`, then launched local Wrangler on `127.0.0.1:8787`.
2. Built and installed `primary` as Alice and `friend` as Bob with the seed-user dart defines.
3. Alice opened Home, pulled `/api/sync/daily`, and the habit creation sheet showed shared standard presets, a `21` day duration, and Bob as an accepted-friend partner chip.
4. Alice selected Bob and saved the Hydration preset. Device logs showed `POST SYNC_HABIT successful` followed by `POST HABIT_INVITATION successful`.
5. Bob opened the friend app, pulled `/api/sync/daily`, saw the invitation banner, accepted it, and device logs showed `POST ACCEPT_INVITATION successful`.
6. API verification after accept showed no pending invitations and symmetric partner visibility for the Hydration habit with `target_duration = 21`.

**Backend hardening checks:**
- Duplicate pending habit invite returned the same invitation id.
- Self-invite returned HTTP `400`.
- Non-friend invite returned HTTP `403`.

---

## 5. ADB Home Habit Creation Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. Built and installed `app-primary-debug.apk` with Alice seed defines, cleared app data, and launched Home.
2. Verified the authenticated shell exposes Home, Social, and Profile as primary destinations.
3. Tapped the Home **Habit** FAB and confirmed it opens the shared `HabitFormSheet`.
4. Closed the sheet, tapped the empty-state **Add habit** button, selected the Hydration preset, and saved.
5. Verified the new Hydration habit appeared immediately through local Home state and the suggested preset strip no longer rendered above the active habit card.
6. Device logs showed `POST SYNC_HABIT successful`; no Flutter `RenderFlex` overflow was present in the Home creation flow.

## 6. Cloudflare Pages Web Smoke Test

**Date:** 2026-07-09
**Target:** `https://hable.pages.dev`

**Build/Deploy:**
1. Built the web bundle from the repo root with `flutter build web --release --base-href /`.
2. Deployed from `backend/` with `wrangler pages deploy ../build/web --project-name hable --branch main --commit-dirty=true --cwd backend`.
3. Confirmed the live production alias eventually served the new deployment after propagation.

**Smoke Verification Checklist:**
- Opening `https://hable.pages.dev` returns the Flutter shell with the `Hable` title and manifest metadata.
- `POST /api/auth/register` returns a JWT and seed user payload on the deployed origin.
- `POST /api/sync/habit` accepts an authenticated habit write.
- `GET /api/sync/daily` returns the expected JSON payload from the deployed origin.
- The production alias is the one exercised by the browser/web smoke flow, not the local Wrangler dev server.

**Notes:**
- The first direct upload produced a preview URL, but the production alias updated after propagation.
- Remote D1 schema had to be synchronized with `backend/schema.sql` before habit sync smoke tests passed.

## 8. Local Worker RBAC Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Pre-step for old local D1 state:** If `npm run db:setup` fails with `no such column: role`, run:
`npx wrangler d1 execute hable_db --local --command "ALTER TABLE partnerships ADD COLUMN role TEXT NOT NULL DEFAULT 'partner';"`
Then rerun `npm run db:setup`.

**Executed checks:**
1. Logged in seeded `local-user-1` and `local-user-2` through `POST /api/auth/login`.
2. Sent and accepted a friend request, created `role-habit-1` as Alice, invited Bob, and accepted the invite as Bob.
3. Verified Bob receives `403` on `POST /api/sync/habit` for the shared habit, while Alice can archive it successfully.
4. Verified Bob receives `200` on `POST /api/sync/log` for the shared habit.
5. Registered `CharlieRole`, inserted a `supporter` partnership row locally for the same habit, and verified Charlie receives `403` on `POST /api/sync/log` but `200` on `POST /api/social/nudge`.

**Outcome:** Owner edit/archive, partner log, partner edit rejection, supporter log rejection, and supporter nudge authorization all matched the RBAC contract.

## 9. Local Worker Gamification Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Executed checks:**
1. Logged in seeded `local-user-1` and `local-user-2`, captured each user's initial `/api/sync/daily.gamification.total_points`, then created a unique shared habit from Alice.
2. Alice completed the habit once and replayed the same `log_id`; the replay returned `accepted: false`.
3. Bob accepted the habit invite, completed the same habit for the same date, and replayed the same `log_id`; the replay returned `accepted: false`.
4. Bob skipped the habit on a later date; skip was accepted but did not add points.
5. Bob nudged Alice and received `first_nudge`; both users received `first_check_in`.
6. Posting to deprecated `/api/sync/score` returned HTTP `410`.

**Outcome:** Alice and Bob each gained exactly `10` points from one completed check-in plus one shared-habit bonus. Duplicate log replays did not change the score, and `/api/sync/daily` returned `gamification.level`, `badges`, and `newly_unlocked_badges`.

## 10. Widget Smoke For Role-Aware Partner Row

**Date:** 2026-07-11  
**Target:** Flutter widget test

**Executed checks:**
1. Rendered `HabitPartnerRow` with five mixed-role partner snapshots.
2. Verified only four visible partner chips render, with the fifth collapsed into a `+1` overflow chip.
3. Verified visible role copy still renders (`owner`) so the chip exposes role state even when avatar-only space is tight.

**Outcome:** The per-card partner row preserves the avatar cap and overflow behavior required for narrow layouts without depending on network state.

## 13. Three-Tab IA Widget Smoke

**Date:** 2026-07-11  
**Target:** Flutter widget test

**Executed checks:**
1. Rendered `MainNavigationShell` with an in-memory Drift database.
2. Verified the shell exposes Home, Social, and Profile in the primary `NavigationBar`.
3. Verified the Home **Habit** FAB opens `HabitFormSheet`.
4. Verified switching to Social exposes three internal tabs: **Friends**, **Activity**, and **Leaderboard**.
5. Verified the **Find Friends** search icon is present in the Social header.
6. Verified switching to Profile exposes the settings gear.
7. Verified Android back from non-Home returns to Home.

**Outcome:** The refined three-tab IA with reorganized Social (3 sub-tabs, inline requests, Activity feed, Find Friends sheet) is covered at the widget level.

## 12. Shared Habit Retention And Nudge State Smoke

**Date:** 2026-07-11  
**Target:** Flutter database/widget tests plus backend type-check

**Executed checks:**
1. Verified `completeHabitDay(..., keepActiveWhenDurationEnds: true)` leaves a partner-side shared habit active at zero remaining days so `watchActiveHabits` keeps rendering the card.
2. Verified `markPartnerNudgeReceived` coalesces repeated nudges into the same `PartnerSnapshots.lastNudgeAt` row for a sender/habit without touching unrelated shared habits.
3. Verified `HabitPartnerRow` renders a visible `nudged` state for a recent `lastNudgeAt`.
4. Type-checked the Cloudflare worker after adding optional `habit_id` nudge payload support.

**Outcome:** Shared cards stay visible after partner check-in, received nudges have a durable local Home-card state, and repeated sender/habit nudges stay bounded.

## 14. Local Worker Friend Request Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Commands/Checks:**
1. Ran `npm run db:setup` in `backend/`.
2. Started local Worker with `npm run dev`.
3. Ran `npm run smoke:social`.
4. Ran `npm run smoke:lifecycle`.

**Coverage verified:**
- Fresh-user social smoke registered two users, verified privacy-safe search fields and relationship state, rejected self-request, kept duplicate pending sends idempotent, listed incoming requests, declined, resent, accepted, and verified accepted-state search.
- Lifecycle smoke still passed after idempotent friend-request handling, including shared normal habit sync, shared multi-day habit sync, Bob-owned habit visibility, owner-only metadata update rejection, archive propagation, and private habit exclusion.
- Flutter verification covered `friend_relationships` cache behavior with `test/friend_relationship_cache_test.dart`, plus the full `flutter test` suite.

**Android twin-harness follow-up:** Later on 2026-07-11, `emulator-5554` became available through the SDK-local `adb` binary. Re-applied `adb reverse tcp:8787 tcp:8787`, rebuilt `app-primary-debug.apk` and `app-friend-debug.apk` with seeded Alice/Bob identities, installed both packages, and launched both flavors. Android UI hierarchy dumps confirmed Alice and Bob each reached Home with the reciprocal shared `Hydration` card, partner identity, FAB, and Home/Social/Profile shell. MobAI MCP tools were still not exposed, so validation used `adb` launch plus UI hierarchy evidence instead of MobAI DSL.

## 15. Account And Social API Regression Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Commands/Checks:**
1. Ran `flutter analyze`.
2. Ran `flutter test`.
3. Ran `npx tsc --noEmit` in `backend/`.
4. Ran `npm run db:setup` in `backend/`.
5. Started local Worker with `npm run dev`.
6. Ran `npm run smoke:regression`.

**Coverage verified:**
- Username/password registration returned JWT/user payloads, and case-insensitive username login returned the same user.
- Authenticated Profile activation PIN request completed in local development and printed the PIN to Wrangler logs.
- Emoji avatar update succeeded, and URL/non-emoji avatar update was rejected by the Worker.
- Friend search returned privacy-safe state, friend request/accept worked, and leaderboard returned the current user plus accepted friend instead of hanging.
- Created a shared habit, accepted the invite, sent a habit-scoped nudge, and verified the receiver's `/api/sync/daily` payload contained the nudge.

**Outcome:** PASS. The route/method regressions covered by the task now resolve to successful data paths or clear 400/error responses instead of 405s, ambiguous API failures, or indefinite loading.

## 16. Skeleton Empty State Widget Smoke

**Date:** 2026-07-11  
**Target:** Flutter widget tests

**Commands/Checks:**
1. Ran `flutter analyze`.
2. Ran `flutter test test/skeletons_test.dart`.
3. Ran full `flutter test`.

**Coverage verified:**
- Added reusable skeleton blocks/cards/lists and structured empty-state cards.
- Verified the empty-state card scrolls instead of overflowing in a short viewport.
- Existing shell, notification, profile CRUD, partner row, leaderboard, and app-launch tests all pass with the skeleton replacements.

**Outcome:** PASS. Main loading states now preserve screen shape with skeletons or structured empty cards instead of abrupt full-screen spinners/blank gaps.

## 7. Android Web-Era Regression Smoke

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Build/Install:**
1. Ran `flutter analyze` and `flutter test` from the canonical `Flutter/hable` app. Both passed after a small async-context fix in `lib/screens/social/social_hub_screen.dart`.
2. Built fresh debug APKs:
   - `flutter build apk --debug --flavor primary --dart-define=SEED_USER_ID=local-user-1 --dart-define=SEED_USERNAME=Alice`
   - `flutter build apk --debug --flavor friend --dart-define=SEED_USER_ID=local-user-2 --dart-define=SEED_USERNAME=Bob`
3. Installed both APKs with `adb install -r` and set `adb reverse tcp:8787 tcp:8787`.

**Smoke Verification Checklist:**
- The `primary` APK launches on the device and shows Alice's Home screen.
- Social Hub opens from Home and renders the accepted-friends cache, including Bob.
- The `friend` APK launches on the same device and shows Bob's Home screen.
- The friend flavor uses the native Android database path and does not crash on startup after the web-specific database split.
- The shared Android flows continue to work after the web deployment work: Home rendering, social navigation, and flavor-specific installs.

**Notes:**
- `adb` was not on PATH in this environment, so the SDK path was used directly: `~/Library/Android/sdk/platform-tools/adb`.
- The Android smoke did not require any web-only assets; the shared code path remained compatible with Android.

## 11. ADB Fresh Registration Smoke Test (Emulator)

**Date:** 2026-07-11  
**Device ID:** `emulator-5554` (Google Emulator, Android 17 API 37)  
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Setup:**
1. Started backend: `cd backend && npm run dev` on port 8787.
2. Configured ADB port forward: `adb reverse tcp:8787 tcp:8787`.
3. Cleared primary app data: `adb shell pm clear com.hable.app.primary`.
4. Verified both APK flavors installed: `com.hable.app.primary` and `com.hable.app.friend`.

**Execution & Observations:**

**Phase 1: Backend Connectivity**
- Initial app launch showed "Cannot reach the backend at http://10.0.2.2:8787" error (expected without reverse forward or prior restart).
- After `adb reverse tcp:8787 tcp:8787` and restarting the app, error cleared immediately.
- Backend health confirmed: `curl http://127.0.0.1:8787/` returned Hable API landing page.

**Phase 2: Unauthenticated State**
- Fresh app install landed directly on `AuthScreen`.
- UI hierarchy confirmed: Username field, Password field, "Forgot Password?" button, "Log In" button, "Sign up" toggle.
- Logged-out users cannot access Home, Profile, or Social Hub; gating works correctly. ✅

**Phase 3: Registration & Auth Flow**
- Tapped "Sign up" button -> Registration form appeared with Username and Password fields.
- Entered credentials: `testuser_smoke1` / `TestPass123`.
- Tapped "Sign Up" → Request sent to backend, registration completed in ~2 seconds.
- Post-registration: App automatically routed to `HomeScreen` without requiring manual login. ✅

**Phase 4: Authenticated Home & UI**

## 12. Anonymous Usage Diagnostics Checks

**Date:** 2026-07-11  
**Targets:** Flutter unit test + backend TypeScript compile

**Executed checks:**
1. Ran `flutter analyze` from the app root and verified the diagnostics additions introduced no analyzer issues.
2. Ran `flutter test test/usage_diagnostics_service_test.dart`.
3. Ran `npx tsc --noEmit` in `backend/`.

**Coverage verified:**
- `UsageDiagnosticsService` records only aggregate counters (`app_open`, `screen_visit`) and rounded visible duration totals.
- Visible duration rounds to 5-second buckets before persistence.
- Upload payload generation omits user/account/device identifiers and auth fields.
- Remote upload does not run unless explicitly enabled.
- Worker-side development routes typecheck cleanly after adding `usage_aggregate_buckets` handling and the aggregate HTML/JSON report surface.
- Home screen displayed with:
  - Welcome message "Good morning" ✅
  - User display name: `testuser_smoke1` ✅
  - Three suggested habit presets: Hydration (💧), Reading (📖), Meditation (🧘) ✅
  - "Add habit" button in header ✅
  - "Open profile" button ✅
  - "Open social hub" button ✅
  - Empty state message: "No active habits yet. Start one from Home." ✅
  - Daily quote footer ✅

**Phase 5: APK Flavor Isolation**
- Both flavors remain installed and isolated:
  - `com.hable.app.primary` (package: `...primary`) ✅
  - `com.hable.app.friend` (package: `...friend`) ✅
- Each maintains separate local Drift database (verified via app data paths).

**Failures Encountered:** None. All core flows passed without errors.

**Repo Hygiene:**
- `.gitignore` already contains `backend/.wrangler/` and `.env` to prevent committing local state. ✅
- No new untracked generated files discovered.

**Smoke Pass Conclusion:** ✅ PASS

All acceptance criteria met:
- Unauthenticated users gate to AuthScreen only.
- Authenticated users access Home, Profile, Social Hub.
- Backend connectivity via `adb reverse` successful.
- Registration end-to-end flow confirmed.
- Both `primary` and `friend` flavors installed side-by-side with isolation.
- `.gitignore` properly configured.

## 12. Auth Repair And Profile Activation Smoke

**Date:** 2026-07-11
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8788` because port `8787` was already occupied by another local process.

**Commands/Checks:**
- Ran `npm run db:setup` to apply `backend/schema.sql` locally.
- Ran `npx wrangler pages dev public --port 8788`.
- Verified `POST /api/auth/register` accepts username/password only and returns JWT/user payload.
- Verified `POST /api/auth/login` accepts uppercase username input for the same stored lowercase username.
- Verified browser CORS preflight for `Origin: http://localhost:59999` returns `Access-Control-Allow-Origin`.
- Verified authenticated `POST /api/user/email/request-pin` prints a development Profile Activation PIN locally.
- Verified authenticated `POST /api/user/email/verify-pin` stores `email` and `email_verified_at`.
- Verified `POST /api/auth/request-pin`, `POST /api/auth/reset-password`, and login with the changed password for the activated email.

**Outcome:** PASS. Signup no longer requires email, username login is case-insensitive, Profile owns optional email/PIN activation, and password reset works after activation.

## 13. Production Auth Deployment Repair

**Date:** 2026-07-11
**Target:** `https://hable.pages.dev`

**Issue reproduced:**
- `POST /api/auth/register` returned `405` with an empty body on production.
- `POST /api/auth/login` returned `405` with an empty body on production.
- `OPTIONS /api/auth/register` returned `405`, so browser CORS preflight could fail before app auth requests.
- `POST /api/user/email/request-pin` reached the function after redeploy but returned `502` because production email delivery was not configured for Hable.

**Repair:**
- Ran `npx wrangler d1 execute hable_db --remote --file=./schema.sql`.
- Ran `npm run deploy` from `backend/` so Pages Functions were deployed with the API bundle.
- Added `EMAIL_WORKER` service binding to Hable's Pages config, pointing to the existing `campusweb-mailer` Worker.
- Updated `sendPinEmail` so an `EMAIL_WORKER` binding can send PIN emails without requiring duplicate sender/API-token secrets in Hable.

**Production checks:**
- `POST https://hable.pages.dev/api/auth/register` returned `200` and a JWT/user payload.
- `POST https://hable.pages.dev/api/auth/login` returned `200` and a JWT/user payload.
- `OPTIONS https://hable.pages.dev/api/auth/register` returned `204` with `Access-Control-Allow-Methods: GET,POST,PUT,DELETE,OPTIONS`.
- Authenticated `POST https://hable.pages.dev/api/user/email/request-pin` returned `200` with `Verification PIN sent`.
- `POST https://hable.pages.dev/api/auth/request-pin` returned `200` with `Verification PIN sent` for an account with an attached email.

**Outcome:** PASS. The reported production 405 auth failures and production PIN delivery failure are repaired.
