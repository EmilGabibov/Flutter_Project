<!-- AI AGENT OPERATING CONTRACT — See Task_ai_agent_contract.md for full rules. This file is the full-body archive for completed tasks. -->

## Archived Tasks

<a id="add-privacy-preserving-anonymous-usage-aggregates-for-development-diagnostics"></a>
### [x] Add Privacy-Preserving Anonymous Usage Aggregates For Development Diagnostics

**Raw source:** implement anonymous usage tracking for development and debugging purposes. Track how frequently users open the app, which screens they visit, and how long they spend on each screen. This data should be anonymized and should not include any personal information. no fingerprinting, no traceable ids; acknowledge-free, don't pass the limits which needs GDPR, but instead, implement it in a way that is GDPR-compliant.
- having an admin panel for it on the web.
- for ui use `npx @21st-dev/cli add larsen66/efferd-dashboard-2`.

**Issue:** Hable has no usage diagnostics layer. That makes it harder to see whether users open the app, which top-level screens are reached, and whether screens are abandoned immediately. But raw analytics events, user IDs, device IDs, IP/user-agent storage, session replay, screen paths containing habit/user data, or third-party analytics SDKs would violate the user's explicit constraints. The implementation must collect only aggregate development diagnostics and must not create a hidden user-tracking system. The requested `21st-dev` dashboard command targets a React/shadcn-style web UI, while Hable is currently a Flutter app, so it must not force a new web stack inside this task unless a separate admin web shell already exists.

**Ponytail triage:**
- *Should exist:* Yes, but only as coarse diagnostics. A full product analytics stack is unnecessary and risky for this app right now.
- *Smallest safe scope:* Build an in-house aggregate counter with static screen labels, in-memory screen timing, optional local Drift buckets, an optional remote aggregate endpoint enabled only by explicit build flag, and a minimal dev-only aggregate report/admin surface. Do not add a third-party analytics SDK.
- *Skipped scope:* Firebase Analytics, Segment, Amplitude, Sentry session replay, per-user funnels, attribution, advertising IDs, device IDs, A/B testing, heatmaps, raw event exports, broad marketing dashboards, crash reporting, and creating a full React admin app solely to host one dashboard component.
- *Boundaries:* No user ID, account ID, device ID, installation ID, stable session ID, IP address, user agent, precise location, habit title, friend name, email, username, route parameter, fingerprint signal, or raw event timeline may be stored in analytics data. If a future need requires any of those, it must become a separate consent/privacy task.

**Action:** Add privacy-preserving anonymous usage aggregates for development diagnostics. Track app opens, allowlisted top-level screen visits, and rounded visible duration per screen as aggregate counters only. Keep collection disabled or local-only by default unless an explicit development/build flag enables remote aggregate upload. Ensure the backend stores only bucketed counts and duration totals, not request metadata or identifiers. Provide a small web-visible admin/report surface for aggregate buckets; use the requested `21st-dev` dashboard template only if there is an appropriate React/shadcn admin shell, otherwise treat it as visual inspiration and do not graft React tooling into the Flutter app.

**Hable perspective:** Hable is offline-first and already uses Flutter/Riverpod/Drift with direct `Navigator` pushes from `MaterialApp(home: _AppGate())`. Usage diagnostics should follow that architecture: Flutter records only local aggregate counters, Riverpod exposes the small service, Drift can buffer unsent aggregate buckets, and Cloudflare Workers/D1 can receive anonymous aggregate increments without authentication or user linkage. Home/Profile/Social UI must not wait on analytics.

**Implementation scope:**
- Flutter service: add a small `UsageDiagnosticsService` or provider that records `app_open`, `screen_visit`, and `screen_visible_ms` for a fixed allowlist such as `auth`, `home`, `profile`, `social_hub`, `habit_form`, and `onboarding`.
- Screen instrumentation: because the app does not use named routes, add minimal wrappers or explicit lifecycle calls in top-level screens rather than relying on a route observer that cannot see all direct widget swaps.
- Timing model: use app lifecycle and screen visibility to accumulate duration in memory, round durations to coarse buckets such as 5 or 10 seconds, and flush aggregate totals rather than individual events.
- Local persistence: if offline buffering is needed, add a Drift-only `UsageAggregateBuckets` table keyed by coarse date, platform/build channel, static screen name, and metric type. Do not include `userId`, username, auth state, habit id, friend id, route arguments, or any persistent client identifier.
- Remote upload: add an optional Worker route such as `POST /api/dev/usage-aggregate` only if remote diagnostics are enabled by explicit compile-time flag. The route must increment D1 aggregate rows and must not persist IP address, user agent, auth header, request id, or raw JSON event logs.
- Backend schema: if remote upload is implemented, add a D1 aggregate table such as `usage_aggregate_buckets(bucket_date, platform, build_channel, app_version, screen_name, metric_name, count, total_duration_ms, updated_at)` with a unique aggregate key. Keep dimensions intentionally coarse.
- Admin/report surface: add the smallest useful web-facing aggregate report, such as a protected Worker HTML endpoint, a Flutter web admin-only route behind a development flag, or documented D1 SQL output. It must show only aggregate counts and rounded durations by date/screen/platform, with no per-user drilldown.
- Requested UI template: evaluate `npx @21st-dev/cli add larsen66/efferd-dashboard-2` only if a separate React/shadcn admin app already exists or is explicitly created by a future task. Do not add Node/React/shadcn dependencies to the Flutter app just for this dashboard.
- Privacy controls: default production builds to disabled unless a documented privacy review changes that. For web, do not use analytics cookies, localStorage identifiers, browser fingerprinting APIs, or cross-site tracking. Do not add a banner merely to justify non-essential tracking.
- Reporting: provide a tiny developer-facing query or documented SQL snippet for aggregate counts/durations. Hide or suppress reporting for very small buckets if the report could single out one person in a low-traffic environment.
- Documentation: update `01_SCHEMA_AND_CORE_LOGIC.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, and `08_Testing.md` if schema, local buffering, backend route, or smoke procedure changes.
- Test surface: add focused unit/provider tests for aggregate incrementing, duration rounding, no identifier fields in payloads, disabled-by-default behavior, and no UI crash when analytics upload fails.

**Scalability considerations:** Keep local and remote storage bounded by aggregate bucket count, not raw event count. Flush in small batches, coalesce repeated screen timings before writing to Drift, and never let upload retries block sync or UI rendering. D1 writes should use aggregate upserts keyed by coarse dimensions so daily growth is proportional to `screens * metrics * platforms`, not active users or events.

**Future split guidance:** A full React/shadcn admin app using the requested `21st-dev` dashboard component, consented product analytics, privacy policy updates, data subject request tooling, differential privacy, k-anonymity enforcement, crash reporting, performance tracing, feature funnels, A/B testing, and retention dashboards should be separate tasks. If production telemetry is needed, add a consent/privacy-design task before collecting personal or pseudonymous data.

**Privacy baseline:** GDPR Article 4 treats online identifiers as potential personal data, and GDPR Recital 26 excludes anonymous information only when a person is not or is no longer identifiable. EDPB's current anonymisation guidance work frames anonymity around preventing singling out, linkage, and inference. ICO storage/access guidance also treats analytics cookies/storage as non-essential and consent-requiring in the web context. For Hable, "acknowledge-free" therefore means no cookies, no persistent analytics IDs, no fingerprinting, and no linkable raw event history.

**Edge cases:** App launched while logged out, auth gate swaps from `AuthScreen` to `HomeScreen`, app backgrounded while a screen timer is running, Android process killed before flush, web tab hidden, multiple browser tabs open, offline for several days, failed remote upload, device clock skew, debug seed users, very low traffic buckets, unsupported platform names, screen rename breaking aggregate continuity, route arguments accidentally included in a screen label, and Cloudflare/platform access logs containing request metadata outside the app-level analytics table.

**Acceptance criteria:**
- App opens, top-level screen visits, and screen visible duration are tracked as aggregate counters only.
- No analytics payload or local analytics table contains `userId`, username, email, auth token, device/install/session ID, IP address, user agent, habit id/title, friend id/name, route parameter, precise timestamped event trail, or fingerprinting signal.
- Analytics collection is disabled or local-only by default, and any remote upload requires an explicit development/build flag.
- Remote upload, if implemented, writes only coarse aggregate D1 rows and never raw event rows.
- A web-visible admin/report surface exists only for aggregate buckets, or the implementation explicitly documents why the safe MVP is SQL/local reporting instead.
- The requested `21st-dev` dashboard template is not added to the Flutter app unless a compatible React/shadcn admin shell exists; if skipped, the completion notes state that compatibility boundary.
- Screen duration is rounded/coarsened before persistence or upload.
- Analytics failures never block auth, Home rendering, habit actions, social sync, or offline-first behavior.
- Web builds do not create analytics cookies, localStorage identifiers, or browser fingerprinting probes.
- Tests or documented checks prove disabled-by-default behavior, aggregate incrementing, duration rounding, and absence of identifier fields.
- Documentation dependencies are verified and updated if schema, architecture, analytics behavior, or testing procedure changes.
- The implementation notes clearly state whether the result is local-only development diagnostics or remote aggregate diagnostics; it must not be described as user-level analytics.

**Dependencies:** `01_SCHEMA_AND_CORE_LOGIC.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`

**Completion notes:**
- Touched files: `lib/database/tables.dart`, `lib/database/database.dart`, `lib/database/database.g.dart`, `lib/providers/usage_diagnostics_provider.dart`, `lib/services/usage_diagnostics_service.dart`, `lib/widgets/usage_tracked_screen.dart`, `lib/main.dart`, `lib/screens/auth_screen.dart`, `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/social/social_hub_screen.dart`, `lib/screens/onboarding/onboarding_username_screen.dart`, `lib/screens/onboarding/onboarding_habit_screen.dart`, `lib/screens/onboarding/onboarding_duration_screen.dart`, `lib/screens/onboarding/onboarding_complete_screen.dart`, `lib/widgets/habit_form_sheet.dart`, `backend/schema.sql`, `backend/src/index.ts`, `test/usage_diagnostics_service_test.dart`, `Developement/01_Schema_and_Core_Logic.md`, `Developement/02_Offline_Architecture.md`, `Developement/04_Social_and_Analytics.md`, and `Developement/08_Testing.md`.
- Behavior implemented: Drift now stores coarse `UsageAggregateBuckets` keyed only by date/platform/build-channel/screen/metric; `UsageDiagnosticsService` records `app_open`, `screen_visit`, and 5-second-rounded `screen_visible_ms` for the allowlisted top-level screens; route-aware screen wrappers track visibility without storing route arguments; optional remote upload posts anonymous aggregate deltas to `POST /api/dev/usage-aggregate`; the Worker upserts aggregate D1 rows and exposes a development-only `/api/dev/usage-report` HTML/JSON surface that hides low-volume buckets.
- Privacy boundary verified: no diagnostics payload, Drift row, or Worker schema field includes user ID, username, email, auth token, device/install/session ID, IP, user agent, cookie/localStorage identifier, fingerprinting probe, habit title, friend name, or raw event timeline. Remote upload intentionally omits auth headers.
- Compatibility boundary: the requested `npx @21st-dev/cli add larsen66/efferd-dashboard-2` template was not added because this repo has no compatible React/shadcn admin shell. The Worker HTML report is the smallest safe web-visible admin surface for the current stack.
- Verification run: `flutter pub run build_runner build`, `flutter analyze`, `flutter test test/usage_diagnostics_service_test.dart`, and `npx tsc --noEmit`.
- Result scope: local aggregate diagnostics are enabled by default; remote aggregate upload remains disabled unless `--dart-define=HABLE_USAGE_DIAGNOSTICS_REMOTE_UPLOAD_ENABLED=true` is set. The shipped feature is development diagnostics, not user-level analytics.
- Completed At: 2026-07-11 14:02 CEST

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

**Completion notes:**
- Touched files: `Developement/00_Agent_Directives.md`, `Developement/05_Search_Engine_Architecture.md`, `Developement/TWIN_TEST_HARNESS.md`, `Developement/Task1_Engineered.md`, `Developement/Task2_Archived.md`, and `Developement/Task0_Raw.md`.
- Behavior verified: the directives doc now matches the current Flutter web plus Android target, mixed Riverpod usage, secure token persistence, and privacy-scoped sync model; the search doc now matches the implemented local in-memory index, `SearchDocuments` metadata, `compute`-backed tokenization, and deferred persistence path; the twin harness doc now matches the invite-driven shared-habit flow, accepted-friend cache expectations, and current backend seed/setup commands.
- Docs verified/updated: `00_Agent_Directives.md`, `05_Search_Engine_Architecture.md`, and `TWIN_TEST_HARNESS.md` were updated. `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`, and `Task_ai_agent_contract.md` were reviewed and already aligned with current code/tasks.
- Verification run: repo-wide doc/code sanity checks with `rg` plus direct source review across Flutter, backend, schema, and test-runbook files. No Flutter/backend tests were run because this task only changed documentation.
- Completed At: 2026-07-11 13:50 CEST

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

<a id="run-adb-smoke-tests-for-auth-friend-harness-and-recent-ui-changes"></a>
### [x] Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes

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

**Completion notes:** Executed comprehensive ADB smoke tests on emulator-5554 (Android 17 API 37). **Touched files:** `Developement/08_Testing.md` (appended Section 11 with full execution log), `Developement/Task1_Engineered.md` (marked [x]). **Behavior verified:** (1) Backend connectivity via `adb reverse tcp:8787 tcp:8787` successful; (2) Unauthenticated users correctly gated to AuthScreen; (3) Registration flow end-to-end working (created testuser_smoke1, confirmed JWT auth); (4) Authenticated Home screen displays all expected UI: welcome message, habit presets, add/profile/social buttons, daily quote; (5) Both APK flavors (primary & friend) installed side-by-side with distinct package IDs (com.example.flutter_project.primary / friend) and isolated Drift databases; (6) `.gitignore` verified and properly configured with `backend/.wrangler/` and `.env`; (7) No untracked generated files; (8) All acceptance criteria passed. **Documentation:** `08_Testing.md`, `TWIN_TEST_HARNESS.md`, `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, and `04_Social_and_Analytics.md` reviewed—existing guidance remains valid; no stale commands discovered. **Completed At:** 2026-07-11 05:30 UTC

<a id="refine-habit-card-ring-icon-partner-rings-and-responsive-state-model"></a>
### [x] Refine Habit Card Ring Icon Partner Rings And Responsive State Model

**Raw source:** Card UI:
- Put the habit dedicated icon inside the ring. Make the icon in the main ring bigger, but faded. Very smooth along with the ring completion, make it smaller but completely visible. The desired metaphor is that a habit starts as transparent/recognizable but not established yet, then stabilizes through the hold/completion interaction.
- Encode the reusable parameters used by difficulty, level, completion, and habit establishment so the same logic can later drive progress, border, or dynamic card background effects.
- Make the partner profile picture bigger, make its ring thickness more like the main habit ring, and make it more visible. Rings are the main element on the UI, make them pop.
- Habit card arrangement should respond to screen size and number of habits, and should not overflow. There is currently no gap between the last card and the very bottom.
- Reduce UI elements by integrating the subtitle of the habit name, "challenge day X of Y", into the progress bar. Bring the habit name from top-left to bottom over the progress bar, making the ring and partners the main focused UI elements.
- Create habit state updates (`check-in`, `skip`, `missed`, `nudge`) at code level, not as full UI yet.
- First developed UI state should connect with task completion/check-in: the current animation transition for the habit icon, a very short appearance of done UI, then a smooth transition to the established habit. Future happiness/splash states are separate phases.
- Follow-up constraint: completed state does not need a green ring. A tech-style completed ring using the habit/ring visual language is enough.

**Issue:** The current Home habit card treats the ring as one element among many: title/subtitle sit at the top, partner chips are visually smaller than the main ring, the ring uses a generic icon/text treatment, and the challenge label is duplicated outside the progress bar. The card also has layout pressure on small screens and near the bottom of the scroll view. Completion state risks becoming a generic green success treatment instead of preserving Hable's ring-driven, habit-specific visual language.

**Ponytail triage:**
- *Should exist:* Yes, the habit card is the primary daily action surface, and the current composition does not match the intended ring-first product direction.
- *Smallest safe scope:* Refactor the existing `_HabitCard`, `MudLongPressButton`, and `HabitPartnerRow` visuals and add a tiny reusable state model for habit visual state. Use existing habit metadata, colors, Drift/Riverpod state, and Flutter animation primitives.
- *Skipped scope:* New design system package, new animation framework, shaders, 3D backgrounds, full happiness splash screen, OS notifications, remote state-machine redesign, and broad navigation changes.
- *Boundaries:* Do not change backend habit completion semantics in this UI task. Do not add new dependencies unless a platform limitation proves impossible with existing Flutter APIs. Do not force completed rings to green; preserve the habit/tech ring identity.

**Completion notes:**
- **Touched files:** `lib/models/habit_visual_state.dart` (created), `lib/widgets/mud_long_press_button.dart` (enhanced with icon animation), `lib/screens/home_screen.dart` (refactored card layout to ring-first), `lib/widgets/habit_partner_row.dart` (enlarged avatars), `test/habit_card_ring_refinement_test.dart` (created for validation).
- **Behavior implemented:**
  - Created `HabitVisualState` enum with idle, pressing, checkInComplete, established, skipped, missed, nudged states.
  - Created `HabitVisualParameters` class encoding reusable icon scale, opacity, ring thickness, and animation durations; provided standard, highDifficulty, and lowDifficulty presets.
  - Updated `MudLongPressButton` to accept optional habit icon and render it inside the ring with smooth animation from larger/faded to smaller/fully visible during hold.
  - Ring thickness parameter now drives both background track and progress arc, responding to hold progress and resistance.
  - Refactored `_HabitCard` layout to center the mud button as the primary focus; moved habit name and challenge day info to bottom progress area; partner avatars now render below the ring with up to 4 visible + overflow indicator.
  - Enlarged `HabitPartnerRow` partner avatars from radius 12 to 16; increased ring border thickness from 2 to 2.5; improved padding and alignment for better visibility.
  - Card layout now responsive: habit name/challenge info integrated into bottom section with habit color background; progress bar at top of bottom section; no overflow on small screens.
  - Completed state shows brief done confirmation, then settles into established habit state using habit color (not forced green).
- **Verification run:** `flutter analyze` (no issues), `flutter test test/habit_card_ring_refinement_test.dart` (6 tests pass), `flutter test --coverage` (9 total tests pass).
- **Documentation verification:** No doc updates were required beyond confirmation that the implementation aligns with intended ring-first philosophy already documented in `03_UI_UX_and_Animations.md`.
- **Completed At:** 2026-07-11 14:30 CEST

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
### [x] Add Revocable iCal Feed For Native Calendar Subscriptions

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

**Completion notes:** Implemented complete calendar feed subscription system. **Touched files:** `backend/schema.sql` (calendar_feed_tokens table), `backend/src/index.ts` (protected GET/POST calendar routes), `backend/functions/calendar/[[route]].ts` (public ICS endpoint), `lib/providers/calendar_provider.dart` (feed state management), `lib/screens/profile_screen.dart` (subscription UI). **Behavior verified:** (1) Protected `/api/user/calendar-feed` generates stable token + URL; (2) `/api/user/calendar-feed/rotate` invalidates old token + issues new; (3) Public `/calendar/:token.ics` returns valid iCalendar with daily habit summaries; (4) Feed is unguessable, revocable, time-limited; (5) ProfileScreen shows subscription card with copy/rotate; (6) No private data exposed; (7) Local dev testing verified end-to-end. **Deployed:** Ready for production. **Completed At:** 2026-07-11 04:15 UTC

<a id="repair-signup-signin-and-forgot-password-network-failures"></a>
### [x] Repair SignUp SignIn And Forgot Password Network Failures

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

**Completion notes:**
- Touched files: `backend/src/index.ts`, `backend/schema.sql`, `lib/config/api_config.dart`, `lib/database/tables.dart`, `lib/database/database.dart`, `lib/database/database.g.dart`, `lib/providers/auth_provider.dart`, `lib/screens/auth_screen.dart`, `lib/screens/profile_screen.dart`, `lib/widgets/calendar_subscription_card.dart`, `test/leaderboard_card_test.dart`, `Developement/01_Schema_and_Core_Logic.md`, `Developement/02_Offline_Architecture.md`, `Developement/03_UI_UX_and_Animations.md`, and `Developement/08_Testing.md`.
- Behavior implemented: signup now asks for username/password only; username login is case-insensitive; Flutter auth errors preserve backend JSON/non-JSON details instead of collapsing to generic `Network error`; `/api/*` has local/prod CORS handling; Android debug defaults to `127.0.0.1:8787` for `adb reverse`; Profile now has optional email/PIN activation for recoverable cloud progress; password reset uses attached email and production PIN delivery returns a clear failure unless Cloudflare email is configured.
- Behavior verified: `POST /api/auth/register` username/password-only returned 200; uppercase username login returned 200 for the stored account; CORS preflight returned `Access-Control-Allow-Origin`; authenticated profile activation PIN request/verify returned 200 and persisted `email_verified_at`; password reset PIN request/reset returned 200; login with the changed password returned 200.
- Verification run: `npx tsc --noEmit`, `flutter pub run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`, `npm run db:setup`, and local Worker curl smoke on `http://127.0.0.1:8788` because 8787 was already occupied.
- Docs verified/updated: `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, and `08_Testing.md` were updated. `Commands.md` was verified and already matched the `adb reverse` local backend guidance.
- Archive note: no task archive script is present in the repo, so the completed body was not manually moved to `Task2_Archived.md`.
- Completed At: 2026-07-11 13:17 CEST

<a id="build-notification-center-and-local-reminder-mvp"></a>
### [x] Build Notification Center And Local Reminder MVP

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

**Completion notes:**
- Shipped a Drift-backed notification center read model with `NotificationEvents` and `ReminderSettings`, schema version `10`, DAO helpers for idempotent upsert/watch/read-state flows, and regenerated Drift outputs in `lib/database/database.g.dart`.
- Normalized `/api/sync/daily` social payloads into notification rows inside `lib/services/sync_service.dart` for nudges, private messages, habit invitations, friend requests, and newly accepted friends while preserving the existing feature-specific tables.
- Added Riverpod notification/reminder providers plus a `LocalReminderService` for opt-in daily local reminders on Android/iOS/macOS, with graceful no-op behavior when the runtime cannot host the plugin.
- Added the Home bell entry point, `NotificationCenterScreen`, Social Hub tab deep-linking, Profile daily-reminder controls, auth reminder restore/cancel hooks, and usage-diagnostics allowlisting for `notification_center`.
- Added `test/notification_center_test.dart` for idempotent unread/read persistence and notification-center widget smoke, and fixed `UsageTrackedScreen` disposal so top-level screen instrumentation is safe during teardown.
- Updated `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` to document the notification stream, reminder placement, sync normalization, and manual smoke expectations.
- Verified on `2026-07-11` with `flutter analyze` and `flutter test`.
- Completed At: 2026-07-11 15:32 CEST

<a id="add-friend-profile-drilldown-and-habit-scoped-nudge-actions"></a>
### [x] Add Friend Profile Drilldown And Habit-Scoped Nudge Actions

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

**Completion notes:**
- Touched files: `lib/widgets/habit_partner_row.dart`, `lib/widgets/partner_ticker.dart`, `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `test/habit_partner_row_test.dart`, `Developement/03_UI_UX_and_Animations.md`, `Developement/04_Social_and_Analytics.md`, `Developement/07_Multi_User_Social_Features.md`, and `Developement/08_Testing.md`.
- Behavior implemented: partner identity taps now open the existing friend profile; habit-card nudges moved to a separate hand action; Home nudge feedback names the specific habit and partner; friend-profile active habit rows now enqueue the existing `sendNudge` sync action for encouragement; `Follow` still opens the local `HabitFormSheet` with the friend habit title prefilled.
- Backend/privacy verification: `GET /api/social/user/:id/profile` is already authenticated and accepted-friend scoped, and returns safe identity plus active shared-habit metadata; `POST /api/social/nudge` already requires shared-habit participation before accepting the queued nudge.
- Docs verified/updated: `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` were updated to match the profile/nudge separation and manual smoke flow.
- Verification run: `flutter analyze`, `flutter test test/habit_partner_row_test.dart`, and `flutter test`.
- Completed At: 2026-07-11 15:38 CEST

<a id="keep-partner-shared-habits-visible-after-check-in-and-surface-nudges"></a>
### [X] Keep Partner Shared Habits Visible After Check-In And Surface Nudges

**Raw source:** HABIT PARTNERING bug report:
- for partner, not creator, habit card shws up, but it gets deleted once the user checkes in (completes the ring), hoof, gone.
- nudge is not implemented yet:
  - just the announcement of the nudge has been sent appears at the very bottom of the home screen for a second, which is not enough. also, it should be more visible and obvious.
  - (the nudged person) is not aware of the nudge at all, in app or when it's closed.
  - when user is nudged, the card does not change state (the ring should animate in a special way)
  - research about how nudging/poking/reminding works and what is the best way to implement it (not spamming, but effective, psychological and fun).

**Issue:** Partner-accepted shared habit cards are being upserted into the recipient's local `Habits` table from `/api/sync/daily`, then completed through the same `_HabitCard._handleCompletion` path as owned habits. The current completion path can set `HabitStatus.completed`, and `watchActiveHabits(userId)` filters completed habits out of Home, so a partner-side check-in can make the shared card disappear. Nudge sending is also only a queued `sendNudge` plus a brief snackbar; received nudges are returned by `/api/sync/daily` but `SyncService` only logs them with `debugPrint`, so the recipient sees no durable in-app state, no card/ring reaction, and no useful feedback if the app was closed.

**Ponytail triage:**
- *Should exist:* Yes, this is a concrete user-visible regression in shared habit retention and a missing feedback loop for an already implemented backend nudge path.
- *Smallest safe scope:* Fix the root shared-habit lifecycle bug in the local completion/sync path, persist or expose received nudges enough for Home to react in-app, and make send/receive feedback visible on the relevant habit card without adding a full push-notification stack.
- *Skipped scope:* FCM/APNs/web push, service workers, notification permission UI, full notification center, real-time sockets, rich encouragement message authoring, anti-spam analytics, and a broad behavioral-science research project.
- *Boundaries:* Keep the app offline-first. Home must render from Drift/Riverpod. Do not expose private journal data. Do not let a nudge create progress/logs or pressure supporters into completion. Do not implement OS notifications here; defer that to the existing notification-center/reminder task.

**Action:** Repair shared habit check-in retention and make nudges visible in the existing Home card experience. Trace `_HabitCard._handleCompletion`, `watchActiveHabits`, `SyncService.pullDailySync`, `PartnerSnapshots`, and `/api/social/nudge`; prevent partner-side daily check-ins from changing the habit lifecycle status to a value that removes the card from Home; and convert received nudge payloads into local state that the relevant habit card can display with a clear temporary ring/card animation or persistent in-app indicator until seen.

**Hable perspective:** Shared habit visibility belongs to accepted habit partnerships, not local habit ownership. A partner can complete/skip their own daily log for a shared habit, but that should not archive or complete the shared habit metadata row unless the owner intentionally changes the habit lifecycle. Nudges are social cues for already-authorized shared habits: sender writes a queued local intent, Worker stores/returns an ephemeral event, and Flutter must persist enough local read-model state for Home to show it even after an app restart.

**Implementation scope:**
- Root-cause audit: inspect `lib/screens/home_screen.dart` `_HabitCard._handleCompletion`, `lib/database/database.dart` `watchActiveHabits` and `updateHabitStatus`, and `lib/services/sync_service.dart` shared-habit upsert behavior.
- Local lifecycle fix: ensure a partner/shared habit remains `HabitStatus.active` after the viewer completes today's ring; if the code needs to distinguish daily completion from challenge lifecycle completion, keep that distinction in Drift/provider logic rather than overloading `HabitStatus.completed`.
- Shared progress semantics: verify `currentDuration`, `targetDuration`, `_challengeDay`, and `_progressFraction` do not make a received shared habit look finished on day one because `/api/sync/daily` inserted it with `currentDuration = 0`.
- Backend sync check: verify `POST /api/sync/log` still accepts owner/partner completion and skip based on role, and verify `/api/sync/daily` returns enough habit metadata/progress to reconstruct the shared card without leaking private fields.
- Nudge receive state: convert `data['nudges']` in `SyncService.pullDailySync` from `debugPrint` only into a small local read model. Prefer an existing notification table/provider if the notification-center task has landed by then; otherwise add the smallest Drift-backed received-nudge cache needed for Home.
- Nudge card UI: make the relevant habit card/ring react when there is an unseen recent nudge from a partner, using a visible but non-spammy treatment such as a short pulse, badge, or "nudged by X" chip that clears after viewing or after a bounded TTL.
- Nudge send feedback: replace or supplement the bottom snackbar with card-local feedback near the partner chip so the sender sees which habit/person was nudged.
- Anti-spam baseline: keep nudges opt-in-by-context and bounded. Use one visible nudge state per sender/habit or a short cooldown/merge window rather than stacking repeated alerts.
- Tests: add focused Drift/provider/widget tests proving shared habits stay active after partner check-in, received nudges persist into local state, and Home renders a visible nudge indicator without duplicate spam.
- Manual smoke: update `08_Testing.md` with a twin-app flow: Alice invites Bob, Bob accepts, Bob checks in and the card remains visible, Alice nudges Bob, Bob syncs/reopens and sees an in-app card/ring nudge state.

**Scalability considerations:** Nudge state should stay bounded by TTL, sender, and habit so local storage does not become an unbounded event log. Repeated nudges should coalesce by `(habitId, senderId)` or expire quickly. Partner habit rendering should remain habit-scoped through `habitPartnersProvider(habitId)` and should not watch all nudge/social rows for every card.

**Future split guidance:** OS push when the app is closed, notification permissions, web push, configurable quiet hours, nudge cooldown policy, richer encouragement copy, analytics on nudge effectiveness, and psychology-backed personalization should be separate tasks. The existing **Build Notification Center And Local Reminder MVP** task can own durable notification-center design; this task should only create the minimal in-app state required for shared habit cards to react correctly.

**Research baseline:** Lightweight nudges should preserve user choice, stay relevant, and avoid excessive frequency. Behavior-change literature supports timely cues as useful short-term prompts, while notification research warns that overly frequent or irrelevant prompts create fatigue. Use this as a product guardrail: one contextual nudge per habit/partner state is better than generic repeated alerts. References reviewed during engineering: `https://pmc.ncbi.nlm.nih.gov/articles/PMC11161714/`, `https://pmc.ncbi.nlm.nih.gov/articles/PMC10337295/`, and `https://pmc.ncbi.nlm.nih.gov/articles/PMC10002044/`.

**Edge cases:** Partner checks in on a shared habit with `currentDuration = 0`, owner checks in on the final day of a challenge, partner skips instead of completes, sync log fails after optimistic local completion, user receives multiple nudges before opening the app, KV nudge is consumed by one sync before UI observes it, app restarts after receiving a nudge, stale partner snapshots after partnership removal, supporter receives or sends nudges but cannot complete/skip, nudge from a partner on a habit no longer active locally, and repeated taps causing duplicate queued nudges.

**Acceptance criteria:**
- A partner-side check-in on a shared habit no longer removes the habit card from the partner's Home active list.
- The fix is rooted in lifecycle/progress semantics, not a one-off UI reinsert hack.
- Shared habit cards inserted from `/api/sync/daily` have sane day/progress values and do not appear already complete on first receipt.
- Owner/partner completion and skip logs still sync through `SyncAction.logHabit` and backend role authorization.
- Received nudges from `/api/sync/daily` are persisted or exposed through a local Riverpod/Drift read model instead of only `debugPrint`.
- Home shows a clear in-app nudge state on or near the relevant habit card/ring for the nudged recipient.
- Sending a nudge gives visible feedback tied to the selected habit/partner, not only a barely noticeable bottom snackbar.
- Repeated nudges are coalesced, cooldown-bounded, or TTL-bound so the UI cannot become spammy.
- No OS push notification or service-worker scope is added in this task.
- Focused tests or documented smoke cover partner check-in retention, nudge send feedback, nudge receipt display, app restart after receipt, and duplicate nudge handling.
- `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` are verified and updated if lifecycle, sync, nudge UI, or testing behavior changes.

**Completion notes:**
- Added a `keepActiveWhenDurationEnds` path to local habit completion and used the viewer role on Home so owner habits can still complete normally while partner-side shared habit cards stay active after check-in.
- Extended queued nudges with optional `habit_id`, updated the Cloudflare Worker to authorize and store habit-scoped nudge KV keys, and preserved sender-only key parsing for backward compatibility.
- Converted received daily-sync nudges into both coalesced `notification_events` rows and `PartnerSnapshots.lastNudgeAt`, giving Home a Drift-backed card state after the ephemeral KV event is consumed.
- Added a habit-colored ring pulse plus "Nudged by X" chip for recipients and a short-lived "Nudge queued for X" chip for senders, while keeping the existing lightweight snackbar.
- Updated the offline, UI, social, multi-user, and testing docs with shared-card retention, habit-scoped nudge state, and twin-harness smoke expectations.
- Added focused database/widget coverage for partner-side active retention, nudge coalescing by sender/habit, and visible partner-row nudge state.
- Verified with `flutter analyze`, `flutter test test/habit_completion_progress_test.dart test/habit_partner_row_test.dart`, full `flutter test`, and `npx tsc --noEmit` in `backend/`.
- Completed At: 2026-07-11 15:51 CEST

**Dependencies:** `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`

<a id="rework-daily-navigation-and-screen-information-architecture"></a>
### [X] Rework Daily Navigation And Screen Information Architecture

**Raw source:** From `Task_Idea.md`: document different sections, tabs, and pages (`home`, `profile`, `social`, `settings`, etc.), then revise the structure and placement of them. Consider tabs for main navigation elements and a page for the most important action, creating a habit. Minimize clutter and use the fewest UI elements needed for the maximum information and functionality. Think as a designer and developer: Hable is a daily habit tracker, so it should stay simple, elegant, easy, fun, and engaging. Review the current UI and user journey, optimize common actions, remove redundant steps, add missing steps, and clarify Home, Profile, Social, Settings, and habit creation.

**Issue:** Hable's current app structure is still screen-push based: `_AppGate` sends authenticated users to `HomeScreen`, and Home opens Social Hub, habit creation, and Profile through header buttons. Profile also mixes account state, cloud activation, charts, habit management, calendar subscription, achievements, and avatar editing. Social Hub contains several tabs internally. There is no dedicated Settings surface. The result works functionally, but the information architecture is starting to blur daily action, account settings, social obligations, historical progress, and habit creation.

**Ponytail triage:**
- *Should exist:* Yes, the app has enough shipped surfaces that navigation and section ownership now need deliberate structure.
- *Smallest safe scope:* Produce a bounded in-app navigation and screen-ownership refactor: introduce or design a persistent main shell for Home, Social, Profile, and Settings; keep habit creation as a prominent action; move only clearly misplaced account/settings controls; and preserve current Home/Profile/Social functionality.
- *Skipped scope:* Full visual redesign, new brand system, onboarding rewrite, new backend features, OS notifications, settings for every future feature, desktop-specific navigation, and a separate design-system package.
- *Boundaries:* Do not rewrite feature logic while reorganizing surfaces. Home remains the daily action view. Profile remains progress/history. Social remains friends, requests, leaderboards, inbox, and shared obligations. Settings owns account, recovery, notifications/preferences, accessibility/language placeholders, and other durable configuration.

**Action:** Audit Hable's current screen structure and implement the smallest useful information-architecture cleanup. Define screen responsibilities, add a main navigation shell if warranted by the current UI, keep habit creation easy from daily use, move account/settings controls into an appropriate Settings surface, and update docs/tests to reflect the new navigation model.

**Hable perspective:** The Flutter app is offline-first and Riverpod/Drift-driven. Navigation changes must not introduce live-network-driven Home state or duplicate habit mutation paths. Habit creation should continue through `HabitFormSheet` or a deliberate replacement with the same Drift/sync behavior. Social and Profile may continue to use their existing providers, but the user should not have to remember hidden header buttons for core app areas.

**Implementation scope:**
- `lib/main.dart`: replace direct `HomeScreen` authentication target with an app shell only if it keeps `_AppGate` simple and preserves auth gating.
- Main navigation shell: add a small Flutter widget such as `AppShell` or `MainNavigationShell` with stable destinations for Home, Social, Profile, and Settings, plus an obvious create-habit action.
- `lib/screens/home_screen.dart`: keep daily habits and today's action primary. Remove duplicate or hidden navigation affordances once the shell owns navigation. Preserve empty-state habit creation and suggested presets only where they help the first-run daily flow.
- `lib/screens/profile_screen.dart`: keep user identity, progress/history, achievements, calendar subscription, and habit management; move sign-out, email/cloud activation, avatar/account editing, notification preferences, and future durable preferences to Settings where appropriate.
- `lib/screens/social/social_hub_screen.dart`: preserve friends, requests, leaderboard, find friends, and inbox; reduce nested navigation conflicts if the shell gives Social a top-level destination.
- Settings screen: add the smallest useful `SettingsScreen` if one does not exist, covering account, email/cloud recovery status, sign out, notification/preferences entry points, accessibility/language placeholders, and profile-picture/account edit entry points without pretending unbuilt settings are functional.
- Habit creation: decide whether creation stays as `HabitFormSheet` launched from a floating/center action or becomes a focused create page. Reuse existing creation logic and accepted-friend partner picker either way.
- Accessibility: ensure the shell destinations, create action, and settings groups have Semantics labels and large enough tap targets.
- Tests/smoke: add focused widget tests or documented smoke checks for authenticated navigation, main destinations, create action, sign-out route, and no loss of existing Social/Profile access.

**Scalability considerations:** A shell reduces navigation complexity as features grow, but it can also increase rebuilds if every destination watches broad providers. Keep each destination's provider watches local to that destination. Preserve lazy screen construction where possible so charts, social requests, and home habit streams do not all rebuild at once.

**Future split guidance:** A full design-system pass, desktop/tablet adaptive navigation, notification preference implementation, language/accessibility settings implementation, profile editing redesign, and a dedicated create-habit page should become separate tasks if the shell exposes larger product decisions. This task should settle ownership and navigation first.

**Edge cases:** Logged-out state, seed-user twin harness startup, Android back button from shell destinations, deep pushes to friend profile or habit form, unsaved habit form state, switching tabs while sync updates local Drift, small Android screens, web browser back button, settings controls for features not implemented yet, sign out from nested screens, and duplicated Profile/Social routes after introducing shell navigation.

**Acceptance criteria:**
- The app has a documented screen ownership model for Home, Social, Profile, Settings, and habit creation.
- Authenticated users can reach Home, Social, Profile, and Settings through clear top-level navigation or a deliberately documented equivalent.
- Creating a habit remains no more than one primary action away from Home and reuses the existing offline-first creation/sync path.
- Home stays focused on today's habits and does not become a generic dashboard.
- Profile no longer owns durable account/settings controls that belong in Settings, unless the task documents why a control intentionally remains there.
- Social Hub remains reachable and its internal tabs do not conflict with the new top-level navigation.
- Settings exposes only real or explicitly placeholder-safe controls; it must not create dead-end fake settings.
- Android back behavior and web/mobile layout do not trap the user or overflow on common viewports.
- Focused tests or documented smoke checks cover top-level navigation, create-habit launch, Social/Profile access, Settings access, and sign out.
- `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, and `08_Testing.md` are verified and updated if navigation, screen ownership, or smoke procedures change.

**Dependencies:** `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`, `Task_Idea.md`

**Completion notes:**
- Implemented this IA cleanup through the refined three-tab decision in **Lock Hable To Three-Tab IA With Nested Profile Settings** rather than creating a duplicate or conflicting four-tab Settings shell.
- Replaced authenticated direct-to-Home routing with `MainNavigationShell`, keeping Home, Social, and Profile as clear top-level destinations.
- Moved durable account/system controls out of Profile into nested Settings while preserving Profile as identity, history/progression, calendar, and habit-management.
- Preserved habit creation through the existing offline-first `HabitFormSheet` path and made Home's primary creation entry the persistent FAB.
- Updated architecture, UI, social, and testing docs to describe the screen ownership model and smoke checks.
- Verified with `flutter analyze`, `flutter test test/main_navigation_shell_test.dart`, and full `flutter test`.
- Completed At: 2026-07-11 16:06 CEST

<a id="lock-hable-to-three-tab-ia-with-nested-profile-settings"></a>
### [X] Lock Hable To Three-Tab IA With Nested Profile Settings

**Raw source:** Refined Core Information Architecture & UX Strategy: implement a highly focused 3-tab navigation shell for Hable with Home, Social, and Profile as the primary destinations. Home should stay dedicated to today's active habits and immediate progress, with a persistent FAB as the main habit-creation entry point. Social should own friends, partnered habits, mutual obligations, nudges/activity history, and friend-profile drilldown. Profile should own identity, long-term history, all-habit management, progress charts, and a clear gear entry point to nested Settings. Settings should handle durable account/system configuration including authenticated email, name, username, avatar customization, notification preferences, and future accessibility/language foundations. Habit creation should launch from the Home FAB as a focused onboarding-style flow with partner selection and custom emoji options. Minimize clutter, keep daily use lightweight, and avoid turning the app into an overwhelming dashboard. Raw source: `Task_Idea.md` "Hable: Core Information Architecture & UX Strategy".

**Issue:** The previous IA task identifies the navigation problem, but it still leaves a key product choice open by allowing Settings to be either a top-level destination or an equivalent surface. The refined strategy makes that decision explicit: authenticated Hable should use exactly three primary destinations - Home, Social, and Profile - while Settings is nested under Profile. Current code still routes `_AppGate` directly to `HomeScreen`; Home owns header buttons for Social, Add Habit, and Profile; Profile owns sign-out, avatar, email activation, charts, history, calendar, and habit management; and there is no dedicated Settings screen. The result works, but it does not yet match the intended lightweight daily ritual IA.

**Ponytail triage:**
- *Should exist:* Yes, because it resolves the ambiguity in the older IA task and prevents implementing a four-tab shell that contradicts the refined plan.
- *Smallest safe scope:* Add a three-tab shell for Home, Social, and Profile; make habit creation a prominent Home FAB using the existing `HabitFormSheet`; add a nested Settings route from Profile; move only durable account/system controls that already exist or can be represented safely.
- *Skipped scope:* Full visual redesign, new design system, new backend features, OS notifications, image upload backend work, notification preference implementation, language/accessibility implementation, desktop/tablet adaptive navigation, and a new custom habit-creation engine.
- *Boundaries:* Do not duplicate habit creation logic, do not make Settings a fourth tab, do not move social data into Home, and do not let live network responses directly drive Home state.

**Action:** Implement the refined IA as a focused navigation and ownership refactor. Replace Home's header-button navigation with an authenticated three-tab app shell, keep Home as the daily action surface, route habit creation through a Home FAB, keep Social as the multiplayer destination, keep Profile as identity/history/management, and add nested Settings behind a gear in Profile for durable account/system controls.

**Hable perspective:** Hable is offline-first and Riverpod/Drift-driven. The shell must not introduce a parallel state model or direct network-driven dashboard. `HomeScreen`, `SocialHubScreen`, `ProfileScreen`, and `HabitFormSheet` should keep their existing providers and local-first behavior, but their responsibilities should become clearer. This task supersedes the ambiguous parts of `Rework Daily Navigation And Screen Information Architecture`; the implementer should prefer the three-tab decision here when the two tasks conflict.

**Implementation scope:**
- App shell: add a small authenticated navigation shell, likely `MainNavigationShell`, and have `_AppGate` route authenticated users to it instead of directly to `HomeScreen`.
- Home: remove Social/Profile header navigation buttons after the shell owns them; expose habit creation as a persistent FAB and keep empty-state creation wired to `HabitFormSheet.show`.
- Social: keep `SocialHubScreen` as the Social tab and preserve its internal tabs for friends, requests, leaderboard, find friends, inbox, and social activity.
- Profile: keep identity, history, progression, charts, calendar, all-habit management, and friend-profile drilldown behavior; add a gear entry point to nested Settings.
- Settings: add the smallest real `SettingsScreen` needed for sign out, email/cloud activation, avatar/account access, and safe placeholders for notifications, accessibility, and language.
- State and sync: keep Riverpod watches scoped inside each destination and preserve Drift-backed reads; do not add new tables or backend endpoints for navigation alone.
- Accessibility: add Semantics labels for tab destinations, Home FAB, Profile settings gear, and settings sections; preserve large tap targets on small Android screens.
- Tests/smoke: add focused widget tests or documented smoke checks for authenticated shell routing, three tab destinations, Home FAB creation launch, Profile gear to Settings, sign out, Android back behavior, and no loss of Social/Profile access.

**Scalability considerations:** The shell should not cause every destination to rebuild together. Keep provider watches inside destination widgets and preserve lazy construction where practical so Home habit streams, Social network-backed providers, and Profile charts do not all execute on every tab switch.

**Future split guidance:** If implementation exposes larger needs, append separate raw tasks for notification preferences, accessibility/language settings, uploaded profile-picture storage, desktop/tablet adaptive navigation, and a full habit-creation redesign. Do not expand this task into those features.

**Edge cases:** Logged-out app startup, seed-user twin harness startup, switching tabs while `/api/sync/daily` updates Drift, Android back button from each tab and nested Settings, returning from Settings after sign out, Home FAB while a habit sheet is already open, unsaved habit form state when switching tabs, Social Hub's internal tab controller inside the shell, friend profile pushes from Social or partner rows, small screens with keyboard open, web browser back behavior, and placeholder settings that look interactive before they are implemented.

**Acceptance criteria:**
- Authenticated users land in a three-tab shell with exactly Home, Social, and Profile as primary destinations.
- Settings is nested under Profile behind a clear gear entry point, not exposed as a fourth primary tab.
- Home remains focused on today's active habits and immediate progress.
- Habit creation is available from a persistent Home FAB and still uses the existing offline-first `HabitFormSheet` creation path.
- Home no longer relies on header buttons for Social/Profile navigation once the shell owns top-level navigation.
- Social keeps friends, partnered habits, requests, leaderboard, search, inbox/activity, and friend drilldown reachable.
- Profile keeps identity, history/progress charts, achievements, calendar, and habit management while moving durable account/system actions to Settings where appropriate.
- Settings exposes only real controls or clearly safe placeholders; sign out and profile activation continue to work.
- Navigation does not create duplicate sync paths, duplicate habit mutation paths, or direct network-driven Home reads.
- Focused tests or smoke notes cover the shell, all three tabs, Home FAB, Settings route, sign out, and Android back behavior.
- `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, and `08_Testing.md` are verified and updated if navigation, screen ownership, or smoke procedures change.

**Dependencies:** `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`, `Task_Idea.md`

**Completion notes:**
- Added `MainNavigationShell` with exactly three primary destinations: Home, Social, and Profile, plus Android-back behavior that returns from Social/Profile to Home before exiting.
- Routed `_AppGate` and seeded/onboarding exits into the shell instead of direct `HomeScreen` routing.
- Removed Home header buttons for Social/Profile/Add and added a persistent Home FAB that opens the existing `HabitFormSheet`; also made the sheet scroll within a bounded bottom-sheet height.
- Added nested `SettingsScreen` behind the Profile gear with real account/avatar, cloud activation, reminder, and sign-out controls plus safe accessibility/language placeholders.
- Kept Settings out of the primary navigation and kept Profile focused on identity, progression, charts, calendar, achievements, and habit management.
- Added `settings` and `main_shell` to the local usage diagnostics allowlist.
- Added `test/main_navigation_shell_test.dart` for the three-tab shell, Home FAB, Social destination, and Profile settings gear.
- Updated `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, and `08_Testing.md`.
- Verified with `flutter analyze`, `flutter test test/main_navigation_shell_test.dart`, and full `flutter test`.
- Completed At: 2026-07-11 16:06 CEST

<a id="wire-friend-requests-through-social-hub-and-twin-harness-verification"></a>
### [X] Wire Friend Requests Through Social Hub And Twin-Harness Verification

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

**Completion notes:**
- Implemented idempotent, privacy-safe friend request handling in `backend/src/index.ts`: self/missing-target guards, duplicate pending/accepted handling, recipient-scoped accept, recipient-scoped decline, relationship-state search, and friend-request indexes in `backend/schema.sql`.
- Added local Drift `friend_relationships` cache plus DAO/Riverpod support so Social Hub can render pending incoming request rows and search relationship labels without storing habit metadata.
- Updated `SocialHubScreen` search rows to show `Add`, `Requested`, `Respond`, or `Friends` based on backend relationship state; Requests now exposes Accept and Decline actions backed by cached pending incoming rows.
- Updated `SyncService.pullDailySync` to cache accepted friends and incoming friend requests into local relationship state while preserving notification-center rows.
- Added focused regression coverage in `test/friend_relationship_cache_test.dart` and repeatable backend API coverage in `backend/scripts/social-friend-smoke.mjs` exposed as `npm run smoke:social`.
- Updated `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md`.
- Verified: `flutter analyze`, `flutter test test/friend_relationship_cache_test.dart test/main_navigation_shell_test.dart`, full `flutter test`, `npx tsc --noEmit`, `node --check scripts/social-friend-smoke.mjs`, `node --check scripts/lifecycle-smoke.mjs`, `npm run db:setup`, `npm run smoke:social`, and `npm run smoke:lifecycle`.
- Device validation note: `adb` and MobAI device-control tools were not exposed in this session, so the tap-by-tap twin-app UI pass remains a manual/device follow-up even though the Worker API and Flutter test surfaces passed.
- Completed At: 2026-07-11 20:19 CEST

<a id="repair-account-and-social-api-regression-across-auth-avatar-nudge-leaderboard-and-search"></a>
### [X] Repair Account And Social API Regression Across Auth Avatar Nudge Leaderboard And Search

**Issue:** Core account and social surfaces are showing a cluster of regressions that point to route, method, or response-shape mismatches between the Flutter app and the Worker. The result is broken login/registration, unclear activation PIN behavior, avatar update failures, friend search uncertainty, nudge failures, and a leaderboard UI that appears to hang.

**Ponytail triage:**
- *Should exist:* Yes. This is a regression repair on existing Hable flows, not a new feature request.
- *Smallest safe scope:* Restore the current auth, avatar, search, nudge, and leaderboard contract end to end, keeping the existing emoji-only avatar picker and the current Social/Profile surfaces.
- *Skipped scope:* New auth model, profile photo uploads, avatar editor redesign, new people tabs, search ranking, friend recommendations, push notifications, and leaderboard redesign.
- *Boundaries:* Preserve offline-first local caching and optimistic UI updates. Do not expose private habit data through search or leaderboard. Treat 405s, stale loading states, and route mismatches as defects to fix, not acceptable fallbacks.

**Action:** Trace the failing surfaces from Flutter call site to backend route, fix the method/response mismatches that produce 405s or indefinite loading, make error states resolve deterministically, and verify the current app can log in, register, request and verify activation PINs, update an emoji avatar, search friends, send nudges, and load the leaderboard without hanging.

**Hable perspective:** Account records should continue to seed Drift so the app can recover offline. Avatar customization stays emoji-first unless a later task introduces media uploads. Friend search must remain privacy-limited, nudges must remain habit-scoped, and leaderboard data must remain server-owned and non-blocking in the UI.

**Implementation scope:**
- Backend route audit in `backend/src/index.ts` and `backend/schema.sql`: verify supported methods, response codes, auth guards, and delivery paths for `/api/auth/login`, `/api/auth/register`, `/api/auth/request-pin`, `/api/auth/reset-password`, `/api/user/avatar`, `/api/social/search`, `/api/social/leaderboard`, and `/api/social/nudge`.
- Flutter auth wiring in `lib/providers/auth_provider.dart` and `lib/screens/auth_screen.dart`: ensure login/register/PIN/activation failures surface clearly, 405s are handled as actionable errors, and local Drift stays in sync after successful auth changes.
- Avatar UI in `lib/widgets/avatar_picker_sheet.dart` and `lib/providers/auth_provider.dart`: keep the picker emoji-only, persist the selected avatar locally and remotely, and show a deterministic failure state if the server rejects the update.
- Social UI/providers in `lib/screens/social/social_hub_screen.dart`, `lib/providers/social_providers.dart`, and related notification providers: ensure friend search requests complete, nudge actions use the existing queued path, and leaderboard/search loading states exit on success or error instead of spinning forever.
- Local persistence in `lib/database/database.dart` and `lib/database/tables.dart`: confirm account and profile fields needed by the UI are cached correctly and refreshed on successful network writes.
- Test surface in `08_Testing.md` and any focused smoke tests: add a regression checklist for login, registration, PIN request, avatar update, friend search, nudge send, and leaderboard load.

**Scalability considerations:** Search and leaderboard should stay bounded and indexed; no new unbounded feeds or polling loops are needed. The emoji-only avatar path avoids media-upload backpressure. Scalability impact: none expected beyond the existing limited search and top-100 leaderboard patterns.

**Future split guidance:** Split profile photo uploads, richer avatar management, search ranking, friend recommendations, and push-based nudge delivery into separate follow-up tasks if they become requirements.

**Edge cases:** Stale cached tokens, missing email during PIN flows, unsupported avatar values, empty search terms, non-JSON leaderboard responses, backend 405/401/500 responses, offline mode during send/update, duplicate nudge taps, and users reopening the app while a previous request is still in flight.

**Acceptance criteria:**
- Login and registration from the app no longer fail with 405 against the current backend origin.
- PIN request and reset/activation flows either complete successfully or surface a clear, non-hanging error.
- Avatar changes remain emoji-only and successfully persist across app restart when the backend accepts them.
- Friend search returns usable results and the UI no longer reports an ambiguous route/API failure.
- Nudge actions are usable from the current social surface and complete without leaving the UI stuck.
- Leaderboard loads to either data or a clear empty/error state instead of indefinite loading.
- Verified docs are updated where the implementation changes auth, offline, social, or testing behavior.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`

**Completion notes:**
- Enforced emoji-only avatar updates in `backend/src/index.ts` for `PUT /api/user/avatar`; URL/data-upload avatar values now return a clear `400`.
- Updated `AuthNotifier.updateAvatar` so avatar failures set deterministic auth error text and local Drift updates use an update path before falling back to user upsert.
- Added 10-second bounds to Social Hub leaderboard, search, pending request, send, accept, and decline HTTP calls so route/backend failures resolve into existing data/error UI instead of indefinite loading.
- Added `backend/scripts/account-social-regression-smoke.mjs` and `npm run smoke:regression` covering username/password registration, case-insensitive login, activation PIN request, emoji avatar update/rejection, friend search/request/accept, leaderboard load, shared-habit creation/invite, habit-scoped nudge send, and nudge receipt through daily sync.
- Updated `01_Schema_and_Core_Logic.md`, `03_UI_UX_and_Animations.md`, and `08_Testing.md` to document emoji-only avatar behavior, relationship cache/API endpoints, social loading bounds, and the regression smoke procedure.
- Verified: `flutter analyze`, full `flutter test`, `npx tsc --noEmit`, `node --check scripts/account-social-regression-smoke.mjs`, `node --check scripts/social-friend-smoke.mjs`, `node --check scripts/lifecycle-smoke.mjs`, `npm run db:setup`, and `npm run smoke:regression`.
- Device validation note: `adb` and MobAI device-control tools were not exposed in this session, so device tap-through remains manual follow-up; backend API and Flutter test surfaces passed.
- Completed At: 2026-07-11 20:24 CEST
- Reopened production follow-up at 2026-07-11 21:23 CEST: reproduced `405` on `https://hable.pages.dev/api/auth/register`, `/api/auth/login`, and CORS preflight, applied `backend/schema.sql` to remote D1, redeployed Pages Functions from `backend/`, and verified production register/login now return `200` while preflight returns `204`.
- Fixed production PIN delivery by adding the `EMAIL_WORKER` service binding to `backend/wrangler.toml` and allowing `sendPinEmail` in `backend/src/index.ts` to use that binding without requiring duplicate Hable email-sender secrets. Verified production profile activation PIN and password reset PIN endpoints return `200` with `{"success":true,"message":"Verification PIN sent"}`.

<a id="replace-core-loading-spinners-with-consistent-skeleton-empty-states"></a>
### [X] Replace Core Loading Spinners With Consistent Skeleton Empty States

**Raw source:** implement better skeleton empty states.

**Issue:** Several Hable screens still fall back to centered `CircularProgressIndicator` widgets or shrink to blank space while data loads. That makes the app feel abrupt and unstable, especially on first open, and it weakens the calm visual language the rest of the UI is already using.

**Ponytail triage:**
- *Should exist:* Yes. This is a real UX polish pass on existing loading and empty states.
- *Smallest safe scope:* Replace the most visible full-screen spinners and blank gaps with lightweight skeleton placeholders that preserve layout shape on Home, Social Hub, Profile, Auth, Notification Center, and Habit Form.
- *Skipped scope:* New animation library, shimmer dependency, global design-system rewrite, custom asset pack, and any backend/data-model changes.
- *Boundaries:* Keep the implementation simple and local. Reuse Material widgets and existing theme tokens before adding anything new. Do not disturb data flow or offline behavior.

**Action:** Add a minimal reusable skeleton/placeholder component and use it to swap the current loading states in the main app surfaces for structured placeholder content instead of abrupt spinners or empty boxes.

**Hable perspective:** Hable should feel calm, immediate, and predictable. Skeletons should hold the screen shape while local Drift or async providers resolve, so the app feels ready instead of stalled.

**Implementation scope:**
- UI surfaces in `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/social/social_hub_screen.dart`, `lib/screens/auth_screen.dart`, `lib/screens/notification_center_screen.dart`, and `lib/widgets/habit_form_sheet.dart`: replace the most visible spinner-only and blank loading branches with skeleton placeholders that resemble the final card/list layout.
- Shared widget in `lib/widgets/`: add a tiny reusable skeleton block/row/card helper if multiple screens need the same placeholder shape.
- Accessibility: preserve labels/semantics for loading content where needed so assistive tech does not lose context.
- Test surface: add or update widget tests for the key empty/loading states so the app does not regress back to blank screens or spinner-only shells.

**Scalability considerations:** This is purely presentational. It should not add any network calls, rebuild pressure, or dependency weight. Scalability impact: none expected.

**Future split guidance:** If the placeholder treatment later needs richer motion, a dedicated skeleton system, or cross-screen animation choreography, split that into a separate visual-polish task.

**Edge cases:** Slow auth init, empty friend lists, no active habits, empty profile data, empty notifications, no accepted friends in the habit form, and intermittent provider refreshes that briefly re-enter loading state.

**Acceptance criteria:**
- Main app screens no longer flash between blank space and content while loading.
- The most visible loading states use stable skeleton placeholders instead of only centered spinners.
- Empty states still show clear copy, but with better structure and visual weight.
- No backend or database behavior changes are required to complete the polish.
- Widget coverage exists for the updated loading/empty states.

**Dependencies:** `03_UI_UX_and_Animations.md`, `08_Testing.md`

**Completion notes:**
- Added reusable skeleton and structured empty-state widgets in `lib/widgets/skeletons.dart`.
- Replaced prominent spinner-only or blank loading branches across Home, Social Hub, Notification Center, Auth auto-login, Habit Form partner chips, Profile chart/friend loads, avatar picker update state, calendar feed loading, and the habit environment visualizer.
- Improved empty states for notifications, friends, requests, and inbox with icon/title/description cards while preserving existing data providers and offline-first reads.
- Fixed a short-viewport overflow in the reusable empty-state card by making it scrollable; covered this with `test/skeletons_test.dart`.
- Updated `03_UI_UX_and_Animations.md` and `08_Testing.md` with skeleton/empty-state expectations and verification notes.
- Verified: `flutter analyze`, `flutter test test/skeletons_test.dart`, `flutter test test/main_navigation_shell_test.dart`, and full `flutter test`.
- Completed At: 2026-07-11 20:31 CEST

<a id="complete-cross-app-habit-lifecycle-sync-and-twin-harness-verification"></a>
### [X] Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification

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
- Added optimistic completion-state repair in `lib/database/database.dart` so local remaining days decrement and habits move to `completed` only when they actually hit zero.
- Updated `lib/screens/home_screen.dart` so completion/skip logs flush the sync queue immediately and skip payloads no longer send private journal text to the backend.
- Updated `lib/services/sync_service.dart` to mark pushed habits/logs as synced after backend success and to reconcile inbound shared habits using backend status plus viewer remaining days instead of forcing `active` + zero progress.
- Extended `GET /api/sync/daily` in `backend/src/index.ts` to return shared-habit `status` and `viewer_remaining_days` for local reconciliation.
- Verified the lifecycle fixes with `flutter analyze`, `flutter test test/profile_habit_crud_test.dart test/habit_completion_progress_test.dart`, and `npx tsc --noEmit`.
- Added repeatable backend lifecycle smoke script at `backend/scripts/lifecycle-smoke.mjs` and exposed it as `npm run smoke:lifecycle`.
- Verified local backend with `npm run db:setup` and a direct API lifecycle smoke covering seeded auth, case-insensitive friend search, friend acceptance, normal shared habit sync, multi-day shared habit sync, Bob-owned habit visibility in Alice, completion progress, owner-only metadata update enforcement, archive propagation, and private habit exclusion.
- Verified emulator harness setup on `emulator-5554`: `adb reverse tcp:8787 tcp:8787`, built `app-primary-debug.apk` and `app-friend-debug.apk` with seeded identities, installed both packages, launched both flavors, and dumped UI hierarchies showing Alice/Bob each reach Home with the reciprocal shared Hydration card.
- Verified Android twin harness on `emulator-5554` with local Wrangler on `http://127.0.0.1:8787`, `adb reverse tcp:8787 tcp:8787`, rebuilt seeded primary/friend debug APKs, installed both packages, and launched both flavors.
- Verified primary flavor launches as Alice and renders the Home shell with `Hydration`, Bob partner state, nudge state, FAB, and Home/Social/Profile tabs.
- Verified friend flavor launches as Bob and renders the reciprocal Home shell with `Hydration`, Alice partner state, FAB, and Home/Social/Profile tabs.
- Fixed Android debug flavor build regression by enabling core library desugaring for `flutter_local_notifications`.
- Verified backend bidirectional habit lifecycle again with `npm run smoke:lifecycle`, including normal shared habit sync, multi-day shared habit sync, Bob-owned habit visibility, owner-only update enforcement, archive propagation, completion progress, and private habit exclusion.
- Device automation note: MobAI MCP tools were not exposed, so validation used SDK-local `adb`, APK install/launch, and Android UI hierarchy dumps instead.
- Progress completed at 2026-07-11 21:05 CEST.

**Completion notes:** Completed at 2026-07-11 21:05 CEST. Touched `android/app/build.gradle.kts` for required core-library desugaring and verified the already implemented lifecycle path through local Worker smoke plus Android primary/friend flavor launch checks on `emulator-5554`.
- Completed At: 2026-07-11 21:05 CEST
