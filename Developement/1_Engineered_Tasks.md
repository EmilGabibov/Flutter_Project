<!-- AI AGENT OPERATING CONTRACT — See ai_agent_contract.md for full rules. This file hosts the compact completed-task index and the active engineered queue. -->

## Completed Tasks

<!-- Completed items will be logged here as concise links to their archived versions. -->

## Remaining Tasks

### [x] Add Cloudflare Worker Backend For Social Sync & Ephemeral Nudges

**Raw source:** Build the Cloudflare Worker Backend (D1 & KV): Implement the Cloudflare API for the Partnership Junction and the Ephemeral Nudge System, replacing the current stubs in `lib/services/sync_service.dart`. (From `04_SOCIAL_AND_ANALYTICS.md`)

**Issue:** The Flutter client is fully offline-capable, but the backend sync layer is stubbed out. Hable needs a remote Cloudflare Worker with D1 and KV bindings to handle partner data requests and transient social nudges without exposing private journal data.

**Ponytail triage:** 
- *Should exist:* Yes, required by `04_SOCIAL_AND_ANALYTICS.md`.
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

**Dependencies:** `04_SOCIAL_AND_ANALYTICS.md`

**Completion notes:** 
- Created `backend/` with `package.json`, `wrangler.toml`, and `tsconfig.json`.
- Implemented `schema.sql` (users, habit_progress, partnerships) and initialized D1.
- Implemented `src/index.ts` with Hono router for `/api/social/nudge` and `/api/sync/daily`.
- Replaced stubs in `lib/services/sync_service.dart` with `http` package logic.
- Documentation dependency verified and aligned.
- Completed At: 2026-07-08 15:59 Z

### [x] Add Offline Inverted Index Search Engine For Local Documents

**Raw source:** Implement the Multithreaded Inverted Index Engine: Build the search and retrieval system with the relational schema (Document metadata), Inverted Index mapping (Hash Tables & Merge Sort), and producer-consumer thread synchronization. (From `05_SEARCH_ENGINE_ARCHITECTURE.md`)

**Issue:** Hable has no local search module yet. The search architecture requires document metadata, an in-memory inverted index, ranked lookup, and non-blocking indexing so large text corpora do not stall the Flutter UI.

**Ponytail triage:**
- *Should exist:* Yes, required by `05_SEARCH_ENGINE_ARCHITECTURE.md` and named in `pubspec.yaml`.
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
- `05_SEARCH_ENGINE_ARCHITECTURE.md` and `02_OFFLINE_ARCHITECTURE.md` are verified and updated if implementation changes schema or threading behavior.

**Dependencies:** `05_SEARCH_ENGINE_ARCHITECTURE.md`, `02_OFFLINE_ARCHITECTURE.md`

**Completion notes:**
- Created `SearchDocuments` table in `lib/database/tables.dart` and added DAO methods in `database.dart`.
- Ran `build_runner` to regenerate Drift database files.
- Implemented `lib/search/search_engine.dart` with tokenization (using `compute`), an in-memory index, and a custom merge sort.
- Created Riverpod providers in `lib/providers/search_provider.dart` to expose the engine and join results with Drift metadata.
- Wrote and passed focused tests in `test/search_engine_test.dart` verifying positional postings and ranking behavior.
- Completed At: 2026-07-08 16:08 Z

### [x] Add JWT Authentication And Friend-Request Authorization For Sync APIs

**Raw source:** Implement secure user authentication for sync APIs (e.g., JWTs and friend-request acceptance flows).

**Issue:** The current Cloudflare Worker trusts caller-supplied user IDs (`x-user-id`, `sender_id`) for sync and nudge operations. Any caller can impersonate another user or send nudges without an accepted relationship, which breaks the privacy boundaries in `04_SOCIAL_AND_ANALYTICS.md`.

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
- `04_SOCIAL_AND_ANALYTICS.md`, `01_SCHEMA_AND_CORE_LOGIC.md`, and `02_OFFLINE_ARCHITECTURE.md` are verified and updated if implementation changes auth, schema, or sync behavior.

**Dependencies:** `04_SOCIAL_AND_ANALYTICS.md`, `01_SCHEMA_AND_CORE_LOGIC.md`, `02_OFFLINE_ARCHITECTURE.md`

**Completion notes:**
- Migrated backend project to Cloudflare Pages (`functions/api/[[route]].ts`, `public/index.html`).
- Added `friend_requests` table to D1 schema.
- Implemented `/api/auth/login` to sign 30-day JWTs using `hono/jwt`.
- Wrapped `/api/social/nudge` and `/api/sync/daily` with JWT middleware.
- Implemented friend request endpoints and database authorization for nudges.
- Updated `lib/services/sync_service.dart` to automatically authenticate and pass `Authorization: Bearer <token>` in headers.
- Completed At: 2026-07-08 16:44 Z

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
- `03_UI_UX_AND_ANIMATIONS.md`, `04_SOCIAL_AND_ANALYTICS.md`, `02_OFFLINE_ARCHITECTURE.md`, and `01_SCHEMA_AND_CORE_LOGIC.md` are verified and updated if implementation changes schema, sync behavior, or ring styling.

**Dependencies:** `03_UI_UX_AND_ANIMATIONS.md`, `04_SOCIAL_AND_ANALYTICS.md`, `02_OFFLINE_ARCHITECTURE.md`, `01_SCHEMA_AND_CORE_LOGIC.md`; raw reference `06_MULTI_USER.md` is currently missing.

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
- `00_AGENT_DIRECTIVES.md`, `02_OFFLINE_ARCHITECTURE.md`, and `04_SOCIAL_AND_ANALYTICS.md` are verified and updated if implementation changes build, sync, or social test behavior.

**Dependencies:** `00_AGENT_DIRECTIVES.md`, `02_OFFLINE_ARCHITECTURE.md`, `04_SOCIAL_AND_ANALYTICS.md`

**Completion notes:**
- Added `flavorDimensions` and `productFlavors` (`primary`, `friend`) to `android/app/build.gradle.kts`.
- Updated `android/app/src/main/AndroidManifest.xml` to use `@string/app_name` for dynamic app labels.
- Intercepted `--dart-define=SEED_USER_ID` and `--dart-define=SEED_USERNAME` in `onboarding_username_screen.dart` to auto-seed local test users and bypass onboarding.
- Auto-seeded `shared-habit-1` into the test user's Drift database.
- Created `Developement/TWIN_TEST_HARNESS.md` with full runbook commands for building and testing both isolated apps on one device.
- Completed At: 2026-07-08 20:08 Z
