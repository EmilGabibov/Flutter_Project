# Twin-App Friend Flow Test Harness

> [!NOTE]
> This guide is the standalone operational ADB twin-app harness. For the full testing spec, smoke checklist, and historical execution logs, see [`qa_testing.md`](qa_testing.md).

This guide provides instructions for testing the end-to-end friendship, habit invitation, shared-habit tracking, and nudging flow on a single Android device or emulator using two isolated instances of the Hable app.

## Prerequisites

1. An Android device or emulator connected and accessible via ADB (`adb devices`).
2. The Cloudflare Worker backend must be running locally.
3. The local database (`schema.sql`) must be applied locally with `npm run db:setup`.
4. The app flavors are launched with seeded identities via `SEED_USER_ID` and `SEED_USERNAME`.

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
- The current dev seed path also inserts a starter local habit so the seeded user can reach Home quickly, but shared-habit verification should still use the invite flow below rather than assuming a pre-linked partnership.

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
- It uses a separate local Drift database and package id from the primary flavor.

## 4. Test the Mutual Flow

With both apps installed, test the current social path in this order:

1. **Friend Request**: In Alice's app, open Social Hub -> Find Friends, search for Bob, and send a friend request.
2. **Request State**: Verify Alice's search row changes to `Requested`, and Bob's search row for Alice shows a pending incoming/respond state.
3. **Acceptance/Decline**: In Bob's app, open Social Hub -> Requests and verify the pending row exposes both Accept and Decline. For the main shared-habit pass, accept Alice's request.
4. **Accepted Friend Cache**: Reopen or sync Alice's app and verify Bob now appears as an accepted friend for local invite surfaces.
5. **Habit Invite**: In Alice's app, create a habit from Home or Profile and select Bob from the accepted-friend partner chips.
6. **Invite Acceptance**: In Bob's app, run/open daily sync, verify the invitation banner appears, and accept it.
7. **Shared Habit Visibility**: After acceptance and sync, verify the shared habit appears on both apps.
8. **Progress Sync**: Complete the shared habit on Alice, flush/open Bob, and verify Bob sees Alice's updated per-card partner state. Then complete the same shared habit on Bob and verify Bob's own challenge day advances locally and Alice sees Bob's updated partner state after sync.
9. **Archive Sync**: Archive the shared habit on Alice and verify it disappears from both active Home lists after daily sync while still remaining in archived/history surfaces locally.
10. **Skip Privacy**: Trigger a skip with journal text on one side and verify the shared partner state updates without exposing that free-form journal text in the other install.
11. **Per-Card Social Status**: On the shared habit card, verify partner/supporter avatars render inside the card with role-aware state.
12. **Send a Nudge**: Trigger a nudge from the shared-habit context and wait for the sync queue to flush.
13. **Receive Nudge**: Open or sync the receiving app and verify the nudge is visible through the current in-app social state.
14. **Role Checks**: Verify Alice can still edit/archive the shared habit, Bob can complete/skip it but cannot edit/archive it, and only shared-habit participants can send nudges.

## 5. Backend Social And Lifecycle Smokes

Before or after the device pass, run the repeatable backend social and lifecycle smokes against the local Worker:

```bash
cd backend
npm run smoke:social
npm run smoke:lifecycle
```

`smoke:social` registers fresh users and verifies privacy-safe search, self-request rejection, duplicate request idempotency, incoming request listing, decline, resend, accept, and accepted-state search. `smoke:lifecycle` uses the seeded Alice/Bob users and verifies case-insensitive search, friend request acceptance or pre-existing accepted state, shared normal habit sync, shared multi-day habit sync, Bob-owned habit visibility in Alice, completion progress, owner-only metadata updates, archive propagation, and private habit exclusion.

## Troubleshooting

- **Android package collision**: Ensure you are using the `--flavor` flag so that the `applicationIdSuffix` applies correctly.
- **Connection refused**: Run `adb reverse tcp:8787 tcp:8787` again if the emulator loses the port mapping.
- **Stale data**: To reset, uninstall both apps from the device to wipe the local Drift databases, and restart the Cloudflare local worker to reset the in-memory D1 data.
- **No accepted-friend chips**: Confirm `npm run db:setup` has applied `schema.sql`, run `adb reverse tcp:8787 tcp:8787`, and check logs for a successful `/api/sync/daily`. Open Alice after the accepted friendship exists so the local `accepted_friends` cache is refreshed before testing habit invites.
- **No shared habit after acceptance**: Verify the owner habit sync succeeded before the invitation was sent, then reopen Bob or trigger another daily sync pull.
- **Old local D1 state**: If `schema.sql` fails with `no such column: role`, run `npx wrangler d1 execute hable_db --local --command "ALTER TABLE partnerships ADD COLUMN role TEXT NOT NULL DEFAULT 'partner';"` once, then rerun `npm run db:setup`.
