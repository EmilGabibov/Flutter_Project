# 08: Testing Procedures & Smoke Tests

**Target Stack:** Flutter / ADB / Integration Tests

## 1. ADB Twin-App Smoke Test

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
- **Friend Requests:** Use the "Find Friends" tab in the Social Hub to search for "Bob" (from Alice's app) and send a friend request.
- **Acceptance:** In Bob's app, open Social Hub -> Requests, and accept Alice's request.
- **Habit Sync:** Create a new habit in Alice's app. Verify it syncs to the Cloudflare Worker.
- **Role Authorization:** After Bob accepts the habit invite, verify Alice can still edit/archive the shared habit, Bob can complete/skip it but cannot edit/archive it, and a future supporter account cannot complete/skip it.
- **Home Habit Creation:** From Home, tap the header add button and verify it opens `HabitFormSheet`. In the empty state, tap **Add habit** and verify it opens the same sheet. After creating a habit, verify the suggested preset strip no longer crowds the active habit card.
- **Preset Habit Partner Invite:** Create a preset habit in Alice's app, select Bob from the accepted-friend chips, verify the queued habit sync runs before `sendHabitInvitation`, then open Bob's app and accept/decline the invitation banner.
- **Nudges:** Tap a partner avatar to enqueue a nudge. Wait for background sync and verify receipt on the twin app.

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
3. **Inbox Tab Integration:**
   - Navigated to the `SocialHubScreen`. The tab count successfully reflects `4` tabs.
   - The newly added **Inbox** tab accurately pulls from the `privateMessagesProvider` local Drift state, successfully separating friend requests, leaderboard ranks, search, and private contextual wishes into distinct interfaces.
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
2. Verified Home header exposes labeled icon buttons for Social Hub, Add habit, and Profile.
3. Tapped the header **Add habit** button and confirmed it opens the shared `HabitFormSheet`.
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
3. Cleared primary app data: `adb shell pm clear com.example.flutter_project.primary`.
4. Verified both APK flavors installed: `com.example.flutter_project.primary` and `com.example.flutter_project.friend`.

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
  - `com.example.flutter_project.primary` (package: `...primary`) ✅
  - `com.example.flutter_project.friend` (package: `...friend`) ✅
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
