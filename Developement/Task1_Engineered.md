<!-- AI AGENT OPERATING CONTRACT — See Task_ai_agent_contract.md for full rules. This file hosts the compact completed-task index and the active engineered queue. -->

## Completed Tasks

- 2026-07-08 15:59 Z: [Add Cloudflare Worker Backend For Social Sync & Ephemeral Nudges](Task2_Archived.md#add-cloudflare-worker-backend-for-social-sync-ephemeral-nudges)
- 2026-07-08 16:08 Z: [Add Offline Inverted Index Search Engine For Local Documents](Task2_Archived.md#add-offline-inverted-index-search-engine-for-local-documents)
- 2026-07-08 16:44 Z: [Add JWT Authentication And Friend-Request Authorization For Sync APIs](Task2_Archived.md#add-jwt-authentication-and-friend-request-authorization-for-sync-apis)
- 2026-07-08 19:51 Z: [Wire Mutual Habit Friends Into Home UI And Habit-Colored Rings](Task2_Archived.md#wire-mutual-habit-friends-into-home-ui-and-habit-colored-rings)
- 2026-07-08 20:08 Z: [Add Twin-App Friend Flow Test Harness](Task2_Archived.md#add-twin-app-friend-flow-test-harness)
- 2026-07-08 21:10 Z: [Complete Account, Friend Search, Habit Recording Sync, And Leaderboard MVP](Task2_Archived.md#complete-account-friend-search-habit-recording-sync-and-leaderboard-mvp)
- 2026-07-08 21:10 Z: [Expand Authentication, User Search, and Leaderboards](Task2_Archived.md#expand-authentication-user-search-and-leaderboards)
- 2026-07-09 14:05 CEST: [Reuse Onboarding Habit Presets In Habit Creation With Partner Invites And Clear Progress Labels](Task2_Archived.md#reuse-onboarding-habit-presets-in-habit-creation-with-partner-invites-and-clear-progress-labels)
- 2026-07-09 14:49 CEST: [Promote Habit Creation To Home Without Turning Home Into Profile](Task2_Archived.md#promote-habit-creation-to-home-without-turning-home-into-profile)
- 2026-07-09 15:10 CEST: [Deploy Flutter Web To Cloudflare Pages With Production Smoke Tests](Task2_Archived.md#deploy-flutter-web-to-cloudflare-pages-with-production-smoke-tests)
- 2026-07-09 16:15 CEST: [Build Social Friends List UI and Fix Partner Selection](Task2_Archived.md#build-social-friends-list-ui-and-fix-partner-selection)
- 2026-07-09 18:55 CEST: [Verify Web-Era Changes On Android APKs](Task2_Archived.md#verify-web-era-changes-on-android-apks)
- 2026-07-09 19:02 CEST: [Apply Flutter Podium Leaderboard Card Design](Task2_Archived.md#apply-flutter-podium-leaderboard-card-design)
- 2026-07-09 19:42 CEST: [Phase 5: Profile-Based Habit CRUD UI](Task2_Archived.md#phase-5-profile-based-habit-crud-ui)

## Remaining Tasks

<a id="run-adb-smoke-tests-for-auth-friend-harness-and-recent-ui-changes"></a>
### [X] Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes

**Raw source:** test recent changes via adb, do it twice. once without logging in, once with logging in. via the friend test harness. via the normal app. document the procedure in `Developement/08_Testing.md`. ensure it is run by you, and you see everything you should, and nothing you shouldn't. test every button and feature you added. and check if the .gitignore is updated.

**Issue:** Recent auth, social, habit CRUD, leaderboard, friend-harness, and sync changes have not been verified on a real Android target. The current `TWIN_TEST_HARNESS.md` explains a seeded two-app path, but there is no executed ADB smoke record proving the normal app gates unauthenticated users correctly, the authenticated app exposes only allowed features, both harness flavors install side by side, and generated/test artifacts are ignored.

**Ponytail triage:**
- *Should exist:* Yes, this is verification work for recently added user-facing and sync behavior.
- *Smallest safe scope:* Run two manual ADB smoke passes on one connected Android device or emulator: a clean normal-app pass without login, then an authenticated pass covering the normal app plus the seeded `primary`/`friend` harness. Capture exact commands, device ID, backend target, observations, failures, and `.gitignore` findings in `Developement/08_Testing.md`.
- *Skipped scope:* New automation framework, `integration_test` suite, Appium/Maestro setup, CI device farm, screenshot diffing, performance profiling, and broad refactors found during smoke testing.
- *Boundaries:* Do not implement new product features as part of the smoke pass. If a tested button exposes a real defect, fix only tiny blocking test-harness/config issues needed to continue the run; otherwise record the defect and append a follow-up raw task.

**Action:** Execute and document the smallest repeatable ADB smoke procedure for current Hable changes. Start from a cleared install for the normal app, verify unauthenticated access is limited to `AuthScreen`, then log in/register and test the visible authenticated surfaces. Run the twin-app harness using the existing Android flavors and seeded identities, verify mutual habit/social behavior, and update `.gitignore` only if generated local artifacts are currently unignored.

**Hable perspective:** The app is offline-first: UI should render from Drift, sync should be background/retryable, and unauthenticated users should not see Home, Profile, Social Hub, friend data, or private habit state. The twin harness must keep `Hable Primary` and `Hable Friend` isolated by application ID and local Drift database while still exercising the shared backend social path.

**Implementation scope:**
- ADB/device flow: `adb devices`, app uninstall/clear-data, `adb reverse tcp:8787 tcp:8787` when using a local backend, `flutter run` for normal and flavored installs, and log capture for failures.
- Normal app smoke: `AuthScreen`, registration/login toggle, validation/error states, app gate routing, Home header/buttons, `MudLongPressButton`, skip bottom sheet, PartnerTicker empty/private state, Profile habit CRUD, and Social Hub leaderboard/search.
- Friend harness smoke: `primary` and `friend` flavors from `android/app/build.gradle.kts`, `SEED_USER_ID`/`SEED_USERNAME` auth path in `AuthScreen`, shared habit visibility, partner ticker, nudge queue, daily sync pull, and package/app-label isolation.
- Sync/backend surfaces: deployed `https://hable.pages.dev` path or local Worker/Pages target, `lib/services/sync_service.dart` queue behavior, JWT-backed auth, and privacy-safe social payloads.
- Documentation: create or update `Developement/08_Testing.md` with the executed procedure and results; update `Developement/TWIN_TEST_HARNESS.md` only if the run discovers stale commands.
- Repo hygiene: inspect `.gitignore` and `git status --short` after running the smoke pass; ignore only generated local artifacts that appear during the test.
- Test surface: the ADB smoke run itself, plus `flutter analyze` only as a quick static sanity check before device work.

**Scalability considerations:** Scalability impact: none expected. Manual smoke coverage will get slow as features grow; if this becomes repeated release work, split a future task for a tiny scripted smoke harness or Flutter `integration_test` flow.

**Future split guidance:** Deferred automation should be a separate raw task only after this manual ADB run shows the stable critical path. Candidate follow-ups: scripted install/reset commands, an `integration_test` auth smoke, or CI-backed emulator checks.

**Edge cases:** No Android device attached, stale app data or secure-storage token, backend unavailable, emulator cannot reach backend without `adb reverse`, production URL differs from local harness URL, duplicate username during register smoke, password errors, flavor package collision, stale D1 seed data, KV nudge consumed before the receiving app syncs, offline mode during login, UI visible before auth completes, private data visible while logged out, and new generated files appearing in `git status`.

**Acceptance criteria:**
- `Developement/08_Testing.md` exists and records the exact device/emulator, date/time, backend target, commands run, and observed results.
- A clean normal-app ADB pass proves logged-out users land on `AuthScreen` and cannot access Home, Profile, Social Hub, partner data, or private habit state.
- An authenticated normal-app ADB pass exercises login/register, Home, Profile habit CRUD, Social Hub leaderboard/search, completion, skip, and visible recent buttons/features.
- The `primary` and `friend` harness flavors install side by side with distinct app labels and isolated app data.
- The friend harness pass verifies seeded users, shared habit visibility, partner ticker behavior, nudge send/receive path, and daily sync behavior as far as the current backend supports.
- Any failures are written in `08_Testing.md` with reproduction steps and either fixed if they are tiny harness/config blockers or appended as new raw tasks.
- `.gitignore` is checked after the smoke run and updated only for generated artifacts that should not be tracked.
- `TWIN_TEST_HARNESS.md`, `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, and `04_Social_and_Analytics.md` are verified and updated if the executed procedure reveals stale guidance.

**Dependencies:** `08_Testing.md` (new), `TWIN_TEST_HARNESS.md`, `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="audit-and-align-hable-development-docs-with-current-code"></a>
### [x] Audit And Align Hable Development Docs With Current Code

**Raw source:** Update docs.

**Issue:** The `Developement/` markdown docs no longer fully match the current Hable codebase. Recent work added auth, secure storage, Social Hub search/leaderboards, profile habit CRUD, partner snapshots, private messages, habit invitations, milestone wishes, search tables/providers, Android flavors, and ADB smoke-test expectations. The docs still describe older or partial architecture, which makes future task engineering and implementation risky.

**Ponytail triage:**
- *Should exist:* Yes, stale architecture docs cause bad follow-on tasks.
- *Smallest safe scope:* Audit the existing development docs against current source files and update only factual mismatches, missing tables/providers/endpoints, and stale testing/runbook instructions.
- *Skipped scope:* A full documentation site, generated API docs, diagrams, changelog cleanup, prose rewrites for style, and new product requirements not already represented by code or accepted engineered tasks.
- *Boundaries:* Treat code and completed engineered tasks as source of truth. Do not change Flutter, backend, schema, or generated files while doing the doc update unless a tiny broken doc reference blocks the documentation work.

**Action:** Review current Hable source and align the development docs so they accurately describe the implemented app/backend architecture, current known gaps, and testing procedure. Keep each doc concise and architecture-focused; record any discovered product/code gaps as raw tasks instead of silently expanding the doc-update task into implementation.

**Hable perspective:** Documentation must preserve Hable's offline-first rule: Flutter UI reads Drift/Riverpod state, sync runs in the background, Cloudflare exposes privacy-scoped APIs, and social/multi-user features must not expose private habit data. The docs should name the real Drift tables, Riverpod providers, widgets, backend routes, Android flavors, and test runbooks now present in the repo.

**Implementation scope:**
- `00_Agent_Directives.md`: align tech-stack claims with current Riverpod usage, secure storage, Cloudflare Pages/Worker shape, and testing expectations.
- `01_Schema_and_Core_Logic.md`: update Drift/D1 parity notes for `colorHex`, `SyncQueue`, `SearchDocuments`, `PartnerSnapshots`, `PrivateMessages`, `HabitInvitations`, `MilestoneEvents`, auth fields, and current sync actions.
- `02_Offline_Architecture.md`: document the actual `SyncService`, `ConnectivityService`, secure token behavior, outbound queue actions, and inbound daily sync persistence.
- `03_UI_UX_and_Animations.md`: align Home/Profile/Auth/Social Hub, habit CRUD, `PartnerTicker`, `InvitationBanner`, `MilestoneWishCarousel`, `SkipBottomSheet`, and `MudLongPressButton` guidance.
- `04_Social_and_Analytics.md`: align friend requests, user search, leaderboards, nudges, private messages, habit invitations, partner snapshots, quote behavior, and privacy boundaries with backend routes.
- `05_Search_Engine_Architecture.md`: note the implemented local Dart search engine, `SearchDocuments` Drift metadata, Riverpod search provider, and deferred persistent posting-list/FTS work.
- `07_Multi_User_Social_Features.md`: separate implemented social primitives from future 3D environment ideation.
- `TWIN_TEST_HARNESS.md` and `08_Testing.md`: align runbooks with Android flavors, seeded users, backend target, ADB steps, and the pending ADB smoke-test task.
- Test surface: documentation review plus link/path sanity checks using `rg`; no Flutter tests are required for docs-only changes.

**Scalability considerations:** Documentation staleness grows with schema/provider/API surface area. Keep docs bounded to authoritative architecture facts and use raw tasks for future work so the docs do not become a speculative product backlog.

**Future split guidance:** If the audit finds missing automation, broken backend behavior, or unimplemented UI flows, append separate raw tasks for those. Defer docs generation, diagrams, and CI documentation checks until repeated doc drift becomes a real maintenance cost.

**Edge cases:** Dirty worktree with user edits, docs describing planned features rather than implemented behavior, generated Drift files diverging from hand-written tables, backend `src/index.ts` vs `functions/api/[[route]].ts` duplication, deployed URL vs local dev URL, missing `08_Testing.md`, completed tasks still sitting under `# Remaining Tasks`, and stale task lookup anchors.

**Acceptance criteria:**
- Each listed development doc is either updated or explicitly verified as already aligned.
- Schema docs name the current Drift tables, core columns, sync metadata, and relevant Cloudflare D1/KV tables.
- Offline docs describe the actual queue actions and background sync boundaries without claiming direct network-driven UI.
- UI docs reflect the current Auth, Home, Profile, Social Hub, habit CRUD, partner ticker, invitations, milestone wishes, skip, and long-press surfaces.
- Social docs reflect current privacy-scoped APIs, auth, friend search/request flow, leaderboards, nudges, private messages, habit invitations, and known deferred work.
- Search docs reflect the implemented local search module and its deferred scaling path.
- Testing docs/runbooks reflect the current Android flavor and ADB smoke-test expectations.
- Any discovered implementation gaps are added to `Task0_Raw.md` as separate raw items instead of being hidden inside docs.
- Completion notes state which dependencies were verified and updated.

**Dependencies:** `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `05_Search_Engine_Architecture.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`, `Task_ai_agent_contract.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="complete-cross-app-habit-lifecycle-sync-and-twin-harness-verification"></a>
### [x] Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification

**Raw source:** Add a habit, set a time, sync it, update it, delete it. see it in your friends app (if you added them as friend), update it in your friends app, see it in your app. do the same for multi-day habits. after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.

**Issue:** Profile habit CRUD exists locally, but cross-app habit lifecycle sync is not real yet. `createHabitWithSync`, `updateHabitDetails`, `archiveHabit`, completion, and skip actions enqueue `SyncAction.createHabit`, `updateHabit`, and `logHabit`; `SyncService` currently mocks those actions instead of sending habit/log records to Cloudflare. The backend has social partnerships and `habit_progress`, but no complete authorized habit metadata lifecycle that lets the primary/friend installs see shared habit create/update/archive/log changes from each other.

**Ponytail triage:**
- *Should exist:* Yes, this is the smallest root-cause fix needed before twin-app habit testing can mean anything.
- *Smallest safe scope:* Implement real sync for create, update, archive, and log actions; pull shared habit metadata/progress through daily sync; verify one shared normal habit and one multi-day habit across `primary` and `friend` flavors.
- *Skipped scope:* Hard delete, reminders, recurring schedules, calendar integration, realtime sockets, conflict-resolution UI, bulk editing, public friend habit feeds, and full automation frameworks.
- *Boundaries:* Keep Hable privacy rules. Friends must not see every habit automatically; cross-app visibility requires an accepted friendship plus explicit partnership/habit invite. Treat "delete" as archive/abandon unless a future task explicitly requires destructive deletion.

**Action:** Replace the mocked habit/log sync path with a real offline-first lifecycle. Local Drift remains the optimistic source for UI. Background sync sends queued habit/log mutations to authenticated backend endpoints, the backend persists and authorizes shared habit state, and daily sync pulls only allowed shared habit metadata/progress into the other app. Then run the twin harness to prove add/time/update/archive/log behavior works in both directions for a normal habit and a multi-day habit.

**Hable perspective:** The Home and Profile screens should continue to read only Drift/Riverpod streams. The backend is only the reconciliation layer. Partner visibility belongs to accepted relationships and per-habit partnerships, not general friendship. Shared updates must not expose private skip journal text or unrelated habit lists.

**Implementation scope:**
- Drift schema/DAO: audit `Habits`, `Logs`, `Partnerships`, `SyncQueue`, and `PartnerSnapshots`; add only the minimum field needed to represent "set a time" without corrupting multi-day duration semantics if the current `targetDuration/currentDuration` fields are insufficient.
- Database methods in `lib/database/database.dart`: enqueue full payloads for create/update/archive/log instead of only `habitId`; mark local rows synced only after backend success.
- Sync layer in `lib/services/sync_service.dart`: replace the mocked `SyncAction.createHabit`, `SyncAction.updateHabit`, and `SyncAction.logHabit` branch with real authenticated HTTP calls and retry-safe error handling.
- Backend D1/schema: add or align full habit metadata storage, progress/log upserts, shared-habit authorization, status/archive handling, updated timestamps, and needed indexes for `user_id`, `habit_id`, partnership lookups, and updated sync ordering.
- Backend routes in `backend/src/index.ts`: implement authenticated habit create/update/archive/log endpoints and extend `/api/sync/daily` to return only authorized shared habit metadata and partner progress.
- Riverpod/UI: keep `ProfileScreen`, `HabitFormSheet`, `HomeScreen`, and `PartnerTicker` wired to local Drift; add only minimal UI/state hooks needed to show shared synced habits after daily sync.
- Twin harness/testing: update `TWIN_TEST_HARNESS.md` and/or `08_Testing.md` with exact steps for primary-to-friend and friend-to-primary habit lifecycle testing; run the path on a device/emulator.
- Test surface: focused backend/API smoke checks for habit create/update/archive/log authorization plus one device smoke pass through the twin harness.

**Scalability considerations:** Habit and log sync can be one queued mutation per request for now. Add D1 indexes before shared habits grow, and keep daily sync scoped to accepted/partnered habits. If offline queues grow after long offline use, batch habit/log mutations in a separate task.

**Future split guidance:** Batch sync, hard deletion, conflict-resolution UI, realtime shared updates, reminders, and CI-grade device automation are deferred. Append separate raw tasks only after this bidirectional lifecycle works manually.

**Edge cases:** User is offline during create/update/archive/log, missing or expired JWT, friend request accepted but no habit partnership, invite pending/declined, user tries to see non-partner habits, duplicate queued updates, update/archive conflict from both apps, archive after completion, restore after archive, local row marked synced after failed backend call, stale daily sync payload, private skip journal leaking to partner payloads, duration unit mismatch between daily time and multi-day journey, and seeded harness data diverging from D1.

**Acceptance criteria:**
- Creating a habit from Profile writes Drift immediately and syncs the full habit metadata to the backend instead of being mocked.
- Setting/updating the habit time/duration preserves correct multi-day habit semantics and does not inflate day counts through unit mismatch.
- Updating title, duration/time, and color in one install syncs and appears in the partnered install after daily sync.
- Archiving a habit in one install removes it from active lists in both partnered installs after sync while preserving history locally.
- Completing and skipping a habit enqueue real `logHabit` payloads; skip journal text stays private and is not exposed to partners.
- A normal shared habit and a multi-day shared habit can be created from `primary`, seen/updated from `friend`, then seen back in `primary`.
- A shared habit created from `friend` can be seen in `primary` after sync.
- Non-partner friends cannot see private habit metadata.
- `SyncService` no longer mocks `createHabit`, `updateHabit`, or `logHabit`.
- `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` are verified and updated to match the implemented lifecycle.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Implementation progress notes:**
- Implemented shared standard habit presets in `lib/data/standard_habits.dart` and reused them from onboarding plus `HabitFormSheet`.
- Updated `HabitFormSheet` to create/edit habits in days, prefill preset title/duration/color, and offer accepted-friend partner chips from Drift/Riverpod.
- Updated `AppDatabase.createHabitWithSync` and `HabitActionsController.createHabit` to return the created habit id, enqueue full habit metadata, and enqueue `sendHabitInvitation` items after the local habit exists.
- Hardened `POST /api/social/habit-invitation` to require requester habit ownership, accepted friendship, non-self target, and idempotent duplicate pending invites.
- Updated docs in `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md`.
- Verified: `flutter analyze`, `npx tsc --noEmit`, `flutter test`, and `flutter build apk --debug`.
- Remaining before completion: physical ADB/twin-harness verification was not run because `adb` is not available on PATH in this shell (`adb: command not found`). `flutter devices` sees macOS, Chrome, and a wireless iPhone, but no Android ADB target.
- Progress noted at 2026-07-09 13:42 CEST.

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="wire-friend-requests-through-social-hub-and-twin-harness-verification"></a>
### [x] Wire Friend Requests Through Social Hub And Twin-Harness Verification

**Raw source:** add a social feature, e.g., friend request. implement it via search and button (e.g., in settings or new people tab). after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.

**Issue:** Backend friend-request endpoints exist, and `SocialHubScreen` already has a user search tab with a person-add button, but the button only shows "not yet implemented." Search results also do not expose relationship state, incoming requests are not surfaced in Flutter, and accepted friend state is not cached locally for downstream habit invites, nudges, leaderboards, or twin-app verification.

**Ponytail triage:**
- *Should exist:* Yes, accepted friendship is the gate for habit partnerships and later shared habit visibility.
- *Smallest safe scope:* Reuse `SocialHubScreen` as the "Find Friends" surface, wire the existing add button to send friend requests, add a compact incoming request list with accept/decline, cache relationship state locally, and verify the flow between `primary` and `friend` app flavors.
- *Skipped scope:* New settings tab, contact import, QR/user-code invites, push notifications, chat, blocking/reporting, public profiles, friend suggestions, and full 3D social browsing.
- *Boundaries:* Friend search may be an explicit network action, but request status and accepted relationships should be cached into Drift for offline-first reads. Search must not expose habit metadata or private journal data.

**Action:** Complete the friend-request flow end to end. Update the backend search/request APIs to be idempotent and privacy-safe, add request listing/accept/decline support, wire Flutter's Social Hub button and request list to those APIs through Riverpod/Drift state, and verify primary-to-friend plus friend-to-primary visibility in the twin harness.

**Hable perspective:** Friendships are a social permission layer, not shared habit data by themselves. Accepted friends can later receive habit-partner invites, but simply becoming friends must not reveal habit lists, logs, skip journal text, partner snapshots, private messages, or milestone events.

**Implementation scope:**
- Backend routes in `backend/src/index.ts`: harden `POST /api/social/friend-request`, add/verify duplicate and self-request guards, add request list and decline endpoints if missing, and update `GET /api/social/search` to return `user_id`, `username`, `avatar_url`, and `relationship_state` only.
- Backend schema/indexes in `backend/schema.sql`: add indexes for `(requester_id, recipient_id, status)` and enforce or simulate uniqueness for pending/accepted request pairs.
- Drift schema in `lib/database/tables.dart`: add a minimal local friend/request cache table if no existing table can represent pending incoming, pending outgoing, accepted, declined, usernames, avatars, and timestamps.
- Database methods in `lib/database/database.dart`: upsert friend request/search relationship state, watch pending incoming requests, watch accepted friends, and update status optimistically on accept/decline.
- Riverpod/social state in `lib/providers/social_providers.dart` or a small companion provider: expose friend requests, accepted friends, send request, accept request, and decline request actions.
- UI in `lib/screens/social/social_hub_screen.dart`: replace the placeholder add-button snackbar with real send behavior; show request state labels/buttons; add an incoming requests section/tab without creating a new broad social screen.
- Sync layer in `lib/services/sync_service.dart`: pull request state through `/api/sync/daily` or a dedicated social request endpoint and persist it locally; keep UI non-blocking when offline.
- Twin harness/testing: update `TWIN_TEST_HARNESS.md` and `08_Testing.md` with primary sends request to friend, friend accepts, primary sees accepted relationship, then reverse or re-run from friend side as needed.
- Test surface: focused backend/API smoke checks for search state, duplicate requests, self-request rejection, accept/decline authorization, and one device/emulator twin-harness pass.

**Scalability considerations:** Friend search should stay prefix/equality based with a small limit and indexed usernames. Friend request lookups need indexed requester/recipient/status pairs before the graph grows. A full friend graph service, pagination, and recommendation system are deferred.

**Future split guidance:** Habit partner invitation from habit creation/edit, friend profile pages, friend blocking, push notifications, contact import, and 3D friend exploration should remain separate tasks. Implement them only after this accepted-friend primitive works.

**Edge cases:** Searching yourself, duplicate request taps, reciprocal pending requests, accepting a missing/rejected request, stale token, user deleted after request, offline during send/accept, declined requests re-sent later, relationship state not refreshing in the sender app, seeded twin users already connected in D1, search leaking `total_score` or habit data, and accepted friendship without any shared habits.

**Acceptance criteria:**
- Social Hub search results show safe fields plus relationship state (`none`, `pending_incoming`, `pending_outgoing`, `accepted`, or equivalent).
- Tapping the existing add/friend button sends a real friend request and updates local/request UI state without blocking unrelated app use.
- Incoming friend requests are visible in the receiving app with accept and decline actions.
- Accepting a request updates backend state and both installs eventually show the relationship as accepted.
- Duplicate friend requests and self-requests are rejected or treated idempotently.
- Accepted friends still do not expose habit metadata until a separate habit partnership/invite exists.
- The primary app can send a request to the friend app, the friend app can accept it, and the primary app can see accepted state after refresh/sync.
- The same flow is verified from the friend app side or documented as already covered by the symmetric backend path.
- `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` are verified and updated to match the implemented flow.

**Dependencies:** `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="build-3d-abstract-habit-environment-prototype"></a>
### [X] Build 3D Abstract Habit Environment Prototype

**Raw source:** 3D Multi-User Social Features Ideation (`07_Multi_User_Social_Features.md`). work on ideation of tracking multi habbits, and seeing your friends habits as well, in a 3D abstract environment.

**Issue:** We have all the backend social primitives (friend requests, partner snapshots, habit synchronization), but the UI is still a standard 2D list/ticker. To fulfill the "inspiring, social experience" vision, habits need to be visualized in a 3D abstract space.

**Ponytail triage:**
- *Should exist:* Yes, this is the core differentiator mentioned in the social ideation doc.
- *Smallest safe scope:* Prototype a lightweight 3D or pseudo-3D abstract visual using Flutter's native `CustomPainter` (pseudo-3D isometric/particles) or a lightweight package (such as shaders or simple transforms). Map the current user's active habits and the partner snapshots to abstract visual elements such as colored orbs whose size represents `currentDuration`.
- *Skipped scope:* Complex 3D game engines, physics simulations, custom GLTF authoring, multiplayer camera controls, and a broad Home-screen redesign.
- *Boundaries:* The visualizer should be a stateless read-only surface over existing Drift/Riverpod data. It must not block the main thread, require network calls to render, or replace the primary habit interaction controls.

**Action:** Determine the smallest rendering approach, implement a `HabitEnvironmentVisualizer` widget, and integrate it into `HomeScreen` or `SocialHubScreen` behind a clear entry point so the current habit list remains usable while the prototype is evaluated.

**Hable perspective:** This is a UI experiment layered on top of the existing offline-first architecture. The scene should consume local `Habits`, accepted-friend state, and partner snapshots already present in Drift/Riverpod. It must preserve privacy boundaries by showing only data already allowed on-device for the current user.

**Implementation scope:**
- `lib/widgets/habit_environment_visualizer.dart` or similar reusable widget for the abstract scene.
- `lib/screens/home_screen.dart` or `lib/screens/social/social_hub_screen.dart` integration using existing providers rather than ad hoc state.
- Mapping of `habit.colorHex`, completion/progress, and partner snapshot values to deterministic visual properties.
- Accessibility fallback text or a compact list summary so the prototype does not become a visual-only dead end.
- A focused smoke or widget test proving the visualizer can render zero-habit, single-habit, and friend-linked states without crashing.

**Scalability considerations:** Keep draw cost bounded. If the user has many habits or many partner-linked items, cap simultaneously rendered objects, avoid rebuild-heavy animations, and keep any layout math off hot build paths.

**Future split guidance:** True 3D navigation, richer shaders, social walkthroughs, environment sharing, and realtime friend presence should be separate follow-up tasks only after the lightweight prototype proves worthwhile.

**Edge cases:** Performance on low-end Android devices, handling users with zero habits or zero friends, overlapping visual elements, stale partner data while offline, unreadable low-contrast color combinations, and state updates causing animation jank.

**Acceptance criteria:**
- A prototype visualizer exists and renders from local habit/social state without requiring network reads.
- Habit colors and progress map to deterministic visual elements.
- The existing Home or Social Hub flow remains usable when the prototype is present.
- Zero-habit and zero-friend states render a stable empty/prose fallback instead of a broken scene.
- `07_Multi_User_Social_Features.md`, `03_UI_UX_and_Animations.md`, and `02_Offline_Architecture.md` are verified and updated if the prototype changes UI guidance or state expectations.

**Dependencies:** `07_Multi_User_Social_Features.md`, `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="support-emoji-or-uploaded-profile-pictures"></a>
### [X] Support Emoji Or Uploaded Profile Pictures

**Raw source:** make possible to set Profile Picture; user should choose either a funny emoji avatar or upload an image profile picture. Uploaded profile pictures must be optimized server-side for web/profile display, stored, and used across the app.

**Issue:** The profile UI now has an avatar tap target and an `AvatarPickerSheet`, but the prompt still assumes only local avatar strings. The app should let users choose between a curated emoji avatar and an uploaded profile image, persist the selection locally, sync it through the authenticated backend, and show the chosen avatar consistently across Profile, friend lists, partner tickers, and friend profile surfaces.

**Ponytail triage:**
- *Should exist:* Yes, profile identity is visible in social flows and the raw request explicitly asks for it.
- *Smallest safe scope:* Reuse the existing `AvatarPickerSheet`, `UserAvatar`, `AuthNotifier.updateAvatar`, local Drift `Users.avatarUrl`, and authenticated backend avatar routes. Keep emoji avatars as safe local tokens. Add one upload path that sends an image to the backend, lets the backend validate and optimize it, stores the optimized result, and returns the stored profile-image URL/key for `avatar_url`.
- *Skipped scope:* Camera capture, manual cropping UI, advanced moderation, animated avatars, custom drawing tools, profile redesign, and marketplace-style avatar packs.
- *Boundaries:* Emoji choices are local strings. Uploaded images must become backend-owned optimized assets before any app surface uses them. Social APIs still expose only `username`, `avatar_url`, and allowed relationship/habit fields.

**Action:** Update the profile-picture flow so tapping the current profile avatar opens a prompt with two choices: choose an emoji avatar or upload an image profile picture. Selecting an emoji updates the local Drift user row immediately and sends the authenticated backend update. Uploading an image sends the original file to the backend, which validates type/size, strips metadata, generates web/profile-optimized image variants, stores the optimized asset, persists the chosen avatar reference, and returns the value used by all `UserAvatar` surfaces.

**Hable perspective:** This is profile/social polish with a backend storage boundary. It should preserve the offline-first Drift/Riverpod read model and the existing API masking rules. Social surfaces should continue to receive only `username`, `avatar_url`, and allowed relationship/habit fields.

**Implementation scope:**
- `lib/widgets/avatar_picker_sheet.dart`: change the prompt to offer emoji selection or image upload, keep the emoji list as stable constants, add clear Semantics/tooltips, and avoid duplicate creation paths.
- `lib/widgets/user_avatar.dart`: ensure local emoji strings, optimized remote profile-image URLs, and username initials all render consistently.
- `lib/screens/profile_screen.dart`: keep the avatar edit affordance discoverable without adding a separate profile-edit screen.
- `lib/providers/auth_provider.dart`: ensure emoji updates and upload results persist the current user's existing required fields locally, update `updatedAt`/sync state correctly, and fail gracefully if offline or unauthenticated.
- Upload client path: add the smallest cross-platform image picker/upload path needed for web and mobile, with clear progress/error states and no permanent loading state.
- `backend/src/index.ts`: keep avatar updates authenticated. Accept safe emoji tokens for direct avatar updates. Add an authenticated image-upload route that rejects unsupported media, enforces size limits, strips metadata, generates profile/web optimized variants, stores the optimized asset, updates `users.avatar_url`, and returns the stored avatar reference.
- Backend storage: use the project storage layer appropriate for Cloudflare deployment, preferably R2 or an equivalent backend-owned object store. Do not store raw user image bytes in D1.
- Social propagation: verify `/api/sync/daily`, friend search/profile responses, `AcceptedFriends`, and `PartnerSnapshots` continue to carry the updated `avatar_url` into friend list and partner UI.
- Test surface: add the smallest widget/provider/backend test or manual smoke entry proving the prompt exposes emoji and upload choices, emoji selection updates the local user avatar, and upload returns an optimized stored avatar that renders in Profile.

**Scalability considerations:** Uploaded images introduce storage, optimization cost, and cache invalidation concerns. Keep the stored image small, generate deterministic profile/web variants, use cacheable URLs, and replace or garbage-collect old avatar assets when users upload a new one.

**Future split guidance:** Append separate raw tasks only if the product needs camera capture, manual cropping, remote avatar packs, deeper image moderation, account-wide profile editing, or cross-device cache invalidation beyond the existing sync payload.

**Edge cases:** Unauthenticated user reaches Profile, offline avatar update, backend rejects the avatar or upload, upload is too large, unsupported file type, corrupt image, EXIF orientation, metadata stripping, slow network, duplicate upload taps, old image cache remains after replacement, local user row is missing a username, selected emoji is multi-codepoint, old DiceBear URL avatars still exist, web font/browser emoji rendering differs from Android, friend caches keep stale avatar values until daily sync, and screen readers need meaningful labels for emoji-only choices.

**Acceptance criteria:**
- Profile avatar tap opens a prompt offering `Choose emoji` and `Upload image` paths.
- Emoji selection updates the Profile avatar immediately from local Drift state and syncs through the authenticated backend.
- Image upload sends the file to the backend, not directly to public storage from the client.
- The backend validates uploaded image type/size, strips metadata, creates optimized web/profile image output, stores the optimized asset, updates `users.avatar_url`, and returns the stored avatar reference.
- `AuthNotifier.updateAvatar` does not corrupt required local user fields when updating `Users.avatarUrl`.
- Authenticated backend avatar routes persist the chosen avatar for the current JWT user and reject unauthenticated updates.
- Friend list, partner ticker, and friend profile avatar renderers continue to handle local emoji tokens, optimized uploaded image URLs, and existing URL avatars.
- Offline or failed network update gives a clear non-crashing result and does not leave the UI in a permanent loading state.
- At least one focused test or documented smoke check verifies the prompt choices, emoji update behavior, upload optimization/storage behavior, and rendered uploaded avatar.
- `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, and `08_Testing.md` are verified and updated if behavior, schema assumptions, or test procedure changes.

**Dependencies:** `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]


<a id="add-partnership-roles-and-enforce-habit-permissions-in-backend"></a>
### [x] Add Partnership Roles And Enforce Habit Permissions In Backend

**Raw source:** 1. Database Roles & Relationships (High Priority Blocker)
* **Objective:** Expand the D1 `partnerships` table to support Role-Based Access Control (RBAC) via a `role` enum to prevent client-side state conflicts.
* **Owner:** Can edit/delete the habit, complete/skip, and nudge participants.
* **Partner:** Can complete/skip, view details, and nudge others. Cannot edit/delete the habit.
* **Supporter:** Read-only view of progress, can send encouragement/nudges. by pressing and holding the habit ring and completing it (with same difficulty as owner/partner). Cannot complete/skip or edit.
* **Relationship Types:** Sole creator, mutual friendships (send/accept), and multi-partner habits.
* **Action:** Engineer a D1 schema migration and update the Cloudflare Worker to enforce these permissions before updating the Flutter UI.

**Issue:** Hable currently treats `partnerships` as a simple `(user_id, partner_id, habit_id)` visibility junction. Worker routes authorize many actions by accepted friendship or partnership existence, so clients can drift into conflicting behavior: owners, partners, and future supporters are not distinguishable at the backend boundary. This blocks later UI work because edit/delete, complete/skip, nudge, and supporter encouragement permissions need a server-enforced source of truth.

**Ponytail triage:**
- *Should exist:* Yes, authorization must be enforced by D1/Worker before client UI can safely expose roles.
- *Smallest safe scope:* Add a role field to partnerships, backfill existing rows as `partner`, ensure habit creators are represented as `owner`, and centralize Worker permission checks for habit update/archive, log completion/skip, invitation acceptance, daily sync, profile habit visibility, and nudge/encouragement.
- *Skipped scope:* Full UI redesign, role-management screens, supporter invitation UX, granular per-field permissions, audit logs, admin tooling, realtime updates, and gamification badges tied to supporters.
- *Boundaries:* This is backend/schema-first. Flutter should only receive/cache role data where needed for later UI tasks; it should not add new role-specific screens or broad visual polish in this pass.

**Action:** Implement backend RBAC for habit relationships. Migrate D1 `partnerships` to include `role` constrained to `owner`, `partner`, and `supporter`; update Worker writes so habit creators and invite acceptances create correct role rows; enforce role checks before mutating habits/logs or sending nudges; and update sync payloads so the client can cache role-aware partner state without inventing permissions locally.

**Hable perspective:** The app stays offline-first, but backend authorization remains authoritative. Flutter can optimistically write local actions, yet failed sync must not be hidden when the backend rejects a role-disallowed mutation. `PartnerSnapshots` and any local partnership cache should carry enough role metadata for future UI decisions, while Home/Profile continue reading Drift streams.

**Implementation scope:**
- D1 schema in `backend/schema.sql`: add `role TEXT NOT NULL DEFAULT 'partner'` to `partnerships`, add indexes for `(user_id, habit_id, role)` and `(partner_id, habit_id)`, and define migration/backfill notes for existing local and remote D1 databases.
- Backend route helpers in `backend/src/index.ts`: add small shared permission helpers such as owner check, partner-or-owner check, supporter-readable check, and accepted-friend check where still needed.
- Habit ownership: ensure `POST /api/sync/habit` creates or maintains an owner relationship for the authenticated creator and rejects update/archive attempts unless the user is owner.
- Habit logging: ensure `POST /api/sync/log` accepts completion/skip from owner or partner only; supporter attempts must be rejected or treated as encouragement through a separate allowed path.
- Invitation flow: update `POST /api/social/habit-invitation` and `/accept` so accepted partner invites create recipient role `partner`, keep creator role `owner`, and never create supporter rows unless a future endpoint explicitly does so.
- Nudge/encouragement: keep partner/owner nudges authorized for shared habits; if supporter encouragement is represented in this pass, make it a clearly separate backend-allowed action that does not create habit logs or progress.
- Daily sync/profile routes: include role in partnership-derived payloads and keep privacy masking intact; supporters can view only allowed habit progress fields and never private journal data.
- Drift schema in `lib/database/tables.dart` and sync merge in `lib/services/sync_service.dart`: add/cache role metadata only if the backend payload now returns it; avoid UI behavior changes beyond not crashing on the new field.
- Test surface: direct Worker/API smoke tests for owner edit/archive, partner complete/skip, partner edit rejection, supporter complete/skip rejection, supporter/partner nudge or encouragement authorization, and daily sync role payloads.
- Documentation: update `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` if schema, auth behavior, sync payloads, or smoke procedures change.

**Scalability considerations:** Role checks must use indexed D1 lookups and should stay centralized so adding more social routes does not duplicate authorization SQL. If partnerships grow large, daily sync should keep querying by `user_id` and `habit_id` with role indexes rather than scanning friend graphs.

**Future split guidance:** The existing raw UI-polish/gamification tasks should consume this role foundation later. Defer role management UI, supporter invite UX, role-change flows, ownership transfer, audit logging, and conflict-resolution UI to separate tasks.

**Edge cases:** Existing partnership rows without roles, creator missing an owner row, duplicate owner rows, accepted friend but no habit role, partner trying to edit/archive, supporter trying to complete/skip, owner archiving a habit while partners have pending local logs, habit invite accepted before habit sync creates the habit row, stale client cached role after backend change, daily sync missing role for old rows, and backend route accidentally authorizing by friendship alone.

**Acceptance criteria:**
- D1 `partnerships` supports a role value of `owner`, `partner`, or `supporter`, with existing rows backfilled safely.
- Habit creators are represented as `owner` for their habits.
- Accepted habit partner invites create/maintain recipient `partner` role and creator `owner` role.
- Owner can update/archive/delete-as-archive a habit; partner and supporter cannot.
- Owner and partner can complete/skip a shared habit when authorized; supporter cannot create completion/skip logs.
- Nudge or encouragement authorization matches the role policy and does not allow arbitrary users to nudge private habit participants.
- `/api/sync/daily` and any friend profile/shared habit payload include role where role-aware UI will need it, without exposing private journals or non-shared habit data.
- Flutter sync/cache handles the role field without breaking existing Home/Profile/Social Hub rendering.
- Focused API smoke tests or documented curl checks prove allowed and rejected paths for owner, partner, and supporter roles.
- Dependency docs are verified and updated if schema, backend permissions, sync payloads, or testing guidance change.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Completion notes:**
- Touched files: `backend/schema.sql`, `backend/src/index.ts`, `lib/database/tables.dart`, `lib/database/database.dart`, `lib/database/database.g.dart`, `lib/services/sync_service.dart`, `Developement/01_Schema_and_Core_Logic.md`, `Developement/02_Offline_Architecture.md`, `Developement/04_Social_and_Analytics.md`, `Developement/07_Multi_User_Social_Features.md`, `Developement/TWIN_TEST_HARNESS.md`, and `Developement/08_Testing.md`.
- Behavior verified: habit creators now get/retain `owner` membership rows; accepted invites create role-aware participant rows; owner-only habit update/archive is enforced; partner log is allowed; supporter log is rejected; nudge authorization now requires shared-habit participation instead of friendship alone; `/api/sync/daily` includes the role field and Flutter caches it into `PartnerSnapshots`.
- Verification run: `npx tsc --noEmit`, `flutter pub run build_runner build`, `flutter analyze`, `npm run db:setup`, and a local Worker RBAC smoke against `http://127.0.0.1:8787` covering owner, partner, and supporter cases.
- Docs verified/updated: `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` were updated to reflect the role model, permission rules, and local D1 migration note.
- Completed At: 2026-07-11 02:56 CEST

<a id="add-server-side-gamification-progression-to-daily-sync"></a>
### [x] Add Server-Side Gamification Progression To Daily Sync

**Raw source:** 2. Gamification: Achievements, Badges & Points
* **Objective:** Implement a server-side progression system returned via the `/api/sync/daily` payload to keep the Flutter client lightweight and prevent spoofing.
* **Points System:** Award 5 points per check-in. Award bonus points when all partners in a shared habit check in.
* **Levels:** Map total points to named tiers (e.g., "Newbie") to replace raw numbers on the user profile.
* **Badges:** Track milestones (first check-in, 10/100/1000 streaks, first nudge, first supporter) entirely on the backend.
* **Action:** Update the Cloudflare Worker to calculate and append unlocked achievements to the user payload during the `SyncQueue` flush.

**Issue:** Hable currently has local/client score logic in `ScoringEngine`, optimistic score updates in Home, and a client-writable `/api/sync/score` endpoint. D1 also stores `users.total_score` and Social Hub reads leaderboards from it, but `/api/sync/daily` does not return an authoritative level or badge payload. This makes profile points spoofable, keeps old `+10` scoring docs in conflict with the new `+5` raw requirement, and blocks later UI polish that needs stable server-owned progression data.

**Ponytail triage:**
- *Should exist:* Yes, score and badge state affect leaderboard/profile trust and must be owned by the backend.
- *Smallest safe scope:* Award points and unlock badges inside Worker routes that already process logs, nudges, and accepted role/supporter events; persist unlocks idempotently in D1; return a compact `gamification` object from `/api/sync/daily`; and let Flutter cache/display only the server values needed to avoid regressions.
- *Skipped scope:* New achievements gallery, badge animations, seasonal ranks, anti-cheat analytics, push notifications, complex streak calendars, profile/card redesign, and marketplace-style habit following.
- *Boundaries:* Do not keep `/api/sync/score` as a client-authoritative score source. Do not broaden the next raw UI polish item into this task. Do not award duplicate points when the same offline log is replayed.

**Action:** Move progression authority to Cloudflare Workers and D1. Add backend achievement storage, calculate 5 points for accepted completed check-ins, grant an idempotent shared-habit bonus when all active owner/partner participants complete the same habit for the same day, unlock milestone badges on backend events, and append current total points, level name, unlocked badges, and newly unlocked badges to the daily sync payload. Update Flutter sync/cache code only enough to consume the payload and stop treating local score math as authoritative.

**Hable perspective:** The app remains offline-first. Flutter can optimistically show local completion, but final point totals, level names, leaderboard ranking, and badges must come from `/api/sync/daily` and Drift/Riverpod read models. Home should not block on network scoring, and Profile should not run local achievement inference as the source of truth once server progression exists.

**Implementation scope:**
- D1 schema in `backend/schema.sql`: add an achievement unlock table such as `user_achievements(user_id, achievement_id, unlocked_at, source_event_id)` with a unique key on `(user_id, achievement_id)`, add any needed progression-event table or columns to make point awards idempotent, and index log/progression lookups by `user_id`, `habit_id`, `logged_at`, and `status`.
- Backend `backend/src/index.ts`: define small scoring constants and tier mapping in one place, starting with `5` points per completed check-in and named levels derived from `users.total_score`.
- `/api/sync/log`: after a log insert actually succeeds, award check-in points only for `completed` logs, update `habit_progress`, unlock `first_check_in` and streak badges, and never double-award duplicate `log_id` replays.
- Shared-habit bonus: when all active owner/partner participants for a habit have a completed log for the same local date, award the bonus once per eligible participant and source it to a unique event key.
- `/api/social/nudge`: unlock `first_nudge` for the sender when the nudge is authorized and accepted.
- Partnership/supporter integration: unlock `first_supporter` when a supporter role is created after the role task exists; if supporter creation is not yet implemented, leave a guarded no-op and document the dependency instead of faking it client-side.
- `/api/sync/daily`: return `gamification` with current `total_points`, derived `level`, all unlocked `badges`, and a bounded `newly_unlocked_badges` list for the current sync window or pending unacknowledged unlocks.
- Flutter Drift in `lib/database/tables.dart` and generated database code: cache server-owned total score and achievement unlocks if needed for Profile/Social Hub offline reads. Use the smallest schema change that preserves local-first rendering.
- Flutter sync in `lib/services/sync_service.dart`: parse `gamification` during `pullDailySync`, update local user score/level/badge cache, and stop relying on `SyncAction.syncScore` for authoritative scoring. Keep backward compatibility if older Worker responses omit `gamification`.
- Flutter UI/providers: remove or demote local `ScoringEngine` use from authoritative score updates. Profile may show the server-derived level and badges in the existing layout, but new visual polish belongs to the next raw task.
- Documentation: update `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` so score values, sync ownership, payload shape, and smoke commands match the implementation.
- Test surface: focused Worker/API checks for duplicate log replay, completed vs skipped logs, shared bonus once all partners complete, badge unlock idempotency, nudge badge unlock, daily sync payload shape, and Flutter sync parsing of the payload.

**Scalability considerations:** Point awards must be event/idempotency-key based so large offline sync queues do not recompute all history or double count. Daily sync should read indexed aggregates and achievement rows, not scan every habit log. Badge unlocks should use unique constraints, and shared-habit bonus checks should query one habit/date participant set rather than the whole friend graph.

**Future split guidance:** Rich achievement UI, badge reveal animations, profile card redesign, social celebration feeds, seasonal leaderboards, notification copy, and supporter invitation UX should be separate tasks. The next raw `Habit Card & Profile UI Polish` item can consume the `gamification` payload after this backend contract exists.

**Edge cases:** Duplicate offline log replay, two devices syncing the same completion, skipped logs, log timestamps around local midnight, archived habits, partner removed before bonus calculation, supporter role not yet available, accepted friend with no shared habit, user with old local `syncScore` queue entries, backend response without `gamification`, partial D1 migration with existing `total_score`, stale Profile score before next daily sync, leaderboard rows during migration, badge unlock generated but daily sync fails, and shared-habit bonus race when participants sync at different times.

**Acceptance criteria:**
- Backend awards exactly 5 base points for each newly accepted completed check-in and no points for skipped logs unless a future spec changes that explicitly.
- Duplicate `log_id` or duplicate source event replays do not increase `users.total_score` or duplicate badge rows.
- Shared-habit all-partner bonus is awarded once per eligible participant when all active owner/partner participants complete the habit for the same date.
- `first_check_in`, `10_streak`, `100_streak`, `1000_streak`, `first_nudge`, and `first_supporter` badges are unlocked idempotently by backend events.
- `/api/sync/daily` returns a compact `gamification` payload with total points, level name, unlocked badges, and newly unlocked badges.
- Flutter daily sync caches the server progression payload for local-first Profile/Social Hub reads and handles missing payloads without crashing.
- Client-side score sync is no longer authoritative; `/api/sync/score` is removed, deprecated, or ignored safely so users cannot spoof leaderboard totals by posting arbitrary totals.
- Existing Home completion flow still works offline and queues log sync without blocking on network scoring.
- Profile no longer has to infer achievements from completed local habits as the source of truth, though full visual polish is deferred.
- Focused backend/API tests or documented curl checks prove scoring, bonus, badge, idempotency, and daily payload behavior.
- Dependency docs are verified and updated if schema, sync payloads, scoring constants, UI expectations, or smoke procedures change.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`

**Completion notes:**
- Touched files: `backend/schema.sql`, `backend/src/index.ts`, `lib/database/tables.dart`, `lib/database/database.dart`, `lib/database/database.g.dart`, `lib/services/sync_service.dart`, `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/providers/habit_providers.dart`, `lib/providers/scoring_provider.dart`, `Developement/01_Schema_and_Core_Logic.md`, `Developement/02_Offline_Architecture.md`, `Developement/03_UI_UX_and_Animations.md`, `Developement/04_Social_and_Analytics.md`, `Developement/07_Multi_User_Social_Features.md`, and `Developement/08_Testing.md`.
- Behavior verified: Worker-owned score events now award 5 points per newly accepted completed check-in, award a 5-point shared-habit bonus once all active owner/partner participants complete the same habit/date, unlock backend-owned achievements idempotently, return `gamification` from `/api/sync/daily`, and reject client-authored `/api/sync/score` with HTTP `410`.
- Flutter behavior verified: Home no longer updates score totals locally, stale `syncScore` queue items are ignored instead of posted, daily sync caches server total points, level name, and achievement unlocks into Drift, and Profile reads the cached level/badges without inferring achievements from completed local habits.
- Verification run: `npx tsc --noEmit`, `flutter pub run build_runner build`, `dart format`, `flutter analyze`, `npm run db:setup`, and a local Worker smoke against `http://127.0.0.1:8787` covering duplicate log replay, completed vs skipped logs, shared bonus, nudge badge unlock, daily payload shape, and deprecated score sync.
- Docs verified/updated: `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` were updated to reflect schema, payload, scoring constants, UI expectations, and smoke procedure.
- Completed At: 2026-07-11 03:05 CEST

<a id="polish-habit-cards-and-profile-with-role-aware-progression-data"></a>
### [x] Polish Habit Cards And Profile With Role-Aware Progression Data

**Raw source:** 3. Habit Card & Profile UI Polish
* **Objective:** Update the client UI to reflect the new roles and gamification data (Strictly blocked by Item 1).
* **User Card:** Compact the profile view to show the profile picture, name, username, and the dynamic Level Name.
* **Habit Card Data:** Display habit title, icon, current streak, target days, and a horizontal progress line along the bottom border.
* **Social Ring:** Show the habit icon inside a color-coded ring. Fill the ring upon completion; leave it empty for active/skipped states.
* **Partner Visibility:** Display a maximum of 4 partner/supporter avatars per card, adding a status ring around their profile pictures to indicate daily completion.

**Issue:** Home and Profile already render useful pieces, but the surfaces are not yet aligned with the upcoming role and server-side gamification contracts. `_HabitCard` currently centers the mud button and shows title, streak, and a challenge label, while partner status is mostly handled by a separate `PartnerTicker`. `ProfileScreen` shows raw points and locally inferred achievement chips, not a compact server-derived level card. Once backend roles and the `/api/sync/daily` gamification payload exist, the UI needs one cohesive polish pass that consumes those read models without adding a second source of truth.

**Ponytail triage:**
- *Should exist:* Yes, the UI needs to reflect role-aware partners/supporters and server-owned progression after the backend contracts land.
- *Smallest safe scope:* Reuse `_HabitCard`, `PartnerTicker`/avatar styling, `UserAvatar`, `habitPartnersProvider`, `currentUserProvider`, and the existing Profile layout. Add only the fields/providers needed to read role, daily partner completion, and server level/badges from Drift.
- *Skipped scope:* Full visual redesign, new navigation, 3D environment, animated badge gallery, public friend feed, role management screens, global leaderboard redesign, and custom chart rewrites.
- *Boundaries:* This task is blocked until `Add Partnership Roles And Enforce Habit Permissions In Backend` and `Add Server-Side Gamification Progression To Daily Sync` define payload fields. Do not infer roles or levels in UI if backend data is missing; use safe fallbacks.

**Action:** Polish the existing Home habit card and Profile user card to consume role-aware partner snapshots and server-side progression. Compact the Profile header around avatar, username, and dynamic level name; update Home cards to show habit title/icon, streak, target progress, bottom progress line, and up to four role/status-aware partner avatars; and keep all UI reads local-first through Drift/Riverpod.

**Hable perspective:** Home remains the daily action surface and must stay calm, fast, and local-first. Profile remains the historical/progression surface. Daily sync and Drift should supply role, completion, score, level, and badge fields; Flutter widgets should render those fields, not calculate permissions or progression policy. The mud long-press button can remain the primary completion affordance, but the card around it should become clearer and more social.

**Implementation scope:**
- `lib/screens/profile_screen.dart`: replace the raw points-first score card with a compact user card showing `UserAvatar`, username/name, dynamic server level name, and points as secondary text. Use cached server gamification fields when available and keep a non-crashing fallback for older local data.
- `lib/screens/profile_screen.dart`: replace completed-habit-derived achievement chips with server badge data after the gamification task adds a Drift cache/provider. Preserve the existing card shape and avoid a new achievements screen.
- `lib/screens/home_screen.dart`: polish `_HabitCard` to show habit title, optional icon/emoji, current streak, target days, and a bottom horizontal progress line computed from local `Habit.currentDuration`/`targetDuration` or the accepted server progress field.
- `lib/screens/home_screen.dart`: render a compact social row inside each `_HabitCard` using `habitPartnersProvider(habit.habitId)`, capped at four avatars with a `+N` overflow indicator.
- Partner/supporter avatars: reuse or extract styling from `PartnerTicker` and `UserAvatar`; add status rings for completed today, active/not completed, skipped, and supporter read-only where the backend role/status fields exist.
- Role handling: use backend-provided `owner`, `partner`, and `supporter` values from the role task. Hide or disable completion/nudge affordances according to cached role metadata instead of deriving permissions in widgets.
- Drift/Riverpod: extend `PartnerSnapshots` or adjacent read models only as needed for role, today status, and display fields; keep provider watches scoped per habit to avoid rebuilding the whole Home list.
- `lib/widgets/partner_ticker.dart`: keep the global ticker if still useful, but remove duplicated partner semantics where per-card avatars now carry the primary role/status information.
- Accessibility: add semantics labels that distinguish habit progress, completion state, partner role, partner daily status, and overflow avatar count.
- Responsive/mobile validation: keep cards stable on narrow Android screens and Flutter web widths; avoid horizontal overflow from avatar rows or long habit titles.
- Documentation: update `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` if card/profile placement, role displays, progression labels, or smoke steps change.
- Test surface: widget/provider tests or documented device/web smoke for compact Profile card, server level fallback, habit-card progress line, max-four partner avatars, overflow count, role-disabled affordances, and no overflow on narrow screens.

**Scalability considerations:** Home can contain many active habits and each card can have many partners. Watch partners by habit with `habitPartnersProvider(habitId)`, cap visible avatars at four, and avoid querying all partners for every card. Progress rendering should be simple arithmetic in build or precomputed provider state; no heavy chart or badge computation belongs on the Home render path.

**Future split guidance:** 3D habit environments, badge reveal animations, custom icon libraries, role-management screens, supporter invitation UX, leaderboard visual redesign, and social celebration feeds should stay separate. If this polish reveals missing backend payload fields, append raw backend/data tasks rather than fabricating UI-only state.

**Edge cases:** Backend role/gamification payload missing during migration, older Drift rows without role or level fields, no avatar URL, emoji avatar, long username, long habit title, zero or invalid target duration, completed habit with stale partner status, more than four partners, supporter mixed with partners, user has no badges, offline after role change, local completion before daily sync returns server score, friend removed from habit, archived habit still cached, Flutter web narrow viewport, Android text scaling, and screen readers reading avatar-only status.

**Acceptance criteria:**
- Profile user card shows avatar, username/display name, server-derived level name, and points as secondary text using local Drift/Riverpod data.
- Profile achievements render backend-provided badge data when available and fall back gracefully when not yet synced.
- Each Home habit card shows habit title, icon or safe placeholder, current streak, target/progress text, and a bottom horizontal progress line.
- Per-card partner/supporter avatars render inside the relevant habit card, capped at four visible users with a clear `+N` overflow indicator.
- Avatar rings distinguish completed today from active/not completed and show supporter/partner role state when backend data provides it.
- Completion, skip, edit, and nudge affordances respect cached backend role metadata; unsupported actions are hidden or disabled without inventing permissions client-side.
- Home and Profile continue to render from local Drift streams and do not make direct network calls for card/profile polish.
- The global `PartnerTicker` no longer duplicates or conflicts with per-card partner status semantics.
- Long text, empty data, no partners, many partners, and narrow mobile layouts do not overflow.
- Semantics labels describe habit progress, partner role/status, and avatar overflow clearly.
- Focused widget/provider tests or documented web/Android smoke verify the compact profile card, progress line, avatar cap/overflow, role-based disabled states, and missing-payload fallback.
- Dependency docs are verified and updated if UI layout, role display, progression labels, or smoke procedures change.

**Dependencies:** `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`

**Completion notes:**
- Touched files: `backend/src/index.ts`, `lib/services/sync_service.dart`, `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/widgets/habit_partner_row.dart`, `lib/data/standard_habits.dart`, `test/habit_partner_row_test.dart`, `Developement/02_Offline_Architecture.md`, `Developement/03_UI_UX_and_Animations.md`, `Developement/04_Social_and_Analytics.md`, `Developement/07_Multi_User_Social_Features.md`, and `Developement/08_Testing.md`.
- Behavior verified: `/api/sync/daily` now exposes `has_completed_today` for partner snapshots; Home habit cards render habit emoji/title, streak, challenge progress, bottom progress line, and a per-card role-aware partner row capped at four visible avatars plus `+N` overflow; supporter roles disable completion/skip affordances locally; Profile uses a compact avatar/username/level card and disables edit/archive/restore controls for non-owner shared habits.
- Verification run: `npx tsc --noEmit`, `flutter analyze`, and `flutter test test/habit_partner_row_test.dart`.
- Docs verified/updated: `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` were updated to reflect per-card partner status, role-gated affordances, and the focused widget smoke coverage.
- Completed At: 2026-07-11 03:22 CEST

<a id="add-revocable-ical-feed-for-native-calendar-subscriptions"></a>
### [ ] Add Revocable iCal Feed For Native Calendar Subscriptions

**Raw source:** 4. Edge-Native Calendar Integration (iCal)
* **Objective:** Allow users to view daily habits in their native phone calendar without adding heavy, permission-bloated Flutter calendar dependencies.
* **Architecture:** Create a Cloudflare Worker route that generates a dynamic, read-only `.ics` (iCalendar) feed subscription link per user.
* **Event Title:** Generate dynamic motivational messages based on progress. Group multiple daily habits into a single summary event to prevent calendar app clutter.
* **Event Description:** Keep descriptions highly concise. Include partner names and the current target fraction (e.g., 3/5 days).

**Issue:** Hable currently keeps habit state in Drift and syncs to Cloudflare Workers, but there is no native-calendar integration. Adding mobile calendar plugins would add OS permissions and platform-specific write behavior that conflicts with the raw requirement. The lightweight path is a server-generated, read-only calendar subscription feed that native calendar apps can consume through a URL while Hable remains the source of truth.

**Ponytail triage:**
- *Should exist:* Yes, it gives users calendar visibility without owning native calendar permissions or duplicate local calendar state.
- *Smallest safe scope:* Add a revocable per-user feed token, a public `.ics` route that returns a compact rolling habit summary, and a Flutter profile/settings surface that copies the subscription URL. Avoid direct calendar writes.
- *Skipped scope:* Calendar plugin integration, two-way sync, per-habit event editing, reminders/notifications, OAuth calendar APIs, timezone preference UI, recurring rule editors, and full calendar management screens.
- *Boundaries:* The feed is read-only and server-generated. Calendar clients cannot send Bearer tokens, so the URL token must be unguessable and revocable. Do not expose journal entries, private friend data, pending invites, or arbitrary user identifiers in the feed.

**Action:** Build an edge-native iCal subscription path. Add a protected Worker route to create/read/rotate the current user's calendar feed token, add a public tokenized `.ics` route that summarizes the user's active daily habits into a small rolling event set, and add a minimal Flutter UI affordance to copy the feed URL for native calendar subscription.

**Hable perspective:** Hable remains offline-first for in-app UI, but calendar apps are external pull clients. The Worker must generate the feed from D1 as the authoritative synced state, not from the device. Flutter only displays/copies the feed URL after authentication; it does not need calendar permissions or a local calendar database table unless a cached link improves UX.

**Implementation scope:**
- D1 schema in `backend/schema.sql`: add a table such as `calendar_feed_tokens(user_id TEXT PRIMARY KEY, token_hash TEXT NOT NULL, created_at DATETIME, rotated_at DATETIME, revoked_at DATETIME)` or an equivalent token model that supports rotation/revocation without storing plain tokens when practical.
- Backend `backend/src/index.ts`: add protected routes under the existing JWT middleware, for example `GET /api/user/calendar-feed` to return/create the user's feed URL and `POST /api/user/calendar-feed/rotate` to revoke the old token and issue a new one.
- Backend public route: add a non-JWT route such as `GET /calendar/:token.ics` or `GET /api/calendar/:token.ics` before protected middleware so native calendar clients can fetch it without app auth headers.
- ICS generation: emit valid `text/calendar; charset=utf-8` with CRLF line endings, `VCALENDAR`, `VERSION:2.0`, `PRODID`, stable `UID`s, `DTSTAMP`, `DTSTART`/`DTEND` or all-day `VALUE=DATE`, escaped text fields, and deterministic ordering.
- Feed content: group daily active habits into one concise summary event per day for a bounded rolling window, such as today plus the next 14 or 30 days, instead of creating one event per habit.
- Event copy: title should be short and motivational without inventing private data; description should include compact habit names, partner names only where the user is authorized to see them, and current target fractions such as `3/5 days`.
- Privacy: exclude journal notes, private messages, pending invitations, raw auth identifiers, email addresses, and non-shared friend data. Treat anyone with the feed URL as able to read the summary until the user rotates the token.
- Flutter UI: add a small "Calendar subscription" card or action in `ProfileScreen` or the nearest settings surface using existing auth/API infrastructure. Provide copy-to-clipboard behavior with `Clipboard` from Flutter services; add `url_launcher` only if a one-tap subscribe/open flow is explicitly required after the copy-link MVP.
- Flutter providers/services: add a minimal authenticated request helper/provider for fetching/rotating the feed link. Do not block Home rendering and do not introduce a background sync table for the calendar feed unless the UI needs cached display.
- Deployment/base URL: generate absolute HTTPS feed URLs using production origin where possible and support local development via `apiBaseUrl`/request origin so curl and ADB smoke tests can verify local feeds.
- Documentation: update `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` if routes, schema, UX placement, privacy semantics, or smoke commands change.
- Test surface: backend curl checks for create link, fetch `.ics`, rotate token, invalid token, no private data leakage, and valid ICS headers/body; Flutter widget/provider or documented smoke for copy-link and rotate actions.

**Scalability considerations:** Calendar clients may poll feeds repeatedly, so the public route should do indexed user/habit/partnership lookups and return a bounded rolling window. Avoid per-request full history scans. If traffic grows, add cache headers with a short safe TTL and consider Cloudflare cache only if token privacy and revocation behavior remain correct.

**Future split guidance:** Native one-tap calendar launching, user-configurable event times, reminder alarms, per-habit calendar selection, Google/Apple OAuth integrations, two-way completion from calendar, and localized motivational copy should be separate tasks. This task should only ship a secure read-only feed subscription.

**Edge cases:** Calendar client cannot send auth headers, leaked feed URL, token rotation while a calendar app caches the old URL, invalid token, revoked token, user with no active habits, archived habits, habit with zero/invalid duration, many active habits, long habit names, emoji habit titles, partner names with special characters, local timezone vs UTC all-day dates, DST boundaries, duplicate UIDs causing calendar churn, stale D1 state before local sync flush, production URL generated from local origin, calendar clients caching aggressively, and ICS line escaping/line folding errors.

**Acceptance criteria:**
- Authenticated users can generate or retrieve a stable calendar subscription URL.
- Users can rotate/revoke the feed token so the old `.ics` URL stops returning habit data.
- Public `.ics` route works without JWT headers and returns `text/calendar` with valid iCalendar structure.
- Feed events are grouped into concise daily summary events rather than one event per habit.
- Event titles are short and motivational; descriptions include authorized habit names, partner names where allowed, and target fractions.
- Feed excludes journal entries, private messages, pending invite data, emails, raw auth identifiers, and non-authorized social data.
- Flutter exposes a minimal calendar subscription action that copies the URL without requiring native calendar permissions or heavy calendar dependencies.
- Missing network/auth failures in the Flutter calendar-link UI are handled with clear non-crashing states.
- Backend queries are bounded and indexed enough for repeated calendar polling.
- Curl or backend tests verify valid token, rotated token, invalid token, empty feed, and no private-data leakage.
- Web/Android smoke or widget/provider tests verify the copy-link/rotate UI.
- Dependency docs are verified and updated if schema, routes, privacy model, UI placement, or test procedure changes.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="add-code-native-mermaid-architecture-diagrams-for-schema-and-sync-flow"></a>
### [ ] Add Code-Native Mermaid Architecture Diagrams For Schema And Sync Flow

**Raw source:** 5. System Architecture Documentation
* **Objective:** Replace manual, text-heavy documentation tasks with maintainable, code-native diagrams.
* **Database Schema:** Generate a `Mermaid.js` Entity-Relationship (ER) diagram mapping D1 tables, columns, and relationships.
* **System Flow:** Create a `Mermaid.js` sequence diagram illustrating the offline-first sync architecture, showing interactions between Flutter, Riverpod, Drift, and Cloudflare Workers.

**Issue:** The development docs describe Hable's architecture in prose, but there is no concise, code-adjacent diagram that shows the current D1/Drift tables or the offline-first sync path. Existing docs are already known to drift as tasks add auth, partner snapshots, invitations, gamification, role metadata, and calendar feeds. Future agents need a faster way to understand the system without re-reading every table and service manually.

**Ponytail triage:**
- *Should exist:* Yes, architecture diagrams reduce repeated manual discovery and make schema/sync drift easier to spot.
- *Smallest safe scope:* Add Mermaid ER and sequence diagrams generated from the current checked-in schema/service code, plus short notes about how to refresh them. Keep prose minimal and link to source files as the authority.
- *Skipped scope:* Building a custom documentation generator, adding a docs website, image exports, PlantUML, CI publishing, exhaustive API reference docs, and rewriting every development document.
- *Boundaries:* Do not change runtime Flutter, backend, Drift schema, generated database files, or Worker behavior. If source code and docs disagree, document the disagreement as a follow-up raw task instead of silently inventing schema.

**Action:** Create or update a system architecture documentation page with code-native Mermaid diagrams. The ER diagram should map the current D1 schema and important Drift-only cache/queue tables. The sequence diagram should show the normal offline-first mutation and daily sync flow from Flutter UI through Riverpod, Drift, `SyncQueue`, `SyncService`, Cloudflare Worker routes, D1, and KV.

**Hable perspective:** Hable's source of truth is split by concern: Flutter UI renders from Drift/Riverpod, `SyncService` pushes queued mutations and pulls daily sync, Cloudflare Workers enforce auth/privacy and persist to D1/KV, and docs must explain that separation clearly. The diagrams should help implementers avoid direct Home-screen network reads, duplicate sync paths, and privacy leaks in social payloads.

**Implementation scope:**
- Add or update a focused architecture document, preferably `Developement/09_System_Architecture.md` or an equivalent clearly named file, with Mermaid blocks and a short "source files" section.
- ER diagram: include D1 tables from `backend/schema.sql` such as `users`, `auth_pins`, `habits`, `habit_logs`, `habit_progress`, `partnerships`, `friend_requests`, `habit_invitations`, `private_messages`, and `milestone_events`.
- Drift-only diagram notes: include local-only or cache/queue tables from `lib/database/tables.dart`, including `SyncQueue`, `CachedQuotes`, `SearchDocuments`, `PartnerSnapshots`, `AcceptedFriends`, and any other Drift tables not mirrored exactly in D1.
- Relationship mapping: represent real foreign-key relationships where they exist and label inferred/application-level relationships separately when D1 lacks explicit FK constraints.
- Sequence diagram: show habit creation/completion/skip/nudge/invitation as local Drift writes first, then `SyncQueue`, `SyncService.flushPending`, authenticated Worker route, D1/KV persistence, and `GET /api/sync/daily` returning partner snapshots, nudges, messages, invitations, accepted friends, and future progression/role/calendar payloads.
- Auth boundary: show JWT storage/use at a high level without documenting secrets or token values.
- Privacy boundary: call out that partner/friend/profile payloads are privacy-scoped and journal notes/private messages must not leak into social/calendar feeds.
- Maintainability: add a short refresh checklist that names the source commands/files to inspect, such as `backend/schema.sql`, `lib/database/tables.dart`, `lib/database/database.dart`, `lib/services/sync_service.dart`, `backend/src/index.ts`, and `rg -n "app\\.(get|post|put|delete)" backend/src/index.ts`.
- Documentation alignment: update `01_Schema_and_Core_Logic.md` and `02_Offline_Architecture.md` to link to the new diagrams instead of duplicating long diagram prose. Update `08_Testing.md` only if a diagram validation command or doc review checklist is added.
- Validation: run a lightweight Markdown/Mermaid sanity check where available, or at minimum verify fenced Mermaid syntax, anchors, and source references with `rg`/`sed`. Do not add new dependencies just to render Mermaid unless the repo already has a doc tool.

**Scalability considerations:** Documentation grows stale as table and route count grows. Keep diagrams high-signal and source-linked rather than exhaustive prose. Mermaid source blocks scale better than committed screenshots because they remain diffable and easy to update during schema or sync changes.

**Future split guidance:** A generated ER diagram script, CI doc validation, OpenAPI-style route documentation, exported PNG/SVG diagrams, or a hosted documentation site should be separate tasks if the manual Mermaid blocks start drifting. This task should only establish maintainable architecture diagrams and update links.

**Edge cases:** D1 schema and Drift schema disagree, generated Drift code differs from hand-written tables, backend `src/index.ts` and compiled `src/index.js` diverge, app-level relationships lack FK constraints, role/gamification/calendar tasks are engineered but not implemented yet, Mermaid syntax unsupported by a viewer, diagrams become too dense to read, docs include future tables as if implemented, stale route names, privacy-sensitive fields shown in diagrams, and dirty user edits in docs.

**Acceptance criteria:**
- A Mermaid ER diagram exists in the development docs and maps current D1 tables, primary keys, key columns, and relationships.
- Drift-only/cache/queue tables are documented clearly without pretending they are all D1 tables.
- A Mermaid sequence diagram shows the offline-first flow through Flutter UI, Riverpod, Drift, `SyncQueue`, `SyncService`, Cloudflare Workers, D1, KV, and daily sync back to Drift.
- The diagrams distinguish real database constraints from inferred application-level relationships.
- The diagrams do not expose secrets, raw JWT values, private journal content, or unauthorized social data.
- `01_Schema_and_Core_Logic.md` and `02_Offline_Architecture.md` link to the diagram document or embed the diagrams without duplicating large stale prose.
- The architecture docs call out current implemented state separately from engineered-but-not-yet-implemented role, gamification, and calendar-feed changes.
- A refresh checklist names the exact source files/commands future agents should inspect before updating diagrams.
- Lightweight syntax/link checks are run or documented if no Mermaid renderer is available.
- Dependency docs are verified and updated if diagram placement, schema notes, sync flow notes, or testing guidance changes.

**Dependencies:** `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`, `backend/schema.sql`, `lib/database/tables.dart`, `lib/services/sync_service.dart`, `backend/src/index.ts`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="repair-signup-signin-and-forgot-password-network-failures"></a>
### [ ] Repair SignUp SignIn And Forgot Password Network Failures

**Raw source:** Continue developement of SignUp, SignIn, and Forgot Password process. You can look and inspire from email authentitcation from VibeCoding/campusweb (the sign in and sign up just says 'Network error'). Previous transfer note referenced **Implement Email Authentication And PIN Reset Flow**, but no matching engineered task anchor currently exists in `Task1_Engineered.md`.

**Issue:** The `AuthScreen` already exposes login, registration, PIN request, and password reset views, and `AuthNotifier` calls `/api/auth/login`, `/api/auth/register`, `/api/auth/request-pin`, and `/api/auth/reset-password`. The user-reported symptom is that SignUp and SignIn only show `Network error`, which means the current client/backend/deployment path is hiding the real failure. The backend also currently logs reset PINs server-side instead of sending email in production, so Forgot Password cannot be considered complete for normal users.

**Ponytail triage:**
- *Should exist:* Yes, auth is a trust boundary and a core app gate. The task should fix the root network/auth path rather than only changing the visible error string.
- *Smallest safe scope:* Trace the exact failing HTTP path for web and Android, surface useful backend/client errors, align D1 schema and deployed Worker/Pages Functions for auth, and add a minimal production-capable email PIN delivery path inspired by `campusweb`.
- *Skipped scope:* OAuth, passkeys, refresh tokens, account deletion, full email verification for registration, multi-account switching, biometric unlock, custom auth service extraction, and a redesigned onboarding/auth UI.
- *Boundaries:* Keep Hable's current username/password plus email reset model. Do not replace the app gate, Drift user cache, JWT middleware, or existing twin-harness seed login unless they are directly causing the network failure.

**Action:** Repair the existing auth flow end to end. Reproduce the SignUp/SignIn/Forgot Password failures against the selected backend target, identify whether the failure is client base URL, Cloudflare routing, D1 schema drift, stale generated Worker output, CORS/same-origin mismatch, or backend exception, then make the smallest code and deployment changes needed for normal login/register/reset to work with actionable errors.

**Hable perspective:** `main.dart` gates the app through `AuthNotifier` state and the local Drift user cache. `AuthScreen` is a live-network exception to the local-first UI rule because authentication must obtain a JWT before background sync can operate. After auth succeeds, the app should persist the token in secure storage, upsert the current user into Drift, and let Home/Profile/Social Hub continue reading local state through Riverpod.

**Implementation scope:**
- Client diagnostics in `lib/providers/auth_provider.dart`: preserve server error messages, log useful debug details in debug builds, handle malformed/non-JSON responses safely, and avoid collapsing every exception into undifferentiated `Network error`.
- Client routing in `lib/config/api_config.dart`: verify debug Android, debug web, production web, and optional `HABLE_API_BASE_URL` behavior so normal app builds hit the intended backend (`127.0.0.1`, emulator host, ADB-reversed physical device, or `https://hable.pages.dev`) without stale localhost calls in release.
- UI in `lib/screens/auth_screen.dart`: keep the current views, validation, and navigation, but ensure the user sees precise failed-auth/reset messages and that reset success returns to login without clearing needed email/PIN state too early.
- Backend auth routes in `backend/src/index.ts`: harden `/api/auth/register`, `/api/auth/login`, `/api/auth/request-pin`, and `/api/auth/reset-password` for validation, duplicate username/email, missing schema columns, expired/invalid PINs, and consistent JSON errors.
- D1 schema/deploy alignment in `backend/schema.sql`, `wrangler.toml`, and Pages/Worker output: ensure `users.email`, `users.password_hash`, `auth_pins`, indexes, and JWT secret bindings exist locally and remotely; remove or regenerate stale compiled files only if they are actually used by the deploy path.
- Email PIN delivery: adapt the smallest useful concept from `../../campusweb/src/routes/api/auth/request-pin/+server.ts`, `../../campusweb/src/routes/api/auth/verify-pin/+server.ts`, and `../../campusweb/src/lib/server/auth/email.ts`: dev may log the PIN, production must send an email or return a clear delivery error instead of pretending the email was sent.
- Security basics: keep PINs hashed, expire PINs, reject weak missing fields, avoid leaking whether unrelated accounts exist beyond the current product decision, rate-limit or add a follow-up raw task if the current backend lacks any abuse control.
- Test surface: add focused provider/backend tests where practical, then verify with `flutter analyze`, `flutter test`, backend TypeScript checks, direct `curl`/HTTP checks for auth endpoints, and a documented web or Android smoke for register, login, request PIN, reset password, and login with the new password.
- Documentation: update `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `08_Testing.md`, and `Commands.md` if schema, auth routing, UI behavior, or test commands change.

**Scalability considerations:** Auth endpoints must stay cheap and indexed by `username` and `email`. PIN request and verification need rate limiting before public traffic grows; if not implemented in the smallest fix, append a separate raw task for abuse controls. Email delivery should use one Cloudflare-native path rather than adding a new third-party dependency.

**Future split guidance:** Email verification at signup, refresh/session rotation, account deletion, passkeys/OAuth, remote logout, multi-device session management, and full abuse/rate-limit telemetry should be separate tasks after the basic username/password/reset flow works reliably.

**Edge cases:** Physical Android device cannot reach `127.0.0.1` without `adb reverse`, emulator needs a different host, Flutter web release accidentally calls localhost, deployed Pages Functions lack the new D1 schema, `JWT_SECRET` is missing, `backend/src/index.js` is stale while deploy uses TypeScript, response body is HTML or empty instead of JSON, duplicate username/email, invalid email format, PIN requested for unknown email, PIN expired, wrong PIN, email provider unavailable, reset password succeeds but login still uses old hash, secure storage contains stale credentials, and local Drift user upsert fails after token save.

**Acceptance criteria:**
- The original SignUp and SignIn flows no longer report a generic `Network error` for normal backend validation or deployment failures; they show actionable messages and log useful debug detail in debug builds.
- `POST /api/auth/register` creates a user with username, email, password hash, avatar URL, and JWT on the selected backend target.
- `POST /api/auth/login` accepts the newly registered credentials and rejects invalid credentials with a stable JSON error.
- Forgot Password can request a PIN, verify/reset the password, and then log in with the new password; dev PIN logging is allowed only for local development.
- Production reset PIN delivery either sends email through the configured Cloudflare email path or returns a clear delivery failure instead of a fake success.
- Local and remote D1 schemas include the auth fields and `auth_pins` table required by the implemented routes.
- `AuthNotifier` saves JWT/user identity only after successful responses and upserts the local Drift user without leaving the app in a half-authenticated state.
- Normal auth works on the intended web target and one Android/debug target, or the missing target is documented with the exact blocker.
- `flutter analyze`, `flutter test`, backend TypeScript checks, and direct auth endpoint checks pass, or failures are documented as unrelated with evidence.
- Dependency docs are verified and updated if schema, routing, UI copy, email delivery, or test procedure changes.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `08_Testing.md`, `Commands.md`, `../../campusweb/src/routes/api/auth/request-pin/+server.ts`, `../../campusweb/src/routes/api/auth/verify-pin/+server.ts`, `../../campusweb/src/lib/server/auth/email.ts`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="show-accepted-partner-habits-on-recipient-home-after-invite-acceptance"></a>
### [ ] Show Accepted Partner Habits On Recipient Home After Invite Acceptance

**Raw source:** UX Major Matter: the habit partner up should get first accepted from partners, and then it should show up at the homepage of partners. currenlty it gets accepted, but not show up in the partner's homepage, just in creator's homepage.

**Issue:** Habit partner invites must be private while pending, then become visible to the recipient only after acceptance. Current docs and earlier smoke notes say accepted invites should create symmetric partnerships and daily sync should expose the shared habit, but the reported behavior is that the accepted partnered habit remains visible only on the creator's Home. The likely gap is in the accept/flush/pull path or in how `/api/sync/daily` shared habit metadata is merged into the recipient's local `Habits` table watched by `activeHabitsProvider`.

**Ponytail triage:**
- *Should exist:* Yes, this is the core permission boundary for habit partnerships and the current behavior breaks the partner UX.
- *Smallest safe scope:* Fix the accepted-invite path so a recipient sees the shared active habit on Home only after the backend accepts the invitation and daily sync pulls authorized metadata into Drift.
- *Skipped scope:* Role-based partnership permissions, supporter mode, public friend habit feeds, realtime sockets, broad Home redesign, habit cloning, push notifications, and new social graph UI.
- *Boundaries:* Do not show pending invites as active habits. Do not expose non-partner habits. Keep Home reading Drift through Riverpod; network work belongs in `SyncService` and backend routes.

**Action:** Trace and repair the accepted habit-partner visibility flow. Verify that `POST /api/social/habit-invitation/accept` creates symmetric partnership rows, `GET /api/sync/daily` returns the accepted shared habit metadata for the recipient, `SyncService.pullDailySync` upserts the recipient-local active habit correctly, and `HomeScreen` rebuilds from `activeHabitsProvider` without requiring app restart or manual local edits.

**Hable perspective:** The recipient Home should render the partnered habit from local Drift state, not directly from the invitation response. Accepting an invite can optimistically hide the pending banner, but the habit card should appear only after the queued accept action reaches the backend and the inbound daily sync confirms authorized partnership data. Creator and recipient may both hold a local row with the same `habit_id`, scoped by their own `userId`, so the sync merge must preserve the current user's ownership/view semantics.

**Implementation scope:**
- Backend route in `backend/src/index.ts`: verify `/api/social/habit-invitation/accept` updates only the recipient's pending invite and inserts both `(creator, recipient, habit)` and `(recipient, creator, habit)` rows idempotently.
- Backend daily sync in `backend/src/index.ts`: verify `/api/sync/daily` returns habit `id`, `title`, `target_duration`, `color_hex`, `status`, partner identity, and current progress for accepted partnerships where `p.user_id` is the current recipient.
- Drift schema and DAO in `lib/database/tables.dart` and `lib/database/database.dart`: confirm shared accepted habits can be upserted for the current user without corrupting creator-owned rows, target duration, status, color, or local progress.
- Sync layer in `lib/services/sync_service.dart`: fix the partner metadata merge if needed, avoid inserting pending invites as active habits, remove stale partner snapshots when partnerships disappear if that is already represented by sync data, and invalidate or naturally refresh relevant Riverpod streams after pull.
- Riverpod/UI in `lib/providers/habit_providers.dart`, `lib/providers/social_providers.dart`, `lib/screens/home_screen.dart`, and `lib/widgets/invitation_banner.dart`: keep Home and the invitation banner driven by Drift streams; ensure accepting an invite flushes then pulls daily sync for the current user and does not leave the UI in a stale accepted-but-hidden state.
- Tests/smoke: add the smallest backend/API or Dart test that catches missing recipient visibility, then run a twin-harness or documented web smoke where Alice creates a habit with Bob selected, Bob accepts, Bob sees the habit on Home, Alice still sees it, and Bob did not see it before acceptance.
- Documentation: update `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` if the accepted-invite flow, sync payload, or test runbook changes.

**Scalability considerations:** Daily sync should remain scoped to accepted partnered habits for the current user and indexed through `partnerships(user_id, habit_id)` and `habit_invitations(recipient_id, status)`. If shared-habit counts grow, pagination or updated-since sync belongs in a separate task.

**Future split guidance:** Partnership roles (`owner`, `partner`, `supporter`), edit/delete permissions, conflict-resolution UI, push notifications for accepted invites, and realtime shared habit updates should remain separate follow-up tasks after this acceptance visibility bug is fixed.

**Edge cases:** Accept tapped twice, accept queued offline, accept succeeds but daily sync fails, stale pending invite remains in Drift, declined invite later appears as active, recipient sees the habit before acceptance, creator habit archived before acceptance, backend habit row missing because habit sync has not flushed before invite sync, duplicate partnership rows, same `habit_id` upserted under the wrong local `userId`, target duration reset to the fallback value, partner progress overwrites recipient progress, and Home does not rebuild after the pull completes.

**Acceptance criteria:**
- Pending habit invitations do not appear as active Home habits for the recipient.
- Accepting a habit invitation reaches the backend and creates symmetric partnership rows idempotently.
- After accepted daily sync, the recipient's Drift `Habits` table contains the shared active habit scoped to the recipient user and `activeHabitsProvider(recipientId)` emits it.
- The creator still sees the original habit after the recipient accepts.
- The recipient sees the shared habit on Home without reinstalling, force-stopping, or manually editing local data.
- Declining an invite does not create a partnership row and does not show the habit on recipient Home.
- Shared habit metadata preserves title, color, target duration, and active/archive status from the backend payload.
- Partner snapshots and nudges remain scoped to accepted partnered habits.
- A focused test or documented twin-harness/web smoke proves before-accept hidden, after-accept visible for the recipient, and still-visible for the creator.
- Dependency docs are verified and updated if backend payloads, Drift merge behavior, Home UX, or smoke commands change.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="verify-normal-android-account-creation-login-and-logout-flow"></a>
### [ ] Verify Normal Android Account Creation Login And Logout Flow

**Raw source:** work creating, logging in , logging out on android ADB

**Issue:** Existing Android smoke documentation focuses on seeded Alice/Bob flavors and unauthenticated gating, but there is no dedicated normal-account ADB pass proving a user can create an account, log out, and log back in on Android. Current code also appears to have registration and login UI, but no visible logout/sign-out path or `AuthNotifier.logout` equivalent, so the requested logout flow may not be testable yet.

**Ponytail triage:**
- *Should exist:* Yes, normal account create/login/logout is a core auth lifecycle and needs Android verification separate from seeded twin-harness auto-login.
- *Smallest safe scope:* Add the smallest logout path if it is still missing, then run one normal Android debug smoke against the local Wrangler backend using ADB. Reuse `AuthScreen`, `AuthNotifier`, `ProfileScreen`, current Drift providers, and existing ADB commands.
- *Skipped scope:* OAuth, email verification, password reset retesting, account deletion, session refresh, biometric auth, full automated UI test framework, and twin-app social flows.
- *Boundaries:* Test the normal unseeded app, not `SEED_USER_ID` auto-login. Logout must clear auth tokens and local user state enough that `AppGate` returns to `AuthScreen` and prior private data is not visible to the next unauthenticated user.

**Action:** Implement or verify a real logout flow, then perform an Android ADB smoke test from a clean app install: start the local backend, create a fresh account through `AuthScreen`, confirm Home loads for the new user, log out through the app UI, verify the app returns to `AuthScreen` and protected surfaces are unavailable, then log back in with the same credentials and confirm Home/Profile render the same account.

**Hable perspective:** `main.dart` gates access through `currentUserProvider`, while `AuthNotifier` stores JWT/user identity in secure storage and upserts the current user into Drift. Logout must coordinate those layers so clearing secure storage alone does not leave a local Drift user row that keeps `_AppGate` on Home. Android debug uses the local backend path (`http://10.0.2.2:8787` in `AuthNotifier`), so the ADB smoke should keep `adb reverse tcp:8787 tcp:8787` and local Wrangler/D1 setup aligned with existing docs.

**Implementation scope:**
- `lib/providers/auth_provider.dart`: add or verify a `logout` action that deletes auth storage, resets `AuthState`, and clears/invalidates the local current-user state used by `_AppGate`.
- `lib/screens/profile_screen.dart` or another existing authenticated settings surface: add the smallest discoverable sign-out button with a confirmation only if needed to avoid accidental taps.
- `lib/main.dart` / provider invalidation: ensure logout navigates or rebuilds back to `AuthScreen` without requiring a process restart.
- ADB procedure: use a normal unseeded debug app install, clear app data, run local backend setup, launch via ADB, create an account, log out, and log back in.
- Documentation: update `Developement/08_Testing.md` with the executed Android auth lifecycle log and `Developement/Commands.md` if exact normal-app ADB commands differ from current docs.
- Test surface: run `flutter analyze` and `flutter test`; add the smallest provider/widget test only if logout logic changes provider behavior beyond a simple UI button.

**Scalability considerations:** Scalability impact: none expected. Auth logout is local state cleanup plus one normal backend-backed login/register smoke; future multi-account support would require a separate data-retention and cache-partitioning design.

**Future split guidance:** Add automated ADB/UI-driver coverage, refresh-token/session-expiry handling, email verification, account deletion, and multi-account local data retention as separate tasks only after the manual Android lifecycle smoke is stable.

**Edge cases:** No ADB device connected, backend not running, local D1 schema missing auth columns, duplicate username/email from prior smoke, Android debug build using `10.0.2.2` vs `adb reverse` expectations, secure storage contains stale tokens, `kDebugMode` auth wipe masks logout persistence behavior, logout clears secure storage but leaves Drift user rows, logout during pending sync, app process killed after logout, and login after logout showing stale previous-user data.

**Acceptance criteria:**
- Normal unseeded Android debug app can be installed and launched through ADB.
- Fresh account registration succeeds against the selected backend and routes to Home.
- A visible logout/sign-out path exists in an authenticated UI surface.
- Logging out clears auth state and returns the app to `AuthScreen` without requiring reinstall or force stop.
- After logout, Home/Profile/Social Hub are not reachable from the normal app UI without logging in again.
- Logging back in with the newly created account succeeds and renders the same account identity in Home/Profile.
- `flutter analyze` and `flutter test` pass, or any failures are documented as pre-existing/non-blocking with evidence.
- `08_Testing.md` records the ADB commands, device/backend target, account lifecycle result, and completion timestamp. `Commands.md` is updated if command guidance changes.

**Dependencies:** `08_Testing.md`, `Commands.md`, `02_Offline_Architecture.md`, `01_Schema_and_Core_Logic.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="build-notification-center-and-local-reminder-mvp"></a>
### [ ] Build Notification Center And Local Reminder MVP

**Raw source:** work on notification system for reminding tasks, getting friends interactions (requests acceptance/denial, nudges, etc), sync between devices, cross platform (android and web/ios), etc.

**Issue:** Hable receives social events through sync (`nudges`, private messages, habit invitations, friend requests, accepted friends), but those events are scattered across feature surfaces and are not persisted as a unified notification stream. There is also no cross-platform reminder permission/settings flow. The app needs one offline-first notification center that works from local Drift state first, plus a small local reminder path for habit/task reminders. Remote push should be designed deliberately, not bolted onto the first pass.

**Ponytail triage:**
- *Should exist:* Yes, notification center and reminders are core product plumbing for habit reminders and social interactions.
- *Smallest safe scope:* Add a local Drift-backed notification center, translate existing sync payloads into idempotent notification rows, expose unread/read state through Riverpod, and add opt-in local reminders for habit/task reminders on platforms where local notifications are supported.
- *Skipped scope:* Cloudflare web push broadcast, FCM/APNs production push, admin notification console, realtime sockets, marketing campaigns, notification recommendation logic, and rich media notifications.
- *Boundaries:* Flutter UI must read notifications from Drift/Riverpod. Remote social events arrive through authenticated sync and are stored locally before rendering. Local reminders are opt-in and device-local. Any future push subscription stores device endpoints separately from in-app notification events.

**Campusweb reference pass:** Before implementing, inspect and adapt the proven concepts from `../../campusweb`; do not copy Svelte UI into Flutter.
- In-app announcements: `../../campusweb/src/routes/api/notifications/+server.ts` uses a KV-backed notification document with type, title, message, link, expiry, and audience filters.
- Client unread model: `../../campusweb/src/lib/stores/notificationsStore.ts` and `../../campusweb/src/lib/components/AppNotifications.svelte` keep seen IDs locally, derive unread count/severity, fetch on open/startup, and provide mark-read/mark-all-read behavior.
- Push opt-in and preferences: `../../campusweb/src/lib/components/settings/SettingsNotifications.svelte`, `../../campusweb/src/lib/components/PushNotificationPrompt.svelte`, and `../../campusweb/src/lib/utils/pushSubscriptionSync.ts` show the useful consent-before-subscribe shape.
- Cloudflare push backend reference only: `../../campusweb/migrations/0000_create_push_subscriptions.sql`, `../../campusweb/migrations/0001_add_push_preferences.sql`, `../../campusweb/src/routes/api/push/subscribe/+server.ts`, `../../campusweb/src/routes/api/push/unsubscribe/+server.ts`, `../../campusweb/src/lib/server/push/broadcast.ts`, and `../../campusweb/src/service-worker.ts` separate D1 subscription storage, preference targeting, stale subscription pruning, VAPID signing, and service-worker display. Treat this as future Hable push architecture, not MVP scope.
- Cloudflare bindings: `../../campusweb/wrangler.toml.example` demonstrates separate KV/D1/R2 bindings. For Hable, use D1 for relational social/sync data, KV only for global/audience announcement documents if that future scope is added, and keep uploaded assets in R2 or equivalent object storage.

**Action:** Build the MVP notification center and local reminder path. Add a Drift notification-events table, persist notification rows from sync and local reminder scheduling, show an unread-count entry point in the app, let users mark notifications read/all-read, and add the smallest settings/permission flow needed for local habit reminders without enabling remote push yet.

**Hable perspective:** Notifications are another offline-first read model. The Home, Profile, and Social Hub should not directly parse backend event payloads for badges. `SyncService.pullDailySync` should normalize allowed remote events into local `NotificationEvents`, then the notification UI reads one local stream. This preserves privacy because only already-authorized social data becomes notifications.

**Implementation scope:**
- Drift schema in `lib/database/tables.dart`: add `NotificationEvents` with stable `id`, `userId`, `type`, `sourceType`, `sourceId`, `title`, `body`, optional `actionRoute`/payload JSON, `createdAt`, optional `expiresAt`, optional `readAt`, and indexes for `userId`, `readAt`, `createdAt`, and `(sourceType, sourceId)` idempotency.
- Database methods in `lib/database/database.dart`: upsert notification events idempotently, watch all/unread notifications for the current user, mark one/all as read, delete expired rows, and avoid duplicate rows when daily sync returns the same event twice.
- Sync normalization in `lib/services/sync_service.dart`: convert `nudges`, `messages`, `invitations`, `friend_requests`, and accepted-friend changes from `/api/sync/daily` into notification rows while still persisting their feature-specific tables. Do not show private habit data beyond what existing social payloads already allow.
- Riverpod in `lib/providers/notification_providers.dart` or equivalent: expose unread count, recent notifications, mark-read actions, and reminder settings/actions using the current user from auth state.
- Flutter UI: add a compact notification bell/entry point to an existing top-level surface, a notification center sheet/screen with unread/read states, type icons, timestamps, empty/error states, and action routing back to Social Hub, invitations, messages, or Home where possible.
- Local reminders: add an opt-in settings control for habit/task reminders, request platform permission only from a user action, schedule/cancel local reminders for supported Android/iOS/macOS paths, and use an in-app fallback state for web until a dedicated web-push task exists.
- Backend: keep MVP backend changes minimal. Extend `/api/sync/daily` only if a currently needed social event is not returned. Do not add Cloudflare push subscription storage in this task unless local notification implementation is already complete and the user explicitly expands scope.
- Documentation: update `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` if schema, sync, UI, social, or manual testing guidance changes.
- Test surface: add focused Drift/provider tests for idempotent upsert and unread/read behavior, widget smoke for the notification center empty/unread states, and a documented manual smoke for local reminder permission/scheduling on at least one supported platform.

**Scalability considerations:** Keep notification events small and indexed by current user/read/time. Expire or prune old read notifications before the table becomes a long-term event log. If future remote push is needed, follow the campusweb separation: D1 stores push subscriptions/preferences, KV can store global audience announcements, and the app still writes in-app notification rows for durable state.

**Future split guidance:** Add Cloudflare web push, FCM/APNs, VAPID key management, admin broadcast UI, KV-backed global announcements, realtime sockets, notification digesting, quiet hours, and cross-device read-state sync as separate tasks after the local center works.

**Edge cases:** Duplicate sync payloads, same nudge received after app reinstall, notification source row missing after deletion, expired notification still unread, logged-out user with old notifications, account switch on same device, offline while marking read, local reminder permission denied, Android notification permission on newer versions, iOS/web support differences, web running without service worker push, sync returns a friend request after it was accepted elsewhere, and notification tap targets routing to unavailable screens.

**Acceptance criteria:**
- A `NotificationEvents` Drift table and DAO/provider surface exist for current-user notifications.
- `/api/sync/daily` social payloads are normalized into idempotent local notification rows without duplicate unread items.
- Users can open a notification center, see unread/read notifications, mark one read, and mark all read.
- The unread count updates from local Drift state and survives app restart.
- Notification actions route to the closest existing relevant surface or degrade gracefully when no route exists.
- Local habit/task reminder settings request permission from a user action and schedule/cancel supported local reminders without crashing unsupported platforms.
- Remote push subscriptions, Cloudflare broadcast, and service-worker push are explicitly deferred unless a later task expands scope.
- Focused tests or documented smoke checks cover idempotent upsert, unread/read state, empty state, and local reminder permission/scheduling behavior.
- The campusweb reference files above are used only as architecture guidance, and any adopted backend pattern is translated to Hable's Flutter/Cloudflare codebase.
- Required development docs are verified and updated if the implementation changes schema, sync, UI, social behavior, or test procedure.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`, `../../campusweb/src/routes/api/notifications/+server.ts`, `../../campusweb/src/lib/stores/notificationsStore.ts`, `../../campusweb/src/lib/server/push/broadcast.ts`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]


<a id="add-friend-profile-drilldown-and-habit-scoped-nudge-actions"></a>
### [ ] Add Friend Profile Drilldown And Habit-Scoped Nudge Actions

**Raw source:** work on seeing friends profile by tapping on their name at homepage, and the nudging is exclusively for partners on the partnered habits cards (inside the card). Follow-up detail: you can see friends profile, and their active habbits, and able to follow their habits and nudge them without being partner in that habbit.

**Issue:** Home currently renders `PartnerTicker` from local `PartnerSnapshots`, and `PartnerTicker` has split behavior: avatar tap enqueues a nudge while username tap opens `ProfileScreen(userId: partner.partnerUserId)`. Friend profile rendering already exists in `ProfileScreen`, but the active-habit list uses a local-only "Nudged" snackbar and a follow button that only pre-fills `HabitFormSheet`. This makes profile navigation hard to discover, nudge behavior too global, and friend-profile encouragement/follow actions inconsistent with the real sync queue and privacy model.

**Ponytail triage:**
- *Should exist:* Yes, the current UI mixes profile navigation and nudge action in the Home partner ticker, and friend-profile actions do not match backend behavior.
- *Smallest safe scope:* Reuse the existing `ProfileScreen`, `friendProfileProvider`, `PartnerTicker`, `habitPartnersProvider`, `HabitFormSheet`, and nudge sync queue. Make Home partner names/avatars clearly open friend profiles, move real nudge controls into partnered habit cards, and make friend-profile follow use the existing habit creation sheet.
- *Skipped scope:* Public habit marketplace, recommendations, follow-feed persistence, push notifications, realtime presence, comments, non-friend profile browsing, full social graph redesign, and new backend tables for "following" habits.
- *Boundaries:* Do not expose private habit journals or non-allowed habit metadata. Do not let global Home partner widgets send ambiguous nudges. If friend-profile nudge remains allowed for accepted friends, label it as encouragement and keep backend authorization explicit.

**Action:** Tighten the friend drilldown and nudge UX. Make tapping a friend identity on Home open their profile consistently. Remove or demote the global partner-ticker nudge affordance. Add per-habit partner controls inside `_HabitCard` using `habitPartnersProvider(habit.habitId)` so nudges are sent from the specific partnered habit context. On friend profiles, keep the active habits list privacy-scoped, make "Follow" prefill a local habit creation flow, and replace local-only nudge feedback with the real queue-backed nudge action only when backend authorization permits it.

**Hable perspective:** Home remains the daily action surface and reads Drift/Riverpod state. Partner snapshots are local read models from `/api/sync/daily`. Friend profile loading may use the existing authenticated network provider because it is a deliberate drilldown, but the profile must only show fields the backend is allowed to expose. Nudge writes should be queued through `SyncQueue` and flushed by `SyncService`, not simulated with a snackbar.

**Implementation scope:**
- `lib/widgets/partner_ticker.dart`: make the primary tap target open `ProfileScreen` for the friend; remove the avatar-tap nudge side effect or replace it with a clearly separate profile-only affordance.
- `lib/screens/home_screen.dart`: stop wiring global `allPartnersProvider` nudges from the bottom ticker; render habit-specific partners inside `_HabitCard` using `habitPartnersProvider(habit.habitId)` and expose a small nudge action per partner on that card.
- `lib/providers/social_providers.dart`: reuse `enqueueNudge` for habit-card partner nudges and friend-profile encouragement; avoid creating a second nudge path.
- `lib/screens/profile_screen.dart`: keep `_buildFriendProfile` and `_FriendHabitListTile`, but make active habit rows show safe data only, make `Follow` open `HabitFormSheet.show(context, prefilledTitle: title)` with no hidden network mutation, and make any nudge/encourage button enqueue a real `sendNudge` item or be hidden/disabled when the viewer is not authorized.
- Backend route `backend/src/index.ts`: verify `GET /api/social/user/:id/profile` is authenticated and privacy-scoped to accepted friends or allowed relationships before returning active habits; verify `POST /api/social/nudge` matches the intended friend-vs-partner authorization rule.
- Drift/Riverpod: use existing `PartnerSnapshots`, `AcceptedFriends`, and stream providers; add only tiny DAO/provider helpers if needed to map partners by habit efficiently.
- Accessibility: update semantics so friend identity tap says it opens profile, and nudge buttons say which friend and habit they affect.
- Test surface: focused widget/provider test or documented smoke for profile navigation from Home, habit-card nudge enqueue, friend-profile follow prefill, and backend rejection/disable behavior for unauthorized nudges.
- Documentation: update `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` if interaction placement, privacy rules, or smoke steps change.

**Scalability considerations:** Keep partner rendering per habit bounded; `habitPartnersProvider(habitId)` should watch one habit's partner snapshots rather than rebuilding Home from every partner row for every card. Friend profile active-habit lists should stay small and privacy-scoped; pagination can be a future task if profiles become large.

**Future split guidance:** A durable "follow habit" model, friend activity feed, profile privacy settings, public habit templates, richer encouragement messages, notifications for encouragement, and recommendation algorithms should be separate tasks. This task should only make existing friend profile, follow-prefill, and nudge mechanics coherent.

**Edge cases:** No partners on a habit, multiple partners on one habit, same partner appears on many habits, tapping a friend with stale profile data, friend profile network failure, accepted friend without shared habits, backend authorizes friend-level nudge but product wants partner-only nudge, user follows their own habit from their profile, duplicate follow-created habit titles, nudge queued offline, nudge button tapped repeatedly, stale partner snapshots after partnership removal, and screen readers confusing profile taps with nudge buttons.

**Acceptance criteria:**
- Tapping a friend identity from Home opens the existing friend profile screen with username, avatar, score, and allowed active habits.
- The global Home partner ticker no longer sends ambiguous nudges from the same tap target used for profile discovery.
- Partner nudge actions appear inside the relevant partnered habit card and enqueue `SyncAction.sendNudge` with the selected partner user id.
- Friend profile active-habit rows show only privacy-safe fields returned by the backend.
- Friend profile `Follow` opens the existing habit creation sheet with the friend's habit title prefilled and does not create remote follow state.
- Friend profile nudge/encourage action either enqueues a real nudge through the existing sync queue when authorized or is hidden/disabled with a clear non-crashing state when unauthorized.
- Backend profile and nudge routes do not expose private habit data or allow unauthorized users to inspect/nudge arbitrary users.
- Semantics labels distinguish "open profile" from "nudge partner".
- A focused test or documented smoke covers Home profile tap, habit-card nudge, friend-profile follow prefill, and unauthorized nudge handling.
- Dependency docs are verified and updated if UX placement, backend privacy rules, or smoke procedures change.

**Dependencies:** `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]
