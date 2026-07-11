# Twin-App Friend Flow Test Harness

This guide provides instructions for testing the end-to-end mutual habit tracking and nudging flow on a single Android device using two isolated instances of the Hable app.

## Prerequisites

1. An Android device or emulator connected and accessible via ADB (`adb devices`).
2. The Cloudflare Worker backend must be running locally.
3. The local database (`schema.sql`) must be seeded with test users (`local-user-1`, `local-user-2`) and the shared habit (`shared-habit-1`).

## 1. Start the Local Backend

If not already running, start the Cloudflare backend in the `backend` directory:

```bash
cd backend
npm run db:setup
npm run dev
```

Since the Android emulator needs to access `localhost:8787`, you must reverse the port via ADB:

```bash
adb reverse tcp:8787 tcp:8787
```

## 2. Install the Primary App (Alice)

Run the following command to install the `primary` flavor of the app, automatically seeded as Alice:

```bash
flutter run --flavor primary \
  --dart-define=SEED_USER_ID=local-user-1 \
  --dart-define=SEED_USERNAME=Alice \
  -d <your-device-id>
```

- This installs an app named **Hable Primary**.
- It bypasses normal onboarding and creates a local Drift database belonging to `local-user-1`.
- It also seeds `shared-habit-1` locally.

## 3. Install the Friend App (Bob)

Open a new terminal window and run the following command to install the `friend` flavor:

```bash
flutter run --flavor friend \
  --dart-define=SEED_USER_ID=local-user-2 \
  --dart-define=SEED_USERNAME=Bob \
  -d <your-device-id>
```

- This installs an app named **Hable Friend**.
- It creates an isolated local Drift database belonging to `local-user-2`.
- It also seeds `shared-habit-1` locally.

## 4. Test the Mutual Flow

With both apps installed, you can now test the social features:

1. **Verify Mutual Habit**: Open both apps. You should see the "Shared Dev Habit". Wait for the daily sync, or trigger it.
2. **Verify Partner Ticker**: In the primary app (Alice), Bob's avatar should appear in the partner ticker at the bottom. In the friend app (Bob), Alice's avatar should appear.
3. **Send a Nudge**: Tap Bob's avatar in the primary app. This enqueues a nudge in the local Drift `SyncQueue`.
4. **Sync**: Wait for the background sync to process the queue and send the nudge to the backend.
5. **Receive Nudge**: Open the friend app (Bob). During the next daily sync pull, the nudge should be received and processed.
6. **Habit Completion**: Complete the habit in one app. After sync, the other app should reflect the completed status (e.g., the partner avatar will have a glowing border).
7. **Preset Habit Invite**: In Alice's app, create a new habit from a preset and select Bob in the partner picker. Let the sync queue send the habit and invite.
8. **Invite Acceptance**: In Bob's app, run/open daily sync, verify the invitation banner appears, accept it, then verify the partnership appears only after acceptance.
9. **Role Checks**: Verify Alice can still edit/archive the shared habit, Bob can complete/skip it but cannot edit/archive it, and only shared-habit participants can send nudges.

## Troubleshooting

- **Android package collision**: Ensure you are using the `--flavor` flag so that the `applicationIdSuffix` applies correctly.
- **Connection refused**: Run `adb reverse tcp:8787 tcp:8787` again if the emulator loses the port mapping.
- **Stale data**: To reset, uninstall both apps from the device to wipe the local Drift databases, and restart the Cloudflare local worker to reset the in-memory D1 data.
- **No partner chips**: Confirm `npm run db:setup` has applied `schema.sql`, run `adb reverse tcp:8787 tcp:8787`, and check logcat for `[SyncService] GET /api/sync/daily successful`. Open Alice after the accepted friendship exists so `/api/sync/daily` can populate the local accepted-friends cache before testing habit invites.
- **Old local D1 state**: If `schema.sql` fails with `no such column: role`, run `npx wrangler d1 execute hable_db --local --command "ALTER TABLE partnerships ADD COLUMN role TEXT NOT NULL DEFAULT 'partner';"` once, then rerun `npm run db:setup`.
