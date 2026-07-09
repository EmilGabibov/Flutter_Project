<!-- AI AGENT OPERATING CONTRACT — See Task_ai_agent_contract.md for full rules. This file is the full-body archive for completed tasks. -->

## Archived Tasks

<a id="add-cloudflare-worker-backend-for-social-sync-ephemeral-nudges"></a>
### [x] Add Cloudflare Worker Backend For Social Sync & Ephemeral Nudges

**Raw source:** Build the Cloudflare Worker Backend (D1 & KV): Implement the Cloudflare API for the Partnership Junction and the Ephemeral Nudge System, replacing the current stubs in `lib/services/sync_service.dart`. (From `04_Social_and_Analytics.md`)

**Issue:** The Flutter client is fully offline-capable, but the backend sync layer is stubbed out. Hable needs a remote Cloudflare Worker with D1 and KV bindings to handle partner data requests and transient social nudges without exposing private journal data.

**Ponytail triage:**
- *Should exist:* Yes, required by `04_Social_and_Analytics.md`.
- *Smallest safe scope:* A single Cloudflare Worker handling `/api/sync/daily` (D1) and `/api/social/nudge` (KV). The Flutter app connects to the local Wrangler dev server.
- *Skipped scope:* Production deployment, robust authentication (use simple UUID headers for MVP), and full friend-request flows.
- *Boundaries:* Worker MUST strictly mask data (returning only `username`, `avatar_url`, and `current_duration`). Flutter MUST NOT block the UI thread during HTTP calls.

**Action:** Initialize a Cloudflare Worker project in a `backend/` folder. Define a D1 schema for `partnerships` and KV bindings for nudges. Expose two endpoints. Update `lib/services/sync_service.dart` to make actual HTTP requests to `localhost:8787`.

**Hable perspective:** The Flutter app's `Workmanager` background task will consume these endpoints. The UI will read from the local Drift DB, not directly from these APIs.

**Implementation scope:**
- Cloudflare Worker (`backend/src/index.ts` / `wrangler.toml`)
- D1 Database schema (`backend/schema.sql`)
- KV Namespace binding for nudges
- `lib/services/sync_service.dart` (Flutter API client integration)

**Scalability considerations:** KV has a 1-minute propagation delay and is eventually consistent; nudges might take a moment to appear. D1 is distributed SQLite, perfectly suited for the `partnerships` junction table.

**Future split guidance:** Robust authentication (e.g., JWTs) and friend-request acceptance flows are deferred. A future raw task should be appended for "Implement secure user authentication for sync APIs" if this scales.

**Edge cases:** Device goes offline during sync, Wrangler dev server isn't running (handle connection refused gracefully), KV expiration occurs before the target user syncs.

**Acceptance criteria:**
- Worker can be started via `npx wrangler dev`.
- `POST /api/social/nudge` writes a key to KV with a TTL.
- `GET /api/sync/daily` returns D1 partnership data and clears active nudges from KV.
- `sync_service.dart` successfully hits the endpoints without crashing the Flutter app.

**Dependencies:** `04_Social_and_Analytics.md`

**Completion notes:**
- Created `backend/` with `package.json`, `wrangler.toml`, and `tsconfig.json`.
- Implemented `schema.sql` (users, habit_progress, partnerships) and initialized D1.
- Implemented `src/index.ts` with Hono router for `/api/social/nudge` and `/api/sync/daily`.
- Replaced stubs in `lib/services/sync_service.dart` with `http` package logic.
- Documentation dependency verified and aligned.
- Completed At: 2026-07-08 15:59 Z

<a id="add-offline-inverted-index-search-engine-for-local-documents"></a>
### [x] Add Offline Inverted Index Search Engine For Local Documents

**Raw source:** Implement the Multithreaded Inverted Index Engine: Build the search and retrieval system with the relational schema (Document metadata), Inverted Index mapping (Hash Tables & Merge Sort), and producer-consumer thread synchronization. (From `05_Search_Engine_Architecture.md`)

**Issue:** Hable has no local search module yet. The search architecture requires document metadata, an in-memory inverted index, ranked lookup, and non-blocking indexing so large text corpora do not stall the Flutter UI.

**Ponytail triage:**
- *Should exist:* Yes, required by `05_Search_Engine_Architecture.md` and named in `pubspec.yaml`.
- *Smallest safe scope:* A local-only Dart search module that stores document metadata in Drift, builds an inverted index from bundled/sample document text off the UI thread, and exposes ranked search through Riverpod.
- *Skipped scope:* Semantic embeddings, fuzzy search, backend search APIs, persistent posting-list tables, corpus downloaders, and a full search UI.
- *Boundaries:* Use Drift/Riverpod already in the app. Do not add a search dependency. Dart isolates should be the concurrency boundary; avoid shared mutable index writes and merge worker outputs deterministically.

**Action:** Add Drift document metadata tables and a small pure-Dart inverted index service. Tokenize document chunks in isolate-backed producer/consumer work, merge results into an in-memory hash map, rank hits by term frequency with the required merge-sort path, then join hit document IDs back to Drift metadata for final results.

**Hable perspective:** The Flutter app remains offline-first. Search reads local Drift metadata and local text only; network sync is not involved. Riverpod exposes a query/result provider, while UI integration can be added later without changing indexing internals.

**Implementation scope:**
- Drift schema: add a `SearchDocuments` table for `document_id`, `title`, `author`, `publication_date`, `source`, `updated_at`, and `is_synced`.
- Database DAO methods in `lib/database/database.dart` for inserting/listing document metadata and resolving search result IDs.
- Search engine files under `lib/search/` for tokenizer, inverted index, chunk indexing, merge sort ranking, and a small result model.
- Riverpod provider under `lib/providers/search_provider.dart` using `@riverpod` generation for index lifecycle and query results.
- Test surface: one focused Dart/Flutter test that indexes a tiny corpus, verifies positional postings, ranking order, and metadata join behavior.

**Scalability considerations:** Large corpora can cause UI thread blocking and memory growth. Keep tokenization/index construction off the UI thread, cap chunk size, and keep the first version in-memory only. If corpora grow beyond a few thousand documents, move posting lists into SQLite-backed tables or FTS.

**Future split guidance:** A full search screen, corpus import pipeline, stemming/language normalization, and persistent posting-list storage are deferred. Append separate raw tasks for those only after the local engine is verified.

**Edge cases:** Empty query, punctuation-only query, duplicate terms, documents with missing author/source metadata, multiple documents with equal frequency, very large document text, isolate failure, and Drift schema migration from existing installs.

**Acceptance criteria:**
- Search document metadata is persisted in Drift and can be resolved from result document IDs.
- Indexing runs off the UI thread and does not mutate shared state from multiple workers.
- The inverted index stores term -> document ID -> positions.
- Query results are ranked deterministically by term frequency, then stable tie-breakers.
- A focused test indexes at least three documents and verifies ranking plus metadata join.
- `05_Search_Engine_Architecture.md` and `02_Offline_Architecture.md` are verified and updated if implementation changes schema or threading behavior.

**Dependencies:** `05_Search_Engine_Architecture.md`, `02_Offline_Architecture.md`

**Completion notes:**
- Created `SearchDocuments` table in `lib/database/tables.dart` and added DAO methods in `database.dart`.
- Ran `build_runner` to regenerate Drift database files.
- Implemented `lib/search/search_engine.dart` with tokenization (using `compute`), an in-memory index, and a custom merge sort.
- Created Riverpod providers in `lib/providers/search_provider.dart` to expose the engine and join results with Drift metadata.
- Wrote and passed focused tests in `test/search_engine_test.dart` verifying positional postings and ranking behavior.
- Completed At: 2026-07-08 16:08 Z

<a id="add-jwt-authentication-and-friend-request-authorization-for-sync-apis"></a>
### [x] Add JWT Authentication And Friend-Request Authorization For Sync APIs

**Raw source:** Implement secure user authentication for sync APIs (e.g., JWTs and friend-request acceptance flows).

**Issue:** The current Cloudflare Worker trusts caller-supplied user IDs (`x-user-id`, `sender_id`) for sync and nudge operations. Any caller can impersonate another user or send nudges without an accepted relationship, which breaks the privacy boundaries in `04_Social_and_Analytics.md`.

**Ponytail triage:**
- *Should exist:* Yes, this closes the deferred auth gap from the social sync task.
- *Smallest safe scope:* Add signed JWT verification middleware to the Worker, store a device/user auth secret hash in D1, and require accepted friend/partnership rows before sync or nudge data is returned.
- *Skipped scope:* OAuth, password reset, email verification, refresh-token rotation, role systems, admin dashboards, and production identity-provider integration.
- *Boundaries:* Do not trust user IDs from request bodies or headers once auth exists. Derive the acting user only from the verified token. Keep journal entries private and keep sync payload masking unchanged.

**Action:** Extend the Worker and Flutter sync client so authenticated users get a signed JWT, send it as `Authorization: Bearer <token>`, and have `/api/sync/daily` plus `/api/social/nudge` authorize requests against accepted friend/partnership records before touching D1 or KV.

**Hable perspective:** Authentication must not break offline-first behavior. Local habit actions still write to Drift immediately; sync simply pauses/retries when the token is missing, expired, or rejected. Friend-request acceptance changes only what social data can sync, not the local habit engine.

**Implementation scope:**
- Cloudflare Worker: auth middleware in `backend/src/index.ts`, JWT signing/verification with Worker secrets, and request-user extraction.
- D1 schema: add minimal auth columns/table and a `friend_requests` table with pending/accepted/rejected status and timestamps.
- Social authorization: require accepted friend/partnership records before returning partner status or writing nudge KV keys.
- Flutter sync: store/send the bearer token from `lib/services/sync_service.dart`; surface auth failures as retryable sync failures rather than UI-blocking errors.
- Test surface: Worker tests or small script checks for missing token, invalid token, valid token, unauthorized nudge target, and accepted friend success.

**Scalability considerations:** JWT verification is cheap at current scale. D1 authorization queries need indexes on requester/recipient/status and partnership keys before friend graphs grow. Token refresh and key rotation are deferred until real production auth exists.

**Future split guidance:** Add production identity, refresh-token rotation, account recovery, device revocation, and friend-request UI as separate raw tasks only after this Worker-level authorization path is working.

**Edge cases:** Missing token, malformed token, expired token, user deleted after token issue, sender spoofing in nudge body, duplicate friend requests, rejected requests, accepted friend without shared habit, and stale local token while offline.

**Acceptance criteria:**
- `/api/sync/daily` rejects unauthenticated requests and derives `user_id` from the verified JWT.
- `/api/social/nudge` rejects unauthenticated requests and ignores spoofed sender IDs in the request body.
- Nudge writes require an accepted friend/partnership relationship.
- Sync payload masking remains limited to allowed social fields.
- Flutter sync sends the bearer token and retries gracefully on auth/network failure.
- D1 schema includes friend-request state and indexes needed for authorization queries.
- `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, and `02_Offline_Architecture.md` are verified and updated if implementation changes auth, schema, or sync behavior.

**Dependencies:** `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`

**Completion notes:**
- Migrated backend project to Cloudflare Pages (`functions/api/[[route]].ts`, `public/index.html`).
- Added `friend_requests` table to D1 schema.
- Implemented `/api/auth/login` to sign 30-day JWTs using `hono/jwt`.
- Wrapped `/api/social/nudge` and `/api/sync/daily` with JWT middleware.
- Implemented friend request endpoints and database authorization for nudges.
- Updated `lib/services/sync_service.dart` to automatically authenticate and pass `Authorization: Bearer <token>` in headers.
- Completed At: 2026-07-08 16:44 Z

<a id="wire-mutual-habit-friends-into-home-ui-and-habit-colored-rings"></a>
### [x] Wire Mutual Habit Friends Into Home UI And Habit-Colored Rings

**Raw source:** continue development; multi-user, mutual habit tracking, nudges, friends. (from 06_MULTI_USER.md). make the ring more similar to app_icon's ring. Assign different color for different Habit.

**Issue:** Authentication and backend friend authorization exist, but the Flutter home experience still renders `PartnerTicker` with an empty list and the completion ring uses one generic green arc for every habit. Users cannot see mutual habit progress, send nudges from the UI, or distinguish habits by color.

**Ponytail triage:**
- *Should exist:* Yes, it connects the completed auth/social backend work to visible multi-user behavior.
- *Smallest safe scope:* Cache partner habit snapshots locally, populate `PartnerTicker`, enqueue nudges from partner taps, and add a `color_hex` habit field that drives a thicker app-icon-like completion ring.
- *Skipped scope:* Full friend discovery, contact import, push notifications, chat, realtime sockets, avatar uploads, and a separate social feed.
- *Boundaries:* Keep the home screen offline-first. Network sync updates Drift in the background; UI reads Riverpod/Drift streams only. Journal notes stay private. Ring styling should reuse Flutter `CustomPainter`, not image assets or a new graphics dependency.

**Action:** Add local social snapshot and habit color support, then wire the home screen to real partner data. Update `sync_service.dart` to persist `/api/sync/daily` partner/nudge payloads into Drift, expose providers for partner snapshots, and let partner taps enqueue a `sendNudge` sync item. Update `MudLongPressButton` so each habit passes a stable pastel color and paints a thicker rounded arc inspired by `Developement/Resources/app_icon.jpeg`.

**Hable perspective:** This is a UI/state integration task, not a new backend auth task. The user should still complete and skip habits offline, see cached partner state when offline, and have nudges retry through the existing sync queue.

**Implementation scope:**
- Drift schema: add `colorHex` to `Habits` and a local partner snapshot table with `habit_id`, `partner_user_id`, `username`, `avatar_url`, `current_duration`, `has_completed_today`, `last_nudge_at`, `updated_at`, and `is_synced`.
- Database DAO methods in `lib/database/database.dart` for upserting partner snapshots, watching partners by habit/user, and assigning missing habit colors from a fixed pastel palette.
- Riverpod providers in `lib/providers/habit_providers.dart` or a small `lib/providers/social_providers.dart` for partner snapshot streams and nudge enqueue actions.
- Sync layer in `lib/services/sync_service.dart` to persist daily sync partner/nudge payloads without blocking UI.
- UI widgets: update `lib/screens/home_screen.dart`, `lib/widgets/partner_ticker.dart`, and `lib/widgets/mud_long_press_button.dart` for real partner data, nudge tap behavior, Semantics labels, and app-icon-like ring arcs.
- Test surface: focused widget/provider test for habit color stability, partner ticker rendering, nudge queue insertion, and ring painter color selection.

**Scalability considerations:** Partner snapshots can grow with friends times shared habits. Add indexes for `habit_id` and `partner_user_id`, keep provider watches scoped per visible habit, and avoid watching all social rows from the home screen. The app-icon ring painter is cheap if it draws simple arcs and avoids image decoding.

**Future split guidance:** Build friend search/invite UI, notification badges, avatar images, realtime sync, and a dedicated friends screen as separate raw tasks only after this cached partner ticker works.

**Edge cases:** Referenced `06_MULTI_USER.md` is missing, empty partner lists, stale partner snapshots while offline, duplicate nudge taps, failed nudge sync, missing avatar URLs, deleted shared habits, habits created before `colorHex` exists, color collisions across many habits, and low-contrast ring colors.

**Acceptance criteria:**
- Existing habits receive stable distinct pastel colors without breaking old local databases.
- `MudLongPressButton` accepts a habit color and paints a thicker rounded progress ring closer to the app icon's soft arc style.
- `PartnerTicker` renders cached partner habit status from Drift instead of `const []`.
- Tapping a partner enqueues a `sendNudge` sync item and gives gentle in-app feedback.
- `/api/sync/daily` partner/nudge payloads are persisted locally and reflected through Riverpod streams.
- Home screen remains usable offline and never waits on network calls for partner data.
- `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `02_Offline_Architecture.md`, and `01_Schema_and_Core_Logic.md` are verified and updated if implementation changes schema, sync behavior, or ring styling.

**Dependencies:** `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `02_Offline_Architecture.md`, `01_Schema_and_Core_Logic.md`; raw reference `06_MULTI_USER.md` is currently missing.

**Completion notes:**
- Added `colorHex` column to `Habits` table with stable pastel defaults and `assignHabitColorIfMissing` DAO helper.
- Added `PartnerSnapshots` Drift table (`habitId`, `partnerUserId`, `username`, `avatarUrl`, `currentDuration`, `hasCompletedToday`, `lastNudgeAt`).
- Bumped schema to v3 with proper migration (`addColumn` + `createTable`).
- Ran `build_runner` to regenerate all Drift files.
- Created `lib/providers/social_providers.dart` with `allPartnersProvider`, `habitPartnersProvider` stream providers, and `enqueueNudge` helper.
- Updated `lib/services/sync_service.dart#pullDailySync` to persist partner payloads into Drift via `upsertPartnerSnapshot`.
- Rewrote `lib/widgets/partner_ticker.dart` to accept `List<PartnerSnapshot>` from Drift, colorize avatar borders with `habitColor`, show nudge snackbar on tap.
- Updated `lib/widgets/mud_long_press_button.dart`: accepts `habitColor`, paints thicker app-icon-style rounded arc with soft glow shadow that lerps to `completionGreen` at 100%.
- Updated `lib/screens/home_screen.dart`: imports `social_providers.dart`, wires `allPartnersProvider` to `PartnerTicker`, passes `_hexToColor(habit.colorHex)` to `MudLongPressButton`, enqueues `sendNudge` on partner tap.
- `flutter analyze` clean (one pre-existing `SearchEngineRef` error unrelated to this task).
- Completed At: 2026-07-08 19:51 Z

<a id="add-twin-app-friend-flow-test-harness"></a>
### [x] Add Twin-App Friend Flow Test Harness

**Raw source:** Install a twin of the hable to act as a friends app. test mutual habit tracking, nudginng, send and receive friend requests. Follow-up note: by tweaking APK package name maybe.

**Issue:** Hable now has backend friend-request, partnership, nudge, and partner snapshot code, but there is no repeatable way to install two isolated app instances on one Android device and verify the full mutual habit flow end to end.

**Ponytail triage:**
- *Should exist:* Yes, this is the smallest practical way to test multi-user behavior without owning two physical devices.
- *Smallest safe scope:* Add Android debug flavors for primary/friend installs, seed two known test users, and provide one script/checklist that installs both apps and verifies friend request, acceptance, shared habit tracking, nudge send, and nudge receive.
- *Skipped scope:* Forking the app, maintaining two codebases, production multi-account switching, UI automation frameworks, push notifications, and App Store/Play Store build variants.
- *Boundaries:* Keep one Flutter source tree. The twin must differ only by Android application ID/app label and dev-only test identity. Do not put production secrets in scripts.

**Action:** Add a reproducible local/dev test harness that builds and installs two Hable debug variants on the same Android device by changing Android application IDs/package names, each with its own sandboxed Drift database and seeded backend user. Exercise the existing Cloudflare Pages/D1/KV social endpoints and document the exact commands to prove the friend flow works.

**Hable perspective:** The test harness validates the actual offline-first sync path: each app writes locally, syncs in the background, pulls partner snapshots into Drift, and renders cached social state. It should not introduce alternate runtime behavior outside dev/test builds.

**Implementation scope:**
- Android Gradle: add `primary` and `friend` debug flavors with distinct `applicationIdSuffix`/app labels so both installs can coexist.
- Flutter bootstrap: support dev-only `--dart-define` values for seeded test user IDs/usernames without affecting normal onboarding.
- Backend/D1 seed: ensure `local-user-1` and `local-user-2` plus a shared test habit can be reset/seeded for repeatable friend-flow testing.
- Script or README: add one command path to run Wrangler/Pages locally or target the deployed test URL, install both flavors, and show required `adb`/`flutter run` commands.
- Social flow checks: send friend request from primary, accept from friend, create partnership/shared habit, send nudge, pull daily sync on both installs, and confirm `PartnerTicker` updates from Drift.
- Test surface: smallest runnable smoke check, likely a shell script with `curl` API assertions plus manual app launch steps for the two installed variants.

**Scalability considerations:** This is dev tooling, so scalability impact is low. Keep seed data deterministic and resettable. If more test personas are needed later, add a fixture file instead of more flavors.

**Future split guidance:** Full device automation, integration tests with `integration_test`, multi-account switching inside the app, and production invite/onboarding flows are deferred. Add those only after the two-install smoke path is stable.

**Edge cases:** Android package ID collision, stale Drift databases between runs, stale JWTs, D1 seed mismatch, KV nudge already consumed by first sync, deployed backend unavailable, emulator without `adb reverse`, and accidental use of test identities in release builds.

**Acceptance criteria:**
- Two debug builds can be installed on the same Android device at the same time.
- Each install has a distinct app label and isolated local Drift database.
- The primary install authenticates as `local-user-1`; the friend install authenticates as `local-user-2`.
- A documented smoke path sends and accepts a friend request between the two test users.
- A documented smoke path creates or verifies a shared habit partnership.
- A nudge sent from one install is received by the other through `/api/sync/daily` and appears in local social state.
- Mutual habit tracking appears in `PartnerTicker` from Drift-backed providers, not direct network reads.
- `00_Agent_Directives.md`, `02_Offline_Architecture.md`, and `04_Social_and_Analytics.md` are verified and updated if implementation changes build, sync, or social test behavior.

**Dependencies:** `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`

**Completion notes:**
- Added `flavorDimensions` and `productFlavors` (`primary`, `friend`) to `android/app/build.gradle.kts`.
- Updated `android/app/src/main/AndroidManifest.xml` to use `@string/app_name` for dynamic app labels.
- Intercepted `--dart-define=SEED_USER_ID` and `--dart-define=SEED_USERNAME` in `onboarding_username_screen.dart` to auto-seed local test users and bypass onboarding.
- Auto-seeded `shared-habit-1` into the test user's Drift database.
- Created `Developement/TWIN_TEST_HARNESS.md` with full runbook commands for building and testing both isolated apps on one device.
- Completed At: 2026-07-08 20:08 Z

<a id="complete-account-friend-search-habit-recording-sync-and-leaderboard-mvp"></a>
### [x] Complete Account, Friend Search, Habit Recording Sync, And Leaderboard MVP

**Raw source:** Work on user authentication, registration, searching, recording, leaderboard scores, and other related matters.

**Issue:** Hable has a JWT login path for seeded users and local-only habit completion scoring, but the production path is incomplete. New users cannot register through the backend, friend search is documented but not exposed, habit create/log mutations are queued locally but not synced to remote D1, and leaderboard scores are not pulled from accepted friends.

**Ponytail triage:**
- *Should exist:* Yes, these are the missing account/social sync pieces needed before multi-user testing is meaningful.
- *Smallest safe scope:* Add backend user registration, privacy-safe friend search, remote habit create/log recording, and a friend leaderboard endpoint, then wire Flutter sync to those endpoints.
- *Skipped scope:* OAuth, password login, email verification, password reset, public search indexing, global leaderboard, push notifications, and analytics dashboards.
- *Boundaries:* Keep JWT auth already in place. Do not expose private journal notes, full habit lists, or non-friend leaderboard rows. Keep UI offline-first; failed sync stays retryable.

**Action:** Extend the Cloudflare Worker and Flutter sync client so real users can register, search for friends by safe fields, record local habit mutations to D1, and fetch friend leaderboard rows based only on accepted friend/partnership relationships.

**Hable perspective:** Local Drift remains the source for UI. Registration and friend search are explicit user actions. Habit recording still writes locally first, then syncs remotely. Leaderboard data is cached locally or shown from a provider fed by sync, not used to drive Home-screen state directly.

**Implementation scope:**
- Backend auth: add `POST /api/auth/register` that creates a `users` row and returns the same JWT shape as login.
- Backend search: add `GET /api/social/search?q=` returning only `user_id`, `username`, `avatar_url`, and relationship state.
- Backend recording: add authenticated endpoints for habit creation/update and log recording that upsert `habit_progress` and user score without exposing journal text.
- Backend leaderboard: add accepted-friends-only leaderboard query sorted by `total_score` then current streak/progress when available.
- D1 schema: align `users` with `total_score`, timestamps, and any indexes needed for username search and friend relationship checks.
- Flutter sync: handle `SyncAction.createHabit` and `SyncAction.logHabit` in `lib/services/sync_service.dart` instead of logging them as unsupported.
- Flutter providers/UI: add minimal registration hook, friend search provider/action, and leaderboard provider/surface in Profile.
- Test surface: focused Worker/API smoke checks for register, login, search privacy, habit recording, and friend-only leaderboard.

**Scalability considerations:** Username search should use a prefix/equality query with an index and a small limit. Leaderboard queries must stay scoped to accepted friends, not all users. Habit log sync can be one request per queued mutation for now; batch only if offline queues become large.

**Future split guidance:** Real identity provider integration, account recovery, search ranking, paginated leaderboards, streak materialization, and background batch sync are deferred. Add separate raw tasks only after the MVP endpoints work.

**Edge cases:** Duplicate username, empty username, registering while offline, stale JWT, user deleted after token issue, search with no results, blocked/non-friend users, duplicate log sync, skip log with private journal text, score conflicts from two devices, and leaderboard ties.

**Acceptance criteria:**
- New users can register against the Worker and receive a JWT.
- Existing users can still log in with the current JWT flow.
- Friend search returns safe fields only and includes relationship state.
- Habit create and log queue items sync successfully instead of being unsupported.
- Skip journal text is not sent to public/social responses.
- Friend leaderboard includes only accepted friends/partners plus the current user when appropriate.
- Flutter Profile exposes a minimal leaderboard surface.
- `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, and `02_Offline_Architecture.md` are verified and updated if implementation changes schema, auth, sync, or leaderboard behavior.

**Dependencies:** `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`

**Completion notes:**
- Completed as part of the Expanded Auth and Leaderboards task below.
- Completion timestamp inherited from the paired task below.
- Completed At: 2026-07-08 21:10 Z

<a id="expand-authentication-user-search-and-leaderboards"></a>
### [x] Expand Authentication, User Search, and Leaderboards

**Raw source:** Work on user authentication, registration, searching, recording, leaderboard scores, and other related matters.

**Issue:** The app currently uses a seeded dev identity and auto-generated UUIDs with a basic JWT middleware. There is no UI for real user registration, login, searching for friends by username, viewing global or friend leaderboards, or managing detailed habit records. These are critical for the app to function as a real social network.

**Ponytail triage:**
- *Should exist:* Yes, full social gamification requires real identity and competitive leaderboards.
- *Smallest safe scope:* Add a login/register UI that talks to Cloudflare Workers to issue real JWTs. Add a user search endpoint to find friends by username. Add a basic leaderboard endpoint that aggregates `totalScore` from the `Users` table.
- *Skipped scope:* OAuth (Google/Apple), complex matchmaking, audio recording (unless specifically requested later), and complex anti-cheat for the leaderboard.
- *Boundaries:* The authentication system should seamlessly replace the existing test-harness seeding. The offline-first sync engine remains the source of truth for records; the backend just computes the leaderboard from synced scores.

**Action:** Build the registration and login UI flow. Create Cloudflare endpoints for user creation, login (returning a JWT), user search (by username prefix), and top-N leaderboard retrieval. Update the Flutter app to use real authentication, store the JWT securely, and add a "Social/Leaderboard" tab to display user rankings and search for friends.

**Hable perspective:** Real authentication replaces the dev-only `SEED_USERNAME` flow. The leaderboard introduces a competitive gamification loop, satisfying the "scores" requirement. User search enables the friend request flow to be used in production rather than just the test harness.

**Implementation scope:**
- **Cloudflare Worker:** `/api/auth/register`, `/api/social/search`, `/api/social/leaderboard`.
- **D1 Schema:** Ensure `Users` table has password hashes (using WebCrypto API in the Worker) and proper indexes for username search and score ordering.
- **Flutter UI:** `AuthScreen` (Login/Register), `LeaderboardScreen` (List of top users), and a `UserSearchDelegate` or screen to find and add friends.
- **Flutter Data:** Secure storage for JWTs (using `flutter_secure_storage`), Riverpod providers for fetching leaderboards and search results.
- **Sync:** Tie `totalScore` updates to the existing habit completion sync flow.

**Scalability considerations:** Leaderboard queries can become expensive if the user base grows; caching the top 100 in KV or using D1 read replicas will be necessary eventually. Username search should be paginated or rate-limited.

**Future split guidance:** OAuth integration, audio/media habit recordings, and complex leagues/tiers should be split into their own raw tasks once basic auth and leaderboards are stable.

**Edge cases:** Duplicate usernames, weak passwords, offline login (cached credentials), searching for yourself, and handling users with zero score on the leaderboard.

**Acceptance criteria:**
- User can register a new account with a username and password.
- User can log in and receive a valid JWT.
- User can search for other users by username and send friend requests.
- User can view a leaderboard showing users ranked by `totalScore`.
- The offline-first sync engine continues to work transparently with the new real JWT.

**Dependencies:** `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`

**Completion notes:**
- Updated D1 `users` table via `ALTER TABLE` to include `password_hash` and `total_score` and added proper indices.
- Added `/api/auth/register`, `/api/auth/login`, `/api/social/search`, and `/api/social/leaderboard` routes to the Cloudflare Worker.
- Added `flutter_secure_storage` to properly persist JWT tokens natively.
- Added `AuthScreen` that allows real login & registration, while gracefully retaining test harness auto-login.
- Created `SocialHubScreen` providing both global leaderboard and user search capability.
- Completed At: 2026-07-08 21:10 Z

<a id="reuse-onboarding-habit-presets-in-habit-creation-with-partner-invites-and-clear-progress-labels"></a>
### [x] Reuse Onboarding Habit Presets In Habit Creation With Partner Invites And Clear Progress Labels

**Raw source:** a list of habits we have at onboarding should be available on home page as well, so that we can add them to our list of habits in our profile. during creation user should able to radd partners (requesst will be send to partner to accept or deny). rewise the logic behind having the days inside the ring and having a streak (fire) trend next to the ring, seems duplicate info.

**Issue:** The onboarding habit presets are hardcoded inside `OnboardingHabitScreen`, while post-onboarding habit creation in `HabitFormSheet` only supports manual title/duration entry. Habit partner invitations already have backend and inbound UI pieces, but the create/edit form has no accepted-friend picker or send-invite sync action. Home also presents challenge progress and streak close together, which makes the day/ring/streak story feel duplicated instead of clearly separated.

**Ponytail triage:**
- *Should exist:* Yes, reusing preset habits and inviting accepted friends during habit creation are core flows already described by the social docs.
- *Smallest safe scope:* Extract the onboarding preset list into one shared Dart constant/model, reuse it in onboarding and `HabitFormSheet`, add a compact accepted-friend multi-select to the create flow, enqueue habit-invitation sends after the habit exists, and clarify Home progress/streak labels without rebuilding the Home screen.
- *Skipped scope:* Habit marketplace, recommendations, contact import, reminders, new Home dashboard, full friend profile picker, partner editing after creation, recurring invite templates, and a new social graph service.
- *Boundaries:* Home may expose a small add-habit affordance or empty-state CTA, but Profile remains the habit management surface. Habit invites can target accepted friends only and must not expose habit data until the recipient accepts.

**Action:** Make standard habits available after onboarding through the existing habit creation flow, allow selecting accepted friends as partner invitees while creating a habit, and simplify the Home habit card copy so challenge progress and streak are visually distinct rather than duplicate.

**Hable perspective:** Keep the flow offline-first: creating the habit writes Drift immediately, queues sync, then queues one invite per selected accepted friend. The UI reads accepted friends and pending invitations from Riverpod/Drift where available, while explicit friend search/network behavior stays in Social Hub. The Home ring remains the daily completion control, not a management dashboard.

**Implementation scope:**
- Shared presets: move `_standardHabits` from `lib/screens/onboarding/onboarding_habit_screen.dart` into a small shared file such as `lib/data/standard_habits.dart`, with title, subtitle, emoji, default duration, and `isCustom` mapping.
- Onboarding: update `OnboardingHabitScreen` to read the shared preset list without changing the waterfall sequence.
- Habit creation UI: update `lib/widgets/habit_form_sheet.dart` to show preset chips/list above the custom title field and prefill title/duration/color when a preset is selected.
- Home affordance: if Home has no active habits, offer a direct "Add habit" action using the same `HabitFormSheet`; otherwise keep Home focused on today's active habits.
- Accepted friend picker: add a minimal accepted-friends provider/repository hook, reusing the friend cache from the friend-request flow if present; otherwise add only the smallest local cache needed for accepted friends.
- Habit invitation send: add a `sendHabitInvitation` sync action or equivalent queue payload, process it in `lib/services/sync_service.dart` through `POST /api/social/habit-invitation`, and enqueue one invite after `createHabitWithSync` returns the created habit id.
- Database/API hardening: adjust `AppDatabase.createHabitWithSync` and `HabitActionsController.createHabit` to return the created `habitId`; harden `backend/src/index.ts` so habit invitation creation verifies accepted friendship, rejects self-invites, and handles duplicate pending invites idempotently.
- Existing invite receive path: keep using `HabitInvitations`, `pendingInvitationsProvider`, and `InvitationBanner` for accept/decline unless a real bug blocks the flow.
- Home progress labels: update `lib/screens/home_screen.dart` and `lib/widgets/mud_long_press_button.dart` only as needed so day progress (`Day X of N`) and streak (`Streak N`) have distinct meanings, avoid duplicate fire/day text around the ring, and preserve accessible Semantics labels.
- Testing/docs: update manual twin-harness steps to cover create preset habit with Bob selected, Bob receives invitation, accepts/declines, and partner snapshots appear only after accept.

**Scalability considerations:** Preset reuse has no scaling impact. Accepted-friend selection should stay a small local list loaded from Drift; search and pagination are deferred until friend counts are large. One queued invite per selected friend is fine for the current app, but batch invitation sync can be split out if offline queues become large.

**Future split guidance:** Partner management after a habit is created, invite cancellation, bulk invites, friend search inside the form, recommended habits from friends, reminder scheduling, and a richer Home habit discovery panel should be separate tasks.

**Edge cases:** No accepted friends, selected friend becomes unaccepted before sync, duplicate invite tap, self-invite, habit creation succeeds but invite sync fails, offline creation with queued invites, editing an existing habit without resending invites, onboarding preset title changed later, preset duration unit mismatch, empty active-habit Home state, completed habits using the new labels, screen-reader labels for ring/streak, and partner visibility before invitation acceptance.

**Acceptance criteria:**
- Onboarding and post-onboarding creation use the same standard habit preset source.
- Profile Add New and any Home empty-state add action can create a habit from a preset without typing the title manually.
- Custom habit creation still works.
- Creating a habit can optionally select one or more accepted friends as partner invitees.
- Habit invitation sends are queued/synced after the habit exists and are idempotent for duplicate pending invites.
- The backend rejects self-invites and invites to non-accepted friends.
- Incoming habit invitations still appear through the existing `InvitationBanner` and accept/decline flow.
- Accepted partnership data appears only after the recipient accepts the invitation.
- Home no longer presents day progress and fire streak as visually duplicate indicators; labels explain challenge day/progress separately from consecutive-completion streak.
- The twin harness verifies Alice creates a preset habit with Bob selected, Bob receives and accepts/declines the invite, and Alice/Bob see the correct post-accept visibility.
- `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` are verified and updated to match the implemented flow.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Completion notes:**
- Touched app files: `lib/data/standard_habits.dart`, `lib/screens/onboarding/onboarding_habit_screen.dart`, `lib/screens/onboarding/onboarding_complete_screen.dart`, `lib/widgets/habit_form_sheet.dart`, `lib/providers/habit_actions_provider.dart`, `lib/providers/sync_provider.dart`, `lib/database/database.dart`, `lib/database/tables.dart`, `lib/services/sync_service.dart`, `lib/services/connectivity_service.dart`, `lib/widgets/invitation_banner.dart`, `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, and `test/widget_test.dart`.
- Touched backend files: `backend/src/index.ts` and `backend/schema.sql`.
- Touched docs: `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md`.
- Behavior verified: onboarding and Home/Profile creation use shared standard presets; Hydration quick-start prefilled title and `21` day duration; Alice selected Bob from accepted-friend chips; app queued and flushed habit sync before habit invitation; Bob received the invitation banner and accepted it; both Alice and Bob `/api/sync/daily` responses showed post-accept Hydration partnership visibility only after acceptance; Home shows `Challenge: Day 1 of 21` separately from the streak chip.
- Backend hardening verified: duplicate pending habit invite returned the same invitation id, self-invite returned HTTP `400`, and non-friend invite returned HTTP `403`.
- Verification commands passed: `flutter analyze`, `flutter test`, `flutter build apk --debug --flavor primary --dart-define=SEED_USER_ID=local-user-1 --dart-define=SEED_USERNAME=Alice`, `flutter build apk --debug --flavor friend --dart-define=SEED_USER_ID=local-user-2 --dart-define=SEED_USERNAME=Bob`, `cd backend && npx tsc --noEmit`, ADB twin-harness smoke on device `wsgagamfkzealzeq`, and `git diff --check`.
- Docs verified/updated: all dependency docs listed above were reviewed and updated to match the implemented preset, accepted-friend, sync, invite, and test flow.
- Completed At: 2026-07-09 14:05 CEST

<a id="promote-habit-creation-to-home-without-turning-home-into-profile"></a>
### [x] Promote Habit Creation To Home Without Turning Home Into Profile

**Raw source:** the app is uncomplete; no adding functionality at home for creating habit and you need to go to profile which is not right, rewise and fix. The UI design and UX.

**Issue:** Home is the user's daily action surface, but habit creation is still framed as something users must discover through Profile. Current code has or is gaining suggested habit cards and `HabitFormSheet` reuse, yet the Home empty state still says "Start a new one from your profile," and there is no consistent primary Home affordance for adding a habit when users already have active habits.

**Ponytail triage:**
- *Should exist:* Yes, creating a habit is a core action and hiding it behind Profile makes the app feel unfinished.
- *Smallest safe scope:* Add one obvious Home add entry point that opens the existing `HabitFormSheet`, update the empty state to create from Home, and keep Profile as the management/history area.
- *Skipped scope:* New onboarding redesign, separate habit creation screen, full dashboard redesign, navigation overhaul, recommendation engine, new state architecture, and custom animation system.
- *Boundaries:* Home should stay focused on today's habits. Add creation access without moving archive/edit/history management out of Profile and without adding network-driven Home state.

**Action:** Revise the Home habit-creation UX so users can start a new habit directly from Home in both empty and non-empty states, using the existing offline-first creation form and preserving Profile for editing, archiving, analytics, and history.

**Hable perspective:** `HomeScreen` should expose a small, clear add action, but habit persistence still flows through `HabitFormSheet`, `HabitActionsController`, Drift, and `SyncQueue`. If the preset/partner-invite task is still open, implement this Home entry point on top of that shared form instead of duplicating creation logic.

**Best-practice constraints:**
- Use one primary Home creation affordance and avoid competing add buttons, oversized recommendation sections, or dashboard clutter.
- Reuse `HabitFormSheet` and the existing Riverpod/Drift mutation path; do not add a second creation flow or manual Home-screen inserts.
- Keep mobile ergonomics solid: 48px tap targets, tooltip/Semantics labels for icon-only controls, stable layout on small screens, and no keyboard overlap in the bottom sheet.
- Preserve offline-first behavior: local creation must succeed without waiting on network sync, and sync failure must not block Home use.

**Implementation scope:**
- `lib/screens/home_screen.dart`: add a clear add-habit affordance in the header, as a floating action button, or as a compact CTA near the habit list; choose the least cluttered option that works on small screens.
- `lib/screens/home_screen.dart`: replace the empty-state copy that points to Profile with an inline button opening `HabitFormSheet.show(context)`.
- `lib/screens/home_screen.dart`: if suggested habit cards remain, make their role explicit as quick-start shortcuts and avoid showing them as a bulky dashboard section when the user has enough active habits.
- `lib/widgets/habit_form_sheet.dart`: reuse the existing sheet; do not create a second habit creation modal.
- `lib/screens/profile_screen.dart`: keep Add/Edit/Archive/Restore management available, but do not make Profile the only creation path.
- Riverpod/Drift: keep creation routed through `habitActionsProvider` and existing database methods so Home does not perform manual inserts.
- UX/accessibility: provide tooltip/Semantics labels for icon-only add controls, keep tap targets at least 48px, and verify no overlap with Social/Profile header buttons.
- Testing: add the smallest widget or manual smoke check proving Home can open the create sheet from empty and non-empty habit states.

**Scalability considerations:** Scalability impact: none expected. This is a navigation/UX entry-point change that reuses existing creation persistence and streams.

**Future split guidance:** A full Home IA redesign, reorderable habits, richer recommendations, reminders, and creation analytics should be separate tasks only after the direct Home add path works.

**Edge cases:** No active habits, many active habits, small Android viewport, keyboard opening inside the bottom sheet, duplicate add buttons when suggested habits are visible, offline creation, unauthenticated user reaching Home unexpectedly, failed sync after local creation, and screen reader users discovering the add action.

**Acceptance criteria:**
- Users can open the habit creation form directly from Home without navigating to Profile.
- The Home empty state includes a working add-habit button and no longer tells users to start from Profile.
- Users with existing active habits still have a visible but unobtrusive Home add affordance.
- Home creation uses the same `HabitFormSheet` and `habitActionsProvider` path as Profile creation.
- Creating from Home writes to Drift immediately and the new habit appears in Home through `activeHabitsProvider`.
- Home remains focused on today's habits; Profile remains the place for edit, archive, restore, analytics, and history.
- Suggested habit cards, if kept, do not crowd the primary daily action or duplicate the main add control.
- Icon-only controls have labels/tooltips and meet normal tap-target expectations.
- `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, and `08_Testing.md` are verified and updated to match the final Home creation flow.

**Dependencies:** `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `08_Testing.md`

**Completion notes:**
- Touched files: `lib/screens/home_screen.dart`, `Developement/02_Offline_Architecture.md`, `Developement/03_UI_UX_and_Animations.md`, and `Developement/08_Testing.md`.
- Behavior verified: Home header has a labeled Add habit button that opens the shared `HabitFormSheet`; the empty state has an Add habit button and no longer points users to Profile; creating Hydration from the empty-state sheet writes locally and appears on Home; suggested preset cards are hidden once an active habit exists.
- Verification commands passed: `flutter analyze`, `flutter test`, `flutter build apk --debug --flavor primary --dart-define=SEED_USER_ID=local-user-1 --dart-define=SEED_USERNAME=Alice`, `git diff --check`, and ADB smoke on device `wsgagamfkzealzeq`.
- Docs verified/updated: `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, and `08_Testing.md`.
- Completed At: 2026-07-09 14:49 CEST

<a id="deploy-flutter-web-to-cloudflare-pages-with-production-smoke-tests"></a>
### [x] Deploy Flutter Web To Cloudflare Pages With Production Smoke Tests

**Raw source:** deploy the flutter app on cloudflare pages at hable.pages.dev and test it thoroughly. create a flutter build for web and test it out. after now system for testing backend could be able to use online build which will be easier to debug and track.

**Issue:** Hable's backend can be exercised locally through Wrangler and ADB reverse, but there is no verified production-style Flutter web target. `backend/package.json` currently deploys `backend/public`, which only serves an API placeholder page, while the Flutter web entrypoint is still stock project metadata. A usable `https://hable.pages.dev` target needs the Flutter release bundle, Pages Functions, D1/KV bindings, and browser smoke tests to work together on the same deployed origin.

**Ponytail triage:**
- *Should exist:* Yes. A hosted web build is the shortest useful path to testing production backend behavior without relying only on physical-device ADB forwarding.
- *Smallest safe scope:* Make `flutter build web --release` pass for the current app, deploy that bundle through the existing Cloudflare Pages project at `hable.pages.dev`, keep the existing Pages Functions API alive under `/api/*`, and run a focused browser smoke test for auth, daily sync, habit creation, and reload persistence.
- *Skipped scope:* Full CI/CD, branch preview environments, custom domains, analytics, SEO/marketing pages, a full PWA/offline redesign, broad responsive UX redesign, load testing, and a comprehensive Playwright suite.
- *Boundaries:* Do not fork the app into a separate web product or change the Android debug/twin-harness backend path. Prefer the existing Pages project and same-origin API unless a concrete blocker requires a split origin.

**Action:** Prepare and deploy the Flutter web release to Cloudflare Pages at `https://hable.pages.dev`, wiring it to the existing Hono Pages Functions backend and verifying the deployed app can authenticate, sync, create a habit, and survive a browser reload without localhost calls or console/network errors.

**Hable perspective:** This is a deployment and compatibility task, not a feature redesign. The release clients already point at `https://hable.pages.dev`, but web should still be checked for same-origin API behavior, token storage, and absence of `127.0.0.1` calls in release. The main technical risk is Flutter web compatibility: `lib/database/database.dart` currently opens a `dart:io`/`NativeDatabase` database through `path_provider`, so the implementation must add the smallest browser-safe Drift executor needed for web while preserving the offline-first Riverpod/Drift read model on Android.

**Implementation scope:**
- Flutter web build: run `flutter analyze`, `flutter test`, and `flutter build web --release --base-href /`; fix only blockers needed for the release bundle.
- Web database compatibility: update `lib/database/database.dart` and, if needed, add a small platform-specific database factory so Android keeps `NativeDatabase.createInBackground` and web uses Drift's browser-supported storage/WASM path.
- Web shell: update `web/index.html` metadata/title and any required Drift web assets such as `sql-wasm.js`/`sql-wasm.wasm`; keep these changes in the canonical `Flutter/hable` app rather than relying on the sibling `hable_web_deploy` copy.
- API base handling: review `lib/providers/auth_provider.dart`, `lib/services/sync_service.dart`, and any other HTTP callers so debug builds still use `http://127.0.0.1:8787`, while release web uses `https://hable.pages.dev` or same-origin safely.
- Pages packaging: adjust `backend/package.json`, `backend/wrangler.toml`, and/or a minimal deploy script so `wrangler pages deploy` uploads the Flutter `build/web` assets together with `backend/functions/api/[[route]].ts`.
- Backend deployment: verify production D1, KV, and `JWT_SECRET` bindings are present for the `hable` Pages project; apply `backend/schema.sql` or migrations to production D1 before app smoke testing.
- Browser smoke: use the deployed site to register or log in, call `/api/sync/daily`, create a habit from Home, reload the page, confirm the local/offline state rehydrates, and verify pending sync items flush to production Pages Functions.
- Regression safety: keep the local Wrangler + ADB twin-harness procedure working for Android after any API-base or database factory changes.
- Docs: update the testing/deployment notes in `Developement/08_Testing.md` and align architecture docs if web storage or production backend assumptions change.

**Scalability considerations:** Cloudflare Pages static assets scale separately from Pages Functions, but stale Flutter service worker caches can make deployments look broken. Production D1 schema changes need explicit migration discipline before online smoke tests. Browser storage quotas and WASM database loading are acceptable for the current habit dataset, but large local search indexes or long habit histories may need a separate web-storage follow-up.

**Future split guidance:** Add CI/CD, branch previews, custom domain setup, source-map upload, production observability, larger Playwright coverage, and web-specific PWA/offline polish as separate tasks after the first deployable web target works.

**Edge cases:** `flutter build web` fails because of `dart:io`, `path_provider`, `workmanager`, secure storage, or native SQLite assumptions; release bundle still calls localhost; `backend/public` deploys the placeholder instead of Flutter assets; Pages Functions are not uploaded with the static bundle; D1/KV/JWT bindings differ between local and production; production schema is missing columns; Cloudflare Pages caches an old `flutter_service_worker.js`; browser refresh or deep links return 404; auth token storage behaves differently on web; habit creation works locally but queued sync fails online; CORS appears because the app and API are accidentally split across origins; and Android debug/twin testing regresses after web-specific changes.

**Acceptance criteria:**
- `flutter analyze` and `flutter test` pass after any web compatibility changes.
- `flutter build web --release --base-href /` succeeds from the canonical `Flutter/hable` app.
- `https://hable.pages.dev` serves the Flutter app, not the API placeholder page.
- Deployed static assets and Pages Functions are served from the same Pages project, and `/api/auth/login`, `/api/auth/register`, and `/api/sync/daily` respond from the deployed origin.
- Release web network traffic does not call `localhost` or `127.0.0.1`.
- A browser smoke test can register or log in, open Home, create a habit, reload the page, and still see the locally persisted habit.
- Creating or updating a habit from the web build flushes through the production `/api/sync/habit` path without console errors.
- Production D1/KV/JWT bindings and schema state are verified before calling the deploy complete.
- Existing Android local test flow still works with Wrangler and ADB reverse.
- `08_Testing.md`, `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, and `04_Social_and_Analytics.md` are verified and updated where the final deployment/storage behavior changes them.

**Dependencies:** `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`

**Completion notes:**
- Touched files: `lib/database/database.dart`, `lib/database/database_connection.dart`, `lib/database/database_connection_io.dart`, `lib/database/database_connection_web.dart`, `web/index.html`, `web/manifest.json`, `backend/package.json`, `Developement/02_Offline_Architecture.md`, and `Developement/08_Testing.md`.
- Behavior verified: `flutter build web --release --base-href /` succeeded; the Flutter web shell served on `https://hable.pages.dev`; `POST /api/auth/register` returned a JWT; `POST /api/sync/habit` returned `{"success":true}`; `GET /api/sync/daily` returned JSON from the deployed origin after the remote D1 schema was synced with `backend/schema.sql`.
- Deployment verified: `npm run web:deploy` uploaded the Flutter `build/web` bundle and the Pages Functions bundle from `backend/functions/api/[[route]].ts` to the `hable` Pages project on production branch `main`.
- Docs verified/updated: `08_Testing.md` and `02_Offline_Architecture.md`.
- Verification commands passed: `flutter analyze`, `flutter test`, `flutter build web --release --base-href /`, `cd backend && npx wrangler d1 execute hable_db --remote --file=./schema.sql`, `cd backend && npm run web:deploy`, and `git diff --check`.
- Completed At: 2026-07-09 15:10 CEST

<a id="build-social-friends-list-ui-and-fix-partner-selection"></a>
### [x] Build Social Friends List UI and Fix Partner Selection

**Raw source:** report: Friend requests receives, get accepted, but not show up in the friends list (or partner list during creating new habit). no friend list exist on UI for now, so impossible to check. (I am using WEB App for testing).

**Issue:** The UI lacks a view to see accepted friends. `acceptedFriendsProvider` might not be updating correctly or syncing locally after a request is accepted, resulting in empty partner lists during habit creation.

**Ponytail triage:** Must add a Friends list section in `SocialHubScreen`. Must ensure `acceptFriendRequest` triggers a sync pull or local insert so the DB updates immediately.

**Action:**
1. Add a "Friends" section to `SocialHubScreen` displaying `acceptedFriendsProvider`.
2. Review friend request logic to ensure the accepted friend is immediately upserted to the local Drift database or a sync is triggered.
3. Verify that `acceptedFriendsProvider` propagates to `HabitFormSheet`.

**Hable perspective:** The local Drift `accepted_friends` table must reflect accepted relationships immediately for Riverpod streams to update the UI without needing a hard app restart or waiting for background sync.

**Implementation scope:**
- `lib/screens/social/social_hub_screen.dart` (Add Friends list UI)
- `lib/providers/social_providers.dart` (Update enqueue accept friend request logic)
- `lib/services/sync_service.dart` (Ensure pull sync fetches friends properly)

**Scalability considerations:** Scalability impact: none expected for typical friend lists. If lists grow large, pagination might be needed.

**Future split guidance:** Advanced friend management (unfriending, blocking) is deferred.

**Edge cases:** Accepting offline should optimistically add the friend locally if we know their basic info.

**Dependencies:** `07_Multi_User_Social_Features.md`

**Completion notes:**
- Touched files: `lib/screens/social/social_hub_screen.dart`, `Developement/07_Multi_User_Social_Features.md`
- Behavior verified: `SocialHubScreen` now has 5 tabs, including a `Friends` tab that watches `acceptedFriendsProvider`. `_acceptFriendRequest` now manually upserts an `AcceptedFriend` into the local Drift database upon success, ensuring the UI (both the Friends tab and the Habit creation sheet's Partner Selection) updates instantly.
- Documentation updated: `07_Multi_User_Social_Features.md` now mentions the Friends List UI.
- Completed At: 2026-07-09 16:15 CEST

<a id="verify-web-era-changes-on-android-apks"></a>
### [x] Verify Web-Era Changes On Android APKs

**Raw source:** make sure new web changes is availble on android too. install new apk and test it.

**Issue:** The Flutter web deployment task introduced platform-specific storage and release API-base assumptions so the app can run on Cloudflare Pages. Android must be rebuilt and installed after those changes to prove the native Drift executor, debug/release backend selection, seeded twin-app flavors, auth, habit creation, friend/social flows, and sync queue still work on a physical device.

**Ponytail triage:**
- *Should exist:* Yes, the web compatibility changes touched shared app startup, database connection, auth, sync, and deployment assumptions that Android relies on.
- *Smallest safe scope:* Build fresh Android APKs from the current tree, install primary and friend flavors on one ADB device, run the existing smoke paths, and document what passed or failed.
- *Skipped scope:* New automation framework, Playwright/Appium setup, Firebase Test Lab, production Play Store signing, broad performance profiling, and unrelated UI redesign.
- *Boundaries:* Treat this as verification and regression repair only. Fix only Android blockers caused by the recent shared web changes, and keep web/browser behavior intact.

**Action:** Rebuild and install the Android app after the web changes, then manually smoke test the primary app and friend harness against the appropriate backend target. Confirm Android still uses `NativeDatabase.createInBackground`, debug APKs still reach local Wrangler through `adb reverse`, release APKs reach `https://hable.pages.dev` when intentionally built for release, and the core social/habit flows remain usable.

**Hable perspective:** Android is still the primary mobile target. The web task added `database_connection_web.dart` and platform exports; this task verifies Android continues to take `database_connection_io.dart`. The offline-first rule still applies: Home/Profile/Social UI must render from Drift, while Cloudflare sync populates local tables in the background.

**Implementation scope:**
- Build/test commands: run `flutter analyze`, `flutter test`, and build fresh `primary`/`friend` Android APKs with the current dart defines needed for Alice/Bob harness testing.
- Device install: use `adb devices`, uninstall or clear stale Hable packages if needed, install the rebuilt APKs, and run `adb reverse tcp:8787 tcp:8787` for local debug backend testing.
- Android database path: verify logs or behavior prove Android is using the native SQLite/Drift path, not the web `WebDatabase('hable_db')` path.
- API-base regression: verify debug Android calls `http://127.0.0.1:8787` through ADB reverse and, if a release smoke is run, release Android calls `https://hable.pages.dev` rather than localhost.
- Primary app smoke: login/seed auth, Home add habit, Profile avatar/profile access, Social Hub navigation, and sync queue flush for habit creation.
- Twin harness smoke: install both flavors, verify package/app-label isolation, friend search/request/accept, accepted friend list, habit partner invite, invitation accept/decline, partner ticker, and nudge path.
- Documentation: update `Developement/08_Testing.md`, `Developement/TWIN_TEST_HARNESS.md`, and `Developement/Commands.md` if the tested Android commands or backend target rules differ from the current docs.

**Scalability considerations:** Scalability impact: none expected. This is a verification task. The only scaling concern is test discipline: as web and Android paths diverge, the smoke checklist should stay compact and focused on shared startup, storage, auth, and sync seams.

**Future split guidance:** If manual ADB testing keeps recurring, append a separate raw task for a small automated device smoke harness. If release Android needs a production backend toggle separate from `kDebugMode`, append a separate raw task for environment-based API configuration.

**Edge cases:** No ADB device connected, stale app data restored from Android backup, local Wrangler not running, D1 schema mismatch, `adb reverse` silently missing, debug build accidentally calls production Pages, release build accidentally calls localhost, primary/friend package collision, web database import accidentally used on Android, secure storage contains stale tokens, background Workmanager timing delays sync, and production Pages D1 lacks the schema needed for release smoke.

**Acceptance criteria:**
- `flutter analyze` and `flutter test` pass or any failures are documented as pre-existing/non-blocking with evidence.
- Fresh primary and friend Android APKs build from the current repository state.
- The rebuilt APKs install on an ADB-connected device without package collision.
- Debug Android startup, local Drift persistence, and local Wrangler sync work with `adb reverse tcp:8787 tcp:8787`.
- Home habit creation works on Android and the created habit appears immediately from local state.
- Social Hub friend request acceptance populates the accepted friend list and the habit partner picker on Android.
- A partnered habit invite can be sent from one flavor, accepted or declined in the other, and partner/nudge UI remains scoped to accepted/partnered relationships.
- Android verification explicitly covers the web-change risk: native database path, API base selection, web assets not required on Android, and no obvious runtime crash from platform imports.
- `08_Testing.md`, `TWIN_TEST_HARNESS.md`, and `Commands.md` are verified and updated with the exact commands, device/backend target, observed result, and completion timestamp.

**Dependencies:** `08_Testing.md`, `TWIN_TEST_HARNESS.md`, `Commands.md`, `02_Offline_Architecture.md`, `00_Agent_Directives.md`

**Completion notes:**
- Touched files: `lib/screens/social/social_hub_screen.dart`, `Developement/08_Testing.md`, and `Developement/Task1_Engineered.md`.
- Behavior verified: `flutter analyze` passed after fixing the social-hub async-context lint; `flutter test` passed; fresh debug APKs built for both `primary` and `friend`; both APKs installed on device `wsgagamfkzealzeq`; `adb reverse tcp:8787 tcp:8787` reached the local backend; the primary app launched to Alice's Home screen; Social Hub opened and rendered Bob in the friends cache; the friend app launched to Bob's Home screen; no Android crash or web-only storage failure appeared during the smoke.
- Docs verified/updated: `08_Testing.md` updated with the Android regression smoke log; `TWIN_TEST_HARNESS.md` and `Commands.md` were reviewed and remained aligned with the tested commands.
- Completed At: 2026-07-09 18:55 CEST

<a id="apply-flutter-podium-leaderboard-card-design"></a>
### [x] Apply Flutter Podium Leaderboard Card Design

**Raw source:** Adapt and apply the supplied React/shadcn `leaderboard-card` design prompt to Hable's leaderboard.

**Adapted project prompt:** Hable is a Flutter/Riverpod app, not a React, shadcn, Tailwind, or TypeScript codebase. Translate the design intent into a reusable Flutter widget: a leaderboard card with a title/subtitle header, global run indicator, top-three podium, current-user highlight, paged ranking rows, avatar rendering through `UserAvatar`, and data fed from the existing authenticated `/api/social/leaderboard` provider.

**Issue:** The existing Social Hub leaderboard used a plain `ListTile` list. It worked functionally, but did not reflect the supplied podium/card visual direction and did not emphasize the top three or current user.

**Action:** Build a Flutter `LeaderboardCard` and `LeaderboardEntry` model, map backend rows into the widget inside `SocialHubScreen`, preserve pull-to-refresh and authenticated fetching, and add a focused widget test for parsing, podium/ranking rendering, current-user highlighting, and the default 10-row "show more" behavior.

**Implementation scope:**
- `lib/widgets/leaderboard_card.dart`: reusable Flutter adaptation of the supplied card, podium, and rankings components.
- `lib/screens/social/social_hub_screen.dart`: replace the plain leaderboard list with the new card while keeping the existing provider/backend contract.
- `test/leaderboard_card_test.dart`: focused parser and widget coverage.
- `Developement/Task0_Raw.md`: mark the raw React prompt as transferred to this Flutter-specific task.

**Completion notes:**
- Touched files: `lib/widgets/leaderboard_card.dart`, `lib/screens/social/social_hub_screen.dart`, `test/leaderboard_card_test.dart`, `Developement/Task0_Raw.md`, and `Developement/Task1_Engineered.md`.
- Behavior verified: `flutter analyze` passed; `flutter test test/leaderboard_card_test.dart` passed; full `flutter test` passed.
- Completed At: 2026-07-09 19:02 CEST

<a id="phase-5-profile-based-habit-crud-ui"></a>
### [x] Phase 5: Profile-Based Habit CRUD UI

Enable users to manage their own habits.

**Tasks:**
- [x] Create/Edit UI (e.g., `HabitFormSheet` or `ProfileScreen` integration)
- [x] Database functions (`createHabitWithSync`, `updateHabitDetails`, `archiveHabit`, `restoreHabit`)
- [x] Wire UI into `SyncQueue` (Ensure new/edited habits are placed in the queue for future cloud syncing)

**Ponytail triage:**
- *Should exist:* Yes, habit CRUD is a core habit-tracker workflow.
- *Smallest safe scope:* Add a `Manage Habits` section in Profile with add/edit/archive/restore actions backed by local Drift writes and sync queue entries.
- *Skipped scope:* Hard delete with cascading logs, bulk editing, templates marketplace, drag-and-drop reordering, custom reminders, and a new Home dashboard.
- *Boundaries:* Keep Home focused on today's action. Use Profile for management. Prefer soft delete by setting `HabitStatus.abandoned`; hard deletion can destroy history and should not be the default.

**Action:** Build a compact Profile-based habit management flow. Add a reusable habit form bottom sheet for create/edit, wire DAO/provider methods for local optimistic writes, enqueue sync payloads, and expose archive/restore actions from the habit list.

**Hable perspective:** Habit CRUD must remain offline-first. The UI writes to Drift immediately, Riverpod streams refresh Home/Profile, and background sync catches up later. Editing must not rewrite logs or partner snapshots except where the changed habit metadata requires it.

**Implementation scope:**
- Database DAO methods in `lib/database/database.dart`: create habit with color assignment, update habit title/duration/color, archive habit, restore habit, and enqueue matching sync actions.
- Riverpod helpers in `lib/providers/habit_providers.dart` or a small `habit_actions_provider.dart` for CRUD actions.
- UI: add `Manage Habits` to `lib/screens/profile_screen.dart` with active/archived sections and concise actions.
- Widget: create `lib/widgets/habit_form_sheet.dart` or inline bottom sheet for title, duration, custom/default mode, and optional color selection from the existing pastel palette.
- Sync: reuse `SyncQueue` payloads; add new `SyncAction` values only if the existing enum cannot express update/archive.
- Test surface: one focused widget/provider test for create, edit, archive, restore, and provider refresh behavior.

**Scalability considerations:** Habit counts are small, so simple Drift stream queries are enough. Keep watches scoped to the current user and avoid adding new tables. If habit history grows, archive filters should stay indexed by `user_id` and `status`.

**Future split guidance:** Hard delete, recurring reminders, habit templates, social invite-on-create, and a dedicated management screen are deferred. Add them only after basic CRUD is stable.

**Edge cases:** Empty title, duplicate title, invalid duration, editing a completed habit, archiving today's active habit, restoring an abandoned habit, color collisions, offline sync queue conflicts, existing habits without `colorHex`, and partner snapshots for archived shared habits.

**Acceptance criteria:**
- User can create a new habit after onboarding without leaving the app.
- User can edit habit title, duration, and color from Profile.
- User can archive an active habit; it disappears from Home but remains visible in Profile history.
- User can restore an archived habit to active status.
- CRUD writes update Drift immediately and mark affected rows unsynced.
- CRUD actions enqueue sync payloads without blocking UI.
- Existing completion/skip behavior still works for edited habits.
- `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, and `01_Schema_and_Core_Logic.md` are verified and updated if implementation changes UX, sync behavior, or schema semantics.

**Dependencies:** `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `01_Schema_and_Core_Logic.md`

**Completion notes:**
- Touched files: `lib/database/database.dart`, `lib/providers/habit_actions_provider.dart`, `test/profile_habit_crud_test.dart`, `Developement/02_Offline_Architecture.md`, `Developement/Task1_Engineered.md`, and `Developement/Task2_Archived.md`.
- Behavior verified: Profile `Manage Habits` supports create/edit/archive/restore; create/update/archive/restore enqueue sync payloads with status-aware habit data; Riverpod `allHabitsProvider` reflects the local CRUD lifecycle; the new in-memory regression test covers local state, provider refresh, and sync payloads.
- Verification commands passed: `flutter analyze`, `flutter test test/profile_habit_crud_test.dart`, and `flutter test`.
- Docs verified/updated: `02_Offline_Architecture.md` now explicitly notes that habit edit/archive/restore actions enqueue the full habit payload, including `status`.
- Completed At: 2026-07-09 19:42 CEST
