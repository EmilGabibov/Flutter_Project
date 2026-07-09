# 08: Testing Procedures & Smoke Tests

**Target Stack:** Flutter / ADB / Integration Tests

## 1. ADB Twin-App Smoke Test

Because Hable involves mutual habit tracking and a offline-first sync engine, it is necessary to test interactions between two distinct users on physical hardware.

### Pre-requisites
1. A physical Android device connected via ADB (`adb devices`).
2. Cloudflare Worker backend running locally (`npm run dev` in `backend/`).
3. Local D1 schema applied: `npm run db:setup` in `backend/`.
4. Port forwarding active: `adb reverse tcp:8787 tcp:8787`.

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
