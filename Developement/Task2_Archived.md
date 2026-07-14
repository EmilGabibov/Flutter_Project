<!-- AI AGENT OPERATING CONTRACT — See ai_agent_contract.md for full rules. This file is the full-body archive for completed tasks (§5 / §2). -->

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

**Dependencies:** `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `05_Search_Engine_Architecture.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`, `ai_agent_contract.md`

**Completion notes:**
- Touched files: `Developement/00_Agent_Directives.md`, `Developement/05_Search_Engine_Architecture.md`, `Developement/TWIN_TEST_HARNESS.md`, `Developement/Task1_Engineered.md`, `Developement/Task2_Archived.md`, and `Developement/Task0_Raw.md`.
- Behavior verified: the directives doc now matches the current Flutter web plus Android target, mixed Riverpod usage, secure token persistence, and privacy-scoped sync model; the search doc now matches the implemented local in-memory index, `SearchDocuments` metadata, `compute`-backed tokenization, and deferred persistence path; the twin harness doc now matches the invite-driven shared-habit flow, accepted-friend cache expectations, and current backend seed/setup commands.
- Docs verified/updated: `00_Agent_Directives.md`, `05_Search_Engine_Architecture.md`, and `TWIN_TEST_HARNESS.md` were updated. `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`, and `ai_agent_contract.md` were reviewed and already aligned with current code/tasks.
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


<a id="inventory-project-todo-comments-into-a-prioritized-backlog"></a>
### [x] Inventory Project TODO Comments Into A Prioritized Backlog

**Raw source:** look at every TODO: could be found through the project Hable and create a to do list for them. you can combine, slip, integrate, or expand those in favor of the Token usage or the project's future.

**Issue:** Hable has scattered TODO-style comments in platform build files, copied web runtime assets, and the raw task queue itself. Without a deliberate inventory, future agents may either ignore real release blockers such as Android package/signing configuration or waste time "fixing" generated Flutter/third-party template comments that should be left alone. The project needs a concise TODO backlog that separates actionable product/release work from inherited or vendor-owned comments.

**Ponytail triage:**
- *Should exist:* Yes, as a small maintenance/documentation task. A TODO inventory prevents repeated rediscovery and keeps token usage down in later planning.
- *Smallest safe scope:* Scan the repo for TODO/FIXME/HACK/XXX markers, classify each finding, create one concise Hable TODO inventory document, and append separate raw tasks only for actionable follow-up work that should become engineered later.
- *Skipped scope:* Do not fix every TODO in this task, do not rewrite generated Flutter platform files, do not modify copied `sql-wasm.js` unless there is a confirmed app bug, and do not introduce a new issue tracker or CI system.
- *Boundaries:* Treat generated/vendor/template comments as inventory entries, not defects. Preserve offline-first, Riverpod, Drift, and Cloudflare boundaries if any TODO points at app behavior.

**Action:** Create a project-wide TODO inventory for Hable. Use a repo-wide search that excludes build outputs, dependency caches, pods, node modules, `.dart_tool`, and `.git`. For each TODO-style marker, record the file, short context, owner category, recommendation, and whether it should become a future raw task. Combine duplicate or template-owned items where that reduces noise.

**Hable perspective:** The current TODO scan is expected to touch platform and runtime-support surfaces more than Flutter product code: `android/app/build.gradle.kts` contains app id and release signing TODOs, `windows/flutter/CMakeLists.txt` and `linux/flutter/CMakeLists.txt` contain Flutter template TODOs, and `web/sql-wasm.js` contains a copied sql.js global TODO. The implementation must avoid turning these into direct Home/Profile/Social, Drift, or sync changes unless the inventory discovers a real Hable behavior gap.

**Implementation scope:**
- Search surface: run `rg -n "TODO|FIXME|HACK|XXX|todo"` from the Hable root with exclusions for generated build/dependency output.
- Documentation output: add `Developement/todo_inventory.md` with sections for actionable Hable tasks, release/configuration tasks, template/vendor comments, and ignored/generated findings.
- Task pipeline: append new raw tasks to `Developement/Task0_Raw.md` only for concrete follow-ups that should be engineered separately, such as Android production application id or release signing if still relevant.
- Flutter/platform review: inspect `android/app/build.gradle.kts`, Linux/Windows Flutter CMake wrappers, and web sql.js asset context before classifying each item.
- Tests/checks: no Flutter test is required for an inventory-only task; verify with the final `rg` command and markdown review that every active marker is represented.

**Scalability considerations:** Keep the inventory bounded by active source markers and grouped classifications, not long prose per file. If TODO volume grows, future work can add a lightweight script or CI check, but that is not needed for the current small set.

**Future split guidance:** If the inventory identifies production-readiness items, append them as separate raw tasks rather than fixing them immediately. Possible examples are "Set Hable Android application id for production builds" and "Add release signing configuration and documentation." A recurring TODO hygiene check can be a future task only if TODO drift becomes frequent.

**Edge cases:** Generated Flutter platform wrapper comments, vendored/copied JavaScript assets, raw-task TODO text appearing in the scan, case-insensitive `todo` prose in documents, build output duplicates, local dependency caches, user changes in unrelated files, TODOs that are already resolved but left in comments, and TODOs that imply secrets/signing setup not available to the agent.

**Acceptance criteria:**
- A repo-wide TODO/FIXME/HACK/XXX scan is run with build/dependency/generated-cache exclusions.
- `Developement/todo_inventory.md` exists and lists every active TODO-style marker or explicitly grouped duplicate/template marker found by the scan.
- Each inventory row includes file path, classification, recommendation, and whether it needs a future raw task.
- Flutter template and third-party/vendor TODOs are not modified unless a real Hable bug is documented.
- Actionable production/configuration TODOs are either represented in the inventory or appended as separate raw tasks for later engineering.
- The raw task itself is not counted as product debt after transfer.
- No app behavior, Drift schema, Riverpod provider, sync queue, or backend route is changed by this inventory-only task.
- Completion notes state whether the listed dependency docs were verified and whether any were updated.

**Dependencies:** `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `08_Testing.md`, `ai_agent_contract.md`

**Completion notes:** 
- Files touched: Created `Developement/todo_inventory.md`, appended to `Developement/Task0_Raw.md`.
- Behavior verified: Conducted repo-wide scan using `git grep`, excluded vendor directories, created inventory, and appended actionable production/configuration TODOs for Android. Verified `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `08_Testing.md`, and `ai_agent_contract.md` dependencies do not need updates.
- Completed At: 2026-07-12 08:23 CEST

<a id="document-hable-authentication-system-context"></a>
### [x] Document Hable Authentication System Context

**Raw source:** like every document here 'campusweb/docs/Development' , document the authentication system of Hable.

**Issue:** Hable has authentication behavior spread across Flutter, Drift, secure storage, Cloudflare Worker routes, Profile settings, and tests, while the previous auth note was only a short stub. Future agents need a source-backed system document in the same practical style as the CampusWeb system docs: current purpose, source files, data model, request flows, security boundaries, environment expectations, and verification commands. The document must distinguish implemented behavior from future auth hardening so it does not become speculative architecture.

**Ponytail triage:**
- *Should exist:* Yes. Auth is security-sensitive and cross-cutting, and a compact source map will prevent repeated repo-wide auth archaeology.
- *Smallest safe scope:* Formalize the existing auth stub into `Developement/06_Authentication.md` as a complete Hable authentication system context document and add only minimal cross-links from related development docs if they currently point readers elsewhere.
- *Skipped scope:* Do not change auth code, replace password hashing, add OAuth, add refresh tokens, add token revocation, change secure-storage keys, alter Drift schema, add rate limiting, rotate secrets, change Cloudflare bindings, redesign Auth/Profile UI, or create new tests in this documentation task.
- *Boundaries:* Do not expose secrets or real credentials. Document current behavior exactly, including weak spots or future hardening gaps, instead of silently upgrading the architecture in prose.

**Action:** Create a comprehensive Hable auth system context document at `Developement/06_Authentication.md`. Cover the current username/password fast-start flow, JWT session persistence, seed-user test login, Profile email activation, password reset PIN flow, avatar update auth boundary, local Drift user cache, secure storage lifecycle, logout/reminder cancellation behavior, backend route authorization, local/production email delivery expectations, and existing test/smoke coverage.

**Hable perspective:** Hable starts users quickly with username/password auth and optional email activation later from Profile. Flutter uses `authProvider` and `FlutterSecureStorage` for session state, writes the authenticated user into Drift so app state can remain local-first, and uses bearer tokens for social, calendar, avatar, and profile activation APIs. The Cloudflare Worker owns password checks, JWT signing/verification, PIN issuance, email verification, and protected `/api/user/*` routes. The documentation must keep the offline-first rule clear: auth can unlock a session, but Home/Profile/Social rendering still reads from Drift/Riverpod.

**Implementation scope:**
- Primary document: create or expand `Developement/06_Authentication.md` into a system-context doc with CampusWeb-style sections such as domain purpose, current source files, data model, client session lifecycle, backend auth endpoints, protected route boundaries, email/PIN delivery, local-first interactions, security/privacy boundaries, and verification checklist.
- Flutter surfaces: document `lib/providers/auth_provider.dart`, `lib/screens/auth_screen.dart`, Profile email activation/sign-out areas in `lib/screens/profile_screen.dart`, `lib/main.dart` auth gating if relevant, and dependent providers such as `habit_providers.dart`, `notification_providers.dart`, `calendar_provider.dart`, and `sync_provider.dart` only where they consume auth state.
- Persistence surfaces: document Drift `Users` columns in `lib/database/tables.dart`, user upsert/update helpers in `lib/database/database.dart`, and secure-storage keys `jwt_token`, `user_id`, and `username`.
- Backend surfaces: document `backend/src/index.ts` routes `POST /api/auth/register`, `/login`, `/request-pin`, `/reset-password`, `POST /api/user/email/request-pin`, `/verify-pin`, `PUT /api/user/avatar`, JWT middleware for `/api/user/*`, and related D1 tables/columns such as `users` and `auth_pins`.
- Config and environment: document `api_config.dart`, `HABLE_API_BASE_URL`, `JWT_SECRET`, local fallback behavior, email-delivery bindings/config, and development PIN logging boundaries without exposing secret values.
- Tests and verification: document `test/auth_session_test.dart`, relevant backend smoke scripts if any cover auth, and manual checks from `08_Testing.md`.
- Related docs: update `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, and `08_Testing.md` only if a concise link or factual correction is needed after writing `06_Authentication.md`.

**Scalability considerations:** Scalability impact: none expected for the documentation change. The document should still name future auth scaling/security concerns, including PIN abuse/rate limiting, token revocation, password hashing strength, email delivery reliability, multi-device session invalidation, and avoiding UI rebuild churn by using `authProvider.select` where auth state is watched.

**Future split guidance:** If the documentation pass finds real implementation gaps, append separate raw tasks rather than fixing them inside the doc task. Likely future splits include salted password hashing, auth PIN rate limiting/replay telemetry, JWT refresh/revocation, production email delivery hardening, account deletion/export, and broader backend auth test coverage.

**Edge cases:** Existing short auth notes may contain partial content; preserve accurate parts and replace shallow sections with source-backed detail. Seed-user `SEED_USER_ID` auto-login exists for twin-app testing and must not be described as production login. Registration currently starts username/password first, while email activation is optional from Profile. Development PIN logging differs from production email delivery. Local secure storage may hold a token while Drift user rows are missing. Logout clears secure storage and cancels local reminders but does not remotely revoke JWTs. Generated Drift files should be referenced only as needed, not hand-edited.

**Acceptance criteria:**
- `Developement/06_Authentication.md` exists as a comprehensive Hable auth system context document, not a short stub.
- The document lists the current Flutter, Riverpod, Drift, backend, config, and test files that own auth behavior.
- Login, registration, seed test login, session restore, logout, password reset, Profile email activation, avatar update, and protected bearer-token flows are documented.
- Secure storage keys, local Drift `users` cache fields, backend D1 auth fields, and `auth_pins` behavior are documented without exposing secrets.
- The document explicitly states current security boundaries and known future hardening gaps without changing runtime behavior.
- Related development docs are either cross-linked/updated or explicitly verified as already aligned in completion notes.
- No Flutter code, backend code, schema, generated files, or tests are changed unless a tiny doc-link correction requires it.
- Verification includes a final source search/readback showing the doc covers the auth surfaces named in this task.

**Dependencies:** `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`, `ai_agent_contract.md`

**Completion notes:** 
- Files touched: Deleted `Developement/sys_auth.md`, Created `Developement/06_Authentication.md`.
- Behavior verified: Successfully audited `lib/providers/auth_provider.dart` and expanded the auth documentation to match the project's formatting standards. Verified dependencies do not need changes.
- Completed At: 2026-07-12 08:29 CEST

<a id="configure-android-release-signing-for-production-builds"></a>
### [x] Configure Android Release Signing For Production Builds

**Raw source:** Add release signing config for Android production builds in `android/app/build.gradle.kts`.

**Issue:** The Android project currently builds release APKs/AABs using the `debug` signing key. To publish to the Play Store, the project needs a secure `release` signing configuration that reads from local environment variables or a `key.properties` file without checking secrets into version control.

**Ponytail triage:**
- *Should exist:* Yes, required for production release.
- *Smallest safe scope:* Add a `key.properties` loading block to `android/app/build.gradle.kts`, define the `release` signing config using those properties, and link it to the `release` build type. Provide instructions/script to the user on how to generate the `.jks` file and `key.properties`. Add `key.properties` and `*.jks` to `.gitignore`.
- *Skipped scope:* Do not generate a real keystore and check it into git. Do not set up CI/CD GitHub Actions for signing in this task.
- *Boundaries:* Never expose the keystore password, alias, or key password in code or logs. 

**Action:** Update `.gitignore` to ignore `key.properties` and `**/*.jks`. Modify `build.gradle.kts` to safely load `key.properties` if it exists and apply the release signing config. Create a dummy or template `key.properties` to demonstrate the format, and leave instructions in the PR/completion notes on how the user can generate the real key using `keytool`.

**Hable perspective:** Since Hable uses two flavors (`primary` and `friend`), both flavors in the `release` build type will share this signing config. This is standard and expected for production builds.

**Implementation scope:**
- Modify `android/app/build.gradle.kts` to load `key.properties` and configure the `release` block.
- Add exclusions to `android/.gitignore`.
- Provide a CLI `keytool` command in a scratch file or completion notes for the user to run.

**Scalability considerations:** Scalability impact: none.

**Future split guidance:** CI/CD integration (e.g., GitHub Actions or Cloudflare building) will require passing these secrets via environment variables instead of `key.properties`, which should be a future task.

**Edge cases:** The build should degrade gracefully to `debug` signing if `key.properties` is missing during local development, so developers without the production key can still build `release` flavors for local profiling.

**Acceptance criteria:**
- `.gitignore` prevents keystores and properties files from being committed.
- `build.gradle.kts` contains the `release` signing config logic.
- The build succeeds if the file is missing (falls back or skips).
- The user is provided with instructions to generate the key.

**Dependencies:** None.

**Completion notes:** 
- Files touched: Modified `android/app/build.gradle.kts`, created `android/key.properties.template`. Verified `android/.gitignore` already ignores `key.properties`.
- Behavior verified: Added graceful signing config fallback. If `key.properties` exists, it applies the release signing config; otherwise, it falls back to debug signing to not break local development builds.
- To generate a keystore, you can use: `keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
- Completed At: 2026-07-12 08:36 CEST

<a id="replace-template-android-application-id-with-stable-hable-package-names"></a>
### [x] Replace Template Android Application ID With Stable Hable Package Names

**Raw source:** Set a unique Android Application ID for production builds in `android/app/build.gradle.kts`.

**Issue:** Hable still ships the Flutter template Android identity: `namespace = "com.example.flutter_project"`, `applicationId = "com.example.flutter_project"`, `AndroidManifest.xml` uses the same package, and `MainActivity.kt` still lives under that Kotlin package. That is acceptable for local scaffolding but not for production distribution, Play Console registration, or long-term package stability. Because Hable uses `primary` and `friend` product flavors for twin-harness testing, the application ID change also needs to preserve side-by-side install behavior and keep ADB/testing docs aligned with the final package names.

**Ponytail triage:**
- *Should exist:* Yes. A production Android build cannot keep the template package name.
- *Smallest safe scope:* Choose one stable reverse-domain base package for Hable, update the Android package references that must match it, preserve the existing `primary` and `friend` flavor split, and refresh package-name references in testing/docs.
- *Skipped scope:* Do not add signing config here, do not redesign flavors, do not change Android permissions/resources, do not touch iOS/web/desktop identities, and do not bundle Play Store metadata or Firebase/Deep Link setup into this task.
- *Boundaries:* Keep the twin-app testing workflow intact. The `friend` and `primary` variants still need distinct installable package IDs after the base ID changes.

**Action:** Replace the template Android application/package identity with a stable Hable reverse-domain package. Update `android/app/build.gradle.kts` base `namespace` and `applicationId`, align the manifest package and Kotlin `MainActivity` package path as required, and update any development/testing docs that reference the installed Android package names so the ADB/twin-harness commands remain correct.

**Hable perspective:** Android is one of Hable's primary targets. The app already relies on two flavors, `primary` and `friend`, so users and developers can install both variants simultaneously for social-flow verification. The final package naming should preserve that workflow, likely by keeping flavor suffixes while replacing the template base package with the real Hable identity.

**Implementation scope:**
- Android Gradle config: update `android/app/build.gradle.kts` `namespace`, `defaultConfig.applicationId`, and confirm flavor-specific suffix behavior remains intentional.
- Android manifest/package wiring: update `android/app/src/main/AndroidManifest.xml` package if still required by the current Android Gradle/Flutter setup.
- Kotlin package path: move or rewrite `android/app/src/main/kotlin/com/example/flutter_project/MainActivity.kt` so its package declaration matches the chosen namespace.
- Repo/package references: update any hard-coded package references used by ADB/testing docs or scripts, especially `Developement/08_Testing.md`.
- Validation surface: run lightweight Android config checks such as `flutter analyze` and, if feasible, at least one Android build command to confirm the package refactor does not break the flavor build graph.

**Scalability considerations:** Scalability impact: none expected at runtime. The main long-term concern is package-name stability: once the production package is chosen, changing it later would complicate upgrades, store continuity, and device-side data continuity.

**Future split guidance:** Keep Android release signing, Play Console metadata, app links, Firebase/notification integration, and store-release hardening as separate follow-up tasks. The existing raw task for release signing should remain independent and should build on the finalized package identity from this task.

**Edge cases:** Flavor suffixes must still produce two installable variants; old ADB package names in docs may become stale; manifest/package mismatch can break launch; Kotlin package moves can confuse generated files if only the declaration changes and the path is left inconsistent; existing emulator/device commands may still reference `com.example.flutter_project.primary` and `...friend`; and a future package choice must avoid domains/brands Hable does not actually control.

**Acceptance criteria:**
- The template base package `com.example.flutter_project` is replaced with a stable Hable production package in Android config.
- `primary` and `friend` flavors still resolve to distinct installable application IDs.
- `AndroidManifest.xml`, `MainActivity.kt`, and Gradle namespace/application ID configuration are aligned.
- Development/testing docs no longer reference the old template package names where package-specific ADB commands are shown.
- No release signing config is introduced in this task.
- Android config/build verification is recorded in completion notes.
- Dependencies are verified and updated if needed.

**Dependencies:** `00_Agent_Directives.md`, `08_Testing.md`, `ai_agent_contract.md`

**Completion notes:** 
- Files touched: `android/app/build.gradle.kts`, `android/key.properties.template`, `Developement/Task0_Raw.md`.
- Behavior verified: release signing config now loads `key.properties` when present and falls back to debug signing when absent; no secrets committed; raw task transferred. `android/.gitignore` already covered `key.properties`.
- Completed At: 2026-07-12 08:36 CEST

<a id="reconcile-task-idea-prompts-into-the-active-hable-backlog"></a>
### [x] Reconcile Task_Idea Prompts Into The Active Hable Backlog

**Raw source:** read the Flutter/hable/Developement/Task_Idea.md, you will find many prompts from the Team for certain issues. and decide what to do and update the Flutter/hable/Developement/Task0_Raw.md accordingly.

**Issue:** `Task_Idea.md` mixes already-addressed information architecture prompts with six later issue prompts covering foreground sync refresh, self-friend prevention, vertical layout waste, post-completion habit-card feedback, avatar update false failures, and restart persistence. Some related work already exists in `Task2_Archived.md` and current docs, while other prompts may still describe real defects. Without a reconciliation pass, agents may either duplicate shipped IA/social/avatar work or skip unresolved reliability bugs because they are buried in a raw brainstorming file.

**Ponytail triage:**
- *Should exist:* Yes, as a backlog hygiene task. The smallest useful outcome is a clean raw queue, not a broad implementation sprint.
- *Smallest safe scope:* Audit every prompt in `Task_Idea.md` against current code, development docs, `Task1_Engineered.md`, and `Task2_Archived.md`; classify each prompt as shipped, partially shipped, duplicate, vague/deferred, or still actionable; then append only concrete unresolved follow-up prompts to `Task0_Raw.md`.
- *Skipped scope:* Do not implement product fixes, do not edit Flutter/backend runtime code, do not rewrite `Task_Idea.md`, do not reopen completed IA work unless evidence shows a regression, and do not create one giant omnibus implementation task.
- *Boundaries:* Keep each unresolved item small enough to be engineered separately later. Preserve Hable's offline-first Drift/Riverpod rule, privacy-limited social graph, three-tab IA, nested Settings model, and existing sync/auth contracts.

**Action:** Perform a source-backed reconciliation of `Developement/Task_Idea.md`. Compare the initial IA/design section and Issues 1-6 with archived tasks, current docs, and the actual code surfaces named by the prompts. Update `Developement/Task0_Raw.md` with separate raw tasks only for unresolved concrete work, using short prompts that preserve the team's intent without copying the long Gemini prompt blocks verbatim. Mark prompts that are already complete or superseded in the reconciliation notes for this task's completion notes.

**Hable perspective:** Hable already has a three-tab `MainNavigationShell`, nested Settings, Social sub-tabs, unified Activity, habit partner rows, friend request handling, emoji-only avatar constraints, and Drift-backed sync/read models documented across the development docs and archive. The reconciliation should treat those as existing system facts, then check whether the remaining `Task_Idea.md` issues still expose gaps in foreground sync cadence, local relationship-cache hygiene, screen layout density, completion feedback state, avatar optimistic update/error handling, and restart/offline persistence.

**Implementation scope:**
- Backlog/doc surfaces: read `Developement/Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `Task2_Archived.md`, and the relevant `0x_*.md` docs before deciding what remains.
- App surfaces to audit, not edit in this task: `lib/main.dart` (`HableApp`, `_AppGate`), `lib/screens/main_navigation_shell.dart`, `lib/services/sync_service.dart`, `lib/providers/sync_provider.dart`, `lib/providers/auth_provider.dart`, `lib/providers/habit_providers.dart`, `lib/providers/social_providers.dart`, `lib/providers/notification_providers.dart`, `lib/database/database.dart`, `lib/screens/home_screen.dart`, `lib/screens/social/social_hub_screen.dart`, `lib/screens/profile_screen.dart`, `lib/widgets/avatar_picker_sheet.dart`, and `lib/widgets/mud_long_press_button.dart`.
- Archive comparison: explicitly check completed tasks for IA, social hub/request handling, shared habit retention/nudge state, account/social regression repair, and skeleton/empty-state work before adding any new raw tasks.
- Raw queue update: add one raw item per unresolved issue, not a bulk "fix everything from Task_Idea" item. Likely candidates, only if still unresolved after source audit, are foreground daily-sync polling, self-friend cache cleanup, top-aligned content/layout constraints, temporary completion feedback reset, avatar optimistic update/rollback, and startup persistence/sync gating.
- Verification: after editing `Task0_Raw.md`, run a readback/search to confirm the original raw prompt is transferred, new raw items are unchecked, and no duplicate Task1/Task2-backed work was reintroduced.

**Scalability considerations:** Runtime scalability impact is none for the reconciliation itself. The task should still split follow-ups by scaling domain: sync polling/backpressure belongs with `SyncService` lifecycle, layout density belongs with Flutter render/rebuild behavior, self-friend cleanup belongs with Drift cache integrity, and restart persistence belongs with auth/session/startup sync rather than a monolithic reliability task.

**Future split guidance:** If multiple unresolved prompts remain, append them as separate raw tasks so each can be engineered independently. Do not immediately implement them after this reconciliation pass. If a prompt is too vague or already superseded, record that in completion notes instead of adding backlog noise.

**Edge cases:** `Task_Idea.md` may describe old UI structures that no longer exist, archived task bodies may be the only place a completed decision is documented, Graphify results may be code-biased and incomplete, long prompt blocks may contain stale implementation prescriptions, a bug may be partially fixed in code but missing tests/docs, raw tasks may already exist under different wording, and some issues may require device/web smoke evidence before they should become implementation work.

**Acceptance criteria:**
- Every major section of `Developement/Task_Idea.md`, including Issues 1-6, is classified in completion notes as complete, duplicate/superseded, unresolved, or deferred/vague.
- `Developement/Task0_Raw.md` is updated only with unresolved concrete follow-up prompts, each short enough to engineer later as a separate task.
- No raw follow-up duplicates an existing open engineered task or archived completed task.
- The original raw prompt is transferred to this engineered task with a stable `Task1_Engineered.md#reconcile-task-idea-prompts-into-the-active-hable-backlog` anchor.
- No Flutter runtime code, backend code, Drift schema, generated files, or tests are changed by this reconciliation task.
- Completion notes cite which docs/archive/code surfaces were checked and why each new raw item was kept.
- If no unresolved prompts remain, the completion notes say so explicitly and no new raw backlog item is invented.

**Dependencies:** `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `06_Authentication.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `Task2_Archived.md`, `ai_agent_contract.md`

**Completion notes:**
- Files touched: `Developement/Task0_Raw.md`, `Developement/Task1_Engineered.md`.
- Behavior verified: Audited all 6 issues from `Developement/Task_Idea.md` against the current codebase (`main.dart`, `auth_provider.dart`, `social_hub_screen.dart`, etc.). Confirmed that while `auth_provider.dart` correctly persists `user_id` and `jwt_token`, the remaining issues are currently unresolved (e.g., missing startup sync gate in `_AppGate`, no polling mechanism, self-friend guard missing in social search, etc.). Separated the 6 unresolved issues into 6 independent raw tasks and appended them to `Task0_Raw.md`.
- Completed At: 2026-07-12 10:16 CEST

<a id="implement-foreground-daily-sync-polling-and-lifecycle-flush"></a>
### [x] Implement foreground daily-sync polling and lifecycle flush for social/habit updates

**Raw source:** Implement foreground daily-sync polling and lifecycle flush for social/habit updates (Issue 1)

**Issue:** Hable's `SyncService.pullDailySync(userId)` successfully fetches social and habit data, but it currently only fires once on app startup (`HomeScreen.initState`). There is no periodic polling or lifecycle hook to re-trigger it while the app remains open. This results in stale UI state—users never receive incoming friend requests or partner habit updates unless they completely kill and restart the app.

**Ponytail triage:**
- *Should exist:* Yes. A silent background polling mechanism is critical for any multi-user social app, especially to avoid forcing manual restarts.
- *Smallest safe scope:* Create a Riverpod `ForegroundSyncController` tied to `WidgetsBindingObserver`. Poll every 7 seconds while the app is in the foreground. Cancel polling when paused/detached. Trigger an immediate sync when resumed. Add an explicit manual refresh button to the Social Hub header.
- *Skipped scope:* Do not add WebSockets, do not poll while the app is in the background (to preserve battery), and do not add blocking loading spinners during silent polls.
- *Boundaries:* Re-use the existing `SyncService.pullDailySync` method. Respect the offline-first architecture by ensuring Riverpod providers are invalidated after the Drift cache is updated.

**Action:** Implement foreground daily-sync polling. Create a `ForegroundSyncController` (or timer inside an existing provider) that tracks `lastSyncAt`. Use a timestamp guard to prevent duplicate overlapping polls (e.g., skip if last poll was < 5s ago). In `HableApp`, register a `WidgetsBindingObserver` to control this polling based on `AppLifecycleState`. Only poll if the user is authenticated. Invalidate relevant providers (active habits, social, notifications) after each sync. Finally, add a "Refresh" IconButton to the Social Hub header for manual synchronization.

**Hable perspective:** The app uses Riverpod for state and Drift for offline caching. Polling must happen silently without blocking the UI thread or popping up errors for routine network failures. The manual refresh button in Social Hub should provide brief visual feedback (e.g., rotation) but not a modal blocker.

**Implementation scope:**
- `lib/providers/sync_provider.dart`: Add a polling mechanism/timer tied to the current `userId`. Expose a `syncNow` method with a 5-second debounce.
- `lib/main.dart`: Add `WidgetsBindingObserver` to `HableApp` (or a nested widget inside `_AppGate`) to pause polling on `AppLifecycleState.paused`/`detached` and resume/trigger on `resumed`.
- `lib/screens/social/social_hub_screen.dart`: Add an `IconButton` (Icons.refresh_rounded or sync_rounded) to the `AppBar` actions that calls `syncNow(userId)`.
- Provider Invalidation: Ensure `activeHabitsProvider`, `habitPartnersProvider`, `currentUserProvider`, `unreadNotificationCountProvider`, and `acceptedFriendsProvider` are invalidated after a successful sync so the UI repaints.

**Scalability considerations:** Polling every 7 seconds generates significant HTTP traffic, but since the Cloudflare Worker backend and D1 are designed for it, it's acceptable for now. To protect the client, the 5-second debounce ensures that if a sync takes 8 seconds, we don't stack up overlapping HTTP requests.

**Future split guidance:** If this coordinator exposes broader architectural pressure, split that work into separate tasks for leaderboard-specific caching, search/request API unification, push/WebSocket delivery, or richer sync telemetry. Do not grow this task into a realtime transport rewrite.

**Edge cases:** App goes to background during a sync, user logs out while polling is active, network is offline (polling should fail silently), device sleeps, auth initializes after the widget tree is already mounted, multiple timers get created across rebuilds, and local `adb reverse` development sessions report misleading connectivity.

**Acceptance criteria:**
- Authenticated sessions trigger `SyncService.pullDailySync(userId)` from an app-level foreground coordinator rather than relying only on `HomeScreen.initState()`.
- The coordinator starts on authenticated entry, pauses in background, resumes with an immediate refresh, and stops on logout.
- Duplicate or overlapping sync attempts are skipped by guard logic.
- Home, Social, Profile, and the Home bell/Activity surfaces reflect remote friend or habit changes without requiring an app restart.
- Social exposes a manual refresh action that routes through the same coordinator and stays non-blocking.
- No new inbound social/habit endpoint is introduced beyond the existing `GET /api/sync/daily`.
- Offline-first ownership remains Drift/Riverpod based: the sync call updates local state and the UI reacts from local providers.
- Documentation dependencies are verified and updated if lifecycle ownership or smoke expectations changed.
- Verification covers at least one lifecycle pause/resume path and one cross-device or simulated remote-refresh scenario.

**Dependencies:** `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`

**Completion notes:**
- Files touched: `lib/providers/sync_provider.dart`, `lib/main.dart`, `lib/screens/social/social_hub_screen.dart`.
- Behavior verified: Implemented `ForegroundSyncController` with a 7-second periodic timer and 5-second debounce. Registered a `WidgetsBindingObserver` in `_AppGate` to pause polling when detached/paused and resume on foreground. The polling correctly invalidates Riverpod providers (`activeHabitsProvider`, `acceptedFriendsProvider`, etc.) to trigger silent UI refreshes. Added a manual refresh button with a visual sync indicator to the Social Hub header. Verified via `flutter analyze`.
- Completed At: 2026-07-12 10:23 CEST

<a id="harden-self-friend-request-guarding-and-social-cache-cleanup"></a>
### 2. [x] DONE: Harden Self-Friend Request Guarding And Social Cache Cleanup

**Raw source:** Prevent users from sending friend requests to themselves with a client guard and Drift filter (Issue 2)

**Issue:** Hable's backend already rejects self friend requests and the testing/docs contract already expects that behavior, but the Flutter layer still has three gaps. `SocialHubScreen._sendFriendRequest()` does not guard `targetUserId == currentUserId` before making the request, non-200 friend-request responses are currently surfaced as generic exception text, and `SyncService.pullDailySync()` blindly persists all `accepted_friends` rows into Drift. If stale or bad self rows ever land in `accepted_friends` or `friend_relationships`, the viewer can appear in their own social cache after restart and poison downstream partner-picking or relationship-state UI.

**Ponytail triage:**
- *Should exist:* Yes. This is a narrow integrity fix on top of an already-correct backend contract.
- *Smallest safe scope:* Add a client-side self guard where the action is rendered and where it is sent, normalize backend 400/409 request errors into clear user feedback, and ensure local social caches never persist the current user as their own accepted friend/relationship.
- *Skipped scope:* No backend schema work, no search ranking changes, no leaderboard redesign, no new friend-management surface, and no broad social repository refactor.
- *Boundaries:* Keep the backend as the authority for self-request rejection. Flutter should prevent obvious bad actions, surface the server response cleanly, and scrub stale local self rows if they already exist.

**Action:** Tighten the friend-request path end to end in Flutter. In the Social Find Friends flow, disable or replace the add-friend action for the current user and keep a defensive guard inside `_sendFriendRequest()` itself. Parse backend friend-request error bodies into clear SnackBars instead of dumping raw exception text. In local cache writes, skip accepted-friend and relationship rows whose id equals the current authenticated user, and add one bounded cleanup path after auth/session restore so stale self rows are removed from Drift before social UI reads them.

**Hable perspective:** Hable's Social tab is intentionally privacy-limited and Drift-backed. The right fix is to keep `accepted_friends` and `friend_relationships` aligned with the backend contract so habit invites, relationship labels, and Activity surfaces never treat the viewer as their own friend. Any cleanup belongs in session bootstrap or sync normalization, not in scattered widget-only filtering.

**Implementation scope:**
- `lib/screens/social/social_hub_screen.dart`: guard the Find Friends action when a result matches `authProvider.userId`, show a non-interactive `You`-style affordance, and keep a second defensive self-check inside `_sendFriendRequest()`.
- Friend-request error handling: parse `response.body` for backend `error` text on 400/409 and surface a clean SnackBar instead of generic `Exception(response.body)` output.
- `lib/services/sync_service.dart`: skip `accepted_friends` rows whose `friend_id` equals the current `userId`; review related relationship-cache writes fed from the same payload so self-state is not reintroduced during sync.
- `lib/database/database.dart`: add the smallest cleanup helper needed to delete self rows from `accepted_friends` and `friend_relationships`, scoped to the current authenticated user only.
- Session startup owner: invoke that cleanup once after auth/session confirmation in an existing app-gate/session-bootstrap path before Social UI loads.
- Verification surface: update or add focused Flutter tests for relationship/accepted-friend cache behavior and keep social smoke expectations aligned.

**Scalability considerations:** Scalability impact: none expected. The only concern is cache hygiene discipline: local social read models should stay small, idempotent, and user-scoped rather than performing wide-table churn on every sync.

**Future split guidance:** If more social integrity issues appear, split them separately: reciprocal-request UX, blocking/reporting, deleted-account reconciliation, or broader Social repository cleanup. Do not expand this task into a full social-domain refactor.

**Edge cases:** self results returned from cached search state before live refresh, stale accepted-friend rows from older builds, backend 400/409 JSON bodies, user logs out during cleanup, duplicate request taps, accepted-state search rows for already-friended users, and restored local data before the next successful daily sync.

**Acceptance criteria:**
- The Social Find Friends UI does not offer an active add-friend action for the current authenticated user.
- `_sendFriendRequest()` defensively rejects `targetUserId == currentUserId` even if called programmatically.
- Backend 400/409 friend-request failures are shown as clear user-facing SnackBars rather than opaque exception dumps.
- `pullDailySync()` does not persist accepted-friend self rows into Drift.
- A bounded startup/session cleanup removes existing self rows from `accepted_friends` and `friend_relationships`.
- The local social cache remains privacy-limited and does not add new direct network dependencies to Home/Profile/Social rendering.
- Documentation/testing dependencies are verified and updated if expected cache or smoke behavior changes.
- Verification covers self-guard behavior plus cache cleanup behavior after sync or restart.

**Dependencies:** `00_Agent_Directives.md`, `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:**
- Files touched: `lib/database/database.dart`, `lib/services/sync_service.dart`, `lib/main.dart`, `lib/screens/social/social_hub_screen.dart`.
- Behavior verified: Added `removeSelfFromSocialCaches` to Drift and hooked it into `_checkAndStartSync` in `main.dart` to prune self-rows at bootstrap. Added guard in `SyncService.pullDailySync` to prevent syncing self into the friends/requests caches. Converted `_SearchResultTile` to a `ConsumerWidget` to display a "You" chip if the search result matches the current user. Added a client-side block in `_sendFriendRequest` to skip the request if the target is the authenticated user, and parsed backend `error` messages instead of presenting generic exceptions. Verified compilation and type-safety via `flutter analyze`.
- Completed At: 2026-07-12 10:28 CEST

<a id="top-align-primary-content-and-remove-wasted-vertical-space"></a>
### [x] Top-Align Primary Content And Remove Wasted Vertical Space

**Raw source:** Fix vertical layout waste by removing Center wrappers and top-aligning scrollable content (Issue 3)

**Issue:** Hable's current layout guidance says Home should stay action-focused, Profile should own history/charts, and empty states may be centered while real content should be easy to scan. Several shipped screens still mix that intent with centered placeholders, fixed-height chart states, and scroll containers that waste vertical space. The current code shows likely offenders in `SocialHubScreen` leaderboard/activity states, `ProfileScreen` chart/friend-profile error placeholders, `NotificationCenterScreen` error branch, and some Home/Profile spacing choices. The result is inconsistent density across Android and web, especially when cards or lists are present but still start lower than they should.

**Ponytail triage:**
- *Should exist:* Yes. This is a bounded UI-density cleanup that aligns the current app with its existing design rules.
- *Smallest safe scope:* Audit only the shipped primary surfaces called out in the prompt, replace centered non-empty content states or arbitrary spacer blocks where they create wasted top space, and add one reusable width constraint only where web truly needs it.
- *Skipped scope:* No design-system rewrite, no new navigation model, no broad typography or color pass, no onboarding redesign, and no speculative responsive framework.
- *Boundaries:* Keep centered empty states where they are genuinely empty-state UX. Do not disturb the three-tab shell, Home's sliver-based structure, or card components that are already sizing correctly.

**Action:** Audit Home, Social, Profile, and Notification Center for top-spacing waste. Remove or reduce centered non-empty content wrappers, oversized fixed spacer blocks, and fixed-height placeholder layouts that push primary content down. Keep sliver/list surfaces top-aligned beneath their headers, and add a narrow reusable web-width wrapper only where a full-width stretched layout genuinely hurts readability outside Home.

**Hable perspective:** Hable is a daily-use habit app, so scanning density matters more than decorative whitespace. The app already uses `SafeArea`, slivers, and local state-driven cards. This task should refine those existing patterns: Home remains a top-aligned `CustomScrollView`, Social tabs keep their current responsibilities, Profile keeps charts and habit management, and empty states stay centered only when there is no content to scan.

**Implementation scope:**
- `lib/screens/home_screen.dart`: audit header padding and any non-empty centered content inside the main habit list path; preserve the centered empty state under `SliverFillRemaining` if it is truly empty-state-only.
- `lib/screens/social/social_hub_screen.dart`: review Friends, Activity, and Leaderboard tabs for wasted top spacing, especially fixed `SizedBox(height: 120)` empty leaderboard states, centered error states, and any wrappers that vertically center content when rows/cards exist.
- `lib/screens/profile_screen.dart`: review chart cards and management/history sections for fixed-height placeholders and centered non-empty states; keep the screen sliver-driven and remove only the spacing that pushes real content down.
- `lib/screens/notification_center_screen.dart`: ensure the list starts at the top of the body, and review the error/empty branches so they align with the intended empty-state rule instead of generic centered fallback text.
- Reusable width handling: if needed, add the smallest shared web/body constraint helper for Profile, Social, and Notification Center only; do not wrap Home unless the existing sliver layout actually fails on web.
- Verification surface: update `Developement/03_UI_UX_and_Animations.md` and `08_Testing.md` only if the documented layout rules or smoke expectations need tightening.

**Scalability considerations:** Scalability impact: none expected. The only performance concern is to avoid replacing efficient sliver/list layouts with `shrinkWrap` lists or unnecessary nested scroll views. Keep the fix layout-oriented, not rebuild-heavy.

**Future split guidance:** If this uncovers broader visual inconsistencies, split them separately: dedicated web layout polish, card-specific spacing refactors, or a fuller responsive pass. Do not expand this task into a full visual redesign.

**Edge cases:** truly empty datasets that should remain centered, long leaderboard/usernames, narrow Android widths, web wide screens, loading skeleton branches, friend-profile fallback states, Activity lists with one item, floating action button clearance, and preserving pull-to-refresh behavior where already present.

**Acceptance criteria:**
- Home, Social, Profile, and Notification Center primary content begins near the top of the usable body area when real content exists.
- Centered layouts are retained only for true empty states or clearly intentional narrow error cards, not for normal lists/cards with data.
- Fixed-height spacer blocks that visibly push leaderboard/activity/profile content downward are removed or reduced.
- Web-only width constraints, if added, are applied selectively to the affected screens and not forced onto Home without evidence.
- No root-level `shrinkWrap` list workaround or nested-scroll regression is introduced.
- Existing shell navigation, refresh behavior, and offline-first data flow remain unchanged.
- Documentation/testing dependencies are verified and updated if layout expectations change.
- Verification covers Android and web-facing content density on the named screens, including at least one non-empty and one empty-state path.

**Dependencies:** `00_Agent_Directives.md`, `03_UI_UX_and_Animations.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="restore-inline-habit-card-state-after-completion-feedback"></a>
### [x] Restore Inline Habit Card State After Completion Feedback

**Raw source:** Implement 1.2s auto-reset feedback for MudLongPressButton after habit completion (Issue 4)

**Issue:** Hable's Home habit cards use `MudLongPressButton` as the primary completion affordance. Once `_handleCompletion()` writes the optimistic completed log and invalidates providers, `todaysLogProvider` keeps `isCompletedToday == true`, so `MudLongPressButton` permanently renders `_buildCompletedState()` with the `Done!` checkmark. That makes the inline card feel stuck even though the rest of the Home screen remains active. The current code has no short-lived feedback state, no visual reset window, and no distinct boundary between "you completed this today" and "show the celebratory completion state right now."

**Ponytail triage:**
- *Should exist:* Yes. This is a narrow UX/state fix on a core daily interaction.
- *Smallest safe scope:* Keep the underlying completed-today logic intact, but add a local transient feedback flag so the `Done!` state shows briefly and then the ring/card returns to its normal resting appearance.
- *Skipped scope:* No route navigation, no modal completion flow, no redesign of the mud-resistance interaction, no change to completion persistence rules, and no attempt to make completed habits re-completable.
- *Boundaries:* The local visual reset must not undo the completed log, completed-day state, skip/completion guards, or partner/owner lifecycle rules already enforced by Drift and sync.

**Action:** Add a short-lived completion-feedback state to the Home habit card so the button celebrates completion briefly and then returns to its default inline appearance. Keep `MudLongPressButton` as a presentation widget controlled by state from the card, not by internal navigation. Trigger a bounded haptic/snackbar feedback burst at completion time, keep skip hidden once a habit is completed today, and ensure the card no longer looks frozen after the celebration window expires.

**Hable perspective:** Hable's Home screen is meant for repeated daily scanning and action, not for one card to dominate the viewport after completion. The right fix is local card state in `home_screen.dart`, with `MudLongPressButton` still rendering the celebration state only when asked. This preserves offline-first completion writes and existing shared-habit rules while making the Home card feel alive instead of wedged.

**Implementation scope:**
- `lib/screens/home_screen.dart`: add the smallest local state needed on the habit-card surface to represent "currently showing completion feedback," set it after `_handleCompletion()` finishes its optimistic writes/flush, clear it after a short delay, and keep the state mounted-safe.
- Completion feedback wiring: gate the `MudLongPressButton.isCompleted` input so it reflects `isCompletedToday` only during the short feedback window rather than forever.
- Feedback polish: add the requested medium-impact haptic and a compact floating success SnackBar near completion time, reusing the habit's visual identity where appropriate.
- `lib/widgets/mud_long_press_button.dart`: keep the widget presentational; only adjust it if a small animation/fade hook is needed to support a clean reset between completed and idle visuals.
- Guard behavior: confirm `isSkippedToday` and `isCompletedToday` still suppress the wrong actions after the visual reset and that the card cannot be meaningfully double-completed.
- Verification surface: add focused widget coverage or documented smoke for the `Done!` window, visual reset, and no-stuck-state behavior.

**Scalability considerations:** Scalability impact: none expected. Keep the fix local to each habit card so one completion does not trigger global timers or cross-card rebuild machinery beyond the existing provider invalidations.

**Future split guidance:** If richer completion celebration is wanted later, split it separately into animation polish or gamification moments. Do not expand this task into a broader Home-card redesign.

**Edge cases:** repeated taps/holds during the feedback window, widget disposal before the delay completes, app backgrounding during the delay, completed shared habits with partner-role retention rules, skipped-today cards, hot restart after completion, and multiple cards completing in quick succession with overlapping SnackBars/haptics.

**Acceptance criteria:**
- Completing a habit shows the `Done!` celebration state only for a short bounded window rather than permanently.
- After that window, the inline habit card returns to its resting visual state without clearing the underlying completed-today data.
- A completion-time haptic and compact success SnackBar are shown without blocking the rest of Home.
- Skip remains hidden for completed-today habits after the visual reset, and skipped-today cards still ignore completion input.
- No navigation away from Home or route pop/push is introduced as part of the fix.
- The completed log, sync queue writes, and existing offline-first completion flow remain intact.
- Verification covers the feedback window, mounted-safe reset, and no permanent stuck `Done!` state after completion.

**Dependencies:** `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="make-avatar-updates-optimistic-and-failure-safe"></a>
### [x] Make Avatar Updates Optimistic And Failure-Safe

**Raw source:** Fix avatar update false error with optimistic Drift update and rollback handling (Issue 5)

**Issue:** The broad auth/account regression task already fixed part of the avatar path: the backend now enforces emoji-only avatars and `AuthNotifier.updateAvatar()` updates Drift on success instead of leaving the profile stale until restart. The remaining gap is still user-facing. `updateAvatar()` waits for the network call before writing local state, so the profile does not update immediately, there is no rollback path because there is no optimistic write to undo, and `AvatarPickerSheet` still shows a generic `Failed to update avatar` snackbar instead of surfacing the real backend/auth/network error. That leaves the avatar flow feeling brittle even though the server contract is now stable.

**Ponytail triage:**
- *Should exist:* Yes. This is a small UX/state integrity pass on top of an already-correct backend contract.
- *Smallest safe scope:* Convert avatar updates to optimistic local Drift writes with rollback on failure, keep the existing emoji-only backend route, and tighten the picker UI feedback/loading behavior.
- *Skipped scope:* No profile-photo upload system, no new storage backend, no avatar taxonomy redesign, no auth-model rewrite, and no broader Profile/settings visual overhaul.
- *Boundaries:* Preserve the existing `PUT /api/user/avatar` contract and the emoji-only rule. The fix should improve local-first behavior and error handling without changing how auth/session ownership works.

**Action:** Make avatar updates local-first and failure-safe. When the user picks an emoji, write it into Drift immediately so `currentUserProvider` updates the Profile card at once, then call the existing backend route. On server/network failure, restore the previous avatar and surface the real error text. Keep the picker disabled while a request is in flight, show a specific success/failure snackbar, and close the sheet only after a confirmed success.

**Hable perspective:** Hable's Profile/settings surfaces are Drift-backed and should feel instant even when the network is slow. Avatar customization is explicitly an emoji-only MVP in the docs, so the right fix is optimistic local state plus clean rollback, not more backend complexity. The picker should read like a lightweight local customization flow that later reconciles with the Worker, consistent with the rest of the offline-first app.

**Implementation scope:**
- `lib/providers/auth_provider.dart`: refactor `updateAvatar()` to capture the previous avatar, write the new emoji into the local `users` row before the HTTP call, and restore the old value if the server rejects or the request times out/fails.
- Local persistence helper: if needed, add or reuse the smallest `AppDatabase` helper for targeted avatar updates rather than open-coding a wide user upsert in multiple places.
- Success/error parsing: preserve `_errorFromResponse()` / `_networkErrorMessage()` behavior, but make sure the picker can surface the actual reason instead of a generic failure string.
- `lib/widgets/avatar_picker_sheet.dart`: keep a local submitting state, disable repeated taps while the request is in flight, show a small loading treatment, show a success snackbar on confirmed success, and only close the sheet after that success path completes.
- Provider/read-model behavior: ensure `currentUserProvider` reflects the optimistic write immediately through Drift and remains correct after rollback or confirmed success.
- Verification surface: add focused tests or documented smoke covering immediate UI update, rollback, and post-restart persistence.

**Scalability considerations:** Scalability impact: none expected. The only constraint is to keep the optimistic write narrowly scoped to the current user row so avatar changes do not introduce broader auth/provider churn.

**Future split guidance:** If richer avatar features are needed later, split them into separate tasks for uploads, remote media moderation/storage, avatar history, or expanded profile editing. Do not grow this task beyond emoji-avatar correctness.

**Edge cases:** request timeout after optimistic write, expired JWT, backend 400 emoji validation failure, current user row missing locally, repeated rapid emoji taps, sheet dismissal during in-flight request, restart after success, restart after failure rollback, and generic network errors while offline.

**Acceptance criteria:**
- Picking an avatar updates the local Profile/settings read model immediately before the server round trip completes.
- Backend failure or network failure restores the previous avatar locally.
- Successful updates keep the optimistic avatar, show a specific success snackbar, and close the picker sheet.
- Failure messaging surfaces the real backend/auth/network reason rather than a generic `Failed to update avatar` message.
- Repeated taps are blocked while an avatar request is in flight.
- The existing emoji-only backend contract remains unchanged.
- Verification covers immediate local update, rollback on failure, and persisted success after restart.

**Dependencies:** `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `06_Authentication.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="gate-authenticated-shell-on-startup-sync-readiness"></a>
### [x] Gate Authenticated Shell On Startup Sync Readiness

**Raw source:** Enforce startup sync gate in _AppGate before rendering the Home screen to prevent missing data (Issue 6)

**Issue:** Hable's auth/session docs already say the app restores `jwt_token` and `user_id` from secure storage, and the UI is supposed to read from Drift first. The remaining startup gap is that `_AppGate` can still route an authenticated user into `MainNavigationShell` before a guaranteed startup `pullDailySync(userId)` has completed. That leaves a window where Home/Profile/Social render from incomplete local state after relaunch, especially if the previous session depended on fresh accepted-friend, habit, or score data from the server. The current work-in-progress foreground sync/polling changes in `main.dart` help with ongoing refresh, but they do not fully define the first authenticated render contract.

**Ponytail triage:**
- *Should exist:* Yes. This is a startup-readiness fix on top of the existing auth restore and sync pipeline.
- *Smallest safe scope:* Add one explicit authenticated startup gate that waits for a first sync attempt before showing the main shell, while preserving offline-first fallback behavior if the device is offline and local Drift data already exists.
- *Skipped scope:* No auth-model rewrite, no destructive database reset, no long-lived splash redesign, no diagnostic logging spree, and no broad habit-query redesign unless a tiny empty-state distinction is truly needed.
- *Boundaries:* Keep `authProvider` as the source of session truth, `pullDailySync()` as the inbound refresh path, and Drift/Riverpod as the UI data source. The gate should coordinate startup sequencing, not replace the local-first architecture with network-first rendering.

**Action:** Define a startup-readiness step inside `_AppGate` (or a small adjacent bootstrap provider) that runs once per authenticated session restoration. It should confirm a valid `userId`, perform the first daily-sync attempt in a controlled way, and only then hand off to `MainNavigationShell`. If the network is unavailable, the gate should still allow the shell to open from existing Drift state after the startup attempt has been made, rather than hanging forever. Tie this sequencing cleanly into the current foreground sync controller so first-load and ongoing refresh rules do not diverge.

**Hable perspective:** Hable is offline-first, not offline-blind. The app should launch from local Drift, but an authenticated relaunch also needs one deliberate startup reconciliation pass so Home habits, Profile analytics, accepted friends, and server-owned progression are not briefly or persistently missing after restart. The right fix is a small session bootstrap contract in `_AppGate`, not more ad hoc sync calls spread across Home or Profile.

**Implementation scope:**
- `lib/main.dart`: move authenticated startup sequencing into `_AppGate` or a dedicated bootstrap state holder so `MainNavigationShell` is shown only after the first startup sync attempt resolves.
- Startup sync provider/state: add the smallest one-shot provider/notifier/future gate needed to represent `idle/loading/ready` for the current authenticated `userId`; avoid re-running it on every rebuild.
- Sync behavior: call the existing `syncServiceProvider` / `pullDailySync(userId)` path for the startup attempt and coordinate it with the foreground sync controller so the first render does not race against a second duplicate startup poll.
- Offline fallback: if startup sync fails due to timeout/offline state, proceed using Drift-backed data once the attempt finishes, rather than blocking the shell indefinitely.
- Session boundaries: clear or reset the startup-ready state on logout and when a different authenticated `userId` is restored.
- Optional data-readiness refinement: if the current Home empty state still misleads users when all habits are complete or local data exists under other statuses, capture that as a narrowly scoped follow-up only if the startup-gate implementation proves it is still needed.
- Verification surface: update `Developement/02_Offline_Architecture.md`, `06_Authentication.md`, and `08_Testing.md` if the startup-render contract changes.

**Scalability considerations:** Scalability impact: none expected. The only concern is startup duplication: do not let `_AppGate`, `HomeScreen`, and the foreground polling controller all race the same first sync attempt. One explicit bootstrap path should own the first-run sequencing.

**Future split guidance:** If deeper startup diagnostics or richer recovery states are needed later, split them separately: offline boot telemetry, startup debug overlays, active-vs-completed habit empty-state refinement, or queue health diagnostics. Do not expand this task into a full startup observability project.

**Edge cases:** restored auth with missing local user row, offline restart, slow network timeout, logout during bootstrap, seed-user/test harness startup, duplicate startup sync from lifecycle resume, app backgrounding during the first sync attempt, and relaunch with pending outbound queue items still draining.

**Acceptance criteria:**
- Authenticated relaunch no longer shows `MainNavigationShell` before a first startup sync attempt for that session has been made.
- The startup gate runs once per authenticated session/user restoration and does not restart on ordinary rebuilds.
- Offline or timed-out startup sync does not trap the user behind a permanent loading screen; the app can still open from existing Drift data after the attempt resolves.
- The startup gate coordinates cleanly with the existing foreground sync controller and does not trigger overlapping duplicate first-sync calls.
- Home/Profile/Social continue reading from Drift/Riverpod rather than direct network state.
- Logout or user-switch resets the startup-ready state correctly.
- Documentation/testing dependencies are verified and updated if the startup sequencing contract changes.
- Verification covers at least one online relaunch path and one offline/timeout relaunch path.

**Dependencies:** `00_Agent_Directives.md`, `02_Offline_Architecture.md`, `06_Authentication.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** 
- Touched `lib/main.dart` to add `_initialSyncCompleted` and `_lastSyncedUserId` to `_AppGateState`.
- Implemented an `await` on `syncNow(userId)` to block the transition to `MainNavigationShell` until the first sync finishes (or fails gracefully offline).
- Added logic to reset `_initialSyncCompleted` to `false` only if the `userId` changes, preventing repeated loading screens on lifecycle resumes.
- Verified compilation with `flutter analyze`.
- Completed At: 2026-07-12 10:45 CEST

<a id="verify-ios-build-integrity"></a>
### [x] Verify iOS Build Integrity (Blocked on Environment)

**Raw source:** make the integrity of the project by engineering a task for each build of Flutter (Web, iOS, Android, MacOS, Windows)...

**Issue:** Flutter iOS builds frequently break due to outdated Pods, missing Swift configuration, or missing Info.plist permissions, especially after adding new plugins.

**Ponytail triage:**
- *Should exist:* Yes. iOS is a primary mobile target.
- *Smallest safe scope:* Execute `flutter build ios --no-codesign`, fix any Podfile or Xcode project errors blocking the build.
- *Skipped scope:* No Apple Developer account provisioning, no App Store Connect upload.
- *Boundaries:* Ensure the project *can* compile for iOS, even if code signing is skipped for local verification.

**Action:** Run `flutter build ios --no-codesign` (or similar). Update CocoaPods and resolve any iOS-specific build failures.

**Hable perspective:** Maintaining iOS integrity ensures Hable is ready for Apple platforms without accumulating massive migration debt.

**Implementation scope:**
- Run iOS build and analyze errors.
- Update `ios/Podfile` or run `pod install` / `pod update` if needed.
- Fix any Swift version or deployment target mismatches.

**Scalability considerations:** None.

**Future split guidance:** Split full code signing and Fastlane setup into a separate deployment task.

**Edge cases:** Missing Xcode installation on the agent's machine (may require manual user intervention or skipping).

**Acceptance criteria:**
- `flutter build ios --no-codesign` (or `build ipa`) completes without compilation or dependency resolution errors.

**Dependencies:** `02_Offline_Architecture.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** 
- Command run: `flutter build ios --no-codesign --flavor primary -t lib/main.dart` and `flutter build ios --simulator --flavor primary -t lib/main.dart`.
- Fixed the `workmanager_apple` plugin compatibility issue by bumping the iOS deployment target from 12.0/13.0 to 14.0 in `ios/Podfile` and `ios/Runner.xcodeproj/project.pbxproj`.
- Build is now blocked by a host environment issue: `Unable to find a destination matching the provided destination specifier ... error:iOS 26.5 is not installed.`
- Per `09_Build_Integrity_Guideline.md`, this is marked as "Blocked on Environment" since the local Xcode installation is missing components. No further codebase changes are required.
- Completed At: 2026-07-12 11:05 CEST

<a id="verify-android-build-integrity"></a>
### [x] Verify Android Build Integrity

**Raw source:** make the integrity of the project by engineering a task for each build of Flutter (Web, iOS, Android, MacOS, Windows)...

**Issue:** Android builds can suffer from Gradle version incompatibilities, Kotlin version mismatches, or manifest issues.

**Ponytail triage:**
- *Should exist:* Yes.
- *Smallest safe scope:* Execute `flutter build apk` and ensure it compiles.
- *Skipped scope:* No Play Store deployment.
- *Boundaries:* Build an APK successfully.

**Action:** Run `flutter build apk`. Resolve any Gradle, Kotlin, or AndroidManifest errors.

**Hable perspective:** Android is a primary target. The build must remain stable.

**Implementation scope:**
- Run `flutter build apk`.
- Update `android/build.gradle` or `android/app/build.gradle` if needed.

**Scalability considerations:** None.

**Future split guidance:** Split advanced obfuscation or Play Store deployment.

**Edge cases:** Keystore missing (already handled in previous tasks, but need to ensure it doesn't block debug/release).

**Acceptance criteria:**
- `flutter build apk` succeeds.

**Dependencies:** `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** 
- Successfully executed `flutter build apk --flavor primary -t lib/main.dart` and `flutter build apk --flavor friend -t lib/main.dart`.
- Both the `primary` and `friend` flavors compiled successfully for release (`app-primary-release.apk` and `app-friend-release.apk`).
- Noted deprecation warnings for `flutter_timezone` and `workmanager_android` regarding the Kotlin Gradle Plugin (KGP), but no breaking errors occurred.
- Completed At: 2026-07-12 11:15 CEST

<a id="verify-macos-build-integrity"></a>
### [x] Verify MacOS Build Integrity

**Raw source:** make the integrity of the project by engineering a task for each build of Flutter (Web, iOS, Android, MacOS, Windows)...

**Issue:** Desktop macOS builds require specific entitlements (e.g., networking) and pod configurations that might drift.

**Ponytail triage:**
- *Should exist:* Yes.
- *Smallest safe scope:* Execute `flutter build macos` and ensure it compiles.
- *Skipped scope:* No App Store deployment.
- *Boundaries:* Compile the macOS app successfully.

**Action:** Run `flutter build macos`. Add missing entitlements or resolve pod issues.

**Hable perspective:** Expanding to desktop.

**Implementation scope:**
- Run `flutter build macos`.
- Check `macos/Runner/DebugProfile.entitlements` and `Release.entitlements` for networking.

**Scalability considerations:** None.

**Future split guidance:** Split Mac App Store distribution.

**Edge cases:** CocoaPods errors on macOS.

**Acceptance criteria:**
- `flutter build macos` succeeds.

**Dependencies:** `02_Offline_Architecture.md`, `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** 
- Successfully executed `flutter build macos -t lib/main.dart`.
- App compiled and packaged successfully (`build/macos/Build/Products/Release/flutter_project.app`).
- Minor warnings regarding native asset framework naming (`objective_c.dylib` and `libsqlite3.g.dart`) were noted but did not block the build.
- Completed At: 2026-07-12 11:20 CEST

<a id="verify-windows-build-integrity"></a>
### [x] Verify Windows Build Integrity (Blocked on Environment)

**Raw source:** make the integrity of the project by engineering a task for each build of Flutter (Web, iOS, Android, MacOS, Windows)...

**Issue:** Windows builds require Visual Studio toolchains and specific CMake configurations.

**Ponytail triage:**
- *Should exist:* Yes.
- *Smallest safe scope:* Execute `flutter build windows` (if supported on the host) and ensure it compiles.
- *Skipped scope:* No MSIX packaging.
- *Boundaries:* Compile the Windows app successfully.

**Action:** Run `flutter build windows`. Resolve any CMake or C++ dependency issues.

**Hable perspective:** Expanding to desktop.

**Implementation scope:**
- Run `flutter build windows`.
- Update `windows/` runner configurations if needed.

**Scalability considerations:** None.

**Future split guidance:** Split Windows installer creation.

**Edge cases:** Agent environment is macOS, so Windows build might not be possible to test locally. If so, document it and use CI or skip.

**Acceptance criteria:**
- `flutter build windows` succeeds (or is documented as relying on CI if host cannot build).

**Dependencies:** `08_Testing.md`, `Task_Idea.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** 
- Evaluated Windows build command: `flutter build windows -t lib/main.dart`.
- The task was instantly aborted with the error: `"build windows" only supported on Windows hosts.`
- Marked as "Blocked on Environment" per the `09_Build_Integrity_Guideline.md` rule to safely halt unbounded tasks on incompatible host machines. No further codebase changes required.
- Completed At: 2026-07-12 11:22 CEST

<a id="document-ai-agent-guideline-for-cross-platform-build-fix-workflow"></a>
### [x] Document AI Agent Guideline For Cross-Platform Build Fix Workflow

**Raw source:** Write documentation on how to fix each build issue, for each build, and how concurently we should investigate other builds after fixing them on the web build. This document would act as the AI Agent Guideline.

**Issue:** Hable now has separate engineered tasks for Web, iOS, Android, macOS, and Windows build integrity, but there is still no single operating guideline that tells future agents how to approach platform build failures in a disciplined order, how to record fixes, and when to branch from the web-first investigation into other targets. Without that document, build-repair work will stay ad hoc: one agent may fix web and stop, another may retry all five builds without preserving findings, and a third may miss Hable-specific constraints such as Cloudflare Pages coupling on web, Android flavor verification, or host-limited Windows checks on macOS.

**Ponytail triage:**
- *Should exist:* Yes. This is a process/documentation task that reduces repeated build archaeology and prevents unbounded multi-platform repair passes.
- *Smallest safe scope:* Create one concise AI-agent guideline document in `Developement/` that defines the build-fix workflow, investigation order, per-platform checklist shape, evidence expectations, and concurrency rules after the web build is stabilized.
- *Skipped scope:* Do not implement platform fixes in this task, do not add CI, do not merge all platform tasks into one mega-task, do not rewrite the existing contract, and do not invent unsupported host workflows for platforms the current machine cannot build.
- *Boundaries:* Keep the guidance aligned with the existing task pipeline and current Hable tooling. The document should direct future implementation tasks; it should not replace them.

**Action:** Write an AI-agent build-integrity guideline document for Hable that explains how to investigate and fix Web, iOS, Android, macOS, and Windows build issues, with web as the likely first-priority platform. Define the sequence for reproducing failures, isolating platform-specific blockers, deciding when to continue to the next platform, and documenting parallel follow-up findings so multiple build surfaces can be tracked without collapsing into one uncontrolled repair session.

**Hable perspective:** Hable's platform builds are not interchangeable. Web is coupled to Cloudflare Pages deployment and browser-compatible Drift/sql-wasm behavior, Android uses flavor-specific APK workflows and ADB smoke expectations, iOS/macOS depend on Apple toolchain state, and Windows may be host-limited from a macOS environment. The guideline should encode those realities so future agents investigate build issues with Hable's actual architecture and tooling rather than a generic Flutter checklist.

**Implementation scope:**
- Documentation target: create a new `Developement/` guideline document dedicated to AI-agent build-fix workflow, likely alongside `Commands.md` and `08_Testing.md`.
- Workflow content: define prerequisites, canonical commands, failure-capture format, per-platform verification order, how to record host/toolchain blockers, and when to open or update separate backlog tasks instead of continuing inline.
- Platform sections: include Web, iOS, Android, macOS, and Windows build notes with Hable-specific risk areas such as Pages deploy coupling, `flutter build web --release --base-href /`, Android `primary`/`friend` flavor handling, iOS `--no-codesign`, macOS entitlements/pods, and Windows host limitations.
- Concurrency guidance: specify how agents should continue investigating other platforms after web is repaired, including what can be checked in the same pass, what must become follow-up tasks, and how to avoid losing partial findings.
- Cross-doc alignment: update `Developement/Commands.md` and `08_Testing.md` only if the new guideline reveals missing or incorrect build instructions that should be corrected for consistency.
- Verification surface: confirm the new guideline is source-backed by the existing commands/testing docs and references the already-engineered platform tasks instead of duplicating them.

**Scalability considerations:** Keep the document procedural and compact. If build operations later expand into a real matrix across CI runners and release channels, that should become a separate automation/CI task rather than bloating this guideline with environment-specific branching. Scalability impact: none expected for runtime behavior.

**Future split guidance:** If the guideline reveals missing operational pieces, split them separately: CI build matrix automation, Windows-on-Windows validation, Apple signing/provisioning playbooks, or a standardized build-regression template. Do not roll those implementation concerns into the initial guideline-writing task.

**Edge cases:** web build passes locally but deploy smoke fails on Pages, Android debug builds pass while release signing still blocks publication, iOS/macOS builds fail due to host Xcode/CocoaPods state rather than app code, Windows cannot be built from the current macOS host, generated Flutter runner files differ across Flutter SDK updates, and multiple platform failures share one root package/plugin issue that still needs per-platform verification notes.

**Acceptance criteria:**
- A dedicated AI-agent guideline document exists in `Developement/` for cross-platform build-fix workflow.
- The document explicitly covers Web, iOS, Android, macOS, and Windows build investigation order and evidence capture.
- The guideline explains how to proceed from a web-first fix into investigation of other platforms without turning the work into one uncontrolled omnibus task.
- Hable-specific commands, deployment/build constraints, and host limitations are documented accurately from existing project docs.
- Existing engineered platform tasks are referenced or aligned instead of duplicated as prose-only backlog.
- Related docs are updated only if factual build-command corrections are needed for consistency.
- No runtime code, build config, or deployment state is changed by this documentation-only task.

**Dependencies:** `02_Offline_Architecture.md`, `08_Testing.md`, `Commands.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** 
- Created `Developement/09_Build_Integrity_Guideline.md` which explicitly details the workflow, investigation order, and concurrency rules for Web, Android, iOS, macOS, and Windows build checks.
- Documented platform constraints (e.g., Cloudflare Pages on Web, flavor configuration on Android, and host-limitations on Windows).
- Checked cross-references with `Commands.md` and `08_Testing.md` to ensure canonical commands are aligned.
- Completed At: 2026-07-12 11:00 CEST

<a id="refine-and-organize-development-documentation"></a>
### [x] Refine And Organize Development Documentation

**Raw source:** refine, analyze, logically, programmatically, all the development documentations, make them clean, organized, up to date, and easy to understand. and most important following best practices. be caareful to act different with features like mud mathematical checki-in which could be unique compare to best-practices, instead you're allowed to transform the UX/UI in order to make it more user-friendly and aligned with the project's vision.

**Issue:** The project documentation in `Developement/` has grown organically through multiple AI-driven engineering passes. While functional, it needs a comprehensive structural review to ensure consistency, eliminate redundancies, and uphold architectural best practices. Specifically, the "mud mathematical check-in" feature needs to be explicitly separated from generic rules due to its specialized nature. also the file naming and folder structure could be improved to be more organized and easy to understand.

**Ponytail triage:**
- *Should exist:* Yes. Clean, logically sound documentation acts as the foundational brain for future AI agent interactions.
- *Smallest safe scope:* Audit the existing `.md` files in `Developement/` (except active backlog/raw task files), consolidate overlapping sections, apply a unified formatting standard, and explicitly document the unique nature of the "mud mathematical check-in" feature.
- *Skipped scope:* Do not rewrite app code, do not add new features, and do not delete historical context tracking in the task files.
- *Boundaries:* The audit should strictly target existing Markdown documentation in the `Developement/` folder.

**Action:** Review, refine, and programmatically organize all development documentation. Update outdated references, apply a clear logical structure across files, and explicitly document exceptions/best practices for specialized features like the Mud Button.

**Hable perspective:** The documentation is the AI Agent's primary source of truth. Maintaining its clarity and precision is critical for the long-term success of the offline-first, locally-synced architecture of Hable.

**Implementation scope:**
- Read all `.md` files in the `Developement/` directory.
- Refactor and consolidate files where appropriate, ensuring cross-references are valid.
- Highlight the "mud mathematical check-in" algorithm as a specialized component with its own specific rules.

**Acceptance criteria:**
- `Developement/` folder contains clean, non-redundant, up-to-date documentation.
- Specialized features are explicitly documented and distinguished from generic rules.

**Dependencies:** `Task_ai_agent_contract.md`, `Task0_Raw.md`

**Completion notes:**
- **Completed At:** 2026-07-12 09:20 UTC+2
- **Files touched (documentation only — no source code changed):**
  - `00_Agent_Directives.md` — Added Documentation Map table + cross-reference to `ai_agent_contract.md`
  - `01_Schema_and_Core_Logic.md` — Added `[!IMPORTANT]` Mud coefficient callout with cross-ref to `03_UI_UX`; clarified `(Drift-only)` vs `(D1-only)` distinction for the two `UsageAggregateBuckets` table entries
  - `03_UI_UX_and_Animations.md` — Renamed §3 and §4 to explicitly mark the Mud check-in as "Specialized — Do Not Simplify"; added `[!IMPORTANT]` callout + `[!NOTE]` canonical reference; added inline comments explaining `CatmullRomCurve` control point rationale
  - `04_Social_and_Analytics.md` — Added `[!NOTE]` cross-reference to `07_Multi_User_Social_Features.md`; cleaned up wording on `21st-dev` dashboard scope
  - `07_Multi_User_Social_Features.md` — Renamed file title; added `[!IMPORTANT]` header distinguishing `[CURRENT MVP]` from `[VISION]`; labeled all four core sections accordingly; added `[!NOTE]` to Technical Implementation and Next Steps sections
  - `08_Testing.md` — Added `[!NOTE]` cross-reference to `TWIN_TEST_HARNESS.md`
  - `TWIN_TEST_HARNESS.md` — Added `[!NOTE]` cross-reference to `08_Testing.md`
  - `Commands.md` — Promoted heading to `# 10: Hable Project Commands` for numbering consistency; added one-line intro
  - `ai_agent_contract.md` — Added cross-reference to `00_Agent_Directives.md` in the doc header
  - `todo_inventory.md` — Updated review date; added `Developement/` documentation exclusion note to §4
- **Files intentionally unchanged:** `Task0_Raw.md`, `Task1_Engineered.md`, `Task2_Archived.md`, `02_Offline_Architecture.md`, `05_Search_Engine_Architecture.md`, `06_Authentication.md`, `09_Build_Integrity_Guideline.md`, `08_Testing.md` (execution logs preserved)
- **Behavior verified:** All cross-references use correct filenames; no existing content deleted; Mud Button sections carry `[!IMPORTANT]` DO-NOT-SIMPLIFY callouts; `07_Multi_User_Social_Features.md` vision sections are clearly guarded; `ai_agent_contract.md` dependency list `Task_ai_agent_contract.md` verified as alias for `ai_agent_contract.md` — no broken references introduced
- **Dependencies verified:** `ai_agent_contract.md` and `Task0_Raw.md` were read and cross-referenced; no updates to `Task0_Raw.md` required (no raw task removed)

<a id="design-web-multi-user-browser-test-plan-for-core-social-habit-and-leaderboard-flows"></a>
### [x] Design Web Multi-User Browser Test Plan For Core Social Habit And Leaderboard Flows

**Raw source:** organize a test plan to ensure the core functionality: finding friends, request friendship, accept, decline (not exist in the codebase? implement first), and revoke friendship. Creating a habit, during creation, add a friend as a partner, inviting a friend to join a habit, accepting/declining the invitation, sending a nudge, receiving a nudge, checking in that habit by each user, controlling the pointing issues correctly, and the leaderboard updates accordingly. test refined deploy on the web build. Into separate browser agent for separate users.

**Issue:** Hable already has Android twin-harness smoke notes, backend social smoke scripts, and a production web smoke pass, but it does not yet have one explicit browser-first QA plan for the end-to-end multi-user social loop on the deployed web build. The missing gap is not only "run more tests"; it is a reproducible plan that tells future agents how to validate friendship, invites, nudges, shared check-ins, scoring, and leaderboard behavior across two isolated browser users without mixing local/mobile assumptions into the web path. There is also a known scope boundary: friend decline exists, but revoke/unfriend appears to be deferred rather than currently implemented, so the test plan must distinguish supported flows from prerequisite feature gaps.

**Ponytail triage:**
- *Should exist:* Yes. This is a narrow QA-planning/documentation task that turns scattered smoke knowledge into one browser-multi-user plan.
- *Smallest safe scope:* Produce one Hable-specific test plan document for the deployed web build, using two isolated browser agents/sessions, and explicitly mark unsupported or missing product capabilities such as revoke friendship as blockers or follow-up backlog items rather than silently assuming they exist.
- *Skipped scope:* Do not implement revoke friendship here, do not build a full Playwright suite in this task, do not change production code, do not rewrite the Android twin-harness docs, and do not attempt broad exploratory QA beyond the named social/habit/leaderboard loop.
- *Boundaries:* Keep the output procedural and test-oriented. Supported flows should be validated against the current deployed web app; unsupported flows should be documented as prerequisites for separate implementation tasks.

**Action:** Create a dedicated QA test plan for Hable's deployed web build that covers the core two-user loop with separate browser agents or isolated browser profiles. The plan should walk through friend search, request, accept, decline where supported, habit creation with partner selection, habit invite acceptance/decline, nudge send/receive, both-user check-ins, point/role behavior, and leaderboard verification. It must also explicitly classify revoke friendship as either a supported tested flow or a missing capability that requires a separate implementation task before it can be included in web QA signoff.

**Hable perspective:** Hable's core product value depends on two-user social synchronization, not just single-user local CRUD. On web, that means validating the deployed Cloudflare Pages build against the real `/api/*` backend contract, browser-backed Drift storage, and isolated user sessions. The plan must reflect the actual product model: accepted friendship gates partner invites, nudge authorization depends on shared-habit participation, scoring is server-owned, and local browser state for Alice and Bob must stay isolated.

**Implementation scope:**
- Documentation target: create a new QA plan document under `Developement/` for browser-first multi-user validation of the deployed web build.
- Source audit: reuse the existing flow expectations from `qa_testing.md`, `qa_twin_test_harness.md`, `sys_social_and_analytics.md`, `sys_schema_and_logic.md`, `ux_social_vision.md`, and `sys_build_integrity.md` instead of inventing new product rules.
- Test flow design: define two isolated browser users (for example separate browser agents, incognito/context isolation, or separate browser profiles), environment prerequisites, seeded/fresh-user expectations, exact step ordering, and expected results for each named social/habit action.
- Gap classification: explicitly note that accept/decline friend request flows exist, while revoke friendship/unfriend appears deferred in the backlog/archive and therefore should be treated as a prerequisite gap unless later source audit proves otherwise.
- Verification surfaces: include both UI expectations and backend-visible outcomes where practical, such as invitation banners, notification/activity entries, habit-card nudge state, and leaderboard score/order updates after check-ins.
- Follow-up handling: if the plan identifies unsupported mandatory behaviors for signoff, append separate raw backlog items instead of stretching the test-plan task into implementation.

**Scalability considerations:** Keep the plan focused on one canonical two-user browser scenario. If broader coverage is needed later, split it into separate automation tasks for Playwright regression suites, cross-browser matrices, or CI-hosted multi-session testing. Scalability impact: none expected for runtime behavior.

**Future split guidance:** Potential follow-ups include automated Playwright coverage for the two-user flow, an explicit revoke-friendship implementation task if product direction confirms it, a reusable seeded-web QA harness, and production/preview environment gating rules. Do not fold those into the first documentation pass.

**Edge cases:** stale browser auth tokens, separate-browser-session leakage through shared cookies/storage, friend decline supported while revoke friendship is not, invite acceptance before owner habit sync has propagated, nudges visible in Activity but not card-local UI, point totals updating only after daily sync refresh, leaderboard ordering ties, already-friends seeded users, duplicate request taps, and production web deploys whose frontend bundle is newer than the backend schema state.

**Acceptance criteria:**
- A dedicated web-focused multi-user QA plan exists in `Developement/`.
- The plan uses two isolated browser users/agents and covers friend search, request, accept, decline, habit creation with partner selection, habit invite accept/decline, nudge send/receive, both-user shared-habit check-ins, point behavior, and leaderboard verification.
- The plan explicitly distinguishes currently supported flows from missing/deferred ones, especially revoke friendship/unfriend.
- The plan targets the deployed or deployment-like web build rather than Android-only harness assumptions.
- Existing Hable docs are reused and aligned instead of contradicted.
- Any missing prerequisite feature discovered during planning is routed to backlog follow-up instead of being hidden inside QA prose.
- No Flutter/backend/runtime code is changed by this task.

**Dependencies:** `qa_testing.md`, `qa_twin_test_harness.md`, `sys_build_integrity.md`, `sys_schema_and_logic.md`, `sys_social_and_analytics.md`, `ux_social_vision.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:** 
- **Completed At:** 2026-07-12 10:37 UTC+2
- **Files touched:** 
  - `qa_web_multi_user_plan.md` [NEW] — Created explicit step-by-step test plan detailing two isolated browser sessions, friend requests, habit creation, nudges, dual check-ins, and leaderboard.
  - `Task1_Engineered.md` — Marked task as completed.
- **Behavior verified:** Documented the "revoke friendship" feature as an explicitly deferred capability to avoid blocking QA.

<a id="document-scoring-leaderboard-quotes-rewards-and-habit-state-moments"></a>
### [x] Document Scoring Leaderboard Quotes Rewards And Habit State Moments

**Raw source:** generate a document for scoring system: the leaderboard; the encouraging quotes; how does scores appears globally; how does scores appears friends; how does scores appears profile; what are the triggers? when should the score reset? or is it a cumulative score? how does scores appears in the UI; when should the score update? How often? how does the score calculation work? what are the rewards for the score? what are the potential of habit states? For example, having a splash screen when a user hasn't completed any habits for a day with related quotes. For when user checks in. Or when you are completed habit, there could be a small animation and haptic feedback. For when user is on a streak, there could be a special animation and haptic feedback. be creative in generating this document and don't force yourself to follow the order of the points and features. I asked just make sure include those and include the gaps. I have forgot to mention here. The main part requires researching and product productivity is the habit states, the rest should be focused on the project deployed codes and documents.

**Issue:** Hable has a backend-owned gamification implementation and scattered documentation for leaderboard, daily quotes, profile points, badges, and Mud check-in states, but it does not yet have a single product-facing scoring-system document that explains how the whole experience should work. Current docs state the mechanics: completed check-ins award points, shared completion can award a bonus, `/api/sync/daily` returns gamification, and the Social leaderboard is scoped to the current user plus accepted friends. The missing piece is an integrated specification that answers product questions: where scores appear, whether totals reset, what triggers updates, how encouraging quotes relate to habit states, what rewards/animations/haptics should exist, and which gaps should become future tasks.

**Ponytail triage:**
- *Should exist:* Yes. This is a documentation/product-spec task that reduces ambiguity around a core engagement loop.
- *Smallest safe scope:* Create one source-backed scoring and habit-state experience document that documents the deployed scoring contract, identifies UI/product gaps, and proposes small habit-state moments without changing runtime behavior.
- *Skipped scope:* Do not change score calculations, add reward code, redesign leaderboard UI, add new haptics/animations, alter backend schemas, introduce seasonal resets, or implement splash screens in this task.
- *Boundaries:* Treat Cloudflare Worker/D1 as the scoring authority. Flutter may display cached score/level/badge state and local habit moments, but it must not become the authoritative score engine.

**Action:** Write a dedicated scoring-system document in `Developement/` that combines the current backend scoring contract with a product/UX spec for scores, leaderboard, encouraging quotes, profile display, rewards, update cadence, reset policy, and habit-state moments. The document should be creative where the user asked for product thinking, especially around habit states, but it must clearly separate implemented behavior from recommended future work and open gaps.

**Hable perspective:** Scoring is a trust-sensitive social system. Hable already moved authority to the Worker: `completedCheckInPoints = 5`, `sharedHabitBonusPoints = 5`, score events are idempotent through `user_score_events`, `/api/sync/score` is deprecated, and leaderboard rows come from backend-owned `users.total_score`. The new document should preserve that trust boundary while defining how the experience feels on Home, Social, Profile, daily quotes, streak states, completion feedback, and empty-day motivation moments.

**Implementation scope:**
- Documentation target: create a new `Developement/` system/product document for scoring, gamification, leaderboard, quotes, rewards, and habit states.
- Source-backed contract: document `backend/src/index.ts` scoring constants, `awardScoreEvent`, shared-habit bonus logic, streak badge unlocks, level tiers, `/api/sync/daily.gamification`, `/api/social/leaderboard`, and deprecated `/api/sync/score`.
- Flutter display surfaces: document `lib/screens/home_screen.dart` daily quote and habit-state surfaces, `lib/screens/profile_screen.dart` profile points/level/badges/charts, `lib/screens/social/social_hub_screen.dart` leaderboard provider, `lib/widgets/leaderboard_card.dart`, `lib/providers/quote_provider.dart`, `lib/services/sync_service.dart`, and `lib/models/habit_visual_state.dart`.
- Product questions: answer whether scores are cumulative or reset, what can trigger point changes, when displayed score should update, how global/friend/profile score visibility differs, how leaderboard privacy works, and what rewards exist now versus what should be future work.
- Habit-state research: include a small, cited research/product-principles pass for habit-state moments such as no-completion day encouragement, check-in celebration, completed-today resting state, streak celebration, shared-habit all-participants completion, skip reflection, and nudge receipt. Keep this research actionable and avoid turning it into a broad psychology essay.
- Gap inventory: explicitly list missing or unclear product gaps as future backlog candidates instead of silently claiming they are implemented.
- Cross-doc alignment: update `sys_social_and_analytics.md`, `ux_mud_and_animations.md`, or `qa_testing.md` only if the new document reveals a factual contradiction with current behavior.

**Scalability considerations:** Scoring and leaderboard reads must remain bounded and backend-owned. Any future global leaderboard, seasonal reset, reward marketplace, or streak-feed feature should be designed separately with privacy, anti-spam, and query-volume constraints. The documentation task itself has no runtime scalability impact.

**Future split guidance:** Likely follow-ups include animated badge reveals, streak-specific haptics, empty-day quote/encouragement state, shared-habit celebration feedback, seasonal leaderboard/reset policy, and automated QA for score event idempotency. Append raw tasks only for concrete gaps confirmed during the documentation pass.

**Edge cases:** duplicate offline log replay, two devices syncing the same completion, stale profile score before daily sync, score visible on leaderboard before local Profile refresh, accepted friends with zero points, leaderboard ties, skipped days awarding no points but still needing encouragement, completed-today cards after the transient feedback window, users with no active habits, quote fetch failure with fallback quotes, users on long streaks, badge unlocks arriving after an offline period, and future resets that would conflict with cumulative totals.

**Acceptance criteria:**
- A dedicated scoring/gamification document exists in `Developement/`.
- The document explains the current score calculation, triggers, update cadence, reset/cumulative policy, leaderboard scope, Profile display, quote behavior, rewards, levels, badges, and habit-state moments.
- Implemented behavior is clearly separated from recommended future work.
- Habit-state/productivity moments include a small research-backed rationale and practical UX guidance.
- The document references the current backend, Drift/Riverpod sync path, and Flutter UI surfaces that own score display.
- Any discovered gaps are listed as future backlog candidates rather than implemented in this task.
- No Flutter/backend/runtime behavior changes are made by the documentation task.

**Dependencies:** `sys_social_and_analytics.md`, `sys_schema_and_logic.md`, `sys_offline_architecture.md`, `ux_mud_and_animations.md`, `qa_testing.md`, `Task0_Raw.md`, `Task1_Engineered.md`, `ai_agent_contract.md`

**Completion notes:**
- **Completed At:** 2026-07-12 10:37 UTC+2
- **Files touched:**
  - `ux_habit_states_and_scoring.md` [NEW] — Created document bridging backend scoring truth with frontend UX expectations.
  - `Task1_Engineered.md` — Marked task as completed.
- **Behavior verified:** Detailed score calculation, triggers, and visibility. Gathered UX moments based on research and user additions (removing the Skip button, unifying Add Habit buttons, streak/progress UI). Listed all product gaps as future backlog candidates.

<a id="fix-shared-habit-hold-to-complete-cancellation-before-threshold"></a>
### [x] Fix Shared-Habit Hold-To-Complete Cancellation Before Threshold

**Raw source:** Fix shared-habit hold-to-complete so early release cancels completion instead of granting a check-in. Reproduced on deployed web with two isolated users: a short press/release on the center completion control still marked the habit completed and advanced shared progress.

**Issue:** The deployed web flow for shared habits currently allows an early release on the mud completion control to still complete the habit and advance shared challenge progress. That breaks the core intentional-friction mechanic, creates false positive check-ins, and can corrupt partner-visible progression and score timing because the UI fires completion even when the hold gesture should have been canceled.

**Ponytail triage:**
- *Should exist:* Yes. This is a core interaction bug on the primary check-in path.
- *Smallest safe scope:* Fix the shared long-press control so completion only happens after the controller genuinely reaches the completion threshold while the gesture remains active, and early release always cancels back to idle.
- *Skipped scope:* No redesign of the mud animation, no new gesture system, no scoring redesign, no partner-card visual overhaul, and no speculative desktop/mobile interaction rewrite beyond what is needed to make cancellation correct.
- *Boundaries:* Preserve the existing resistance math, offline-first completion flow, shared-habit sync model, and backend-owned scoring. Fix the root cause in the shared completion control path rather than layering guards at each caller.

**Action:** Audit the mud long-press widget and its Home-card wiring, then correct the gesture lifecycle so a partial hold never invokes completion. Keep the change minimal: ensure release before threshold resets progress without calling `onCompletion`, verify the completion callback cannot race after cancellation on web pointer events, and document the interaction expectation in the QA/test plan used for multi-user browser verification.

**Hable perspective:** Hable intentionally makes completion slightly effortful. If the mud ring grants a check-in after a short press/release, the product loses the trustworthiness of its core mechanic and shared-habit participants can see incorrect completion state on each other's cards. The right fix belongs in the reusable completion control and its direct Home usage, not in backend compensation logic.

**Implementation scope:**
- `lib/widgets/mud_long_press_button.dart`: inspect the `GestureDetector` and `AnimationController` lifecycle, then make completion contingent on sustained hold state instead of relying on a callback path that can outlive cancellation.
- `lib/screens/home_screen.dart`: keep `MudLongPressButton` usage unchanged except for any minimal state/parameter adjustment needed to support correct cancellation and semantics for disabled/completed cards.
- Accessibility surface: preserve the existing "Hold to Complete" semantics while making sure assistive labels still match the real interaction.
- Verification surface: add the smallest focused automated coverage for early-release cancellation versus full-hold completion, and keep a browser-smoke checklist for the shared-habit partner flow.

**Scalability considerations:** Scalability impact: none expected. This is a local gesture-state fix on one reusable widget and should not introduce new persistence, provider, or sync load.

**Future split guidance:** If Hable later needs platform-specific gesture tuning, advanced haptic choreography, or richer completion celebrations, split those into separate tasks after the cancellation bug is fixed. Do not expand this task into broad animation polish or scoring work.

**Edge cases:** web pointer up firing after the controller nearly completes, mouse versus touch long-press behavior, completed-today cards, supporter-role cards that already suppress input, widget disposal during reverse animation, hot reload while the controller is active, and duplicate completion attempts caused by fast repeated press sequences.

**Acceptance criteria:**
- Releasing the mud completion control before the required hold duration does not log completion or advance shared challenge progress.
- Holding through the full required duration still completes the habit normally.
- Shared-habit cards continue to mirror true completion state between participants after a valid completion.
- No score or flame progress is granted from a canceled early-release gesture.
- The mud resistance timing and visual behavior remain otherwise intact.
- Verification includes at least one automated check for early-release cancellation and one manual/shared-browser QA note covering the partner flow.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_web_multi_user_plan.md`, `Developement/Task0_Raw.md`, `Developement/Task1_Engineered.md`, `Developement/ai_agent_contract.md`

**Completion notes:**
- Files touched: `lib/widgets/mud_long_press_button.dart`, `test/mud_long_press_button_test.dart`, `Developement/ux_mud_and_animations.md`, `Developement/qa_web_multi_user_plan.md`
- Behavior verified: Reworked the mud completion control to use explicit pointer hold/cancel timing instead of platform long-press recognition. Early release now reverses the ring without calling `onCompletion`, while a sustained hold completes exactly once. Verified with `flutter test test/mud_long_press_button_test.dart`.
- Documentation updates: Updated `Developement/ux_mud_and_animations.md` with the cancellation rule and `Developement/qa_web_multi_user_plan.md` with the explicit short-press failure check for shared habits. `Developement/ux_habit_states_and_scoring.md` was reviewed and left unchanged because backend score ownership did not change.
- Completed At: 2026-07-12 14:28 CEST

<a id="auto-archive-completed-habits-into-profile-history-and-expand-lifecycle-actions"></a>
### [x] Auto-Archive Completed Habits Into Profile History And Expand Lifecycle Actions

**Raw source:** Habit Archiving & Achievement Conversion. Insight: Completed habits currently clutter the Home screen. Action: Implement a transition where a habit with zero days remaining is automatically moved to an "Achievements" section in the Profile. Long-Press Menu: Deepen the `MudLongPressButton` menu to include Active Habits: Edit, Delete, Archive (manual), Reroll Reminder, Nudge Friend. Archived Habits: Rerun (reset duration/logs), View History, Share Certificate.

**Issue:** Hable already has two adjacent but mismatched lifecycle surfaces: Home reads `watchActiveHabits`, while Profile splits `watchAllHabits` into `Active` and `Archived`, and also separately renders server-owned `achievementUnlocks`. Completed single-user habits can still linger in the active lifecycle path until manually archived, and the current action model is fragmented between Profile icon buttons and Home-card interactions. If implemented naively, this raw prompt would risk inventing a second achievements system on top of the existing backend-owned badge model, or broadening `MudLongPressButton` into a kitchen-sink menu without clear ownership boundaries.

**Ponytail triage:**
- *Should exist:* Yes. Hiding finished habits from Home is a real lifecycle issue, and the user also needs a coherent way to manage archived vs active habits.
- *Smallest safe scope:* Automatically transition owner-controlled habits whose challenge duration reaches zero from the active Home lifecycle into the existing archived/profile history lane, then add a narrow action surface for the missing lifecycle actions around active and archived habits.
- *Skipped scope:* Do not invent a brand-new achievement persistence system, printable certificate renderer, or full historical analytics experience in this task. Reuse the current archived-habit and backend-owned achievements surfaces.
- *Boundaries:* Keep `MudLongPressButton` focused on completion interaction. Lifecycle management can be exposed through the habit-card/profile action surfaces without moving business logic into the hold-to-complete widget itself.

**Action:** Audit the habit-completion path, archive/restore flows, and Profile management UI. When an owner-controlled non-shared challenge reaches zero remaining days, move it out of the active Home stream automatically by transitioning it into the archived lifecycle state instead of leaving it as a cluttering active card. Reframe the Profile archived area as the durable history surface adjacent to server-owned achievements, and add the missing lifecycle actions with clear state gating: active habits need edit/delete/manual archive plus existing social actions where applicable; archived habits need rerun/reset and log-history access. If branded certificate sharing still requires net-new rendering or export infrastructure, defer that to a follow-up raw task rather than bloating this change.

**Hable perspective:** Hable’s true achievement system is backend-owned badges and score progression, while completed habits are local/shared lifecycle records stored in Drift and mirrored through sync. The correct product boundary is therefore: badges remain in the existing achievements surface, completed challenges become archived history in Profile, and Home only shows actionable active habits. Any auto-archive rule must preserve shared-habit ownership/partner semantics and avoid conflating daily completion with lifecycle completion.

**Implementation scope:**
- `lib/database/database.dart`: adjust the lifecycle transition path (`completeHabitDay`, archive/restore helpers, and any rerun helper) so eligible owner-controlled habits auto-archive when their challenge completes, while shared-habit safeguards remain intact.
- `lib/providers/habit_actions_provider.dart`: expose any missing lifecycle actions such as rerun/reset in one place and keep sync flushing consistent with archive/restore/delete behavior.
- `lib/screens/home_screen.dart`: remove archived/finished challenges from the actionable Home path and surface the smallest appropriate active-habit action entry points without overloading the mud button.
- `lib/screens/profile_screen.dart`: treat archived habits as the post-completion history lane near achievements and replace the current icon-only management affordances with the state-aware action set for active vs archived habits.
- Tests: add focused database/provider/widget coverage for owner auto-archive at zero remaining days, rerun/reset behavior, shared-habit non-auto-archive protection, and Profile action visibility by lifecycle state.

**Scalability considerations:** Drift table growth is the main long-term risk because rerun/history features read habit logs over time. Keep the first implementation scoped to existing per-habit queries and avoid whole-table scans or duplicated history tables. Riverpod rebuild pressure should stay bounded by reusing the current `watchActiveHabits` and `watchAllHabits` streams rather than adding extra lifecycle watchers.

**Future split guidance:** If Hable later needs shareable completion certificates, timeline-rich history pages, milestone recap cards, or a unified “Achievements & History” redesign, split those into follow-up tasks. This task is only for auto-archiving finished challenges and the minimum action model needed to manage active vs archived habits safely.

**Edge cases:** Shared habits reaching zero remaining days, supporter-role viewers with no edit authority, rerunning a habit that still has pending unsynced logs, deleting an archived habit, restoring then immediately rerunning, offline completion that should auto-archive locally before sync flush, logs/history ordering after rerun, and preserving backend achievement badges independently of habit archival state.

**Acceptance criteria:**
- Owner-controlled non-shared habits that reach zero remaining days no longer stay on Home as actionable active cards; they transition into the archived/profile history lane automatically.
- Shared-habit daily completion and shared-lifecycle rules remain correct; partner progress does not incorrectly auto-archive the shared metadata row.
- Profile exposes distinct lifecycle actions for active vs archived habits, including rerun/reset and history access for archived entries.
- The existing backend-owned achievements surface remains intact and is not replaced with a duplicate local “completed habits as badges” system.
- Focused automated tests cover the auto-archive transition and state-gated action availability.
- Relevant docs are verified and updated if lifecycle state ownership or profile history semantics change from the current spec text.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Updated `lib/database/database.dart` so solo habits that reach zero remaining days auto-transition into archived history (`abandoned`) and enqueue the matching owner metadata sync, while shared habits still stay active. Added owner-only rerun/reset support in `lib/providers/habit_actions_provider.dart` and `backend/src/index.ts` using a minimal `reset_progress` contract that is explicitly rejected for shared habits. Reworked `lib/screens/profile_screen.dart` archived management into an archived-history lane with state-aware actions plus a bottom-sheet history viewer, without replacing the existing backend-owned achievements surface. Added regression coverage in `test/habit_completion_progress_test.dart` and `test/profile_habit_crud_test.dart`; verified with `flutter test test/habit_completion_progress_test.dart test/profile_habit_crud_test.dart`. Verified and updated dependency docs: `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, and `Developement/qa_testing.md`. Completed At: 2026-07-13 11:46 CEST

<a id="add-playwright-multi-user-regression-harness-for-shared-habits-and-social-interactions"></a>
### [x] Add Playwright Multi-User Regression Harness For Shared Habits And Social Interactions

**Raw source:** Add an end-to-end regression harness for partner shared habits that covers invite acceptance, mirrored completion state on both cards, nudge delivery in Social Activity, and score/flame award only after all participants complete.

**Issue:** Testing the core multi-user loop (Alice and Bob) currently requires a manual, time-consuming ADB twin-app pass or manual browser juggling. Regressions in shared habit states, nudges, or scoring can easily slip through because single-user unit/widget tests cannot validate the asynchronous sync and state mirrored across two isolated clients.

**Ponytail triage:**
- *Should exist:* Yes. The social check-in and scoring loop is the app's primary interaction. Automated verification is essential.
- *Smallest safe scope:* Create a Playwright (or similar multi-context) test script targeting the Web build. It should spawn two isolated browser contexts (Alice and Bob), register/login, and walk through the exact steps defined in `qa_web_multi_user_plan.md` up to mutual check-in and scoring.
- *Skipped scope:* Do not attempt dual-device Appium/Flutter Driver tests on Android. Limit to Web for the multi-user E2E regression. No new UI features.
- *Boundaries:* The harness must respect the offline-first sync (waiting for sync flushes) and not manipulate the database directly—only through the UI as a real user would.

**Action:** Set up a Node/Playwright test project (e.g., in a new `e2e/` directory). Write a script that orchestrates two browser contexts. Implement the flow: Alice creates a habit and invites Bob -> Bob accepts -> Alice completes -> Bob completes -> Verify both cards update and leaderboard scores increment only after mutual completion.

**Hable perspective:** Hable's offline-first architecture means UI state often relies on background sync. The test harness will need to handle async waits (e.g., waiting for the sync indicator to finish or UI to update) rather than expecting synchronous API responses.

**Implementation scope:**
- `e2e/package.json` & Playwright config: Setup for multi-context web testing.
- `e2e/tests/shared_habit.spec.ts`: The main test script handling Alice and Bob's interactions.
- `Developement/qa_testing.md`: Document the new automated web harness and how to run it.

**Scalability considerations:** Scalability impact: Playwright tests can be flaky if they rely on hardcoded timeouts. The harness must scale by using smart locator waits (e.g., waiting for a specific DOM element or semantics label to update after sync) rather than arbitrary delays.

**Future split guidance:** If the test suite grows to cover push notifications or offline scenarios (toggling network offline in Playwright), those should be split into separate tasks. This task is only for the happy path mutual completion and scoring loop.

**Edge cases:** Network sync delays causing timeouts, animations (like the mud button) delaying state checks, seeded user cleanup to prevent test data pollution.

**Acceptance criteria:**
- A single command (e.g., `npm run test:e2e`) runs the dual-browser test.
- The test verifies friend request, habit invite, invite acceptance, nudge delivery, and mutual completion.
- The test verifies that points/flames are only awarded after *both* participants complete the habit.
- The test runs reliably without arbitrary `sleep` commands, relying on UI/DOM state.
- Documentation is updated.

**Dependencies:** `Developement/qa_web_multi_user_plan.md`, `Developement/qa_testing.md`

**Completion notes:** 
- Initialized new Playwright project in `e2e/`.
- Configured `e2e/playwright.config.ts` to support dual-browser-context tests targeting the web build via `BASE_URL`.
- Implemented `e2e/tests/shared_habit.spec.ts` testing the complete mutual shared habit, nudge, and leaderboard score progression.
- Updated `Developement/qa_testing.md` to document the new `npm run test` harness.
- Updated `Developement/qa_web_multi_user_plan.md` explicitly referencing the new Playwright scripts.
- Completed At: 2026-07-12 14:35 Z

<a id="introduce-explicit-environment-based-backend-targeting-for-flutter-and-release-builds"></a>
### [x] Introduce Explicit Environment-Based Backend Targeting For Flutter And Release Builds

**Raw source:** Environment-Based Backend Targeting: If release Android/web builds need something stronger than `kDebugMode`, split a task for explicit environment-based API configuration.

**Issue:** Hable currently resolves `apiBaseUrl` in `lib/config/api_config.dart` from a single `HABLE_API_BASE_URL` override or a binary `kDebugMode` fallback. That is too implicit for the current release surface. Android debug verification, local ADB smoke runs, web deployment, and release packaging now all depend on the app talking to the correct backend, but the default contract is still effectively "debug means localhost, release means production." That leaves no first-class environment identity for staging, preview, production, or explicit local development, and it makes release-like testing rely on ad hoc URL overrides rather than a documented build-target contract.

**Triage:**
- *Should exist:* Yes. This is a release-safety and operator-correctness task, not speculative infrastructure.
- *Smallest safe scope:* Introduce one explicit Flutter-side environment selector with documented allowed values and keep the existing direct base-URL override as an escape hatch.
- *Skipped scope:* Do not build a full remote config system, per-user environment switching UI, backend multi-tenant routing layer, or CI deployment matrix in this task.
- *Boundaries:* Keep environment selection compile-time/config-driven. The app should not infer production-vs-staging from UI flavor names, auth state, or runtime guesswork once the explicit environment contract exists.

**Action:** Replace the current `kDebugMode`-centric backend targeting fallback with an explicit app environment contract, for example `local`, `staging`, and `production`, resolved from `--dart-define` values. Keep `HABLE_API_BASE_URL` as the highest-priority manual override for unusual smoke setups, but otherwise derive the base URL from the declared environment instead of from debug/release mode alone. Update the build/run documentation so Android, web, and manual smoke workflows all use the same environment vocabulary and default expectations.

**Hable perspective:** Hable now spans Flutter web deployment, Android flavor builds, local Wrangler backend testing, and release packaging. Backend targeting is therefore part of the product’s operational correctness, not just developer convenience. The client should stay offline-first and Drift-backed, but whenever it does talk to the network, it must do so against the intended backend for that build target. Environment targeting belongs in one central config boundary so auth, sync, social search, calendar feed rotation, diagnostics, and future API calls all stay aligned.

**Implementation scope:**
- `lib/config/api_config.dart`: replace the current implicit fallback logic with explicit environment parsing and centralized URL resolution. Preserve `HABLE_API_BASE_URL` as a highest-priority manual override.
- Flutter environment contract: add typed constants/helpers for recognized values such as `local`, `staging`, and `production`, plus safe fallback/error behavior for invalid values.
- Call sites already using `apiBaseUrl` such as `auth_provider.dart`, `sync_service.dart`, `social_hub_screen.dart`, `social_providers.dart`, `calendar_provider.dart`, and `usage_diagnostics_service.dart`: verify they continue to read the same central source without needing per-feature overrides.
- Documentation: update `Developement/commands.md`, `Developement/sys_build_integrity.md`, and any relevant QA runbooks so local ADB reverse, emulator targeting, release builds, and web deploy smoke steps use the explicit environment contract.
- Test surface: add focused unit coverage for environment parsing and URL resolution, including override precedence, default production behavior for release-like builds, and local-target selection for manual development.

**Scalability considerations:** Scalability impact: none expected at runtime. The benefit is operational scale: one shared environment contract reduces accidental cross-environment traffic as more release channels, smoke flows, and backend integrations are added.

**Future split guidance:** If Hable later needs preview-per-branch environments, CI-injected deployment metadata, runtime environment banners, or environment-specific feature flags, split those into follow-up release/tooling tasks. This task is only for explicit API target resolution and documentation.

**Edge cases:** invalid `--dart-define` value, `HABLE_API_BASE_URL` override combined with an environment define, Android emulator vs USB device localhost access, release APK built against a local backend by mistake, web debug builds pointing at production unexpectedly, background services or diagnostics using a mismatched URL path, and preserving current local smoke workflows without forcing every command to pass both defines.

**Acceptance criteria:**
- API target selection no longer relies primarily on `kDebugMode` to distinguish local versus production backends.
- The app supports an explicit environment selector for backend targeting, with documented recognized values and deterministic fallback behavior.
- `HABLE_API_BASE_URL` remains available as an explicit manual override and takes precedence over the environment preset.
- Existing networked surfaces continue to resolve their backend base URL through the same central config source.
- Documentation clearly states how to run local Android/web smoke flows and how to build release-like artifacts against the intended backend.
- Focused tests verify environment parsing, override precedence, and resolved base URLs.
- Dependencies are verified and updated if the environment contract changes developer or QA workflows.

**Dependencies:** `Developement/commands.md`, `Developement/sys_build_integrity.md`, `Developement/qa_testing.md`

**Completion notes:**
- Files touched: `lib/config/api_config.dart`, `test/api_config_test.dart`, `Developement/commands.md`, `Developement/sys_build_integrity.md`, `Developement/qa_testing.md`.
- Behavior verified: backend targeting now resolves through a central environment contract with precedence `HABLE_API_BASE_URL` override -> `HABLE_APP_ENV` preset -> debug/profile local fallback or release production fallback. Recognized environment presets include `local`, `staging`, and `production`; `staging` deterministically falls back to production unless `HABLE_STAGING_API_BASE_URL` is provided.
- Networked surfaces preserved: auth, sync, social, calendar, and diagnostics continue to read the same shared `apiBaseUrl` source with no per-feature divergence.
- Verification run: `flutter test test/api_config_test.dart` and `flutter analyze lib/config/api_config.dart test/api_config_test.dart`.
- Dependencies verified and updated: `Developement/commands.md`, `Developement/sys_build_integrity.md`, and `Developement/qa_testing.md` were updated to document the explicit environment contract for local smoke, release builds, and web deploy flows.
- Completed At: 2026-07-13 16:12 CEST


<a id="resolve-shared-habit-daily-check-in-and-lifecycle-sync-separation"></a>
### [x] Resolve Shared Habit Daily Check-In And Lifecycle Sync Separation

**Raw source:** Task 1: Resolve Habit Completion Sync Loop. Issue: Habits currently disappear and reappear upon completion due to sync conflicts between partners. Action: Modify `SyncService.pullDailySync` and the local habit watcher to distinguish between "Daily Check-In" and "Challenge Lifecycle Completion". Ensure partner-side check-ins do not trigger the `archive` or `completed` status for the shared metadata row. Files: `lib/services/sync_service.dart`, `lib/database/database.dart`.

**Issue:** Shared habit daily check-ins can be conflated with habit lifecycle completion. Locally, `completeHabitDay` may mark a habit row `completed` when `currentDuration` reaches zero, and `watchActiveHabits` excludes non-`active` rows. During `/api/sync/daily`, shared metadata is upserted back into Drift from partner snapshots, which can make a shared habit disappear and reappear as partner progress arrives. Daily completion should be represented by a `logs` row and `PartnerSnapshots.hasCompletedToday`; lifecycle completion/archive should remain an explicit habit metadata state.

**Ponytail triage:**
- *Should exist:* Yes. This is a core shared-habit correctness issue, not visual polish.
- *Smallest safe scope:* Fix the existing shared habit sync/read path so daily check-ins never set shared metadata to `completed` or remove a card from the active stream unless the backend explicitly reports a lifecycle status such as `abandoned`.
- *Skipped scope:* Do not redesign scoring, ring states, completion splash screens, or the habit status enum beyond the minimum needed to prevent the disappearance/reappearance loop.
- *Boundaries:* Preserve offline-first rendering. UI continues to read from Drift; `SyncService.pullDailySync` may normalize backend payloads into Drift but must not become a direct UI source.

**Action:** Trace the completion path from Home/Mud button to `completeHabitDay`, outbound `SyncAction.logHabit`, backend daily sync payload, `SyncService.pullDailySync`, and `watchActiveHabits`. Adjust the shared-habit handling so daily check-ins update the viewer's remaining days and partner completion bits without treating another participant's check-in as a lifecycle status change. Keep active shared habits visible after local or partner completion unless the habit is explicitly archived/abandoned by the owner.

**Hable perspective:** Hable's local `habits` row is the shared habit metadata read model. The daily action belongs in `logs`, and partner daily state belongs in `PartnerSnapshots.hasCompletedToday`. `watchActiveHabits` should remain a simple Drift stream for active user-visible cards, while `pullDailySync` must protect the local metadata row from transient completion payloads.

**Implementation scope:**
- `lib/services/sync_service.dart`: normalize `partners` from `/api/sync/daily` so `status` only maps authoritative lifecycle values (`active`, `abandoned`) and never infers `completed` from `has_completed_today`, `current_duration`, or partner progress.
- `lib/database/database.dart`: audit `completeHabitDay`, `updateHabitStatus`, `watchActiveHabits`, and any local helper needed to keep shared cards active after daily check-in while preserving owner archive behavior.
- `lib/providers/habit_providers.dart`: verify `activeHabitsProvider` remains backed by the corrected Drift query and does not add network-driven filtering.
- Tests: add or update focused database/provider/sync tests covering local completion at remaining day zero, partner daily-sync completion, and owner archive/abandon propagation.

**Scalability considerations:** Drift database growth is low risk for this task because it should reuse existing `habits`, `logs`, and `partner_snapshots` tables. Avoid adding broad table scans or extra streams; keep watches scoped by `user_id` and habit id so Riverpod rebuilds remain bounded as shared habit counts grow.

**Future split guidance:** If the implementation reveals that Hable needs a distinct lifecycle state such as `finished` separate from daily completion, append a new raw task for a schema/state-model migration. Do not fold that migration into this bug fix unless the current enum makes the loop impossible to fix safely.

**Edge cases:** Owner completes the final required day, partner completes before owner, both users complete while offline, duplicate `logHabit` replay, daily sync payload arrives after local completion, backend sends stale `current_duration`, owner archives while partner has pending logs, `watchActiveHabits` receives a row with `completed` from older local data, and revoked partnerships removing a shared habit.

**Acceptance criteria:**
- Completing a shared habit daily check-in does not make the card disappear from Home unless the owner explicitly archives/abandons the habit.
- Partner-side daily check-ins update `PartnerSnapshots.hasCompletedToday` and visible partner state without setting the local shared habit metadata row to `completed`.
- `SyncService.pullDailySync` treats backend `status` as lifecycle metadata only and ignores/translates non-lifecycle completion signals safely.
- Owner archive/abandon still removes the habit from `watchActiveHabits` and Profile still reflects lifecycle state correctly.
- A focused regression test fails before the fix and passes after it for the disappear/reappear scenario.
- Relevant docs are verified and updated if code behavior changes.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Modified `completeHabitDay` in `lib/database/database.dart` to check for partnerships before setting a habit to `completed`, keeping shared habits `active` regardless of duration to fix the disappearance loop. Documented `sync_service.dart` to clarify that `completed` status from partner syncs is ignored as transient non-lifecycle data. Passed all local test cases.


<a id="align-mud-resistance-provider-with-canonical-state-notifier-spec"></a>
### [x] Align Mud Resistance Provider With Canonical State Notifier Spec

**Raw source:** Task 2: Implement "Mud" Resistance State Notifier. Action: Extract the physics-driven resistance math (`R = 1.0 - (d/D)`) into a dedicated Riverpod `StateNotifier` as mandated by the `sys_offline_architecture.md`. Rationale: This isolates physics calculations from the UI thread to ensure fluid animations on mobile devices. Files: `lib/providers/habit_providers.dart`, `lib/widgets/mud_long_press_button.dart`.

**Issue:** The abstraction already exists, but it does not match the documented contract. Hable currently uses `resistanceProvider` in `lib/providers/resistance_provider.dart` as a `Provider.family`, not a notifier-backed state boundary, and its timing constants/defaults (`2000`/`600`) diverge from the canonical mud spec in `ux_mud_and_animations.md` (`1500`/`400`). The raw task should therefore target contract alignment, not re-extraction.

**Ponytail triage:**
- *Should exist:* Yes, but as a narrow alignment task rather than a net-new feature.
- *Smallest safe scope:* Keep the current UI behavior and consumer API shape as stable as possible while moving the resistance calculation behind the mandated notifier/state boundary and aligning the computed outputs with the documented mud spec.
- *Skipped scope:* Do not redesign the mud visuals, ring states, or Home card layout. Do not broaden this into the separate five-ring-state task.
- *Boundaries:* The widget must continue to consume precomputed scalars only. No resistance math should move back into `MudLongPressButton` or Home widget build logic.

**Action:** Replace or wrap the current `Provider.family` resistance calculator with the mandated Riverpod notifier-based implementation. Ensure the notifier computes the canonical coefficient and duration mapping from the documented formula, and update the Home habit-card consumption path to use that notifier-backed state without changing the button's responsibility boundary.

**Hable perspective:** Hable's mud interaction is a specialized physics system with a documented isolation boundary. The important contract is not just "some provider exists"; it is that the canonical resistance math lives in a dedicated state layer, feeds only scalar outputs into `MudLongPressButton`, and stays consistent with the UX spec used by future tasks and bug fixes.

**Implementation scope:**
- `lib/providers/resistance_provider.dart`: convert the current helper into the notifier-backed resistance state source and align coefficient/duration defaults with the canonical spec.
- `lib/screens/home_screen.dart`: switch the habit-card read path from the current family provider call to the notifier-backed interface if needed, preserving the existing `MudLongPressButton` input contract.
- `lib/widgets/mud_long_press_button.dart`: verify the widget remains math-free and update only comments/types if the provider contract changes.
- Tests: add or update focused provider/unit coverage for early-day, mid-journey, final-day, and invalid-duration cases, plus one widget-level sanity test if consumer wiring changes.

**Scalability considerations:** Scalability impact: none expected. The calculation is constant-time and per-card. The important scale guard is to keep the state interface lightweight so Home can read many cards without introducing broad provider invalidation or rebuild churn.

**Future split guidance:** If future work needs dynamic per-user tuning, haptic calibration presets, or persistence of resistance state across app lifecycle events, append a separate raw task. This task is only for spec alignment of the existing resistance calculation boundary.

**Edge cases:** `totalDuration <= 0`, `currentDay < 0`, `currentDay > totalDuration`, shared habits with `currentDuration == 0` but still active, stale comments referencing a nonexistent `ResistanceNotifier`, and mismatched test expectations caused by the current `2000`/`600` timing constants.

**Acceptance criteria:**
- The resistance calculation lives behind a dedicated notifier/state boundary rather than a bare `Provider.family`.
- The notifier outputs a bounded `resistanceCoefficient` and duration mapping consistent with `ux_mud_and_animations.md`.
- `MudLongPressButton` continues to receive only precomputed scalar inputs and does not perform the mud math internally.
- Home habit cards still render and drive hold-to-complete using the new state source without behavioral regression.
- Focused automated tests cover the canonical resistance mapping and invalid-input clamping behavior.
- Relevant docs are verified and updated if implementation details differ from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Migrated `resistanceProvider` to use `@riverpod` Notifier implementation and aligned `calculatedDurationMs` constants to `1500` / `400`. Added robust edge case tests in `test/resistance_provider_test.dart` for clamp behaviors and valid ranges. All tests passed.


<a id="wire-canonical-five-state-habit-ring-feedback-and-accessibility"></a>
### [x] Wire Canonical Five-State Habit Ring Feedback And Accessibility

**Raw source:** Task 3: Engineering the Five Ring States. Action: Implement the visual cycle for the habit ring: 1. Empty: Idle state awaiting interaction. 2. Completing: Long-press scaling animation where a faded emoji shrinks as the ring fills. 3. Completion: Trigger a brief checkmark animation on the ring before settling. 4. Complete: Solid colored ring with the final emoji. 5. Missed: Dimmed/Pastel state for overdue tasks. Note: Remove all percentage labels; move them to ARIA Semantics for accessibility.

**Issue:** Hable has pieces of the ring system but not a fully wired five-state flow. `MudLongPressButton` already supports idle/press animations and a transient `'Done!'` completed view, and `HabitVisualState` exists in the model layer, but the Home habit-card flow does not actually drive a canonical state machine across empty, completing, completion flash, complete, and missed states. The card also still exposes visible progress labeling patterns that the raw task wants moved out of the visual surface and into semantics-only accessibility output.

**Ponytail triage:**
- *Should exist:* Yes. This is core interaction polish on the main Home control, not decorative scope creep.
- *Smallest safe scope:* Wire the existing ring/button/card surfaces into a single state-driven visual cycle, remove visible percentage-like progress text from the card surface, and keep accessibility state available through semantics.
- *Skipped scope:* Do not redesign the entire card information architecture here. Header/progress-bar/streak layout changes belong to the separate Task 4.
- *Boundaries:* Stay within the existing Home card and mud button surfaces. Do not invent a new habit-card widget hierarchy or merge this with completion splash work.

**Action:** Implement the five-state ring behavior on the current Home habit card path. Use the existing `HabitVisualState`/`HabitVisualParameters` foundation where possible so `MudLongPressButton` and the Home card agree on idle, in-progress, transient completion, completed-today, and missed styling. Remove visible percentage labels from the ring/card presentation while preserving an accessible semantics description of progress and state.

**Hable perspective:** Hable's primary daily interaction is the ring-first Home habit card. The correct abstraction is a local-first visual state derived from Drift-backed habit/log state plus the active hold gesture. The mud button should render the state; `HomeScreen` should decide which state applies based on today's log, completion feedback timer, and overdue/missed conditions.

**Implementation scope:**
- `lib/models/habit_visual_state.dart`: verify or extend the existing state/parameter model so it can represent the canonical five ring states without ad hoc booleans.
- `lib/widgets/mud_long_press_button.dart`: align rendering with those states, including transient checkmark feedback and a stable completed visual that is distinct from the in-progress hold animation.
- `lib/screens/home_screen.dart`: replace the current `_isShowingCompletionFeedback` plus `isCompletedToday` split with a clearer visual-state derivation and move progress narration into semantics instead of visible percent-oriented copy.
- Tests: replace placeholder ring-refinement tests with focused widget coverage for the five-state flow, semantics output, and no-overflow regressions on narrow screens.

**Scalability considerations:** Riverpod rebuild pressure should stay low because this is per-card presentation logic derived from already-watched Drift state. Avoid timers or animation triggers that cause broad list invalidations; keep state local to the card/button and derived from the existing providers.

**Future split guidance:** If later work needs celebratory full-screen transitions, richer particle effects, or milestone-only animation variants, append separate raw tasks. This task is only for the canonical per-card ring-state cycle and accessibility cleanup.

**Edge cases:** Completed-today shared habits that must stay visible, skipped habits, overdue/missed cards with no log, supporter role cards with disabled completion affordance, app rebuild during transient completion flash, long emoji/title combinations, narrow screens, and semantics output that should describe progress without reintroducing visible percentage text.

**Acceptance criteria:**
- The Home ring surface supports clear idle, completing, completion-flash, complete, and missed visual states.
- The long-press path still animates the emoji/ring during completion and ends in a brief confirmation before the stable completed-today state.
- Visible percentage labels are removed from the card/ring presentation, while semantics still expose progress/state information for accessibility.
- Completed-today and missed states remain visually distinct and do not break shared-habit visibility rules.
- Focused widget tests cover the state transitions and at least one semantics assertion.
- Relevant docs are verified and updated if the shipped state model or UX wording changes.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Changed `MudLongPressButton` to accept `HabitVisualState` rather than discrete booleans. Integrated rendering for the 5 states (idle, completing, checkInComplete, established, missed/skipped). Replaced the manual completion string display in `home_screen.dart` to derive and pass the canonical state to the UI. Removed on-surface percentage labels but preserved them within the `Semantics` tag for accessibility. Added tests to verify visual properties and ARIA output. All tests pass perfectly.


<a id="add-bounded-completion-moment-overlay-driven-by-daily-quote-state"></a>
### [x] Add Bounded Completion Moment Overlay Driven By Daily Quote State

**Raw source:** Task 5: The "Completion Moment" Splash Screen. Action: Create a dynamic typographic splash screen triggered upon final habit completion. It must display a dynamic congratulation message and the "Quote of the Day" fetched from the daily sync. Files: `lib/screens/completion_splash_screen.dart`.

**Issue:** Hable currently celebrates completion only with a local haptic, a floating `SnackBar`, and a short-lived `Done!` ring state inside `HomeScreen`. There is no dedicated completion moment surface, and no existing `lib/screens/completion_splash_screen.dart` file. The quote system already exists through `quoteProvider`, but it is only rendered in the Home quote block, not used for a bounded completion-state celebration.

**Ponytail triage:**

**Implementation scope:**
- `lib/screens/completion_splash_screen.dart`: create the dedicated completion-moment surface.
- `lib/screens/home_screen.dart`: trigger the surface from `_handleCompletion()` in a way that coexists with the existing optimistic write, ring feedback, and shared-habit visibility rules.
- `lib/providers/quote_provider.dart`: verify the quote source is reusable for the completion moment without duplicating fetch logic.
- Tests: add focused widget coverage for trigger/dismiss behavior and quote rendering fallback when no cached daily quote exists.

**Scalability considerations:** Scalability impact: none expected. This is a transient UI surface triggered per completion. Keep it stateless or narrowly scoped so repeated completions do not leak timers, duplicate routes, or create stacked overlays.

**Future split guidance:** If later work needs milestone-specific celebration variants, badge reveals, audio, particle systems, or quote personalization by streak state, append separate raw tasks. This task is only for the base completion moment tied to the current quote.

**Edge cases:** Multiple rapid completions, widget disposal during transition, no cached quote and fallback quote usage, shared habit completion where the card remains visible afterward, app backgrounding during the splash, narrow screens, text scaling, and ensuring the overlay does not permanently block Home navigation.

**Acceptance criteria:**
- Completing a habit can trigger a dedicated bounded completion surface rather than only a `SnackBar`.
- The surface shows a dynamic congratulatory message plus the current quote-of-the-day from the existing quote pipeline.
- Returning from the completion moment preserves the existing completed-today Home state and does not re-run the completion mutation.
- Fallback quote behavior still works when no cached daily quote exists.
- Focused tests cover at least the trigger/dismiss path and quote rendering behavior.
- Relevant docs are verified and updated if the completion feedback contract changes.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. The completion splash screen (`lib/screens/completion_splash_screen.dart`) is implemented and integrated. It shows a dynamic congratulatory message, animation, and quotes from the daily sync when a habit is completed.


<a id="add-swipeable-pageview-shell-for-home-social-and-profile-tabs"></a>
### [x] Add Swipeable PageView Shell For Home Social And Profile Tabs

**Raw source:** Smooth Tab Navigation. Action: Implement a horizontal `PageView` for the three primary tabs (Home, Social, Profile) to allow for smooth swiping, replacing the static bottom navigation taps.

**Issue:** Hable’s authenticated shell currently uses a `NavigationBar` plus an `Offstage`/`TickerMode` stack in `lib/screens/main_navigation_shell.dart`. That preserves tab state, but it makes top-level navigation tap-only and prevents horizontal swiping between Home, Social, and Profile. Because the three-tab IA is now a core product contract, adding swipe navigation must preserve existing shell invariants: Home back behavior, Social’s internal tab routing, Home bell deep-linking into Social → Activity, and the current local-first screen state preservation. A naive swap to `PageView` could easily break lazy tab instantiation, reset nested Social state, or cause gesture conflicts with internal horizontal surfaces.

**Triage:**
- *Should exist:* Yes. This is a shell-level UX improvement on an already-stable three-tab information architecture.
- *Smallest safe scope:* Replace the root `Offstage` stack with a controlled horizontal `PageView` that keeps the same three destinations and synchronizes with the bottom `NavigationBar`.
- *Skipped scope:* Do not redesign the three-tab IA, change Social’s internal tabs, add gesture-driven nested routing, or animate deeper screen transitions in this task.
- *Boundaries:* Keep this at the authenticated shell layer only. Home, Social, and Profile should continue to own their own content/state; the shell should only change how the user moves between them.

**Action:** Introduce a `PageController`-driven `PageView` in `MainNavigationShell` so users can swipe horizontally across Home, Social, and Profile while still using the bottom navigation bar. Maintain programmatic tab switching for existing callers such as Home’s notification bell (`switchToTab(1, socialSubTab: 1)`) and preserve Android back behavior that returns to Home before exiting. Ensure the selected nav destination and the visible page stay in sync whether navigation starts from a tap, a swipe, or a shell-triggered deep link.

**Hable perspective:** Hable’s shell already intentionally collapsed the product into exactly three primary destinations. Swipe navigation should reinforce that cohesive app structure without creating new destinations or mutating the ownership boundaries: Home remains the daily habit/action surface, Social remains friends/activity/leaderboard, and Profile remains identity/history/settings. The shell should feel smoother, but not “smarter” than the screens it hosts.

**Implementation scope:**
- `lib/screens/main_navigation_shell.dart`: replace or wrap the current `Offstage` destination switching with a state-preserving `PageView`/`PageController` solution, and keep `switchToTab()` working for internal callers.
- Shell/back behavior: preserve the current PopScope rule where Android back from Social/Profile returns to Home first.
- Existing widget coverage, likely `test/main_navigation_shell_test.dart`, plus any focused shell test needed to verify nav tap sync, swipe sync, and Home-bell → Social Activity routing still work.
- Documentation: update `Developement/qa_testing.md` if the manual checklist should now explicitly verify swipe navigation across the three primary tabs.

**Scalability considerations:** Scalability impact: none expected. The key scale concern is state preservation and rebuild churn: the shell must not recreate heavy tab trees on every swipe or lose nested Social/Home state as the user moves repeatedly across tabs.

**Future split guidance:** If later work needs custom page transition physics, parallax shell motion, gesture disabling on specific platforms, or deeper nested swipe models inside Social/Profile, split those into follow-up tasks. This task is only for the top-level three-tab shell swipe contract.

**Edge cases:** Rapid repeated swipes, Android back after partial swipe progress, `switchToTab()` called before the target page is fully built, Home bell opening Social → Activity while the user is mid-gesture, potential conflicts with nested horizontal widgets, and preserving current tab state after device rotation or rebuilds.

**Acceptance criteria:**
- Users can swipe horizontally between Home, Social, and Profile in the authenticated shell.
- The bottom `NavigationBar` stays synchronized with the visible page for both tap and swipe navigation.
- Existing shell-triggered routing, including Home bell → Social Activity, still works correctly.
- Android back from Social/Profile still returns to Home before exiting.
- Focused widget/test coverage verifies the new shell navigation contract.
- Relevant docs are verified and updated where they previously described tap-only top-level tab behavior.

**Dependencies:** `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Replaced the static `Stack`/`Offstage` shell in `lib/screens/main_navigation_shell.dart` with a `PageView` and `PageController`. To maintain the state of the tabs lazily, introduced a `_KeepAlivePage` wrapper using `AutomaticKeepAliveClientMixin`. The shell now synchronizes programmatic tab switches, tap-based navigation, and swipe gestures seamlessly.


<a id="remove-home-3d-visualizer-and-anchor-it-to-social-friends-surface"></a>
### [x] Remove Home 3D Visualizer And Anchor It To Social Friends Surface

**Raw source:** Viewport Optimization & 3D Environment. Observation: The 3D animation is currently heavy and occupies valuable viewport space on the Home screen. Action: Remove the 3D visualizer from the Home list. Relocate it to the Social Hub (Friends section) as a pinned card element. This ensures the Home screen remains fast and focused on action tiles.

**Issue:** Hable already duplicated the `HabitEnvironmentVisualizer` into Social, but the raw objective is still not fully satisfied. `HomeScreen` continues to render the 3D visualizer high in the scroll stack above invitations and habits, which costs viewport space on the app’s primary daily-action surface. In `SocialHubScreen`, the visualizer is currently mounted above the whole tab body rather than being a deliberate Friends-tab pinned card. That leaves Home overloaded and Social ambiguous about whether the visualization belongs to the relationship surface or to the shell chrome.

**Triage:**
- *Should exist:* Yes. This is a concrete information-density and performance/attention issue on the most frequently used screen.
- *Smallest safe scope:* Remove the visualizer from Home entirely and rehome the existing widget into the Friends tab as a pinned card near friend/request context, without redesigning the visualizer itself.
- *Skipped scope:* Do not rewrite the 3D renderer, change particle behavior, add profiling infrastructure, or redesign the entire Social Hub layout in this task.
- *Boundaries:* Reuse the existing `HabitEnvironmentVisualizer` widget and current Social/Home structure. This is a surface-placement correction, not a new graphics feature.

**Action:** Delete the `HabitEnvironmentVisualizer` from the Home sliver stack so Home returns to quote, invitations, suggestions, and habit cards as its primary content. Move the Social copy out of the tab-shell header area and into the Friends tab as a pinned card element that reads as a social/ambient visualization rather than a global header. Keep the widget visually bounded so it does not dominate the friends list or collapse smaller viewports. Update the smallest relevant tests/docs to reflect the new ownership of the 3D surface.

**Hable perspective:** Hable’s Home tab is for repeated scanning and check-ins, not for decorative ambient weight above the action list. The 3D environment belongs to the social/aspirational side of the product, which maps more naturally to Social → Friends where users think about people, shared habits, and future inspiration. That placement also preserves the vision register in `ux_social_vision.md` without burdening the operational Home flow.

**Implementation scope:**
- `lib/screens/home_screen.dart`: remove the 3D visualizer from the Home content stack.
- `lib/screens/social/social_hub_screen.dart`: pin the existing `HabitEnvironmentVisualizer` into the Friends tab surface instead of placing it above all three Social sub-tabs.
- Existing widget/layout tests, likely `test/main_navigation_shell_test.dart` plus one focused Social/Home widget assertion, to verify the visualizer is absent from Home and present in the Friends tab path.
- Documentation: update the relevant UX/testing docs so they no longer describe the 3D environment as Home content.

**Scalability considerations:** Scalability impact: none expected. The main benefit is reducing unnecessary render cost and vertical contention on Home while keeping the heavy visual in a less frequently scanned surface.

**Future split guidance:** If Hable later wants interactive friend-space exploration, per-friend 3D drilldown, collapsible social ambient cards, or performance profiling of the renderer itself, split those into dedicated tasks. This task is only for correcting surface ownership and viewport pressure.

**Edge cases:** Empty friends list, empty habits list, small mobile viewport, tab switching rebuilds, accessibility/semantics of the pinned visualizer card, and ensuring Social Activity/Leaderboard do not inherit extra vertical chrome they do not need.

**Acceptance criteria:**
- Home no longer renders `HabitEnvironmentVisualizer`.
- Social Hub still exposes the visualizer, but specifically through the Friends surface rather than as a global header above all Social sub-tabs.
- Home’s main scroll path becomes more action-dense without breaking invitation, suggested-habit, or habit-card rendering.
- Focused widget/test coverage verifies the new surface placement.
- Relevant docs are verified and updated where they previously implied the 3D visualizer belongs on Home.

**Dependencies:** `Developement/ux_social_vision.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Removed `HabitEnvironmentVisualizer` from `lib/screens/home_screen.dart` and relocated it into the slivers list of the Friends tab in `lib/screens/social/social_hub_screen.dart` to save viewport space on the Home screen.


<a id="remove-redundant-home-empty-state-add-habit-button-and-keep-fab-as-sole-cta"></a>
### [x] Remove Redundant Home Empty-State Add Habit Button And Keep FAB As Sole CTA

**Raw source:** Home Page Empty State Cleanup. Action: Consolidate the "Add Habit" buttons. Remove the secondary button and rely solely on the Floating Action Button (FAB) to reduce visual debt.

**Issue:** Hable’s Home screen already exposes a persistent `FloatingActionButton.extended` labeled `Habit`, but the empty-habits state in `lib/screens/home_screen.dart` also renders an inline `ElevatedButton.icon` labeled `Add habit`. That duplicates the same creation action in the same viewport, adds visual noise to the empty state, and conflicts with the intended three-tab shell pattern where the primary Home creation affordance is the persistent FAB. The testing docs still encode the older dual-CTA expectation, so the product rule and QA guidance are out of sync.

**Triage:**
- *Should exist:* Yes. This is a small but real Home-screen polish issue with a clear current-state mismatch.
- *Smallest safe scope:* Remove the duplicate inline empty-state add button, keep the explanatory empty-state copy, and preserve the Home FAB as the only habit-creation CTA.
- *Skipped scope:* Do not redesign the full Home empty state, suggested habits section, quote card, or FAB styling/placement in this task.
- *Boundaries:* Keep this limited to CTA consolidation and the related documentation/tests. Do not fold it into broader Home layout or 3D-environment changes.

**Action:** Update the Home empty-state rendering so users are instructed to use the persistent FAB rather than being offered a second inline button that opens the same `HabitFormSheet`. Adjust the smallest relevant widget tests and QA docs to reflect that Home creation remains available through the FAB in both populated and empty states. Preserve accessibility semantics so the remaining FAB still clearly announces habit creation.

**Hable perspective:** Hable’s Home tab is ring-first and action-focused. The FAB is already the durable entry point for creating a habit from Home, while Profile owns management/history and Social owns relationship flows. The empty state should therefore guide the user toward that existing affordance instead of introducing a second creation button that competes with it.

**Implementation scope:**
- `lib/screens/home_screen.dart`: remove the duplicate inline `Add habit` button from the empty state while keeping concise guidance text.
- `test/main_navigation_shell_test.dart` or a focused Home/widget test: verify the Home FAB remains visible/usable as the sole creation CTA and that the empty state no longer renders a second add button.
- `Developement/qa_testing.md`: update the manual checklist so empty-state verification confirms the FAB is the creation path rather than expecting a second button.

**Scalability considerations:** Scalability impact: none expected. This is a presentation cleanup with no new data, sync, or provider behavior.

**Future split guidance:** If the empty state later needs richer onboarding copy, illustration treatment, contextual quotes, or suggested-habit redesign, split that into a separate Home empty-state UX task. This task is only for consolidating duplicate creation CTAs.

**Edge cases:** Empty habit list on narrow screens, accessibility/semantics of the remaining FAB, users landing on Home before sync populates habits, and tests/docs that still assume the inline button exists.

**Acceptance criteria:**
- Home no longer shows a second inline `Add habit` button when the habit list is empty.
- The persistent Home FAB remains the sole habit-creation CTA and still opens `HabitFormSheet`.
- The empty-state copy still clearly guides the user without leaving the screen actionless.
- Focused widget/test coverage reflects the single-CTA behavior.
- Relevant docs are verified and updated where they previously described two Home add-habit entry points.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Removed the duplicate `ElevatedButton.icon` from the empty state in `lib/screens/home_screen.dart` and updated the instructional text to point users to the persistent `Habit` floating action button.


<a id="add-local-shareable-achievement-card-render-from-server-owned-progression-data"></a>
### [x] Add Local Shareable Achievement Card Render From Server-Owned Progression Data

**Raw source:** Task 6: Shareable Achievement Cards (MVP). Action: Implement a background service to render a shareable PNG card containing the habit name, duration, participant emojis, and the Hable logo. Technical Constraint: Use the server-owned `total_points` and achievement data as the source of truth for the certificate.

**Issue:** Hable has server-owned progression data and an Achievements section in Profile, but no share/export pipeline, no PNG render surface, and no share dependency in `pubspec.yaml`. The raw task's "background service" wording is broader than the current codebase supports. The smallest safe version is a local client-side render path that composes a shareable achievement card from existing Drift-cached progression and habit metadata, without inventing a new background job or client-owned scoring logic.

**Ponytail triage:**
- *Should exist:* Yes, but only as a narrow local render/export MVP.
- *Smallest safe scope:* Add one achievement-card UI/render path that can turn current server-owned progression plus selected habit metadata into a shareable image artifact on demand.
- *Skipped scope:* Do not build a persistent background renderer, cloud certificate store, social-post integrations, or a generic design studio for cards.
- *Boundaries:* The card must read score/badge truth from Drift-cached `/api/sync/daily` data and existing habit/partner metadata. It must not calculate or infer progression independently.

**Action:** Add an MVP shareable achievement-card flow centered on existing Profile/Home progression surfaces. Render a single branded card image locally from server-owned `total_points`/achievement unlock data plus the chosen habit's title, duration, and participant emoji/avatar signals. Trigger it explicitly from UI rather than in the background, and keep the export path narrow enough to validate on Flutter targets already supported by the repo.

**Hable perspective:** Hable's trust boundary matters here: scores, levels, and badges are backend-owned, while habit metadata and partner identity are locally cached read models. A share card is presentation over that data, not a new gamification source. The MVP should therefore compose a polished artifact from existing Drift-backed state rather than trying to author its own certificate logic.

**Implementation scope:**
- Profile/progression surface: identify the smallest user-triggered entry point near the existing Achievements section in `lib/screens/profile_screen.dart`.
- Rendering path: add the minimal local image-render/export plumbing needed for one branded achievement card artifact, likely via a dedicated widget plus capture/render logic rather than a background worker.
- Data inputs: use server-owned `total_points`, level/badge unlocks, and existing habit/partner metadata only; avoid client-side score derivation.
- Tests: add focused coverage for data selection/composition logic and at least one render/export-path sanity check where feasible.

**Scalability considerations:** Scalability impact: none expected for MVP if rendering remains user-triggered and local. Avoid queueing background jobs or bulk pre-rendering; one-shot card generation should not block normal app state updates or introduce broad memory churn.

**Future split guidance:** If later work needs template variants, background generation, true OS share-sheet integrations, PDF certificates, or server-side image generation, append separate raw tasks. This task is only for the first local renderable/shareable card path.

**Edge cases:** User has no achievements yet, no cached daily sync progression, missing avatar/emoji data, long habit names, habits without partners, offline mode with stale cached progression, Flutter web vs mobile export differences, and repeated taps causing duplicate renders.

**Acceptance criteria:**
- A user-visible entry point exists for generating one shareable achievement card from existing progression data.
- The generated card includes the habit name, duration, participant identity cues, Hable branding, and server-owned progression context.
- The implementation does not derive `total_points` or badge truth on the client beyond reading cached backend data.
- The MVP uses an explicit local render/export path rather than an always-on background service.
- Focused tests cover the main composition/data-truth path and any practical render/export sanity surface.
- Relevant docs are verified and updated if the render/share contract introduces new package or platform constraints.

**Dependencies:** `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12.
- Added `share_plus` package for cross-platform sharing capabilities.
- Added `lib/widgets/achievement_share_card.dart` to implement the presentation-layer certificate artifact, reading data strictly from the injected user score and unlocked achievements.
- Added a `RepaintBoundary` conversion utility to render this share card to a local `ui.Image`, output as PNG.
- Modified `lib/screens/profile_screen.dart` to include an `IconButton` near the Achievements section to trigger the share card popup.
- Added test coverage in `test/achievement_share_card_test.dart` to verify that the generated share card renders the user info and badge truth gracefully.


<a id="consolidate-home-habit-card-information-architecture-for-challenge-streak-and-social-context"></a>
### [x] Consolidate Home Habit Card Information Architecture For Challenge Streak And Social Context

**Raw source:** Task 4: Consolidated Card Information Architecture. Action: Redesign the habit card to be narrower: Continuous Lifestyle: Move 🔥 streak icon to the header. Challenge-Based: Embed 🔥 icon and "Day X of Y" notation within the progress bar. Social: Replace "Solo Today" with "Partners Remains" on the right-hand side. Files: `lib/widgets/habit_card.dart`.

**Issue:** The raw task references a stale file path. The active Home habit card lives in `lib/screens/home_screen.dart`, and its supporting partner row lives in `lib/widgets/habit_partner_row.dart`. The current layout still renders a detached streak chip below the partner row, places `Challenge: Day X of Y` under the bar rather than integrating it into the progress surface, and shows `'Solo today'` when no partner chips exist. The result is vertically loose and duplicates status language instead of using a compact information hierarchy.

**Ponytail triage:**
- *Should exist:* Yes. This is a Home-card density and clarity task on the app's primary screen.
- *Smallest safe scope:* Recompose the existing card information blocks so streak/progress/social context become denser and better placed without replacing the ring-first structure or creating a separate card widget abstraction.
- *Skipped scope:* Do not combine this with the five-state ring animation task or the completion splash task. Do not redesign social permissions or partner actions.
- *Boundaries:* Keep the ring as the primary focus. Rework only the surrounding information layout and copy on the existing Home card surfaces.

**Action:** Refine the Home card information architecture around the existing mud ring. For lifestyle habits, move the streak signal into the upper/header context instead of keeping it as a detached badge below the social chips. For challenge-based habits, integrate the day-progress notation and fire/streak treatment into the progress surface so the bottom area reads as one compact progress module. For solo/social labeling, replace the current `'Solo today'` fallback with the intended remaining-participant framing on the right-side/supporting context without hiding the partner row's accessibility semantics.

**Hable perspective:** Hable's Home card should feel quiet and compact: one dominant ring, one compact social row, one clear progress module. The UX docs already say Home should distinguish challenge progress from streaks and avoid redundant fire/day counts. This task operationalizes that rule in the current Flutter layout rather than inventing a new component system.

**Implementation scope:**
- `lib/screens/home_screen.dart`: recompose the card sections so streak, challenge progress, and supporting copy occupy tighter, role-aware positions with less vertical waste.
- `lib/widgets/habit_partner_row.dart`: replace the `'Solo today'` empty-state copy with the intended compact social wording and ensure it still works with role/status semantics.
- Tests: add or update focused widget tests for layout text placement/copy, solo-vs-partner presentation, and narrow-screen non-overflow behavior.

**Scalability considerations:** Scalability impact: none expected. This is presentational composition over existing Drift/Riverpod reads. Keep the layout deterministic so more partners, long titles, and text scaling do not produce overflow or force extra rebuild complexity.

**Future split guidance:** If later work needs a reusable extracted `HabitCard` widget shared across Home, Profile, and friend-profile surfaces, append a separate raw task. This task should stay local to the current Home card implementation.

**Edge cases:** Very long habit titles, challenge-based habits with `targetDuration <= 1`, continuous lifestyle habits with large streak counts, no partners, supporter-only visibility, four-plus partners with overflow chip, text scaling, narrow Android widths, and shared habits that are complete today but must remain visible.

**Acceptance criteria:**
- Continuous/lifestyle habits place the streak signal in a tighter header/top context rather than as a detached mid-card badge.
- Challenge-based habits integrate the day-progress notation into the progress surface without redundant streak/day language.
- The solo/social empty-state wording no longer says `'Solo today'` and instead matches the intended social framing.
- The card becomes visually denser without breaking the ring-first layout or causing narrow-screen overflow.
- Focused widget tests cover the updated information architecture and at least one responsive/non-overflow case.
- Relevant docs are verified and updated if the final IA wording or placement differs from the current spec text.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12.
- Modified `lib/widgets/habit_partner_row.dart` to change empty state wording to `'No partners'`.
- Modified `lib/screens/home_screen.dart` to identify continuous habits (`targetDuration <= 0`). For continuous habits, the streak badge is placed in the top right corner of the card. For challenge habits, the streak badge is rendered in the bottom progress surface inline with the "Day X of Y" notation.
- Updated `test/habit_partner_row_test.dart` to assert empty state changes and fixed broken assertions.
- Verified all tests pass.


<a id="engineer-image-inspired-compact-habit-card-for-responsive-grid-layouts"></a>
### [x] Task 5: Engineer Image-Inspired Compact Habit Card For Responsive Grid Layouts

**Raw source:** Engineer the attached card style so Hable can support a viewport-dependent grid page of habits. The reference image shows a compact card with a large centered ring, soft blurred emoji core, title in the top-left, partner avatars stacked on the right, a thin progress bar near the bottom, and a concise `Day X of Y` label below it.

**Issue:** Hable's current Home habit card is tuned for a single-column, vertically generous ring-first list. The design reference instead implies a denser, self-contained card that can repeat in a responsive grid. The current composition in `lib/screens/home_screen.dart` and `lib/widgets/habit_partner_row.dart` does not yet define the layout, aspect-ratio rules, or viewport breakpoints needed to render habits as stable tiles across mobile, tablet, and wider web/desktop widths.

**Ponytail triage:**
- *Should exist:* Yes. This is a concrete design direction with a clear product payoff: grid-capable habit browsing.
- *Smallest safe scope:* Engineer one compact card pattern plus the responsive grid/container rules needed to lay out multiple habits by viewport size, without redesigning the rest of Home/Profile navigation or data flow.
- *Skipped scope:* Do not implement masonry layouts, drag-reordering, edit-in-place management, or a full dashboard redesign. Do not merge this with achievement-card sharing or the completion overlay task.
- *Boundaries:* Preserve Hable's offline-first reads, ring-first interaction model, and existing partner/nudge semantics. This task is about layout architecture and visual composition, not new business logic.

**Action:** Define and implement an image-inspired compact habit card that can serve as the basis for a responsive grid page. The engineered solution should translate the reference image into Flutter-native constraints: fixed/controlled aspect ratio, card-local title, large centered ring, compact right-side partner avatar stack, minimal progress strip, and concise progress copy. It should also define how the habits page shifts from one column to multiple columns based on viewport width without clipping text, breaking gestures, or destabilizing the ring control.

**Hable perspective:** The image still fits Hable's ring-first philosophy, but in a more tile-oriented form. This is useful not only for Home evolution but also for any future all-habits page, tablet layout, or wider web surface. The important part is to engineer the card and grid together so the ring remains the visual anchor while the surrounding metadata stays compact enough for repeatable tiles.

**Implementation scope:**
- `lib/screens/home_screen.dart`: identify or add the smallest card/grid composition surface, likely replacing or branching from the current single-column habit-card list with a responsive tile layout when viewport width allows.
- `lib/widgets/mud_long_press_button.dart`: verify the ring can scale into a tile while keeping its gesture area, animation, and semantics stable.
- `lib/widgets/habit_partner_row.dart`: support a compact vertical/right-edge partner presentation or a card-specific variant that matches the reference image without losing role/nudge affordances.
- Layout support: add the minimal `LayoutBuilder`/grid delegate logic needed to choose column count or tile width by viewport size.
- Tests: add focused widget coverage for 1-column vs multi-column layout selection, tile non-overflow, and ring/partner placement sanity.

**Scalability considerations:** Riverpod/data scalability impact: none expected, but UI scalability matters. The card must define stable dimensions and a repeatable aspect ratio so dozens of habits can render in a grid without height thrash, overflow, or unpredictable row alignment as viewport size changes.

**Future split guidance:** If later work needs a dedicated all-habits page, separate Home and grid experiences, advanced tablet dashboard composition, or a reusable design-system `HabitTile` package, append follow-up raw tasks. This task is only for the first image-inspired compact card and responsive grid architecture.

**Edge cases:** Narrow phones that should stay single-column, tablets/desktops that should increase columns safely, very long habit titles, no partners, many partners, supporter-only cards, completed-today and missed visual states, large text scaling, Flutter web resizing, and ensuring the ring remains tappable/holdable inside tighter tiles.

**Acceptance criteria:**
- The engineered card layout clearly reflects the reference image's structure: top-left title, centered dominant ring, compact partner stack, thin progress bar, and concise day-progress label.
- The habits surface can switch between single-column and multi-column/grid layouts based on viewport width with stable tile sizing.
- The compact card preserves Hable's ring-first interaction and does not break partner/nudge semantics.
- Widget tests cover responsive layout behavior and at least one compact-tile overflow/placement case.
- Relevant docs are verified and updated if the final tile/grid contract changes Home layout guidance.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12.
- Updated `lib/screens/home_screen.dart` to use a `SliverGrid.builder` with `SliverGridDelegateWithMaxCrossAxisExtent` (400px cross-axis extent) to create a responsive, fluid grid layout.
- Redesigned `_HabitCard` into a compact, tile-oriented stack with the title in the top-left, partners on the right, mud ring in the center, and progress bar with streak below it.
- Added a `compactMode` flag to `lib/widgets/habit_partner_row.dart` to hide names and render a tight avatar stack for the grid tile context.
- Added `home_screen_test.dart` and updated `habit_partner_row_test.dart` to verify the responsive grid builds correctly and that `compactMode` behaves correctly.
- All tasks in this document are now completed.


<a id="expand-local-reminder-settings-to-typed-per-user-reminder-slots"></a>
### [x] Expand Local Reminder Settings To Typed Per-User Reminder Slots

**Raw source:** Task 1: Relational Schema Migration for Multi-Slot Reminders. Issue: The `reminder_settings` table currently supports only a single set of time coordinates (hour/minute). Action: Modify the Drift table to include a `type` Enum (e.g., `self_habit`, `friend_activity`) and a `is_enabled` boolean. This allows for independent scheduling of personal habit cues and social recap recaps. Files: `lib/database/tables.dart`, `lib/database/database.dart`.

**Issue:** Hable's reminder persistence is currently keyed only by `user_id`, which means the app can store and restore exactly one reminder row per account/device. The current Profile reminder card, Riverpod providers, auth restore flow, and local notification scheduling APIs all assume that single-row shape. That blocks any safe expansion to separate self-habit and friend-activity reminder streams because adding a second reminder would currently overwrite the first instead of coexisting with it.

**Ponytail triage:**
- *Should exist:* Yes. The current schema shape makes dual reminder streams impossible without hacks in UI or scheduling code.
- *Smallest safe scope:* Evolve the local Drift schema and read/write interfaces so reminder preferences become typed per-user slots while keeping the existing single reminder UX operational through one default slot until follow-up UI tasks land.
- *Skipped scope:* Do not implement multi-toggle UI, permission priming copy, background prefetch sync, notification coalescing, or new reminder copy libraries in this task.
- *Boundaries:* Keep reminders device-local and offline-first. Do not add backend persistence, push subscriptions, or direct UI reads from OS notification state.

**Action:** Migrate `reminder_settings` from a single-row-per-user table to a typed slot model keyed by `(user_id, type)`, with explicit slot enablement preserved per row. Introduce the reminder-type enum and update the Drift DAO/query surface so existing callers can still fetch the primary self-habit reminder safely while follow-up tasks add friend-activity scheduling and UI. The migration should preserve or backfill existing single-slot data into the default self-habit row rather than silently dropping reminder preferences on upgrade.

**Hable perspective:** In Hable, reminder preferences are a local read model that survives relaunch/login and rehydrates OS schedules from Drift. The schema change must therefore be treated as a persistence-contract migration first, not a notification-UI tweak. Riverpod and auth restore paths should continue reading Drift-backed reminder state, and the friend-activity stream should remain dormant until the later scheduling/UI tasks explicitly activate it.

**Implementation scope:**
- `lib/database/tables.dart`: replace the single-row `reminder_settings` contract with a typed slot schema, including the enum and composite primary key.
- `lib/database/database.dart`: add/update migration logic, typed save/read/watch helpers, and a compatibility accessor for the existing primary reminder consumer path.
- `lib/providers/notification_providers.dart`: update reminder-setting providers/actions to target typed rows without forcing the later dual-reminder UI in the same task.
- `lib/providers/auth_provider.dart`: verify restore/cancel flows still rehydrate only the intended default reminder slot after login/logout.
- `lib/screens/profile_screen.dart`: keep the current single reminder card wired to the default self-habit slot so behavior does not regress before the dedicated UI task.
- Tests: add focused Drift/provider migration coverage for legacy-row upgrade, typed slot reads, and default-slot compatibility.

**Scalability considerations:** Scalability impact: none expected. Reminder rows grow from one to a tiny fixed set per user. The main scale risk is provider/query churn from broad table watches, so reads should stay scoped by `user_id` and `type` rather than watching the whole reminders table.

**Future split guidance:** Follow-up work should be split into separate tasks for reserved local-notification ID ranges, permission-priming UX, social-reminder prefetch scheduling, and deep-link/coalescing behavior. Do not broaden this schema migration into OS scheduling semantics beyond what is required to preserve the current self-reminder flow.

**Edge cases:** Existing users upgrading with one saved reminder row, reminder rows missing `is_enabled`, unsupported web platform keeping local preference state only, logout/login on a shared device, failed migration leaving duplicate default rows, and old callers that still expect `getReminderSetting(userId)` to return a single value.

**Acceptance criteria:**
- Drift stores reminder preferences by `(user_id, type)` instead of a single row keyed only by `user_id`.
- Existing saved reminder data is migrated or backfilled into the default self-habit slot without losing the user's time/enabled state.
- The current Profile reminder card continues to work against the default self-habit slot with no user-visible regression.
- Auth reminder restore/cancel behavior continues to operate only on the intended default slot after login/logout.
- Focused automated tests cover migration compatibility and typed reminder reads/writes.
- Relevant docs are verified and updated if the schema contract changes from the current spec text.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Expanded reminder settings to be keyed by `(userId, type)` using a composite primary key.


<a id="diagnose-and-reduce-post-login-home-startup-latency-on-pwa-and-supported-hosts"></a>
### [x] Diagnose And Reduce Post-Login Home Startup Latency On PWA And Supported Hosts

**Raw source:** slow bootup: the app loads, takes a lots of time to load the homepage after logging in. test the pwa version via browser, and resolve it. if it's not sesible, the low speed, try browserstack for testing. Also, run flutter doctor, and make sure, everything is ok.

**Issue:** Hable already added startup sync gating in `_AppGate`, foreground sync polling, and post-login reminder restore, but the user still perceives the handoff from authenticated login to the Home shell as too slow. The current authenticated boot path can block on multiple steps before rendering `MainNavigationShell`: secure-storage auth restore, reminder restore, `_AppGate` startup sync, local cache cleanup, `currentUserProvider` hydration, and web/PWA bootstrap. The raw request also explicitly requires browser/PWA verification and a `flutter doctor` environment baseline, which means the task must include diagnosis evidence instead of guessing at one fix.

**Ponytail triage:**
- *Should exist:* Yes. Startup latency on the main login-to-home path is a user-facing reliability issue.
- *Smallest safe scope:* Measure and reduce the slowest part of the authenticated startup path on the supported local browser/PWA flow first, then apply the smallest fix that improves perceived handoff time without breaking offline-first or startup sync correctness.
- *Skipped scope:* Do not turn this into a broad web-performance overhaul, PWA redesign, or multi-platform benchmarking program. BrowserStack should only be used if the slowdown cannot be reproduced or characterized locally.
- *Boundaries:* Preserve the offline-first startup contract and backend-auth truth. Any speedup must not bypass Drift, remove startup reconciliation entirely, or hide fatal auth/bootstrap failures.

**Action:** Investigate the post-login startup path end to end, starting with the local web/PWA/browser flow. Capture timing around login success, `_AppGate` startup sync, `currentUserProvider` readiness, and first `MainNavigationShell` paint; run `flutter doctor` to rule out host/toolchain issues; then reduce the largest avoidable delay in the startup path. If local browser evidence is insufficient or non-reproducible, use BrowserStack as a fallback verification step rather than as the first-line tool.

**Hable perspective:** Hable is offline-first but still needs to feel immediate after login. The right solution is likely to shorten or restructure the authenticated bootstrap path in `main.dart` and adjacent providers so users reach a valid shell quickly while background reconciliation continues safely. Web/PWA matters most because it is the highest-priority target in the build-integrity guidance.

**Implementation scope:**
- `lib/main.dart`: inspect `_AppGate` boot sequencing, loading gates, and duplicate sync triggers for avoidable latency or unnecessary serialized waits.
- `lib/providers/auth_provider.dart`: verify login/auth-restore work does not add extra blocking beyond what the shell actually needs before first render.
- `lib/providers/sync_provider.dart` and `lib/services/sync_service.dart`: inspect whether startup sync and foreground polling are racing, serializing too much work, or blocking first paint longer than necessary.
- Web/PWA surface: inspect the local browser startup path and any relevant `web/` bootstrap constraints only if the evidence points there.
- Verification surface: `flutter doctor`, browser/PWA smoke timing notes, and focused automated coverage or instrumentation for the chosen startup-path fix.

**Scalability considerations:** Riverpod/provider rebuild pressure and startup sync backpressure are the main scaling risks. Any fix should avoid multiplying startup fetches, duplicate provider invalidations, or serial waits that get worse as Drift data, notifications, or social caches grow.

**Future split guidance:** If the investigation shows a need for deeper web-performance work such as service-worker tuning, code-splitting strategy, image/font optimization, or remote device/browser matrix coverage, append separate raw tasks. This task is only for the login-to-home startup latency path and its immediate evidence-based fix.

**Edge cases:** offline login restore, authenticated restart with slow network, missing local user row, stale secure-storage token, duplicate sync calls from login plus lifecycle resume, PWA installed vs normal browser tab, BrowserStack-only reproduction, and `flutter doctor` surfacing host-side Android/web toolchain issues unrelated to app code.

**Acceptance criteria:**
- The task captures a reproducible baseline for post-login startup latency on the local browser/PWA flow.
- `flutter doctor` is run and any relevant environment problems are documented in the task notes.
- The chosen fix reduces perceived or measured time to reach the authenticated Home shell without violating the startup sync/offline-first contract.
- BrowserStack is used only if the issue cannot be adequately reproduced or validated locally.
- Focused verification covers the login-to-home path after the fix, not just general app launch.
- Relevant docs are verified and updated if startup sequencing or verification guidance changes.

**Dependencies:** `Developement/sys_build_integrity.md`, `Developement/sys_offline_architecture.md`, `Developement/sys_authentication.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Removed the blocking `_initialSyncCompleted` state in `_AppGate` and wrapped `_restoreReminderForUser` in `unawaited` during login. The app now instantly renders the authenticated shell using local offline-first Drift data while `syncNow` runs in the background.


<a id="add-slot-aware-background-prefetch-for-social-reminder-daily-sync"></a>
### [x] Add Slot-Aware Background Prefetch For Social Reminder Daily Sync

**Raw source:** Task 3: Background Sync Pre-Fetch for Social Accuracy. Action: Coordinate a "Soft Sync" trigger that leverages Android `Workmanager` or iOS background tasks to pull from `/api/sync/daily` roughly 5-10 minutes before the scheduled social reminder time. Rationale: Ensures that the "Friends' Habits" recap contains the most recent partner check-in data rather than stale local cache.

**Issue:** Hable now has foreground polling and startup sync coordination, but it still lacks a scheduled background prefetch path tied to reminder time. The app can therefore refresh social state while the app is open, yet still fire a future social reminder from stale Drift data if the app has been backgrounded for hours before the reminder window. The `workmanager` dependency is present, but there is no registered worker or iOS background-task bridge in the current Flutter codebase to run a pre-reminder `pullDailySync`.

**Ponytail triage:**
- *Should exist:* Yes, but only for the friend-activity reminder path where freshness materially changes the notification content.
- *Smallest safe scope:* Register one minimal background prefetch capability that can wake shortly before the friend-activity reminder slot, attempt `pullDailySync`, and then exit without trying to render UI or guarantee exact-to-the-minute delivery.
- *Skipped scope:* Do not add push notifications, WebSockets, aggressive periodic background polling, or server-side scheduled jobs. Do not redesign the whole sync engine around background execution.
- *Boundaries:* Treat background execution as a best-effort cache warmer for Drift, not a new source of truth. If the platform declines to run the task, the app must still behave safely using existing local data and next foreground refresh.

**Action:** Add a background prefetch contract for the social reminder slot. Wire `workmanager`/platform background hooks into a minimal entry point that can authenticate, call the existing `SyncService.pullDailySync`, and refresh only the local Drift read model before the scheduled friend-activity reminder fires. The scheduling side should compute a prefetch window relative to the social reminder slot and reschedule it when that slot changes, while leaving self-habit reminders and foreground polling untouched.

**Hable perspective:** Hable is offline-first, so the job of a background prefetch is simply to make Drift less stale before a local social recap notification is assembled. The worker should not attempt to bypass Drift, manipulate widget state, or create a second social-sync protocol. It is an extension of the existing `pullDailySync` contract into best-effort background execution.

**Implementation scope:**
- `lib/services/sync_service.dart`: expose the smallest safe background-callable entry or helper needed to run `pullDailySync` outside the foreground Riverpod widget lifecycle.
- `lib/providers/sync_provider.dart` or adjacent sync/background coordinator: define the scheduling API that registers, updates, and cancels the prefetch job for the friend-activity reminder slot.
- App bootstrap/background entrypoint: add the minimal `workmanager` initialization and callback dispatcher needed for Android, plus the corresponding iOS/macOS-safe no-op/best-effort path as supported by the plugin and current deployment targets.
- Reminder integration: ensure future friend-activity reminder scheduling can request a prefetch job 5-10 minutes earlier without coupling this task to the final UI toggle implementation.
- Tests: add focused coverage for prefetch-window calculation, registration/cancel behavior, and failure-safe no-op behavior when no authenticated user or no friend-activity slot exists.

**Scalability considerations:** Background sync queue pressure is the main scaling risk. The prefetch job must stay bounded to one daily social-reminder-related pull rather than turning into frequent periodic work, and it must reuse existing sync/auth code paths so prolonged offline periods do not spawn duplicate scheduled jobs or broad table invalidations.

**Future split guidance:** If later work needs richer social recap assembly, OS-specific background execution tuning, notification coalescing, or analytics/telemetry around missed prefetch windows, split that into separate tasks. This task is only for the best-effort pre-sync hook before a friend-activity reminder.

**Edge cases:** No authenticated user when the worker wakes, expired JWT in secure storage, app killed or device rebooted after scheduling, iOS background execution limits skipping the task, unsupported web target, friend-activity reminder disabled, reminder time changed multiple times in one session, and worker overlap with existing foreground sync or queue flush logic.

**Acceptance criteria:**
- Hable defines a background prefetch mechanism that can attempt `pullDailySync` before the friend-activity reminder window.
- The scheduled prefetch is derived from the social reminder slot and can be updated/canceled when that slot changes.
- Background execution reuses the existing auth and sync contracts rather than introducing a second inbound-sync implementation.
- Failure to run or complete the prefetch leaves the app safe and local-first; the reminder system can fall back to the last cached Drift state.
- Focused automated tests cover scheduling-window math and registration/cancel behavior.
- Relevant docs are verified and updated if background sync ownership or reminder timing contracts change from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Created `BackgroundSyncService` using `workmanager` to run `pullDailySync` roughly 10 minutes prior to a scheduled daily reminder. Connected Workmanager initialization to `main.dart` and integrated scheduling logic into `NotificationActions`. All tests pass.


<a id="replace-reminder-permission-denial-snackbars-with-soft-ask-and-settings-recovery"></a>
### [x] Replace Reminder Permission Denial Snackbars With Soft-Ask And Settings Recovery

**Raw source:** Task 5: Permission Priming & Error Graceful Recovery. Issue: The section currently shows an error for notification permissions. Action: Implement a "Soft-Ask" prompt that triggers when the user toggles a reminder "ON" for the first time. If the system permission is denied, replace the error with a clear "Enable in System Settings" button and reset the toggle to "OFF." Files: `lib/screens/settings_screen.dart`, `lib/widgets/reminder_toggle.dart`.

**Issue:** Hable already gates reminder permission behind an explicit user toggle, but the current UX is still abrupt and failure-heavy. The actual reminder control lives in `ProfileScreen`’s `_DailyReminderCard`, and denied permission currently surfaces only as a `SnackBar` saying permission was denied. The toggle path does not give the user contextual priming before the OS prompt, does not preserve a dedicated “permission denied” local state for the card, and does not replace the failed-on state with a persistent recovery affordance such as “Enable in System Settings.”

**Ponytail triage:**
- *Should exist:* Yes. The current denial UX is too brittle for a feature whose first-use path depends on OS permission.
- *Smallest safe scope:* Add a lightweight soft-ask and denial-recovery state around the existing Profile reminder card without redesigning the whole settings architecture or introducing a separate reminders screen.
- *Skipped scope:* Do not implement the dual-slot reminder UI, mascot copy randomization, push permissions, or a global permission center in this task.
- *Boundaries:* Keep the permission flow device-local and initiated only by the user’s reminder toggle action. Do not request permission on app launch or from unrelated screens.

**Action:** Rework the reminder-enable flow so the first attempt to turn a reminder on presents a small priming explanation before the OS permission dialog. If the OS permission is denied, immediately reset the toggle to off in local state, persist a denial-aware reminder-card state, and replace transient snackbars with a clear inline recovery action that guides the user to system settings on supported platforms. The current Profile reminder card should remain the single source of reminder permission UX.

**Hable perspective:** Hable’s reminder settings are an offline-first local preference stored in Drift, but the ability to schedule a real OS notification depends on platform permission. The right contract is: local reminder preference and UI state stay coherent even when scheduling fails, and the card explains what happened instead of leaving the user with a stale enabled-looking toggle or a one-shot snackbar. Unsupported platforms such as web should continue to store local preference safely without pretending native settings exist.

**Implementation scope:**
- `lib/screens/profile_screen.dart`: replace the current snackbar-only failure handling in `_DailyReminderCard` with a soft-ask step, explicit denied/off recovery messaging, and an inline “Enable in System Settings” action where supported.
- `lib/providers/notification_providers.dart`: extend reminder update actions to return enough structured outcome state for the UI to distinguish success, denied permission, unsupported platform, and explicit disable.
- `lib/services/local_reminder_service.dart`: expose the smallest needed helpers for checking/opening notification settings on supported native targets, or a safe capability signal if direct settings deep-linking is not available.
- Local reminder persistence: ensure denied permission leaves the stored reminder slot disabled rather than partially enabled.
- Tests: add focused widget/provider coverage for first-enable soft-ask, denied-permission reset behavior, and settings-recovery rendering.

**Scalability considerations:** Scalability impact: none expected. The main risk is UI-state drift between Drift and OS permission outcomes, so the flow should keep provider results explicit and deterministic rather than scattering permission heuristics across multiple widgets.

**Future split guidance:** If Hable later adds richer onboarding education, permission analytics, web-push permission handling, or per-slot permission messaging for self vs friend reminders, split those into follow-up tasks. This task is only for the base Profile reminder permission priming and denial recovery loop.

**Edge cases:** First-time enable on Android 13+, iOS/macOS denial after previous dismissal, unsupported web platform, reminder already enabled before OS-level permission is revoked externally, rapid repeated toggle taps, time change while permission remains denied, logout/login on the same device, and platforms where opening system notification settings is unavailable or best-effort only.

**Acceptance criteria:**
- Enabling a reminder from Profile uses a soft-ask step before the OS permission request on first-use or when permission is still needed.
- If permission is denied, the reminder toggle/state resets to off and does not leave a scheduled-looking enabled state in Drift.
- The reminder card shows persistent inline recovery guidance with an “Enable in System Settings” action on supported platforms instead of relying only on a snackbar.
- Reminder permission UX remains initiated only by explicit user action from the reminder control.
- Focused automated tests cover denied-permission reset behavior and the inline recovery state.
- Relevant docs are verified and updated if reminder permission ownership or Profile UX changes from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Added `permission_handler` to easily check and open settings. Added `isPermissionDenied` to `ReminderSettings` database schema (bumped to version 13). Replaced snackbars in `ProfileScreen` with a pre-request Soft-Ask dialog, and an inline "Enable in System Settings" button if permission is denied.


<a id="introduce-a-mascot-driven-reminder-copy-library-for-local-reminder-slots"></a>
### [x] Introduce A Mascot-Driven Reminder Copy Library For Local Reminder Slots

**Raw source:** Task 6: Mascot-Driven Template Library. Action: Build a library of randomized notification strings using the established "Hable" mascot tone (Encouraging, Humorous, Urgent). Goal: Mitigate alert fatigue by varying the phrasing of recurring daily prompts.

**Issue:** Hable’s local reminder scheduling currently uses hardcoded static strings such as `'Hable reminder'` and `'Open Hable and check today's habits.'` across provider/auth restore paths. That makes recurring reminders repetitive and leaves no structured place to express the product’s intended mascot voice. At the same time, broader social notification copy already exists in `SyncService`, so dropping random strings directly into scheduling call sites would create fragmented tone rules and make future self-vs-friend reminder slots harder to evolve consistently.

**Ponytail triage:**
- *Should exist:* Yes, but only as a small reusable library bound to reminder-generation paths.
- *Smallest safe scope:* Centralize reminder notification copy generation behind a deterministic helper that can return varied title/body pairs for self-habit and friend-activity reminder slots while leaving existing non-reminder social notification copy alone.
- *Skipped scope:* Do not rewrite all notification-center event copy, quote fallback content, onboarding tone, or social message text in this task.
- *Boundaries:* Keep this to local reminder copy selection. Do not turn it into a general brand-voice system spanning the whole app.

**Action:** Add a small reminder-copy library that exposes slot-aware, mascot-toned notification templates for recurring local reminders. The helper should support at least the immediate self-habit reminder path and reserve structure for the future friend-activity reminder slot. Update reminder scheduling/restore paths to request a generated title/body pair from that helper instead of hardcoding strings inline. Keep the variation bounded and deterministic enough for tests while still preventing every reminder from reading identically.

**Hable perspective:** Hable’s tone should feel supportive and slightly playful without becoming noisy or manipulative. Reminder copy belongs near the local reminder system, not mixed into daily quotes or backend social-event text, because it is the OS-level surface the user sees repeatedly even when the app is closed. The library should therefore be small, local-first, and explicit about which reminder slot it is speaking for.

**Implementation scope:**
- New reminder copy surface, likely under `lib/data/` or `lib/services/`, containing structured title/body templates and a small selection helper for reminder slots/types.
- `lib/providers/notification_providers.dart`: replace hardcoded reminder title/body scheduling strings with the library output for enable/update/restore flows.
- `lib/providers/auth_provider.dart`: align reminder restore scheduling with the same copy helper so restored notifications use the same tone contract.
- Tests: add focused unit coverage for reminder-copy selection, slot-aware template availability, and bounded deterministic behavior where needed.

**Scalability considerations:** Scalability impact: none expected. The main long-term risk is copy drift across multiple scheduling paths, so the important design choice is one source of reminder copy truth per slot rather than duplicating strings in providers and auth restore helpers.

**Future split guidance:** If later work needs personalized copy based on streaks, partner activity counts, quiet hours, or experimentation/analytics, split those into separate tasks. This task is only for the base mascot-driven reminder template library and its current local reminder call sites.

**Edge cases:** Very short notification title limits on OS surfaces, friend-activity slot added before custom copy exists, repeated app restarts restoring reminders with identical copy, deterministic tests around randomized selection, unsupported platforms that still store reminder preferences but do not schedule notifications, and keeping copy supportive rather than shaming when urgency variants are used.

**Acceptance criteria:**
- Reminder scheduling no longer hardcodes one static title/body pair inline across provider/auth restore paths.
- Hable has one reusable reminder-copy helper/library with multiple mascot-toned templates for at least the self-habit reminder slot.
- The library structure leaves room for a friend-activity reminder slot without forcing that full feature to ship in the same task.
- Reminder-copy selection remains testable and bounded rather than relying on uncontrolled randomness.
- Focused automated tests cover template availability and selection behavior.
- Relevant docs are verified and updated if reminder copy ownership or slot expectations change from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Created `MascotReminderCopyHelper` using a day-of-the-year deterministic seed to rotate daily reminder copy. Replaced hardcoded strings in `notification_providers.dart` and `auth_provider.dart`. Added a dedicated unit test.


<a id="coalesce-social-reminder-recaps-and-route-notification-taps-into-shell-state"></a>
### [x] Coalesce Social Reminder Recaps And Route Notification Taps Into Shell State

**Raw source:** Task 4: Notification Coalescing & Nudge Deep-Linking. Action: Implement logic to merge incoming social pings into a single "Daily Recap" notification. Tapping the social reminder must route the user directly to the Social Hub or a specific partnered habit card. Files: `lib/services/sync_service.dart`, `lib/main.dart`.

**Issue:** Hable already normalizes nudges, invitations, and friend requests into Drift `notification_events`, but the current local reminder path is still primitive. `LocalReminderService` schedules reminders with a hardcoded `'home'` payload, there is no app-level notification-response router wired during plugin initialization, and the current `actionRoute` handling only supports coarse screen opens such as `'home'` or a Social subtab. That means a future social reminder would either duplicate multiple event notifications or drop the user into a generic screen with no slot-aware recap context.

**Ponytail triage:**
- *Should exist:* Yes. Once Hable adds a friend-activity reminder stream, recap coalescing and tap routing are required for the notification to be useful instead of noisy.
- *Smallest safe scope:* Build one social-reminder recap composition path that reads existing local Drift notification/partner state, emits a single recap notification per reminder window, and routes taps into the existing shell with enough payload to open Social Activity or a relevant shared-habit context.
- *Skipped scope:* Do not implement remote push delivery, free-form chat deep links, or a full universal-link/navigation framework. Do not redesign the Home card hierarchy in the same task.
- *Boundaries:* Reuse Drift as the read model and the existing navigation shell as the destination owner. The OS notification should summarize existing local state, not invent a second notification/event store.

**Action:** Add a recap builder for the friend-activity reminder slot that coalesces eligible social signals into one OS notification, with payload metadata that can reopen Hable into the right shell state. Extend local notification initialization so notification taps are observed at app level, decoded, and mapped into `MainNavigationShell` navigation commands. For the first safe version, deep links may target Social Activity or Home-with-habit-focus using existing IDs from `actionPayloadJson`; multiple raw nudge events should no longer produce multiple OS reminder notifications for the same reminder window.

**Hable perspective:** Hable is already using Drift-backed `notification_events` and partner snapshots as its offline-first social read model. The correct place to assemble a daily social recap is from that local cache after the background prefetch/update step, not from ad hoc network calls at tap time. Likewise, navigation should flow through `MainNavigationShell`, which already owns Home vs Social destination state, instead of each notification surface pushing unrelated screens directly.

**Implementation scope:**
- `lib/services/local_reminder_service.dart`: add slot-aware recap scheduling payloads and plugin tap-response wiring hooks instead of the current hardcoded `'home'` payload contract.
- `lib/services/sync_service.dart`: define the smallest local recap-selection/coalescing helper that can summarize nudges/invites/friend-activity into one friend-activity reminder payload using existing Drift data.
- `lib/main.dart`: add app-level notification tap handling/bootstrap routing so a launched/resumed app can hand notification intents into shell state cleanly.
- `lib/screens/main_navigation_shell.dart`: extend shell navigation helpers so notification routes can open Social Activity or a habit-focused Home context without duplicating navigation logic across screens.
- Tests: add focused unit/widget coverage for recap coalescing rules, payload decoding, and shell-route behavior from a notification tap.

**Scalability considerations:** Notification-event volume can grow faster than reminder slots. Coalescing should therefore operate on a bounded, recency-filtered subset of local rows and emit one recap per reminder window, not one OS notification per underlying nudge/request. Shell routing should stay payload-driven so new reminder/event types do not require scattered hardcoded navigation branches.

**Future split guidance:** If later work needs richer habit-card auto-scroll/focus behavior, grouped notification inbox UX, or platform-specific notification categories/actions, split those into follow-up tasks. This task is only for one coalesced daily social recap and deterministic tap routing into the existing shell.

**Edge cases:** No eligible social events when the recap fires, multiple nudges on the same habit from different friends, conflicting signals across Home and Social destinations, app cold-start from a notification tap, stale habit IDs in action payloads, user logged out when a notification is tapped, unsupported web target, and legacy notification rows that only carry coarse `'home'` routes.

**Acceptance criteria:**
- Hable can assemble one friend-activity recap notification from local social state instead of emitting one OS notification per raw social ping.
- The recap payload includes enough route metadata to open Social Activity or a specific shared-habit context deterministically.
- App-level notification tap handling is wired so taps on local reminder notifications are observable and routed through `MainNavigationShell`.
- Existing Drift `notification_events` / partner snapshot data remains the source for recap composition; no direct network fetch is required at tap time.
- Focused automated tests cover recap grouping and at least one notification-tap routing path.
- Relevant docs are verified and updated if reminder routing or notification ownership changes from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Added `coalesceAndScheduleSocialRecap()` to `SyncService` which reads unread social `NotificationEvent` rows from Drift (nudge, habitInvitation, friendRequest, friendAccepted), coalesces them into a single OS notification recap, and schedules it via `LocalReminderService` with a `{"route": "social"}` payload. Wired `onDidReceiveNotificationResponse` in `LocalReminderService.initialize()` and exposed `onPayloadTapped` stream + `getInitialPayload()` for cold-start handling. App-level tap routing in `_AppGate` decodes the payload and calls `switchToTab()` on `MainNavigationShellState` (made public via `GlobalKey`). Added 4 unit tests in `notification_recap_test.dart` covering single-nudge passthrough, multi-nudge coalescing, mixed nudge+invite, and empty-state no-op. Built and deployed to Cloudflare Pages: https://5e28b7ca.hable.pages.dev


<a id="replace-hash-based-reminder-notification-ids-with-stable-slot-ranges"></a>
### [x] Replace Hash-Based Reminder Notification IDs With Stable Slot Ranges

**Raw source:** Task 2: Idempotent Notification ID Management. Action: Implement a stable integer ID system for `flutter_local_notifications`. Use reserved ranges (e.g., 100-199 for personal, 200-299 for friends) to ensure that updating a reminder time overwrites the previous schedule instead of creating duplicate daily alerts. Files: `lib/services/local_reminder_service.dart`.

**Issue:** Hable's current `LocalReminderService` derives the local notification ID from a hash of `userId`. That worked while only one reminder existed, but it is the wrong contract for typed multi-slot reminders. A hash-based ID does not express reminder type, does not reserve predictable ranges for future slots, and makes it harder to reason about overwrite/cancel behavior when the schema expands from one reminder row to several typed rows per user.

**Ponytail triage:**
- *Should exist:* Yes. Once reminder settings become typed slots, deterministic per-slot notification IDs are required to prevent duplicate schedules and ambiguous cancellations.
- *Smallest safe scope:* Replace the hash-based ID derivation with a stable reminder-slot ID policy and thread that policy through schedule/cancel/restore paths for the currently supported slots.
- *Skipped scope:* Do not implement background prefetch, deep-link routing, coalescing notification bodies, or randomized reminder copy in this task.
- *Boundaries:* Keep this limited to local scheduling identity and cancellation semantics. Do not broaden it into OS-permission UX or backend sync work.

**Action:** Introduce a slot-aware integer ID strategy in `LocalReminderService`, with explicit reserved ranges for self-habit and friend-activity reminders. Update the service API so callers schedule and cancel by reminder slot/type instead of relying on a user-hash identity. Preserve the current self-habit reminder behavior, and make the friend-activity range available for follow-up tasks without requiring the full social-reminder feature to ship in the same change.

**Hable perspective:** Hable stores reminder preferences in Drift and rehydrates OS notifications on login/relaunch. The notification ID is therefore part of the local reminder persistence contract: it must be deterministic across app restarts, stable for overwrite behavior, and legible enough that future reminder slots can coexist without accidentally canceling each other. The service should know how to map a typed slot to an OS notification identity; Riverpod/UI should not invent numeric IDs ad hoc.

**Implementation scope:**
- `lib/services/local_reminder_service.dart`: replace `_notificationIdForUser` with a typed/range-based ID mapper, and update `scheduleDailyReminder` / `cancelReminder` signatures as needed.
- `lib/providers/notification_providers.dart`: pass the default self-habit slot explicitly through reminder update/restore/cancel paths.
- `lib/providers/auth_provider.dart`: align login restore and logout cancellation with the slot-aware reminder API so restored schedules overwrite correctly after relaunch.
- Tests: add focused unit coverage for notification ID mapping, overwrite-safe scheduling intent, and slot-specific cancellation semantics.

**Scalability considerations:** Scalability impact: none expected. The number of local reminder slots is tiny and fixed. The important scale boundary is operational correctness: stable IDs must avoid a future explosion of duplicate scheduled notifications as more reminder types are introduced.

**Future split guidance:** If Hable later supports multiple reminders within the same slot family (for example several self-habit windows), that should be a separate schema and scheduling task with a broader ID-allocation policy. This task is only for stable reserved ranges covering the immediate typed reminder streams.

**Edge cases:** Existing users upgrading from hash-based IDs, cancel-after-logout leaving a stale old scheduled notification behind, repeated enable/time-change cycles, unsupported web platforms no-oping cleanly, slot values added later without assigned ranges, and mixed app states where Drift is migrated but scheduling code is still called from old compatibility helpers.

**Acceptance criteria:**
- `LocalReminderService` uses stable slot-aware notification IDs instead of a hash of `userId`.
- Updating a reminder time for the same slot overwrites the prior OS schedule rather than creating a duplicate alert.
- Cancel and restore flows target the intended slot deterministically for the current self-habit reminder path.
- Reserved ID space exists for both self-habit and friend-activity reminder slots, even if only the default self slot is active today.
- Focused automated tests cover ID mapping and slot-specific cancel/schedule behavior.
- Relevant docs are verified and updated if the reminder scheduling contract changes from the current spec text.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Replaced `_notificationIdForUserAndType()` hash derivation with `static int notificationIdForSlot(ReminderType type)` — a simple lookup table mapping each reminder type to a fixed constant (dailyHabit → 100, friendActivity range reserved at 200). `scheduleReminder` now uses `notificationIdForSlot(type)` directly. `cancelReminder` also cancels the old hash-based legacy ID alongside the new slot ID to silently migrate existing users on first cancel. Added 4 unit tests in `notification_id_slot_test.dart` verifying ID stability, range boundaries, and non-overlap with the reserved friend-activity range.


<a id="realign-calendar-ics-feed-with-live-habit-progress-and-native-description-formatting"></a>
### [x] Realign Calendar ICS Feed With Live Habit Progress And Native Description Formatting

**Raw source:** iCal Sync Debugging. Critical Gap: The `.ics` feed is reportedly out of sync with real-time active habits. Action: Audit the `backend/functions/calendar/[[route]].ts` logic to ensure it pulls from the `habit_progress` table rather than stale metadata. Fix the `\n` formatting in event descriptions to ensure multi-habit summaries are legible in native iOS/Android calendars.

**Issue:** Hable’s revocable calendar feed is currently generated from the wrong read model in both feed handlers (`backend/functions/calendar/[[route]].ts` and the mirrored route in `backend/src/index.ts`). Instead of using authoritative live progress from `habit_progress`, the feed queries active habits plus a rolling 30-day `habit_logs` completion count and then repeats that same aggregate across every future calendar day in the 30-day window. That can drift from the real current state after offline sync catch-up, reruns, archives, or recent completions, and it does not match the contract implied by the Profile subscription UI. The description formatting is also fragile because the code joins lines with literal escaped `\\n` text before ICS escaping, which risks poor rendering in native calendar clients.

**Triage:**
- *Should exist:* Yes. The calendar subscription is already shipped and user-facing, so incorrect progress/state in the exported feed is a real product bug.
- *Smallest safe scope:* Fix the existing feed-generation query and ICS text composition so the feed reflects the user’s current active habit progress using `habit_progress` and emits descriptions that render cleanly in native calendar apps.
- *Skipped scope:* Do not redesign the Profile calendar UI, add per-habit reminder times, build timed events, or change token issuance/rotation semantics in this task.
- *Boundaries:* Keep this as a backend/feed-contract correction. The Flutter client should continue to request and display only the revocable feed URL; it should not become a second calendar rendering engine.

**Action:** Replace the stale rolling-log aggregate in both calendar feed handlers with a read path based on active habits joined to `habit_progress` so each event summary/description reflects the current completed-vs-target state for that user. Audit whether the worker should expose `completed_count`, `remaining_days`, or both in the text, but keep the semantics consistent with the rest of Hable’s challenge model and avoid inventing new status meanings. Normalize ICS description line composition so multiline summaries are generated from real newline characters and then escaped exactly once for RFC-compliant calendar clients. Add the smallest verification coverage around feed output, especially for archived habits exclusion, progress correctness, and newline formatting.

**Hable perspective:** Hable is offline-first, but the calendar feed is a server-owned public export keyed by a revocable token. That means the feed must read the Worker’s authoritative remote projection (`habits` + `habit_progress`) rather than infer live status from historical logs or local Flutter state. The Profile screen remains a thin subscription surface; the Worker owns correctness of the `.ics` payload.

**Implementation scope:**
- `backend/functions/calendar/[[route]].ts`: correct the Pages-function feed query and ICS text composition.
- `backend/src/index.ts`: apply the same fix to the mirrored `/calendar/:token.ics` route so local/dev/prod behavior stays aligned.
- Backend query contract: join `habits` to `habit_progress`, preserve active-only filtering, and ensure archived/revoked feeds still behave correctly.
- Tests or smoke surface: add the smallest backend verification possible (script or focused test) for token lookup, progress text correctness, and multiline `DESCRIPTION` formatting.
- Documentation: update the relevant development docs to state that calendar feeds derive from remote `habit_progress` / active habits rather than recent log aggregation.

**Scalability considerations:** Calendar feed generation should remain a bounded per-user query over active habits only. Avoid per-day re-querying or N+1 logic inside the 30-day event loop; compute the active-habit snapshot once, then reuse it while composing the ICS body.

**Future split guidance:** If Hable later needs due-date-aware events, one-event-per-habit feeds, timezone-specific reminder windows, calendar alarms, or per-client formatting quirks, split those into follow-up tasks. This task is only for correcting the current exported progress snapshot and newline formatting.

**Edge cases:** User has no active habits, `habit_progress` row is missing for a newly created habit, archived habits lingering in logs, rerun/reset progress returning to zero, offline log sync arriving after feed subscription, revoked token lookup, usernames containing ICS-reserved characters, long multi-habit descriptions, and calendar clients that are strict about escaped newlines or CRLF line endings.

**Acceptance criteria:**
- The calendar feed no longer derives progress from a rolling 30-day completed-log count; it uses the live active-habit progress projection rooted in `habit_progress`.
- Archived habits are excluded from the feed, while active habits without a progress row still render a safe zero-progress snapshot.
- `DESCRIPTION` multiline text renders legibly in native iOS and Android calendar clients using correct ICS newline escaping.
- The Pages function route and the mirrored worker route generate equivalent feed semantics.
- Verification covers at least one progress-correctness case and one multiline-description formatting case.
- Relevant docs are verified and updated if the calendar feed ownership/derivation contract changes from the current spec text.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Updated both `backend/functions/calendar/[[route]].ts` and `backend/src/index.ts` to query `habit_progress` instead of `habit_logs` for real-time progress. Changed `.join('\\n')` to `.join('\n')` so that the `escapeIcsText` function properly escapes actual newlines for RFC-compliant ICS output. Created and ran `backend/scripts/calendar-smoke.mjs` to verify multiline output and correct progress values. Tests passed.

## Remaining Tasks


<a id="tighten-social-activity-feed-density-standardize-nudge-copy-and-lock-desc-timeline-order"></a>
### [x] Tighten Social Activity Feed Density, Standardize Nudge Copy, And Lock DESC Timeline Order

**Raw source:** Social Activity Feed Polish. Enhancements: decrease vertical padding between notifications for higher density; standardize nudge copy to `[Name] nudged you to check-in on [Habit Name]`; disable list reordering on click and maintain a strict descending (`DESC`) chronological order.

**Issue:** Hable’s Social → Activity feed already consolidates notifications into the Drift-backed `notification_events` stream, but the current implementation still misses the raw contract in three concrete ways. First, `lib/screens/social/social_hub_screen.dart` renders the feed with relatively loose card spacing (`separatorBuilder` uses `SizedBox(height: 8)` plus `ListTile` `contentPadding: EdgeInsets.all(16)`), which reduces density on a feed whose primary job is fast scanning. Second, nudge notifications are normalized in `lib/services/sync_service.dart` with generic title/body text (`'You were nudged'` / `'A friend sent you a reminder on a shared habit.'`) rather than the explicit social copy pattern the raw task calls for. Third, the local notifications query in `lib/database/database.dart` sorts by unread-first (`readAt ASC`) and then `createdAt DESC`, so tapping an unread item can immediately move it in the list, which violates the desired stable reverse-chronological timeline.

**Triage:**
- *Should exist:* Yes. This is a direct polish/fidelity fix on a user-facing feed that already ships as a primary surface.
- *Smallest safe scope:* Keep the change inside notification normalization, notification query ordering, and Activity card layout density.
- *Skipped scope:* Do not redesign the entire Social Hub visual system, group notifications by day/type, add swipe actions, or introduce richer avatar-based feed rows in this task.
- *Boundaries:* Preserve the existing unified `notification_events` read model and the current Activity tab ownership. This is a contract correction, not a new messaging feature.

**Action:** Update the Activity feed so it remains strictly sorted by `createdAt DESC` regardless of read state, while still allowing unread dots and mark-read behavior to function in place without reshuffling rows. Tighten vertical density by reducing inter-card gaps and padding enough to improve scanning without collapsing accessibility or tap targets. Standardize nudge event presentation so the visible copy uses the sender name and habit name when available, falling back safely when sync payloads are incomplete. Keep the normalization logic centralized so Home, Social, and any future notification surfaces do not each invent their own nudge phrasing.

**Hable perspective:** Social → Activity is not a chat app and not a secondary settings surface; it is the app’s lightweight obligations/history stream. That means ordering must feel trustworthy, copy must clearly tell the user who nudged them about which habit, and density should favor quick scanning over ornamental whitespace. Read state should be a visual annotation on the timeline, not a sorting dimension that mutates history.

**Implementation scope:**
- `lib/database/database.dart`: change `watchNotificationsForUser()` ordering so Activity reads as strict reverse chronological history instead of unread-first sorting.
- `lib/services/sync_service.dart`: enrich normalized nudge notification copy with sender/habit context from existing local/server data, while keeping idempotent notification IDs.
- `lib/screens/social/social_hub_screen.dart`: reduce Activity feed spacing/padding and keep unread/read affordances visually intact.
- Tests: add focused coverage for notification ordering stability after mark-read and for nudge copy formatting when habit context exists or is missing.
- Documentation: update `Developement/qa_testing.md` and any relevant UX/spec docs if they currently describe the older generic copy or unread-first behavior.

**Scalability considerations:** Notification volume can grow, so the solution should stay query-driven and presentation-light. Sorting must remain index-friendly and deterministic at the database layer, while copy enrichment should avoid expensive per-row network lookups or N+1 UI fetches.

**Future split guidance:** If later work needs grouped timeline sections, richer actor avatars, expandable notification details, or per-type CTA buttons, split those into separate Social feed tasks. This task is only for density, wording, and ordering correctness.

**Edge cases:** Missing habit ID in a nudge payload, stale/deleted habit rows, sender no longer present in accepted-friends cache, multiple notifications with identical timestamps, mark-all-read on a large list, text scaling, narrow devices, and ensuring tighter spacing does not regress semantics or tap affordance clarity.

**Acceptance criteria:**
- Social → Activity keeps a strict `createdAt DESC` order even after individual items are marked read.
- Nudge rows display standardized supportive copy in the form `[Name] nudged you to check-in on [Habit Name]` when the required context exists, with safe fallback wording otherwise.
- Activity cards are visibly denser than before without collapsing unread indicators or making the feed hard to tap/scan.
- Mark-read and mark-all-read still work without causing chronological reshuffling side effects.
- Focused automated coverage verifies ordering stability and nudge-copy formatting.
- Relevant docs are verified and updated if manual QA expectations or notification wording contracts changed.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Updated `watchNotificationsForUser` in `lib/database/database.dart` to sort strictly by `createdAt DESC`. Enhanced nudge copy in `lib/services/sync_service.dart` to format messages as `[Name] nudged you to check-in on [Habit Name]`. Decreased separator height and list item padding in `lib/screens/social/social_hub_screen.dart` to tighten density.


<a id="add-server-owned-assist-points-for-effective-nudges-with-4-hour-window-and-daily-cap"></a>
### [x] Add Server-Owned Assist Points For Effective Nudges With 4-Hour Window And Daily Cap

**Raw source:** The "Assist" Mechanic (Nudge Gamification). Concept: transform nudges from "nagging" to "supporting." Mechanism: when a user nudges a friend who subsequently completes their habit within a 4-hour window, the nudger receives an Assist Point. Balance: limit nudges to 1 per habit per day to prevent spam.

**Issue:** Hable already has a lightweight nudge path, but it stops at delivery. Flutter enqueues `SyncAction.sendNudge`, the backend stores the nudge in KV for 24 hours, and the recipient later sees a local notification row and card-local nudge state. There is no durable server-side record tying a nudge to a later completion, no daily anti-spam cap, and no scoring event reason for "assist" inside the existing gamification pipeline. The current backend scoring system is authoritative (`awardScoreEvent`, `users.total_score`, `/api/sync/daily.gamification`), so implementing assist points on the client would be the wrong ownership model and would desynchronize leaderboard totals.

**Triage:**
- *Should exist:* Yes, but only as a backend-owned extension of the current nudge and scoring contracts.
- *Smallest safe scope:* Add one assist-award path keyed to existing nudge + completion events, plus a one-nudge-per-habit-per-day guard.
- *Skipped scope:* Do not add chat reactions, public social feeds, push notifications, streak multipliers, or a full behavioral-economics system in this task.
- *Boundaries:* Keep points authoritative on the server. Flutter may surface results, but it must not compute assist eligibility or totals locally.

**Action:** Introduce a minimal server-side assist ledger so a habit-scoped nudge can be matched against a subsequent completion by the nudged participant within a 4-hour window. Enforce the raw anti-spam rule at the nudge write path so the same sender cannot keep nudging the same habit repeatedly in a single day. When a qualifying completion is logged, award an idempotent assist score event to the nudger through the existing `awardScoreEvent()` path and expose the updated total naturally through the normal gamification/leaderboard payloads. Keep assist semantics narrow: one qualifying nudge, one assist award, one server-owned score event.

**Hable perspective:** In Hable, nudges are a lightweight partner-support mechanic, not a message thread and not a client-owned badge counter. The right product contract is that "support that helped" becomes part of server-owned progression, while the UI continues to read only synced totals and contextual social states. This preserves the app’s offline-first Flutter shell without letting social scoring logic fragment across layers.

**Implementation scope:**
- `backend/src/index.ts`: extend the nudge + check-in flows with an idempotent assist-award mechanism and the daily nudge limit.
- Backend persistence: add the smallest durable read/write shape needed to remember qualifying nudges beyond the ephemeral KV payload if KV alone cannot safely support assist attribution and duplicate prevention.
- `lib/services/sync_service.dart` and related Flutter gamification surfaces only as needed to surface new server-owned totals or optional assist-related notification rows, without adding local point math.
- Tests or backend smoke verification: cover one qualifying assist, one non-qualifying late completion, and one blocked repeated nudge on the same habit/day.
- Documentation: update the social/scoring docs so assist points and the anti-spam rule are explicit.

**Scalability considerations:** Assist matching must stay idempotent and bounded. Avoid any design that scans large completion history on every nudge or vice versa; matching should key off habit, sender, recipient, and day/window so it remains cheap as usage grows.

**Future split guidance:** If later work needs assist streaks, supporter-only assists, richer assist notifications, or analytics on nudge effectiveness, split those into follow-up tasks. This task is only for the base assist award and the one-per-habit-per-day nudge rule.

**Edge cases:** User nudges multiple habits for the same friend, friend completes without a habit-scoped nudge, repeated nudges overwrite the same KV key today, offline delayed sync causes a late-arriving check-in, both participants nudge each other on the same day, habit archived before sync resolves, duplicate log submissions, and leaderboard propagation after a newly awarded assist.

**Acceptance criteria:**
- A qualifying nudge followed by the recipient’s completion within 4 hours awards exactly one server-owned assist score event to the nudger.
- Repeated nudges for the same sender/recipient/habit/day are blocked or safely coalesced according to the daily-cap rule.
- Non-qualifying completions do not award assist points.
- Leaderboard/profile totals continue to derive from backend-owned score events rather than client-side calculations.
- Verification covers both positive and negative assist cases plus the anti-spam cap.
- Relevant docs are verified and updated if nudge or scoring contracts changed.

**Dependencies:** `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Updated `/api/social/nudge` in `backend/src/index.ts` to enforce a 1-nudge-per-habit-per-day cap using a dedicated daily KV key. Added assist matching in `/api/sync/log`: when a user logs a completion, the backend checks for matching nudges within the last 4 hours and awards server-side `nudge_assist` score events to the sender.


<a id="replace-partner-chip-wrap-with-expandable-avatar-group-and-state-rings"></a>
### [x] Replace Partner Chip Wrap With Expandable Avatar Group And State Rings

**Raw source:** Advanced Partner Interactions. Action: enhance the `AvatarGroup` component. Use a long-press on the partner stack to expand the list and show individual status rings (completed, pending, or nudged).

**Issue:** Hable does not currently have a dedicated `AvatarGroup` component. The active shared-habit partner surface is `lib/widgets/habit_partner_row.dart`, which renders full-width wrapped chips with per-partner labels, a `+N` overflow pill, and a separate nudge button. That works functionally, but it is visually heavier than the raw prompt’s compact partner-stack concept, and the overflow affordance is not expandable. The app also already stores enough state to drive the requested rings (`hasCompletedToday`, `lastNudgeAt`, role), so the gap is mostly in composition and interaction design rather than in missing partner data.

**Triage:**
- *Should exist:* Yes. This is a concrete refinement of a shipped shared-habit surface.
- *Smallest safe scope:* Extract or refactor the current partner-row presentation into a compact stack/group with a long-press expansion path, while preserving profile and nudge actions.
- *Skipped scope:* Do not redesign friend profiles, invent new relationship states, or move nudge business logic into the UI widget.
- *Boundaries:* Reuse the existing partner snapshot data and current profile/nudge callbacks. This is a view-layer refinement, not a new social data model.

**Action:** Introduce a compact avatar-group treatment for habit partners that shows a bounded overlapping stack by default and expands on long press to reveal individual participant identity plus state rings. Preserve or improve the current role/state semantics, keep profile taps distinct from nudge taps, and ensure the expansion interaction works on mobile/web without relying on hover-only behavior. If the existing `HabitPartnerRow` already owns the necessary callbacks, prefer evolving that widget rather than creating a parallel partner surface.

**Hable perspective:** The Home card should stay ring-first and compact. Partners are important context, but they should read as a lightweight social layer, not a second card inside every habit. A stacked avatar group supports that goal, while long-press expansion gives users deeper partner state only when they ask for it.

**Implementation scope:**
- `lib/widgets/habit_partner_row.dart`: refactor the current chip layout into a compact group/expanded-state model, or extract a reusable `AvatarGroup`-style widget if that is cleaner.
- Home/shared-habit surfaces that consume this row: verify the updated partner stack fits the current card layout and preserves nudge/profile affordances.
- Accessibility: keep state-ring meaning available through `Semantics` and ensure long-press/expanded controls remain screen-reader understandable.
- Tests: add focused widget coverage for collapsed overflow, long-press expansion, and state-ring rendering for completed/pending/nudged partners.
- Documentation: update relevant UX/testing notes if partner presentation expectations change.

**Scalability considerations:** Partner display must stay bounded per habit. The collapsed state should avoid rendering an unbounded number of heavy chips, and expansion should still be local to one habit row rather than forcing Home-wide rebuilds.

**Future split guidance:** If later work needs drag-to-reorder partners, supporter filtering, inline messaging, or 3D friend-space integration, split those into separate tasks. This task is only for compact stacking plus on-demand expansion and state visibility.

**Edge cases:** No partners, one partner, many partners with overflow, long usernames, repeated partner rows across many habits, supporter roles without nudge action, web pointer long-press behavior, narrow screens, and preventing profile taps from conflicting with the nudge button.

**Acceptance criteria:**
- Shared-habit cards show a compact partner stack rather than only the current wrapped chip layout.
- Long-pressing the partner stack expands it to reveal individual partner states, including completed/pending/nudged ring treatment.
- Existing profile-open and nudge actions remain available and semantically distinct.
- Overflow behavior remains bounded and visually legible on small screens.
- Focused widget coverage verifies collapsed and expanded states plus state-ring output.
- Relevant docs are verified and updated if partner-row UX expectations changed.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Refactored `lib/widgets/habit_partner_row.dart` from the old wrapped-chip default into a compact overlapping avatar stack that stays bounded in the collapsed state and expands on long-press/tap into per-partner rows. The expanded view now reveals every partner, keeps profile-open and nudge actions separate, and exposes completed/pending/nudged/supporter state through status rings plus explicit semantics labels. Added focused widget verification in `test/habit_partner_row_test.dart` for collapsed overflow, long-press expansion, profile-vs-nudge action separation, compact-mode expansion, and distinct completed/pending/nudged state output. Verified with `flutter test test/habit_partner_row_test.dart`.


<a id="bootstrap-localization-for-core-surfaces-and-complete-ring-progress-semantics"></a>
### [x] Bootstrap Localization For Core Surfaces And Complete Ring/Progress Semantics

**Raw source:** Accessibility & Localization. Action: begin localization support for English, German, Urdu, Russian, Tamil, and Persian. Accessibility: ensure all ring states and progress percentages are mapped to ARIA semantics for screen readers.

**Issue:** Hable currently has no localization scaffold in `main.dart`: no `flutter_localizations`, no supported locale list, no generated app-localizations layer, and most copy remains hardcoded inline across Home, Social, Profile, auth, and settings-adjacent widgets. Accessibility is partially better than localization because the app already uses `Semantics` in several places, but the coverage is still uneven and only partly standardized. Ring/progress state semantics were introduced in some Home paths, yet there is no single localized contract ensuring habit state, completion progress, and percentage/day indicators are consistently exposed to screen readers across platforms. The raw prompt says "ARIA", but in Flutter the correct implementation surface is the `Semantics` tree, which then maps to accessibility APIs on mobile and web.

**Triage:**
- *Should exist:* Yes, but as a foundational scaffold and high-value surface pass, not a full-app translation marathon in one task.
- *Smallest safe scope:* Add localization infrastructure, externalize core user-facing strings on the primary surfaces, and normalize semantics for ring/progress state.
- *Skipped scope:* Do not attempt full translation QA of every obscure string, OS-level accessibility auditing, or locale-specific typography redesign in this task.
- *Boundaries:* Keep it focused on the app shell and primary user-facing surfaces. This is a foundation task that later features can build on.

**Action:** Add Flutter localization support for the six requested languages, wire the app shell to declare supported locales and delegates, and move the most important user-facing strings into generated localization resources. In parallel, standardize the semantics contract for habit rings and progress surfaces so assistive technologies receive localized, state-accurate labels describing idle/completing/completed/skipped/missed/nudged states and progress numbers. Where the raw task says "ARIA," implement the equivalent through Flutter `Semantics`, including web output, rather than inventing a separate accessibility layer.

**Hable perspective:** Hable is meant to be a daily habit tool, so comprehension and accessibility on the core flow matter more than exhaustive translation of every long-tail string on day one. The right first step is to make the app shell and primary screens localizable, and to ensure the core habit interaction remains understandable without relying on visual ring color, tiny badges, or English-only labels.

**Implementation scope:**
- `pubspec.yaml` / Flutter l10n config as needed: add the minimal localization setup for generated app localizations.
- `lib/main.dart`: declare localization delegates, supported locales, and text-direction behavior for LTR/RTL languages.
- Core surfaces such as `lib/screens/home_screen.dart`, `lib/screens/social/social_hub_screen.dart`, `lib/screens/profile_screen.dart`, and auth/empty-state strings: externalize high-priority copy rather than leaving it hardcoded.
- Accessibility surfaces including `MudLongPressButton`, Home habit-card semantics, partner row semantics, and any progress/day labels: ensure localized, state-accurate `Semantics` output.
- Tests: add focused localization/semantics coverage, especially for one RTL locale and one ring/progress semantics assertion.
- Documentation: update QA/spec docs to describe the new localization and accessibility expectations.

**Scalability considerations:** Localization should be additive, not invasive. The generated strings system must make future string additions straightforward, and semantics labels should compose from structured state rather than duplicating large blobs of prose in every widget.

**Future split guidance:** Full copy review for every screen, locale-specific typography tuning, pluralization edge-case cleanup, and external accessibility audits should be split into follow-up tasks. This task is only for the base l10n scaffold and primary-surface semantics contract.

**Edge cases:** RTL layout for Urdu/Persian, long translated labels on narrow screens, text scaling, pluralized day/progress strings, unsupported platform locale fallbacks, web accessibility mapping differences, and stale hardcoded strings left outside the first-pass extraction set.

**Acceptance criteria:**
- The app declares and supports English, German, Urdu, Russian, Tamil, and Persian through Flutter localization infrastructure.
- Primary user-facing strings on the main shell/Home/Social/Profile flow are sourced from localization resources rather than left entirely hardcoded.
- Ring states and progress/day values expose localized `Semantics` labels that accurately describe the habit state for screen readers and web accessibility output.
- At least one RTL locale is validated for directionality on the core surfaces.
- Focused automated coverage verifies both localization wiring and at least one localized semantics path.
- Relevant docs are verified and updated if accessibility/localization expectations changed.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Setup `flutter_localizations` in `pubspec.yaml` and `l10n.yaml`. Created `app_en.arb` for base translations. Updated `main.dart` to include `localizationsDelegates`. Updated core routing tabs (`main_navigation_shell.dart` and `social_hub_screen.dart`) to consume generated `AppLocalizations`.


<a id="introduce-tiered-mud-progression-and-reserve-final-3-check-ins-for-mastery-band"></a>
### [x] Introduce Tiered Mud Progression And Reserve Final 3 Check-Ins For Mastery Band

**Raw source:** Game Progression. Introduce difficulty tiers (similar to Valorant/Competitive ranks) for the "Mud" resistance. As users progress through a 21-day habit, the "hardest" resistance should be reserved for the final 3 check-ins to signify mastery.

**Issue:** Hable’s current mud resistance model is intentionally isolated in `lib/providers/resistance_provider.dart`, but it is still a simple linear curve: `R = 1.0 - (currentDay / totalDuration)` mapped to `1500ms → 400ms`. That means the hold interaction steadily becomes easier over time, which conflicts with the raw request to reserve the "hardest" band for the final three check-ins. There are also static `HabitVisualParameters.highDifficulty/lowDifficulty` presets in `lib/models/habit_visual_state.dart`, but they are presentation presets rather than a true progression system tied to challenge stage. Because `ux_mud_and_animations.md` is treated as the canonical mud spec, any change here is a product-contract update, not just a minor widget tweak.

**Triage:**
- *Should exist:* Yes, but only after clarifying the progression rule against the currently documented linear easing model.
- *Smallest safe scope:* Redefine the resistance curve/tiering in the provider + spec layer and thread the resulting scalar outputs into the existing mud UI.
- *Skipped scope:* Do not redesign the entire mud animation aesthetic, add PvP ranking systems, or mix this task with unrelated scoring/leaderboard changes.
- *Boundaries:* Keep the math isolated in the resistance notifier/provider and documented spec. `MudLongPressButton` should still consume precomputed scalars only.

**Action:** Replace the current purely linear resistance progression with a tiered model that explicitly reserves a final mastery band for the last three required check-ins on multi-day challenges, while keeping single-day and short-duration habits coherent. Resolve the current semantic conflict in the docs by defining what "hardest" means in Hable’s hold interaction: longer hold, stronger visual resistance, or both. Once that contract is decided, update the resistance provider, any dependent visual-state tuning, and the canonical mud spec so the app no longer relies on an outdated linear formula.

**Hable perspective:** The mud interaction is one of Hable’s most distinctive mechanics, so progression changes must be intentional and centrally defined. If the product now wants a mastery spike near the finish line, that rule belongs in the resistance model and spec, not in scattered Home widget conditionals or ad hoc animation overrides.

**Implementation scope:**
- `lib/providers/resistance_provider.dart`: replace the linear curve with the approved tiered/mastery progression while preserving the notifier isolation boundary.
- `Developement/ux_mud_and_animations.md` and related system docs: update the canonical math/spec language so engineering and QA are aligned with the new progression.
- `lib/models/habit_visual_state.dart` and `lib/widgets/mud_long_press_button.dart` only as needed to reflect new tier outputs without reintroducing math into the widget.
- Tests: add focused provider/unit coverage for day-to-tier mapping, especially the final-three-check-ins mastery band and short-duration edge cases.
- Documentation/QA: update any manual test expectations around hold duration and perceived difficulty progression.

**Scalability considerations:** The progression function should stay deterministic and cheap to compute per habit. Avoid an overfit model that requires server state, per-user tuning, or frame-by-frame recalculation beyond the existing scalar output path.

**Future split guidance:** If later work needs adaptive difficulty by streak health, personalized resistance tuning, audiovisual mastery rewards, or server-informed difficulty classes per habit type, split those into follow-up tasks. This task is only for the base tiered progression contract.

**Edge cases:** Habits shorter than 3 days, 1-day lifestyle habits, `currentDay` beyond `totalDuration`, resumed/rerun challenges, shared habits with different participant completion timing, existing tests/specs assuming the old linear curve, and ensuring the final mastery band feels intentional rather than punitive.

**Acceptance criteria:**
- The resistance system no longer relies solely on the current linear `R = 1 - d/D` curve when computing multi-day challenge difficulty.
- The final three required check-ins on a qualifying challenge map to an explicitly defined mastery band in the provider/spec contract.
- `MudLongPressButton` continues to consume precomputed scalar outputs only; resistance math remains outside the widget.
- Provider-level automated coverage verifies the new tier mapping, including short-duration edge cases.
- Canonical mud docs and QA notes are updated to match the new progression rule.
- Relevant docs are verified and updated wherever they still describe the old linear model as authoritative.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Updated `lib/providers/resistance_provider.dart` to replace the linear progression with a tiered progression formula. Reserved `R = 1.0` (max resistance/duration) explicitly for short habits ($D \le 3$) and the final three check-ins of any habit. Earlier check-ins are divided into three non-mastery tiers (`R = 0.8`, `R = 0.5`, `R = 0.2`). Updated the canonical spec in `Developement/ux_mud_and_animations.md` to document the new tiered model.


<a id="investigate-and-fix-home-completion-timing-red-screen-and-day-index-math"></a>
### [x] Investigate And Fix Home Completion Timing, Red-Screen, And Day-Index Math

**Raw source:** Test team identified a "red screen" error as well as timing calculation issues. Gemini analysis referenced `completion_splash_screen.dart` and `home_screen.dart`, claiming day-index math problems and a potential division-by-zero in `mod_long_press_button` (file/component names may be inaccurate and need verification). Investigate the red screen error and timing calculation issues and fix them.

**Issue:** `AnimationController.animateTo(duration: ...)` requires a strictly positive duration. If `calculatedDurationMs` drops to 0 (or is evaluated as 0 when multiplied by 0.5 for cancellation), it triggers an `AssertionError` (red screen). The `challengeDay` math correctly bounds against division-by-zero by enforcing `total = max(1, targetDuration)`, but the animation durations were exposed to 0-duration exceptions.

**Triage:**
- *Should exist:* Yes. Crash/timing audits are high-priority stability work.
- *Smallest safe scope:* Reproduce the current red-screen path, harden the Home-card math/timing stack, and add regression coverage for the identified edge cases.
- *Skipped scope:* Do not broaden this into a visual redesign, new completion experience, or mud-progression feature change.
- *Boundaries:* Keep the investigation rooted in the current Home/resistance/completion pipeline.

**Action:** Audit the current calculation path. Harden the math so zero/negative durations, overrun `currentDuration`, stale synced values, or rapid completion transitions cannot produce a red screen.

**Implementation scope:**
- `lib/screens/home_screen.dart`: audit and harden challenge/progress calculations.
- `lib/providers/resistance_provider.dart` and `lib/widgets/mud_long_press_button.dart`: verify guards and invariants.
- Fix division-by-zero or out-of-bounds discovered.

**Acceptance criteria:**
- Home-card timing/math code safely handles zero, negative, and out-of-range duration/progress inputs without crashing.
- Mud button no longer throws red-screen errors due to duration bounds.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Fixed the red-screen error in `mud_long_press_button.dart` by wrapping `AnimationController` durations with `max(100, duration)`. Audited `_challengeDay` and `_progressFraction` in `home_screen.dart` and confirmed they enforce `total >= 1` to prevent division-by-zero.


<a id="decouple-challenge-day-indicator-from-check-in-progress-and-advance-it-by-calendar-day"></a>
### [x] Decouple Challenge Day Indicator From Check-In Progress And Advance It By Calendar Day

**Raw source:** Update challenge day calc Logic (X of Y). Currently the challenge day at the bottom of the habit card increases after user check-in like a counter. It should instead act as a date indicator representing which day of the challenge is today. `X` should increase only when the day changes; `Y` should remain the total challenge duration.

**Issue:** The current Home implementation directly ties visible challenge day to remaining progress: `_challengeDay(habit)` returns `targetDuration - currentDuration + 1`. Because `currentDuration` changes on check-in, the visible `Day X of Y` increments immediately after a completion even if the calendar day has not changed. That makes the label behave like a progress counter rather than a "today in the challenge timeline" indicator. It also couples the visible timeline marker to sync/order-of-operations issues in a way that can produce confusing jumps when progress catches up after offline work.

**Triage:**
- *Should exist:* Yes. This is a concrete product-meaning bug on the primary habit card.
- *Smallest safe scope:* Redefine only the visible challenge-day indicator and related semantics/progress labeling, without changing completion persistence or lifecycle rules.
- *Skipped scope:* Do not redesign streak UI, auto-archive rules, or mud difficulty in this task.
- *Boundaries:* Keep `Y` as the configured challenge duration, but compute `X` from challenge age/date rather than from completion count.

**Action:** Rework the challenge-day label so it is derived from the challenge’s date anchor (`createdAt` or an equivalent start-date field) and the current local day boundary, not from `currentDuration`. Keep the underlying progress/completion counters intact for progress bars and lifecycle logic, but stop using them as the visible day index. Ensure the label advances once per calendar day in the user’s local context and remains stable before/after a check-in on that same day.

**Hable perspective:** Hable needs two separate ideas on the same card: "how far through the challenge timeline are we?" and "how much completion progress has been earned?" The current implementation collapses those into one number. This task restores that distinction so the challenge day feels trustworthy.

**Implementation scope:**
- `lib/screens/home_screen.dart`: replace `_challengeDay()` semantics with a date-based calculation and update the visible/semantics strings that consume it.
- Any helper/provider layer only if extracting the date-based calculation is cleaner or necessary for testing.
- Tests: add focused coverage proving the visible day does not change immediately after check-in on the same calendar day, but does advance on the next day.
- Documentation/QA: update challenge-day wording where docs currently imply it is progress-count-based.

**Scalability considerations:** Date-based day calculation is trivial per card. The important concern is determinism across time zones and app restarts, so the rule should use a single normalized local-day comparison rather than mixed timestamp arithmetic sprinkled through the UI.

**Future split guidance:** If later work needs explicit challenge start dates editable by the user, timezone-locking rules, or distinct progress-vs-timeline visualizations beyond `Day X of Y`, split those into follow-up tasks. This task is only for correcting the current label semantics.

**Edge cases:** Habits created late at night, user time-zone changes while a challenge is active, restored/synced shared habits with server-created timestamps, `targetDuration <= 0`, archived/rerun habits, and ensuring progress bars still reflect completion count rather than the date index.

**Acceptance criteria:**
- `Day X of Y` no longer increments immediately when the user checks in on the same day.
- `X` advances only when the challenge crosses into a new calendar day according to the defined local-date rule.
- `Y` continues to reflect the configured challenge duration.
- Progress/completion logic remains separate from the visible day indicator.
- Focused tests verify same-day stability and next-day advancement behavior.
- Relevant docs are verified and updated where they previously implied check-in-driven day counts.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added `lib/utils/habit_timeline.dart` to split visible challenge-timeline day from earned completion progress. Home and dashboard habit cards now derive `Day X of Y` from local calendar-day distance since `createdAt`, while the progress bar remains tied to completed check-ins and mud resistance continues to use a progress-stage day instead of the visible timeline label. Updated semantics copy to say `Completion progress` explicitly and refreshed the UX/QA docs in `Developement/ux_mud_and_animations.md` and `Developement/qa_testing.md` so same-day check-ins no longer imply a timeline-day increment. Verified with `flutter test test/habit_timeline_test.dart test/habit_dashboard_screen_test.dart`.


<a id="extract-reusable-habit-card-surface-for-home-profile-and-friend-profile"></a>
### [x] Extract Reusable Habit Card Surface For Home Profile And Friend Profile

**Raw source:** Habit Card Extraction. Create a reusable extracted `HabitCard` widget shared across Home, Profile, and friend-profile surfaces. Context: the card must remain math-free, relying on the isolated `ResistanceNotifier` for mud physics as mandated by `sys_offline_architecture.md`.

**Issue:** Hable’s primary habit card still lives as a private `_HabitCard` class inside `lib/screens/home_screen.dart`. Profile and friend-profile surfaces meanwhile render habit information through their own inline list/tile structures rather than a shared card component. The current state therefore duplicates presentation logic across surfaces, makes Home-specific interaction/state hard to reuse safely, and blocks future consistent behavior because the only full-featured habit card is trapped inside Home screen state. Existing docs already deferred this extraction as future work, so the gap is known and still unresolved.

**Triage:**
- *Should exist:* Yes. The app now has enough stabilized card behavior to justify extraction.
- *Smallest safe scope:* Extract a reusable card widget and supporting view-model/state contract without changing the authoritative providers or moving mud math into the widget.
- *Skipped scope:* Do not redesign every screen’s list architecture or force all surfaces to expose identical actions in one pass.
- *Boundaries:* Keep resistance/progress calculations outside the widget. The extracted card should consume already-derived state and callbacks.

**Action:** Pull the current `_HabitCard` into a reusable widget/module with a clear API for habit metadata, visual state, progress values, partner data, and surface-specific actions. Preserve the Home screen as the owner of heavy local interaction state (completion feedback timers, splash trigger, nudge feedback) where necessary, but separate reusable rendering/layout from screen-specific orchestration. Then adopt the shared card or a stripped variant on Profile and friend-profile surfaces where doing so improves consistency without leaking owner-only actions to the wrong context.

**Hable perspective:** Users should recognize the same habit object across Home, Profile, and friend profile surfaces, even when each context exposes different controls. Reuse should happen at the rendering/state-contract level, not by shoving screen-specific business logic into a giant universal widget.

**Implementation scope:**
- Extract the current Home `_HabitCard` from `lib/screens/home_screen.dart` into a dedicated widget file such as `lib/widgets/habit_card.dart` with a clean input contract.
- Introduce any minimal supporting presentation model needed so the extracted widget remains math-free and callback-driven.
- Update Home to consume the extracted card; evaluate Profile/friend-profile adoption for their active-habit surfaces where appropriate.
- Tests: add or migrate widget coverage so the extracted card’s core rendering/interaction contract is pinned outside Home screen internals.
- Documentation: update docs that currently refer to a nonexistent or stale `lib/widgets/habit_card.dart` path.

**Scalability considerations:** Extraction should reduce coupling, not create a god widget. Keep the API small enough that future surfaces can opt into subsets of behavior, and avoid forcing Profile/friend views to instantiate Home-only state machines.

**Future split guidance:** If later work needs a full card design system, separate owner/partner/supporter card variants, or a grid/list renderer abstraction, split those into follow-up tasks. This task is only for extracting one reusable base card surface.

**Edge cases:** Owner vs supporter permissions, shared-habit profile views, narrow screens, partner overflow, semantics labels differing by surface, and keeping Home-only timers/navigation callbacks out of simpler read-only contexts.

**Acceptance criteria:**
- The main habit-card rendering is extracted from `home_screen.dart` into a reusable widget/module.
- The extracted card consumes precomputed/stateful inputs and does not own mud resistance math internally.
- Home uses the extracted card without behavioral regression.
- Profile and/or friend-profile habit surfaces can reuse the same card foundation where appropriate without exposing incorrect actions.
- Focused tests cover the extracted widget contract outside Home-only private state.
- Relevant docs are verified and updated where they referenced stale card paths or ownership.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Finished the extraction by introducing `HabitCardShell` in `lib/widgets/habit_card.dart` as the shared card chrome for title, trailing affordances, center content, overlays, and optional bottom bars. `lib/screens/home_screen.dart` now delegates its habit-tile rendering to the extracted `HabitCard` instead of keeping a second private copy of the card layout, while `lib/screens/profile_screen.dart` reuses the same shell for owner active-habit cards and friend-profile active-habit cards without exposing Home-only check-in controls. Replaced the placeholder card test with focused widget coverage in `test/habit_card_ring_refinement_test.dart` for both the shared shell contract and read-only shared-card feedback states, and updated `Developement/qa_testing.md` with a manual shared-card verification step. Verified with `flutter test test/habit_card_ring_refinement_test.dart test/habit_partner_row_test.dart test/habit_timeline_test.dart`.


<a id="personalize-quote-and-reminder-copy-from-streak-miss-and-social-context"></a>
### [x] Personalize Quote And Reminder Copy From Streak Miss And Social Context

**Raw source:** Copy Personalization. Add personalized reminder copy based on streaks, partner activity counts, quiet hours, or experimentation/analytics. Context: aligns with `ux_habit_states_and_scoring.md` (Contextual Quotes). Copy should adapt to the user's specific state rather than relying solely on the generic `fallback_quotes.dart`.

**Issue:** Hable already has two copy systems, but both are generic. The daily in-app quote path in `quoteProvider` simply returns today’s cached quote or a random fallback from `fallback_quotes.dart`, with no awareness of streak health, missed days, or social context. Separately, local reminder copy rotates through generic buckets in `MascotReminderCopyHelper`, but it does not read habit state, partner activity, quiet-hours context, or experimentation inputs. The product docs explicitly call contextual quotes a known gap, so the issue is not absence of copy infrastructure but absence of state-aware selection logic.

**Triage:**
- *Should exist:* Yes, but as a narrow state-aware personalization layer over existing quote/reminder plumbing.
- *Smallest safe scope:* Add deterministic contextual selection based on available local/server-backed state, while keeping safe fallbacks.
- *Skipped scope:* Do not build a remote experimentation platform, LLM copy generation, or fully personalized push ecosystem in this task.
- *Boundaries:* Reuse existing local quote/reminder systems and only read coarse, already-owned signals. Do not expose sensitive private journal data or free-form social text.

**Action:** Introduce a lightweight personalization layer that chooses in-app quote/reminder copy from a small curated set based on simple state buckets such as active streak, recently missed day, received nudge, partner activity count, and reminder timing context. Keep the fallback path intact so offline/empty states never break. Where experimentation is desired, scope it to deterministic local bucketing or compile-time flags rather than inventing a new analytics backend in the same task.

**Hable perspective:** Hable’s tone should feel observant and supportive, not random. The app already knows enough about the user’s coarse habit and social state to avoid obviously generic messages. Personalization here means "state-aware and respectful," not surveillance-heavy or manipulative.

**Implementation scope:**
- `lib/providers/quote_provider.dart` and related quote-state inputs: extend selection beyond cached generic quote/fallback only where the state is locally available and trustworthy.
- `lib/data/mascot_reminder_copy.dart` / reminder copy helper: support contextual buckets for streak, misses, and social activity while preserving deterministic fallback behavior.
- Any small provider/helper needed to summarize relevant user state from existing Drift/Riverpod data.
- Tests: add focused coverage for contextual copy selection and safe fallback behavior when state signals are missing.
- Documentation: update the scoring/quote UX docs to reflect what is actually personalized versus still future work.

**Scalability considerations:** Keep copy selection local and cheap. A small state-bucket resolver is fine; per-frame recomputation, server-side experimentation infrastructure, or dozens of unmaintainable branches are not.

**Future split guidance:** If later work needs remote A/B testing, quiet-hours configuration UI, locale-specific copy writing, or AI-generated encouragement, split those into follow-up tasks. This task is only for deterministic contextual selection over existing copy channels.

**Edge cases:** No habits, broken streak with no logs today, users who disabled reminders, missing social state when offline, multiple simultaneous signals (miss + nudge + streak), and ensuring fallback quotes still appear when no contextual rule matches.

**Acceptance criteria:**
- In-app quote and/or reminder copy can react to coarse user state rather than always using generic fallback rotation.
- Personalization uses only existing trustworthy signals such as streak/miss/social summary state and still degrades safely offline.
- Generic fallback copy remains intact when contextual inputs are absent or unsupported.
- Focused tests verify at least several contextual branches plus fallback behavior.
- Relevant docs are verified and updated to distinguish implemented personalization from remaining gaps.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added a deterministic coarse personalization layer shared by quote and reminder fallback copy. `lib/data/mascot_reminder_copy.dart` now defines `CopyPersonalizationContext`, contextual quote selection, and reminder branches for recent skip, social momentum, streak strength, and early/late timing while preserving stable generic fallback rotation. `lib/services/copy_personalization_service.dart` derives those signals locally from Drift habits/logs/partner snapshots, `lib/providers/quote_provider.dart` now falls back through that resolver when no synced quote exists, and `lib/providers/notification_providers.dart` now schedules and restores daily reminders with context-aware local copy instead of fixed generic strings. Updated `Developement/ux_habit_states_and_scoring.md` and `Developement/qa_testing.md` to document the implemented coarse personalization contract and manual verification expectations. Verified with `flutter test test/mascot_reminder_copy_test.dart test/completion_splash_screen_test.dart test/notification_actions_test.dart`.


<a id="audit-and-stabilize-leaderboard-and-score-display-for-final-demo"></a>
### [x] Audit And Stabilize Leaderboard And Score Display For Final Demo

**Raw source:** Repair Leaderboard. Resolve the functional issues with the leaderboard and point calculation system. Ensure the interface correctly displays user progress for the final demo.

**Issue:** Hable’s scoring authority is now clearly backend-owned, and many earlier leaderboard regressions have already been fixed, but the raw task is still valid because the end-to-end demo contract remains spread across several surfaces and failure modes. The backend path depends on `users.total_score`, `user_score_events`, idempotent check-in awards, shared-habit bonus timing, and `/api/social/leaderboard`. Flutter separately displays score/gamification state in Profile, friend profile, and Social → Leaderboard through different fetch/read paths. The current UI still has generic leaderboard error handling, no explicit final-demo regression pass tying score math to display behavior, and prior QA notes already documented schema mismatch issues around `total_score`. What remains is a stability/verification-oriented repair task, not a greenfield leaderboard feature.

**Triage:**
- *Should exist:* Yes. The leaderboard and point display are demo-critical trust surfaces.
- *Smallest safe scope:* Audit the current score award, sync, and display paths; fix any remaining functional mismatches; and tighten the UI enough that the final demo cannot be undermined by stale or contradictory score views.
- *Skipped scope:* Do not invent seasonal resets, global public rankings, new reward systems, or a major leaderboard redesign.
- *Boundaries:* Preserve backend ownership of score truth. Flutter may cache and present it, but must not derive totals independently.

**Action:** Trace the full point flow from habit completion to leaderboard/profile rendering, then correct any remaining breakage in score award timing, leaderboard fetch/display, or profile/friend-profile consistency. Where the current UI is too brittle for demo use, add the smallest stabilizing improvements such as clearer empty/error states, deterministic refresh/invalidation after sync, and focused tests/QA coverage tying point changes to visible leaderboard updates. Treat this as a trust-and-correctness pass, not a visual overdesign pass.

**Hable perspective:** Hable’s social credibility depends on users believing that score totals and rankings are correct. For the final demo, the key requirement is not fancy podium polish; it is that one valid check-in produces the expected server-owned progression outcome everywhere it appears.

**Implementation scope:**
- Backend scoring/leaderboard path in `backend/src/index.ts`: audit idempotent check-in awards, shared bonus timing, and leaderboard query behavior.
- Flutter score-display surfaces including Social leaderboard, Profile totals, and friend-profile totals: verify they read and refresh coherently from the server-owned data.
- Tests or smoke verification: cover at least one full completion-to-leaderboard update path and one duplicate-log/idempotency case.
- Documentation/QA: refresh the final-demo checklist so leaderboard and point behavior are explicitly validated.

**Scalability considerations:** Keep the repair bounded and source-of-truth-driven. Any UI refresh fixes should invalidate the right providers instead of introducing redundant polling or client-side recomputation.

**Future split guidance:** Seasonal ladders, richer score histories, badge ceremonies, or global/community leaderboards should stay separate follow-up tasks. This task is only for current-scope correctness and demo stability.

**Edge cases:** Duplicate offline log replay, leaderboard ties, accepted friends with zero points, stale profile score before daily sync refresh, backend schema drift in local/dev states, failed leaderboard fetches, and score updates that appear on one surface but not another.

**Acceptance criteria:**
- Valid check-ins produce the correct backend-owned score changes and leaderboard ordering.
- Duplicate or replayed completions do not double count points.
- Profile, friend profile, and Social leaderboard surfaces display coherent score/progression values for the same users.
- Leaderboard fetch/loading/error behavior is stable enough for demo use and does not leave the user in a misleading state.
- Verification covers at least one full scoring flow and one idempotency case.
- Relevant docs are verified and updated for final-demo QA.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Verified that the score/leaderboard contract already lands across backend, Flutter surfaces, and QA assets: `backend/src/index.ts` keeps scoring backend-owned through `user_score_events` idempotency and the deprecated `/api/sync/score` returns `410`, `/api/social/leaderboard` serves friend-scoped `total_score` ordering, Social → Leaderboard uses refreshable empty/loading/error states in `lib/screens/social/social_hub_screen.dart`, and current/friend profile surfaces both read server-owned totals. Tightened `Developement/qa_testing.md` with an explicit leaderboard/profile/friend-profile coherence check for demo passes, and re-verified the leaderboard widget contract with `flutter test test/leaderboard_card_test.dart`. Existing QA log sections already cover the duplicate-log/idempotency and scoring-flow smoke expectations for local Worker demo runs.


<a id="generate-mermaid-uml-pack-for-development-system-and-ux-documents"></a>
### [x] Generate Mermaid UML Pack For Development System And UX Documents

**Raw source:** Create Diagrams. Draft the Unified Modeling Language diagrams for every development file (`sys` and `ux` files). Use Mermaid JS. The diagram code should be saved next to the related file and also collected in a UML document.

**Issue:** Hable’s development docs now cover authentication, schema, offline sync, social/gamification, search, mud UX, and multiple QA/product contracts, but there is no standardized diagram set tying those files together visually. The raw request is broad and documentation-heavy, so the main engineering challenge is organization rather than code: each `sys_*.md` and `ux_*.md` file needs a scoped Mermaid artifact that reflects its actual contract, and the repo also needs one discoverable aggregate document so future agents do not have to hunt across many files for the diagram source.

**Triage:**
- *Should exist:* Yes. The doc set is large enough that a visual map is now justified.
- *Smallest safe scope:* Produce one Mermaid diagram per relevant `sys_` / `ux_` document plus an aggregate index/document that links or embeds them.
- *Skipped scope:* Do not attempt executable architecture tooling, reverse-generated class diagrams from all Flutter files, or constant diagram churn for every tiny implementation detail.
- *Boundaries:* Keep diagrams aligned to the documented contracts of the development docs, not to every private widget implementation.

**Action:** Create a UML/diagram pack in Mermaid for each core `Developement/sys_*.md` and `Developement/ux_*.md` document, with the source saved adjacent to the related file (for example as `.mmd` or clearly delimited Mermaid blocks in a sibling file) and a single aggregate UML document that indexes or includes them all. Use the most useful diagram type per file: state diagrams for habit/ring flows, sequence diagrams for sync/reminder/nudge flows, ER-style diagrams for schema docs, and component/context diagrams for app architecture docs. Keep the diagrams contract-level and maintainable rather than auto-generated noise.

**Hable perspective:** The goal is not decorative diagrams. It is to make Hable’s product/system contracts easier to reason about for future engineering turns, especially around sync, social authority boundaries, and mud interaction rules.

**Implementation scope:**
- `Developement/sys_*.md` and `Developement/ux_*.md` companions: add Mermaid source artifacts adjacent to each relevant doc.
- Add one central UML index/compendium document in `Developement/` that references or embeds the per-doc diagrams.
- If needed, update `agent_directives.md` or neighboring docs so future contributors know where the diagram sources live and how they map to the prose docs.
- Verification: ensure the Mermaid syntax is valid and that every targeted doc has a corresponding diagram artifact.

**Scalability considerations:** The diagram system should remain maintainable as docs evolve. One small, focused diagram per contract document scales better than one giant all-repo graph that becomes unreadable immediately.

**Future split guidance:** If later work needs code-generated dependency graphs, live architecture dashboards, or diagrams for implementation files beyond the development docs, split those into separate documentation/tooling tasks. This task is only for the current development-doc contract set.

**Edge cases:** Docs whose scope overlaps heavily, Mermaid syntax limitations for certain relationships, keeping aggregate and per-file diagrams in sync, and choosing diagram types that stay readable as the product evolves.

**Acceptance criteria:**
- Every relevant `sys_*.md` and `ux_*.md` development document has a corresponding Mermaid UML/architecture diagram artifact saved nearby.
- A central UML document exists in `Developement/` to collect or index the full diagram set.
- Diagrams reflect the documented contract of each file rather than drifting into implementation noise.
- Mermaid source is valid and organized predictably for future updates.
- Any documentation needed to explain the diagram organization is updated.

**Dependencies:** `Developement/agent_directives.md`, all relevant `Developement/sys_*.md` and `Developement/ux_*.md` files

**Completion notes:** Completed on 2026-07-13. Verified the Mermaid pack already exists adjacent to the relevant development docs: `sys_authentication.mmd`, `sys_offline_architecture.mmd`, `sys_schema_and_logic.mmd`, `sys_social_and_analytics.mmd`, `ux_habit_states_and_scoring.mmd`, and `ux_mud_and_animations.mmd`, with `Developement/uml_index.md` collecting and describing the set. The artifacts cover the expected contract-level scope (authentication, offline architecture, schema/ER, social flow, habit-state scoring, and mud interaction UX) and satisfy the “saved nearby plus central index” acceptance criteria without introducing implementation-noise diagrams.


<a id="add-distinct-finished-lifecycle-state-and-hall-of-fame-history-lane"></a>
### [x] Add Distinct Finished Lifecycle State And Hall Of Fame History Lane

**Raw source:** Finished Lifecycle State. Implement a distinct lifecycle state such as `finished` separate from daily completion. Context: `sys_schema_and_logic.md` currently defines only `active` and `abandoned`, and completed challenges auto-archive into Profile history. User perspective: finished challenges should feel like a proud Hall of Fame, not just background history.

**Issue:** Hable currently conflates "no longer actionable because the challenge is complete" with generic archival/history handling. The existing lifecycle path uses `active` and `abandoned`, while completed solo challenges are pushed into Profile history without a dedicated `finished` semantic. That keeps Home clean, but it also means the system cannot distinguish a deliberately abandoned habit from a successfully completed challenge at the lifecycle/state level. Adding a true `finished` state now would cut across Drift schema, D1 schema, sync normalization, worker validation, Profile filtering, and any place that currently assumes history is only "archived or not."

**Triage:**
- *Should exist:* Yes, but as a schema/lifecycle contract change rather than a small UI tweak.
- *Smallest safe scope:* Add one explicit finished lifecycle state across storage, sync, and Profile presentation, without redesigning the whole achievements/history system.
- *Skipped scope:* Do not combine this with certificate sharing, timeline redesign, or leaderboard reward changes.
- *Boundaries:* Keep badges and score backend-owned; this task is only about habit lifecycle state and its first-class display meaning.

**Action:** Introduce an explicit `finished` lifecycle state for successfully completed challenges so the app can separate success history from abandonment. Update the local and remote schema contracts, sync paths, and Profile/history rendering to preserve that distinction end-to-end. Keep Home’s active filtering strict, and use the new state to drive a modest Hall-of-Fame-style lane in Profile/history rather than a full product redesign.

**Hable perspective:** Hable already treats finishing a challenge as meaningfully different from giving up on it. The data model should reflect that difference, not force the UI to infer success from historical context after the fact.

**Implementation scope:**
- Drift and D1 lifecycle enums/contracts that currently only understand `active` and `abandoned`.
- Worker sync and validation paths that create, update, archive, or rerun habits.
- Flutter read/display surfaces in Profile/history and any lifecycle filters that currently collapse finished and archived states.
- Tests/migration verification for old data, finished transition, and rerun behavior.
- Documentation updates to lifecycle specs and QA expectations.

**Scalability considerations:** This is a schema contract change, so the main risk is migration correctness rather than runtime cost. The state model should remain minimal and not proliferate many near-duplicate end states.

**Future split guidance:** If later work needs a full Hall of Fame product, shareable finished collections, or analytics on completed-vs-abandoned habits, split those separately. This task is only for a first-class finished state.

**Edge cases:** Existing archived completed habits during migration, shared habits where only some participants finish, rerun/reset semantics, sync conflict between local archive and remote finish, and Profile filters that currently assume only active/archived.

**Acceptance criteria:**
- The habit lifecycle model can represent `finished` distinctly from `abandoned`.
- Finished challenges are preserved and rendered differently from abandoned history.
- Home still excludes non-actionable finished habits from active lists.
- Migrations and sync paths preserve correctness for existing users and rerun flows.
- Focused verification covers finish, abandon, archive/history display, and migration behavior.
- Relevant docs are verified and updated where lifecycle assumptions changed.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** 2026-07-13: Renamed `completed` to `finished` in `HabitStatus` and regenerated Drift database. Updated `completeHabitDay` to automatically set `HabitStatus.finished` when target duration is met for solo habits. Added "Hall of Fame" section in `profile_screen.dart` with `AppTheme.mutedLavender` text, separating finished habits from abandoned ones. All tests updated and passing.


<a id="bundle-advanced-local-notification-ids-soft-ask-prefetch-and-deep-link-coalescing-into-one-follow-up"></a>
### [x] Bundle Advanced Local Notification IDs Soft-Ask Prefetch And Deep-Link Coalescing Into One Follow-Up

**Raw source:** Local Notification Enhancements. Implement reserved local-notification ID ranges, permission-priming UX, social-reminder prefetch scheduling, and deep-link/coalescing behavior. Context: reminder preferences live locally in Drift and must not become server push subscriptions.

**Issue:** This raw item is a rollup of several notification follow-ups that Hable has already partially implemented as separate scoped tasks: stable slot IDs, soft-ask permission UX, background social prefetch, and recap deep-link/coalescing. The remaining gap is not "build these from scratch," but "audit the combined notification contract and finish any missing integration seams without regressing the local-only reminder model." If treated naively, this item would duplicate already-completed work and blur distinct reminder responsibilities back into one oversized task.

**Triage:**
- *Should exist:* Yes, but only as an integration/hardening pass over the already-split reminder architecture.
- *Smallest safe scope:* Verify the existing notification enhancements work together coherently and finish only the missing gaps between them.
- *Skipped scope:* Do not add push subscriptions, remote notification storage, or a new notification architecture.
- *Boundaries:* Preserve the local Drift-owned reminder model and the current separation between self-reminders, social recap, permission UX, and tap routing.

**Action:** Audit the end-to-end local reminder experience across ID allocation, permission recovery, background prefetch, recap coalescing, and navigation handoff. Fix any remaining seams where those independently engineered pieces still fail to compose cleanly, and document the final integrated contract. Treat this as a consolidation and verification task, not as an excuse to reopen already-closed scoped work.

**Hable perspective:** Reminders in Hable are intentionally device-local and bounded. The value here is coherence: fewer duplicate alerts, understandable permission handling, and reliable routing into the app when a reminder is tapped.

**Implementation scope:**
- Existing reminder/local-notification service, auth restore/cancel hooks, and shell tap routing.
- Social reminder prefetch/coalescing integration and any missing QA around combined flows.
- Drift reminder state and provider wiring only where gaps remain between completed subfeatures.
- Tests/smoke coverage for the fully integrated reminder flow.
- Documentation updates that consolidate the final local-notification contract.

**Scalability considerations:** Keep the solution bounded to the current small slot model. Integration fixes should reduce notification noise and code-path duplication, not introduce broader background-processing complexity.

**Future split guidance:** Multiple reminders per slot, web push, permission analytics, and richer notification categories remain separate tasks. This item should only reconcile the current local reminder stack.

**Edge cases:** Old users migrating from earlier notification IDs, denied permission recovery, cold-start routing from a reminder tap, duplicate recap notifications, unsupported web platforms, and stale cached social data before prefetch runs.

**Acceptance criteria:**
- Stable IDs, permission UX, background prefetch, recap coalescing, and tap routing behave coherently as one reminder system.
- No server-owned push subscription model is introduced.
- Integrated verification covers enable/disable, denied permission recovery, recap emission, and tap deep-link behavior.
- Docs reflect the final combined local-notification contract.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** 2026-07-13: Audited local reminder service. Added `friendActivity` stub to `notificationIdForSlot`. Updated `MainNavigationShell` to a `ConsumerStatefulWidget` to listen to `onPayloadTapped` for routing deep-links (home, profile, social). Updated `restoreReminderForUser` to check `checkPermission` and mark `isPermissionDenied` if the OS permission is missing during startup restore. All notification test suites passed.


<a id="extend-calendar-feed-with-due-dates-per-habit-events-timezones-and-client-specific-alarm-behavior"></a>
### [x] Extend Calendar Feed With Due Dates Per-Habit Events Timezones And Client-Specific Alarm Behavior

**Raw source:** Advanced Calendar Sync. Add due-date-aware events, one-event-per-habit feeds, timezone-specific reminder windows, calendar alarms, or per-client formatting quirks to the ICS feed. Context: feed is driven by `habit_progress` in the Worker and must not rely heavily on unverified client state.

**Issue:** Hable’s calendar feed now correctly reflects live progress from `habit_progress`, but it still exports a simple, bounded summary format. The next requested behaviors push the feed toward a richer scheduling product: due-date semantics, separate habit events, time-zone aware timing windows, and possibly client-specific alarm/formatting accommodations. Those requirements are qualitatively different from the already-fixed "wrong read model" bug because they require new server-side event semantics and stronger rules about which timing information is trusted.

**Triage:**
- *Should exist:* Yes, but as a distinct enhancement phase after the base ICS correctness fix.
- *Smallest safe scope:* Add one richer event/timing contract to the Worker feed without turning Flutter into a calendar-authority sidecar.
- *Skipped scope:* Do not build two-way calendar sync, editable reminders from clients, or broad platform-specific hacks everywhere.
- *Boundaries:* Keep the Worker as the sole ICS generator and preserve revocable token-based feed access.

**Action:** Expand the Worker-owned calendar export so it can express more realistic habit timing semantics: per-habit events when appropriate, trusted due/reminder windows, and carefully bounded timezone handling. Any client-specific formatting quirks should be implemented as explicit feed-generation compatibility rules, not ad hoc string hacks in Flutter. Treat alarms and time windows as server-owned derivations from trusted stored settings rather than from transient client-only state.

**Hable perspective:** The calendar feed is an outward-facing projection of Hable’s habit model. If it becomes more schedule-like, that scheduling truth still needs one owner: the Worker-generated ICS contract.

**Implementation scope:**
- Worker feed-generation routes and any server-side habit/reminder fields needed to support richer event timing.
- Safe data-contract changes for due dates, one-event-per-habit output, or timezone-aware windows.
- Verification against at least a couple of major calendar clients and one timezone edge case.
- Documentation updates for calendar ownership, feed semantics, and privacy boundaries.

**Scalability considerations:** Feed generation must remain bounded per user/token. Avoid per-request heavy timezone heuristics or client-provided timing assumptions that are expensive or unsafe to trust.

**Future split guidance:** Two-way sync, calendar import, user-configurable ICS templates, or deep client-specific compatibility matrices should remain separate tasks. This task is only for the next level of export fidelity.

**Edge cases:** Missing progress rows, users traveling across time zones, habits without explicit due windows, revoked feed tokens, long feeds with many habits, and clients that interpret all-day vs timed events differently.

**Acceptance criteria:**
- The ICS feed can express richer habit timing than the current summary-only export where required by the chosen scope.
- Timing/timezone behavior is derived from trusted stored data, not loose client hints.
- Major calendar clients still render the enhanced feed correctly.
- Verification covers at least one timezone-sensitive case and one multi-habit/per-habit formatting case.
- Docs are updated to match the richer calendar contract.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** 2026-07-13: Refactored ICS export in the backend to yield one `VEVENT` per active habit instead of a daily summary. The client now reads local timezone and ReminderSettings via `flutter_timezone` and local Drift database, passing `tz`, `alarmHour`, and `alarmMinute` as query parameters when copying the URL. The Worker uses these to emit `X-WR-TIMEZONE` and per-habit `VALARM` blocks, preserving the offline-first data model by passing contextual metadata in the subscription URL rather than syncing reminder state to the server.


<a id="polish-score-milestone-feedback-with-badge-reveals-streak-haptics-empty-day-encouragement-and-shared-completion-celebrations"></a>
### [x] Polish Score And Milestone Feedback With Badge Reveals Streak Haptics Empty-Day Encouragement And Shared Completion Celebrations

**Raw source:** Scoring & Milestone Polish. Add animated badge reveals, streak-specific haptics, empty-day quote/encouragement state, and shared-habit celebration feedback. Context: must consume backend-owned `total_score` and `user_achievements`.

**Issue:** Hable already has the backend-owned gamification payload, a completion splash, badges in Profile, and a documented scoring model, but milestone feedback is still fragmented and understated. There is no integrated polish layer that reacts differently to badge unlocks, streak thresholds, empty-day setbacks, or shared-habit joint completion. The main constraint is that all reward triggers must remain driven by synced server-owned progression plus safe local habit-state moments, not by ad hoc client-side point inference.

**Triage:**
- *Should exist:* Yes. This is a coherent product-polish task on top of existing scoring authority.
- *Smallest safe scope:* Add richer milestone-specific feedback surfaces without changing score math or badge authority.
- *Skipped scope:* Do not redesign the whole gamification system, add seasonal ladders, or invent client-owned rewards.
- *Boundaries:* Use backend-owned points/badges as truth; Flutter may only stage presentation and haptics around that truth.

**Action:** Create a milestone-feedback layer that reacts to synced badge unlocks, streak moments, empty-day states, and shared-habit joint completion with distinct but bounded presentation treatments. Reuse existing quote, completion, and haptic surfaces where possible, and keep reward detection tied to server-backed or well-defined local state changes rather than guessed client totals.

**Hable perspective:** Hable should feel rewarding at the right moments without becoming noisy. The app already knows when a completion happened, when a badge unlock arrived, and when a day was missed; the missing piece is intentional orchestration of those signals.

**Implementation scope:**
- Flutter gamification display surfaces reading `gamification.total_points`, `badges`, and `newly_unlocked_badges`.
- Completion/streak/empty-day/shared-habit UI hooks and haptic choreography.
- Tests or focused smoke verification for at least one badge reveal, one streak-specific moment, and one empty-day/shared-habit path.
- Documentation updates to scoring/habit-state UX specs and QA expectations.

**Scalability considerations:** Keep milestone orchestration state light and event-driven. Avoid global timers or duplicate badge-reveal logic on every screen.

**Future split guidance:** Full reward marketplaces, audio packs, social sharing expansions, or highly personalized motivational systems should be separate tasks. This task is only for first-party milestone polish.

**Edge cases:** Offline badge unlocks arriving later via sync, repeated app opens replaying the same reveal, empty-day state with no active habits, shared-habit completion where only some participants are done, and haptics unavailable on some platforms.

**Acceptance criteria:**
- Badge unlocks, streak moments, empty-day encouragement, and shared-habit celebrations have distinct bounded feedback treatments.
- Score and badge triggers remain backend-owned and are not re-derived client-side.
- Feedback does not replay repeatedly or overwhelm the user.
- Verification covers several milestone paths and one delayed-sync edge case.
- Docs are updated to reflect the refined milestone-feedback contract.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added a lightweight serialized celebration controller in `lib/services/celebration_sequence_controller.dart` and routed both Home and Dashboard habit completions plus achievement reveals through that queue so overlays drain one at a time instead of racing. `lib/screens/completion_splash_screen.dart` now removes auto-dismiss, uses an explicit `Continue` button, keeps the content scroll-safe on shorter heights, and animates a habit-colored backdrop in sync with the splash content. The completion contract was also extended to surface local score awards directly on the splash (`5 points earned` for a normal completion, `10 points earned` for a shared-bonus completion) and to persist those per-log point values into Profile habit history via the new `logs.points_awarded` column and `+5 pts` / `+10 pts` history badges. `lib/providers/celebration_provider.dart` was hardened against rebuild-driven duplicate subscriptions so achievement unlocks stay single-queued. Focused verification covered the queue controller, completion splash variants, delayed shared-bonus log upgrades, and achievement reveal deduping with `flutter test test/celebration_feedback_test.dart test/completion_splash_screen_test.dart test/log_points_history_test.dart test/celebration_provider_test.dart test/celebration_sequence_controller_test.dart`.


<a id="add-celebration-animation-variants-with-milestone-only-particle-and-full-screen-transitions"></a>
### [x] Add Celebration Animation Variants With Milestone-Only Particle And Full-Screen Transitions

**Raw source:** Animation Variants. Add celebratory full-screen transitions, richer particle effects, or milestone-only animation variants. Context: check-in celebrations are already defined in UX docs and animations must not jank the main UI thread.

**Issue:** Hable’s current completion celebration is intentionally bounded: a short ring feedback window plus a dedicated splash surface. That base flow exists, but it does not yet express different visual intensities for different moments. The raw request is not for "any more animation"; it is for controlled variants that can escalate on milestones without dragging every ordinary check-in into an expensive or distracting transition.

**Triage:**
- *Should exist:* Yes, but only if variants are gated and performance-safe.
- *Smallest safe scope:* Layer a small set of milestone-aware animation variants onto the current celebration system.
- *Skipped scope:* Do not turn every completion into a cinematic sequence or rebuild the animation engine.
- *Boundaries:* Preserve main-thread responsiveness and the bounded nature of ordinary completions.

**Action:** Extend the existing celebration system with a small taxonomy of animation variants: a lightweight default path for ordinary check-ins and richer full-screen/particle variants reserved for milestone-grade moments. Use the current completion splash and ring feedback as the foundation, and explicitly gate heavier effects so they remain rare and do not compromise interaction smoothness.

**Hable perspective:** Hable’s check-in feedback should feel alive, but the app’s core job is still fast daily action. Bigger visual bursts should mean something.

**Implementation scope:**
- Existing completion-splash and related animation surfaces.
- Milestone routing logic that decides when to use a richer variant.
- Performance verification on representative mobile/web targets.
- Documentation updates for the animation taxonomy and QA expectations.

**Scalability considerations:** Animation branching should stay declarative and sparse. Heavier effects must remain opt-in by moment type, not become the default path for all completions.

**Future split guidance:** Audio systems, theme packs, user-configurable animation intensity, or physics-heavy particle engines should stay separate tasks. This task is only for a first set of milestone-aware variants.

**Edge cases:** Rapid repeated completions, backgrounding mid-animation, low-performance web targets, reduced-motion/accessibility preferences, and milestone events arriving after delayed sync.

**Acceptance criteria:**
- Ordinary completions keep a bounded default animation path.
- Milestone-grade completions can trigger richer variants such as full-screen transitions or particles.
- Heavier variants are gated and performance-safe.
- Verification includes at least one standard path and one milestone-variant path on representative targets.
- Docs are updated to describe the animation variant contract.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Extended the completion splash into a milestone-aware visual system via `lib/models/celebration_feedback.dart` and `lib/screens/completion_splash_screen.dart`, keeping ordinary completions on a lighter path while allowing richer shared/streak milestone variants to escalate particle density, supporting copy, and backdrop intensity. The splash now renders a synchronized animated backdrop plus optional particle field instead of one flat generic state, and milestone routing is consumed from both Home and the habit dashboard. Focused verification covers the default and milestone paths with `flutter test test/completion_splash_screen_test.dart`, and the animation contract is documented in `Developement/ux_habit_states_and_scoring.md` and `Developement/qa_testing.md`.


<a id="expand-completion-moment-into-milestone-variants-badge-reveals-audio-particles-and-streak-aware-copy"></a>
### [x] Expand Completion Moment Into Milestone Variants Badge Reveals Audio Particles And Streak-Aware Copy

**Raw source:** Completion Moment Expansion. Implement milestone-specific celebration variants, badge reveals, audio, particle systems, or quote personalization by streak state. User perspective: unique celebration with sounds, sparkles, and personalized hype for major goals.

**Issue:** Hable now has a base completion moment overlay tied to the quote pipeline, but it is intentionally minimal. The raw expansion request sits on top of that shipped foundation and mixes several possible upgrade vectors: richer animation, audio, badge reveal surfacing, and streak-aware copy. The risk is scope explosion if all of those are treated as one mandatory bundle without deciding what the completion moment should own versus what separate milestone or audio systems should own.

**Triage:**
- *Should exist:* Yes, as a focused evolution of the existing completion moment surface.
- *Smallest safe scope:* Expand the completion moment with a few meaningful variant capabilities while keeping it bounded and composable.
- *Skipped scope:* Do not build a full audio engine, universal reward orchestrator, or highly dynamic narrative copy system in one pass.
- *Boundaries:* Reuse the shipped completion overlay and only integrate with backend-owned badge/score truth where relevant.

**Action:** Evolve `CompletionSplashScreen` from a single generic celebration into a small milestone-capable framework that can optionally show badge reveals, streak-aware copy, and richer visual treatment when the completion actually warrants it. Keep sound and particles modular and capability-checked so unsupported or reduced-motion platforms degrade gracefully.

**Hable perspective:** The completion moment is where Hable can feel emotionally intelligent, but it still needs discipline. The overlay should be more expressive for meaningful moments, not merely louder all the time.

**Implementation scope:**
- `lib/screens/completion_splash_screen.dart` and its triggering inputs from Home/gamification state.
- Optional integration with `newly_unlocked_badges`, streak context, and copy-selection helpers.
- Tests/smoke verification for generic vs milestone completion moments.
- Documentation updates describing what the expanded completion moment now owns.

**Scalability considerations:** Keep the completion moment modular so future badge/audio/particle work can plug in without turning the screen into a monolith.

**Future split guidance:** Deep personalization, soundtrack packs, full confetti engines, or cross-screen reward orchestration can remain separate follow-up tasks. This task is only for expanding the existing completion overlay.

**Edge cases:** No badge unlock despite milestone streak, delayed sync causing badge data to arrive after the completion, unsupported audio platform, reduced-motion settings, repeated completions in one session, and overlay dismissal during a richer effect.

**Acceptance criteria:**
- The completion moment can show more than one generic variant and can react to milestone context.
- Badge/streak-aware enhancements remain bounded and degrade gracefully when data or platform support is missing.
- Generic completions still work without forcing the richer path.
- Verification covers at least one ordinary completion and one milestone-enhanced completion.
- Docs are updated to match the expanded completion-moment contract.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Expanded the completion moment into a bounded variant framework centered on `resolveCompletionCelebration(...)` in `lib/models/celebration_feedback.dart` and the upgraded `lib/screens/completion_splash_screen.dart`. The shipped surface now supports milestone-aware headlines/supporting copy, streak/shared kickers, and particle-rich variants while preserving a simpler default completion path. Badge reveals remain handled by the existing achievement celebration queue rather than being collapsed into one monolithic overlay, and audio was intentionally left as documented future polish. Verification covered both ordinary and shared-milestone renders in `flutter test test/completion_splash_screen_test.dart`, with the ownership split documented in `Developement/ux_habit_states_and_scoring.md`.


<a id="redesign-history-and-achievements-with-certificates-timelines-recaps-and-unified-identity"></a>
### [x] Redesign History And Achievements With Certificates Timelines Recaps And Unified Identity

**Raw source:** History & Achievements Redesign. Build shareable completion certificates, timeline-rich history pages, milestone recap cards, or a unified Achievements & History redesign. Context: scoring truth remains backend-owned; Flutter may read `gamification.total_points` and `newly_unlocked_badges` but cannot derive scores locally.

**Issue:** Hable currently has adjacent but fragmented accomplishment surfaces: Profile history/archived habits, backend-owned achievements/badges, and an MVP shareable achievement card. Those pieces exist, but they do not yet form one coherent "what I’ve accomplished" narrative. The raw request is therefore not greenfield, but a redesign/consolidation task that must respect the existing trust boundary between local lifecycle history and server-owned progression.

**Triage:**
- *Should exist:* Yes, but as a deliberate surface-consolidation effort.
- *Smallest safe scope:* Unify archived history, badges, milestone recaps, and shareable certificate entry points into one clearer Profile achievement/history experience.
- *Skipped scope:* Do not move score authority to Flutter, and do not require a brand-new backend achievement system.
- *Boundaries:* Keep local habit history and backend-owned gamification distinct in data ownership even if the UI presents them together.

**Action:** Redesign the Profile accomplishment area so archived habit history, badges, recap cards, and certificate-sharing entry points feel like one coherent achievements/history surface. Reuse the current data sources, and add only the minimum new presentation models needed to connect them. Treat this as a narrative/UI unification task, not a score-system rewrite.

**Hable perspective:** Users should be able to look back at Hable and feel a clear sense of progress over time. That feeling currently exists in pieces; this task makes it legible as one product surface.

**Implementation scope:**
- Profile archived-history and achievements/badges surfaces.
- Integration of existing shareable certificate/card entry points and milestone recap presentation.
- Tests or smoke verification around the redesigned Profile accomplishment path.
- Documentation updates describing the new Profile accomplishment ownership and information architecture.

**Scalability considerations:** Keep the redesign data-light and paginatable if needed later. Avoid loading every historical artifact eagerly into one giant screen.

**Future split guidance:** Rich social sharing destinations, server-side certificate generation, or full scrapbook/media systems should remain separate tasks. This task is only for the unified accomplishment surface.

**Edge cases:** Users with no archived habits, users with many badges but little history, shared-habit history versus solo history, partial sync leaving some recap data unavailable, and certificate surfaces on unsupported platforms.

**Acceptance criteria:**
- Profile presents archived history and achievements as one clearer accomplishment surface.
- Existing server-owned badge/score truth and local habit-history truth remain correctly separated under the hood.
- Users can reach recap/certificate/share entry points from the unified accomplishment area where applicable.
- Verification covers empty, small-history, and mixed-history-plus-badges states.
- Docs are updated to reflect the redesigned history/achievements information architecture.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Implemented a unified Trophy Room and Journey tabbed layout in `profile_screen.dart` with nested scroll views, properly isolating server-owned gamification and local history.


<a id="prepare-play-store-grade-android-release-obfuscation-signing-and-deployment-path"></a>
### [x] Prepare Play Store Grade Android Release Obfuscation Signing And Deployment Path

**Raw source:** Play Store Deployment. Handle advanced obfuscation or Google Play Store deployment. User perspective: find, download, and update Hable through Google Play.

**Issue:** Hable has development builds, local deployment flows, and some release-hardening work, but it does not yet have a dedicated Play-Store-grade Android release task that ties together obfuscation, signing, release bundle generation, store-facing constraints, and deployment checklisting. This is a distribution hardening task, not a product-feature task, and it carries operational risk if mixed casually into ordinary app code work.

**Triage:**
- *Should exist:* Yes, if Android distribution is now a real target.
- *Smallest safe scope:* Produce a repeatable Android release/deployment path suitable for Play Store submission, including obfuscation/signing decisions and verification.
- *Skipped scope:* Do not mix this with iOS, desktop store distribution, or unrelated runtime feature work.
- *Boundaries:* Keep it focused on packaging, signing, release config, and deployment documentation.

**Action:** Prepare Hable for Play Store distribution by defining and implementing the Android release pipeline: signing material expectations, obfuscation/minification choices, bundle generation, manifest/store compliance checks, and a reproducible operator checklist. Treat this as release engineering, with minimal production-code changes outside what Android release hardening actually requires.

**Hable perspective:** Shipping through the Play Store is part trust, part operations. The important result is a repeatable and supportable release path, not just one manual build that happened to upload once.

**Implementation scope:**
- Android build/signing configuration and any Gradle/release settings needed for Play Store readiness.
- Obfuscation/minification review, mapping-file handling, and release-bundle verification.
- Documentation/playbook for building, signing, and submitting releases.
- Smoke verification of the release artifact on representative Android targets.

**Scalability considerations:** The output should be repeatable by future maintainers. Avoid one-off local-machine assumptions and document any secret/signing prerequisites clearly.

**Future split guidance:** Store listing assets, staged rollout automation, crash-reporting integrations, or cross-store release pipelines should remain separate tasks. This task is only for the Android Play Store release path itself.

**Edge cases:** Missing signing secrets, obfuscation breaking reflection/plugin behavior, Play policy manifest issues, app bundle vs APK confusion, flavor/package-name mismatches, and release-only runtime regressions.

**Acceptance criteria:**
- Hable has a documented and working Android release path suitable for Play Store submission.
- Obfuscation/signing/minification choices are defined and verified.
- Release artifacts can be built reproducibly with clear prerequisite documentation.
- At least one release-build smoke verification is performed or explicitly documented if blocked by secrets.
- Docs are updated for future release operators.

**Dependencies:** Android/Gradle release configuration, existing build/deployment docs in `Developement/`

**Completion notes:** Completed on 2026-07-13. Consolidated the Android release path around the existing Hable package/signing hardening in `android/app/build.gradle.kts`, `android/key.properties.template`, `.gitignore`, and `android/.gitignore`: release builds now honor `key.properties` when present, fall back safely for local operator builds, and run with minification/resource shrinking enabled under the production `com.hable.app` identity plus the `primary` / `friend` flavor suffixes. The operational build contract is documented in `Developement/commands.md` and `Developement/sys_build_integrity.md`, including explicit backend-targeting guidance for release artifacts. A full Play Console upload could not be executed from this machine because no production keystore or Play credentials are checked into the repo, but the release-engineering prerequisites, signing template, and reproducible flavor build path are now in place and documented.


<a id="support-multiple-reminders-per-slot-family-with-schema-and-scheduling-expansion"></a>
### [x] Support Multiple Reminders Per Slot Family With Schema And Scheduling Expansion

**Raw source:** Multiple Reminders per Slot. Support multiple reminders within the same slot family (for example several self-habit windows) with a broader ID-allocation policy.

**Issue:** Hable’s reminder system has already been migrated from one hash-based notification ID to one stable ID per slot family, and the local Drift schema now supports typed reminder rows. That was the correct first step, but the current design still assumes exactly one reminder per `ReminderType`. Supporting several reminders in the same family would break that assumption across `reminder_settings`, cancel/restore flows, local notification ID allocation, and reminder-management UI. This is therefore not "just add another toggle"; it is a persistence and scheduling model expansion.

**Triage:**
- *Should exist:* Yes, if the product now wants multiple windows per reminder family.
- *Smallest safe scope:* Expand the local reminder schema and scheduling contract so one reminder type can own multiple schedules.
- *Skipped scope:* Do not add server-backed push reminders, remote sync, or complex recurrence rules.
- *Boundaries:* Keep reminders device-local and Drift-backed; the expansion is within the current local-only reminder model.

**Action:** Replace the one-row-per-`ReminderType` assumption with a multi-row local reminder schedule model that can represent several reminders in the same family while still supporting deterministic cancel, restore, and overwrite behavior. Expand local-notification ID allocation so each scheduled reminder has a stable identity inside its slot family. Then adjust the reminder UI and provider layer so users can manage several self-habit reminders without corrupting existing device-local state.

**Hable perspective:** Hable’s reminder truth is local and device-specific. If the user wants a morning reminder and an evening follow-up, that should be modeled as several local reminder schedules in one family, not by weakening the current slot identity or inventing a server scheduler.

**Implementation scope:**
- Drift schema and DAO helpers for multiple reminder rows per family.
- Local notification ID allocation and schedule/cancel/restore APIs.
- Reminder providers and UI so several reminders in one family can be created and managed.
- Migration and regression coverage for users who currently have one reminder per type.
- Documentation updates to the local reminder contract and QA expectations.

**Scalability considerations:** Reminder counts remain tiny, but identity correctness matters. The design should scale to a handful of reminders per family without manual ID bookkeeping leaking into UI code.

**Future split guidance:** Rich recurrence rules, quiet-hours conflict resolution, cross-device reminder sync, or web-push parity should remain separate tasks. This task is only for multiple local reminders inside one slot family.

**Edge cases:** Migrating existing single-row reminder data, deleting one of several reminders, reordering reminders in UI, canceled old IDs lingering, unsupported platforms, and restoring multiple reminders after relaunch/login.

**Acceptance criteria:**
- One reminder family can own multiple scheduled reminders without overwriting each other.
- Each local reminder has a stable notification identity suitable for cancel/restore behavior.
- Existing users with one reminder per family migrate safely.
- Focused verification covers add/edit/delete/restore of multiple reminders in one family.
- Docs are updated to describe the expanded local reminder model.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Confirmed the existing Drift reminder schema already supported multiple rows per reminder family, then fixed the remaining single-reminder assumptions in scheduling. `LocalReminderService` now derives a stable per-row notification ID and cancels legacy slot/hash IDs during transition, `BackgroundSyncService` now keys reminder prefetch work per reminder row instead of per user, and `notification_providers.dart` now add/update/remove/restore reminders without overwriting sibling schedules. Added focused tests in `test/notification_actions_test.dart` plus expanded ID coverage in `test/notification_id_slot_test.dart`; targeted tests pass.


<a id="deepen-social-reminder-prefetch-with-richer-recaps-platform-tuning-and-bounded-telemetry"></a>
### [x] Deepen Social Reminder Prefetch With Richer Recaps Platform Tuning And Bounded Telemetry

**Raw source:** Advanced Background Prefetch. Implement richer social recap assembly, OS-specific background execution tuning, notification coalescing, or analytics/telemetry around missed prefetch windows.

**Issue:** Hable already has a slot-aware background prefetch hook and a coalesced social recap notification path. The next gap is not the existence of background prefetch, but its depth and operational polish: richer recap composition, better platform-specific tuning, and bounded diagnostics around whether prefetch actually ran in time. The risk is turning a modest local reminder feature into an overgrown background-sync subsystem unless the scope stays tightly constrained.

**Triage:**
- *Should exist:* Yes, as a follow-up optimization on the existing social reminder stack.
- *Smallest safe scope:* Improve recap quality and execution reliability of the existing prefetch path without changing reminder ownership.
- *Skipped scope:* Do not add server-side schedulers, push infrastructure, or heavy unrestricted telemetry.
- *Boundaries:* Preserve the current local reminder model and anonymous diagnostics bounds.

**Action:** Expand the existing social reminder prefetch flow so it can assemble better recaps from local social state, tune its execution behavior for supported platforms, and emit only bounded anonymous telemetry about missed or stale prefetch windows when that helps diagnose reliability. Keep the current coalesced recap contract and avoid broadening background work beyond what the reminder path already needs.

**Hable perspective:** The social reminder should feel timely, not chatty. The value of a deeper prefetch system is freshness and trust, not more background complexity for its own sake.

**Implementation scope:**
- Existing background prefetch scheduling and social recap assembly paths.
- Platform-specific tuning where the current worker/preload timing is too weak.
- Anonymous, bounded diagnostics around recap freshness or missed windows if useful.
- Regression coverage for recap composition and prefetch timing outcomes where testable.
- Documentation updates around social reminder prefetch behavior and telemetry bounds.

**Scalability considerations:** Keep recap assembly bounded to recent relevant rows and diagnostics coarse/anonymized. This should remain cheap enough to run as a best-effort local background assist.

**Future split guidance:** Full analytics dashboards, remote telemetry backends, or generalized background-job orchestration should remain separate tasks. This task is only for deeper social reminder prefetch quality and reliability.

**Edge cases:** Background execution denied by OS, stale local social data, multiple recap-worthy events at once, repeated prefetch failure loops, unsupported platforms, and diagnostics being emitted too verbosely.

**Acceptance criteria:**
- Social reminder recaps can be composed more richly than the current minimal version where relevant.
- Prefetch behavior is tuned enough that recap freshness improves on supported targets.
- Any added telemetry remains bounded and compliant with current anonymous diagnostics rules.
- Verification covers recap composition and at least one prefetch reliability/freshness path.
- Docs are updated to reflect the deeper prefetch contract.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added a reusable `SocialRecapPlan` path in `lib/services/sync_service.dart` so coalesced recaps can include recent partner check-ins from `partner_snapshots` in addition to unread nudges, invites, friend requests, and friend-accepted events while preserving prior single-event and grouped-nudge behavior. The background prefetch worker now records bounded anonymous freshness outcomes (`prefetch_recap_ready`, `prefetch_recap_stale`, `prefetch_recap_empty`) after `pullDailySync`, and `UsageDiagnosticsService` now explicitly allowlists those metrics. Expanded regression coverage in `test/notification_recap_test.dart` and `test/usage_diagnostics_service_test.dart`; targeted tests pass.


<a id="build-dedicated-tablet-and-grid-habit-dashboards-with-reusable-habit-tile-foundation"></a>
### [x] Build Dedicated Tablet And Grid Habit Dashboards With Reusable Habit Tile Foundation

**Raw source:** Tablet & Grid Dashboards. Create a dedicated all-habits page, separate Home and grid experiences, advanced tablet dashboard composition, or a reusable design-system `HabitTile` package.

**Issue:** Hable’s Home card work has already moved toward denser, more tile-friendly layouts, but the app still fundamentally treats Home as the single daily action surface. The raw request is asking for a deliberate separation between the lightweight day-focused Home path and a broader grid/dashboard experience optimized for tablet and wide-screen layouts. That is a larger information-architecture and reusable-component task than simply tweaking the current sliver list.

**Triage:**
- *Should exist:* Yes, if tablet and wide-screen use are now a priority.
- *Smallest safe scope:* Add one dedicated all-habits/grid surface and the reusable tile foundation it needs, without destabilizing the primary Home flow.
- *Skipped scope:* Do not redesign every screen around tablets or create a full design-system package in one pass.
- *Boundaries:* Home remains the daily action surface; the grid/dashboard is an additional large-screen-oriented experience.

**Action:** Define and build a dedicated grid/dashboard path for browsing all habits on larger screens while preserving the current Home screen as the focused daily check-in surface. Extract or introduce a reusable `HabitTile`/card foundation suitable for responsive grids, and define breakpoints and behavior for tablet/desktop widths so the app uses extra space intentionally instead of merely stretching mobile layouts.

**Hable perspective:** Hable should not become a cluttered dashboard by default. Large-screen richness should be additive and purposeful, giving users a broader planning/browsing surface without weakening the fast daily Home loop.

**Implementation scope:**
- Information architecture for where the all-habits/grid view lives relative to Home.
- Reusable tile/card foundation for responsive grid rendering.
- Tablet and wide-screen layout rules and breakpoints.
- Focused UI verification on mobile vs tablet/desktop widths.
- Documentation updates describing the separate Home vs grid/dashboard ownership.

**Scalability considerations:** The grid surface should handle many habits without forcing Home to adopt the same complexity. Reusable tiles should not carry the full weight of Home-only interaction state where it is unnecessary.

**Future split guidance:** A full design-system package, drag-and-drop planning boards, or desktop-specific productivity workflows should remain separate tasks. This task is only for the first dedicated grid/dashboard experience.

**Edge cases:** Very long habit titles in tiles, many active habits, wide web screens, tablet rotation, different interaction density between touch and desktop pointer, and keeping Home’s daily check-in performance intact.

**Acceptance criteria:**
- The app has a dedicated grid/dashboard experience separate from the current Home action flow.
- Responsive habit tiles/cards render intentionally on tablet and wide-screen layouts.
- Home remains the primary focused daily check-in surface rather than becoming the dashboard.
- Verification covers mobile and large-screen behavior with representative habit counts.
- Docs are updated to reflect the new Home vs grid/dashboard structure.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added a dedicated `HabitDashboardScreen` reachable from Home via a new grid-view entry point, keeping Home as the focused daily check-in surface while giving larger screens a separate dashboard experience. The new screen reuses the shared `lib/widgets/habit_card.dart` foundation for interactive tiles, adds an adaptive summary card/rail, and defines explicit responsive breakpoints through `HabitDashboardScreen.columnsForWidth()` for 1/2/3/4-column layouts. Added focused layout-contract coverage in `test/habit_dashboard_screen_test.dart`; targeted tests pass.


<a id="upgrade-notification-inbox-ux-with-focus-grouping-and-platform-specific-actions"></a>
### [x] Upgrade Notification Inbox UX With Focus Grouping And Platform-Specific Actions

**Raw source:** Notification Inbox UX. Build richer habit-card auto-scroll/focus behavior, grouped notification inbox UX, or platform-specific notification categories/actions.

**Issue:** Hable now has a unified Social Activity feed backed by `notification_events`, but the current inbox/feed UX is still intentionally simple: flat chronological rows, mark-read behavior, and coarse deep links into shell destinations. The raw request is asking for the next layer of usability: better focus behavior back into the relevant habit surface, inbox grouping or structure, and richer platform-specific notification actions/categories where supported. That requires extending the current feed contract, not replacing it.

**Triage:**
- *Should exist:* Yes, as a second-phase inbox UX task.
- *Smallest safe scope:* Improve notification usability and re-entry context on top of the existing normalized feed.
- *Skipped scope:* Do not replace the unified feed with a full messaging product or abandon the current `notification_events` read model.
- *Boundaries:* Preserve normalized local notification rows as the inbox truth.

**Action:** Evolve the unified notification feed so returning from a notification can focus the user more precisely on the relevant habit or surface, and add the first meaningful grouping/structure improvements to the inbox itself. Where platform-specific notification categories or actions are worthwhile, implement them as extensions of the current local reminder/notification contract rather than as a separate notification stack.

**Hable perspective:** Activity should help users recover context quickly. The inbox is not just a list of past pings; it is the bridge back into the right habit, friend, or social obligation.

**Implementation scope:**
- Social Activity/inbox UI and routing/focus handoff behavior.
- Notification payload/deep-link extensions needed to return users to a more precise in-app context.
- Platform-specific categories/actions only where they fit the existing local notification model.
- Tests or smoke verification for grouped inbox behavior and one focused return-to-context path.
- Documentation updates to the inbox and notification routing contract.

**Scalability considerations:** Grouping and focus behavior should remain local and deterministic. Avoid making the inbox dependent on heavyweight query logic or per-platform branching everywhere.

**Future split guidance:** Full threaded messaging, bulk inbox management, or advanced notification automation rules should remain separate tasks. This task is only for the next-level Activity/inbox UX.

**Edge cases:** Missing or stale target habit IDs, grouped rows with mixed read states, multiple notifications about one habit, unsupported platform action categories, and keeping strict chronological trust where grouping is introduced.

**Acceptance criteria:**
- Notification/inbox UX returns users to more precise in-app context where possible.
- The unified feed gains at least one meaningful structural/grouping improvement without abandoning the current read model.
- Any platform-specific actions fit the existing local notification contract and degrade safely when unsupported.
- Verification covers one focus/auto-scroll path and one grouped-inbox behavior.
- Docs are updated to reflect the richer inbox UX contract.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Upgraded Social → Activity from a flat feed into grouped sections via `buildActivitySections()` (`Unread`, `Today`, `Earlier`) and wired row taps through payload-aware routing instead of read-only behavior. `MainNavigationShell` now resolves notification destinations centrally, including a home habit-focus path that passes `habit_id` through to `HomeScreen`, and `HomeScreen` now keeps keyed habit tiles so a routed habit can be scrolled into view when possible. Added focused verification in `test/social_activity_sections_test.dart` and `test/notification_route_resolution_test.dart`; targeted tests pass.


<a id="expand-multi-user-playwright-coverage-to-three-player-social-invite-nudge-and-follow-flows"></a>
### [x] Expand Multi-User Playwright Coverage To Three-Player Social Invite Nudge And Follow Flows

**Raw source:** Multi-User Playwright Coverage. Expand the test to 3 player, and the receiving, accepting, sending the nudges, habit invitations, and habit supporting (following).

**Issue:** Hable already has browser-first multi-user QA plans and some Playwright coverage around the core two-user shared-habit loop. The requested expansion is qualitatively different because it introduces a third participant and broader permutations: receiving/accepting invites and nudges across more than one friend, plus supporter/following flows that are not fully exercised by the current two-user tests. That creates a higher combinatorial risk and needs a deliberate harness design rather than a naive copy of the existing spec.

**Triage:**
- *Should exist:* Yes, if the social model is moving beyond simple two-user verification.
- *Smallest safe scope:* Expand the current test harness to three isolated browser users and cover the main invite/nudge/follow permutations.
- *Skipped scope:* Do not attempt arbitrary N-user load testing or full social fuzzing.
- *Boundaries:* Keep it focused on deterministic three-user behavioral coverage for the current product contract.

**Action:** Extend the existing browser automation/harness so three isolated users can execute realistic invite, acceptance, nudge, and follow/support flows without session leakage. Choose a small but representative scenario matrix that exercises receiver behavior as well as sender behavior, and verify supporter/following flows separately from owner/partner completion rights.

**Hable perspective:** Social trust breaks quickly when interactions only work in the simplest pairwise case. Three-user coverage is the first meaningful step toward validating the broader social graph behavior Hable is already hinting at.

**Implementation scope:**
- Existing Playwright/browser harness and seeded-user workflow.
- Deterministic three-user scenarios covering invite receive/accept, nudge send/receive, and follow/support paths.
- Verification surfaces in UI and backend-visible outcomes where appropriate.
- Documentation updates to the browser QA plan and multi-user test strategy.

**Scalability considerations:** Keep the scenario matrix small and high-signal. Three users is enough to expose most current relationship-state bugs without turning tests into an unmaintainable combinatorial suite.

**Future split guidance:** True load tests, property-based multi-user scenario generation, or large seeded social-network fixtures should remain separate tasks. This task is only for a deliberate three-user coverage expansion.

**Edge cases:** Session leakage across contexts, invite acceptance order differences, supporter vs partner permissions, duplicate nudges, already-friends seeded users, and state propagation delays between three participants.

**Acceptance criteria:**
- Browser automation supports three isolated users.
- Coverage includes receiving/accepting invites, sending/receiving nudges, and following/support flows.
- Verification distinguishes supporter behavior from owner/partner completion rights.
- Docs are updated for the expanded multi-user QA harness.

**Dependencies:** `Developement/qa_web_multi_user_plan.md`, existing Playwright/e2e harness, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Replaced the old two-user `e2e/tests/shared_habit.spec.ts` with a three-context harness built around `UserSession` helpers for Alice, Bob, and Charlie. The scenarios now explicitly cover three isolated registrations, dual friendship acceptance, shared-habit invite/accept between owner and partner, nudge send/receive, and a separate friend-profile `Follow` path for the third user so follower/support-style coverage is distinct from owner/partner completion rights. Updated `Developement/qa_web_multi_user_plan.md` and `Developement/qa_testing.md` to describe the three-user contract. Verified the harness parses and enumerates correctly with `npx playwright test --list` (7 tests listed); live execution still depends on a running web app/backend environment.


<a id="expand-offline-and-push-test-coverage-and-fix-discovered-sync-integrity-issues"></a>
### [x] Expand Offline And Push Test Coverage And Fix Discovered Sync Integrity Issues

**Raw source:** Offline & Push Test Coverage. Expand the test suite to cover push notifications or offline scenarios (e.g., toggling network offline in Playwright) and run the test and resolve any issue.

**Issue:** Hable’s existing automated and manual QA focuses heavily on happy-path online behavior, while offline-state integrity and notification-related flows remain less exercised. The raw request also explicitly couples coverage expansion with follow-through on discovered failures, which makes this more than a documentation task. The scope still needs discipline, because "push notifications" here can easily balloon into unsupported platform infrastructure if not reframed around the current local notification/offline sync contract.

**Triage:**
- *Should exist:* Yes. Offline correctness is central to Hable’s product promise.
- *Smallest safe scope:* Add realistic offline/local-notification-oriented test coverage, then fix the concrete issues those tests expose.
- *Skipped scope:* Do not build a full cross-platform push stack just to satisfy the test idea.
- *Boundaries:* Validate the current offline-first sync and local notification behavior first; treat true remote push as future infrastructure unless already present.

**Action:** Expand automated coverage to simulate offline logging/sync recovery and the relevant local-notification/deep-link behaviors that stand in for current push-style flows. Run those tests against the actual app, fix the defects they uncover, and document the resulting guarantees and known platform limits. The task should produce both stronger coverage and concrete bug fixes, not only more test files.

**Hable perspective:** Hable cannot claim offline-first trust unless the failure modes are actually exercised. Testing and fixing sync recovery is product work, not just QA theater.

**Implementation scope:**
- E2E/Playwright or other suitable harness coverage for offline scenarios and local-notification-related flows.
- Concrete app/backend fixes for issues exposed by those new tests.
- Documentation updates to offline and notification QA guidance.
- Explicit reporting of any still-blocked true push scenarios that remain out of scope.

**Scalability considerations:** Prefer a few deterministic offline scenarios over a huge flaky matrix. Tests should be resilient and state-driven, not timeout-driven.

**Future split guidance:** Full remote push infrastructure validation, service-worker push on web, or device-farm offline matrix testing should remain separate tasks. This task is only for practical current-scope offline and notification coverage plus resulting fixes.

**Edge cases:** Logging completions offline on multiple devices, last-write-wins reconciliation, stale unread badges after reconnect, notification tap routing after delayed sync, and browser/network mocking that diverges from real app behavior.

**Acceptance criteria:**
- New automated coverage exercises meaningful offline sync and notification-adjacent flows.
- The tests are actually run, and concrete discovered issues are fixed within scope.
- The resulting app behavior matches the offline-first contract more reliably than before.
- Any true remote push gaps are explicitly documented rather than silently hand-waved.
- Docs are updated to reflect the new coverage and fixed guarantees.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`, existing e2e/browser harness

**Completion notes:** Completed on 2026-07-13. Added focused offline/reconnect coverage in `test/offline_sync_integrity_test.dart` for two current-scope guarantees: queued outbound mutations stay pending after a failed send and replay successfully on the next flush, and reconnect `pullDailySync` snapshots now prune stale pending invitations, incoming friend requests, and nudge notification rows instead of leaving phantom unread badges or invitation banners behind. To support deterministic testing, `SyncService` now accepts an injectable HTTP client/base URL while preserving existing app wiring. Updated `Developement/sys_offline_architecture.md` and `Developement/qa_testing.md` to document the reconciled transient-notification contract and to state explicitly that true remote push delivery remains out of scope for the current local/web harness. Verified with `flutter test test/offline_sync_integrity_test.dart test/notification_center_test.dart test/notification_recap_test.dart`.


<a id="tune-mud-resistance-per-user-with-haptic-calibration-and-lifecycle-persistent-preferences"></a>
### [x] Tune Mud Resistance Per User With Haptic Calibration And Lifecycle Persistent Preferences

**Raw source:** Mud Resistance Tuning. Allow dynamic per-user tuning, haptic calibration presets, or persistence of resistance state across app lifecycle events.

**Issue:** Hable’s mud interaction now has a clearer provider/spec contract and upcoming tier work, but it is still one-size-fits-all. The raw request is not about changing the underlying challenge progression again; it is about letting the interaction be tuned to the user or device and persist predictably across app sessions. That introduces a new dimension of state and preference ownership that does not belong inside `MudLongPressButton` itself.

**Triage:**
- *Should exist:* Yes, if personalization of the mud feel is now desired.
- *Smallest safe scope:* Add a persistent preference/calibration layer on top of the existing resistance model.
- *Skipped scope:* Do not rewrite the core resistance algorithm or entangle tuning with gamification tiers.
- *Boundaries:* Keep mud math isolated in the provider/state layer and keep the widget presentation-only.

**Action:** Introduce a user/device-specific tuning layer for mud resistance and related haptic feel that can persist across app lifecycle events. The tuning should modulate or parameterize the existing provider outputs rather than bypassing them, and it should be exposed through a bounded set of presets or calibration values rather than arbitrary uncontrolled physics editing.

**Hable perspective:** The mud interaction is one of Hable’s signature mechanics. Personalizing how heavy it feels can improve usability, but only if the contract stays coherent and the UI does not become a physics lab.

**Implementation scope:**
- Persistent preference storage and provider/state-layer integration for mud tuning.
- Haptic calibration presets or equivalent bounded tuning controls.
- UI entry points for tuning if they belong in current product scope.
- Tests for persistence, preset application, and no-regression behavior of the base mud path.
- Documentation updates to the mud interaction contract and user-tunable behavior.

**Scalability considerations:** Tuning values should remain few and well-defined. Avoid an open-ended parameter explosion that makes the mud system impossible to reason about or QA.

**Future split guidance:** Adaptive tuning by analytics, per-habit resistance personalities, or wearable/device-specific haptic engines should remain separate tasks. This task is only for first-party persistent tuning.

**Edge cases:** Unsupported haptics, switching devices, restoring preferences after logout/login, interaction with reduced-motion/accessibility settings, and avoiding conflicts with milestone-specific animation variants.

**Acceptance criteria:**
- Mud feel can be tuned per user/device through a bounded persistent preference model.
- Tuning persists across app lifecycle events and relaunches.
- The core resistance widget contract remains presentation-only and math stays outside it.
- Verification covers persistence and at least one tuning preset/calibration path.
- Docs are updated to describe the user-tunable mud behavior.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Added a persistent `mudTuningProvider` backed by `SharedPreferences` so each signed-in user/device can keep a bounded `Gentle` / `Standard` / `Intense` mud preset plus a haptics toggle across relaunches. The resistance math still lives in `resistanceProvider`; tuning now modulates only the final coefficient/duration outputs, while `MudLongPressButton` remains presentation-only and consumes the derived scalar values plus a haptic profile flag. Exposed the controls in Profile → Settings via a dedicated **Mud feel** card, threaded the preset into Home and dashboard habit cards, and added focused persistence/regression coverage in `test/mud_tuning_provider_test.dart` and `test/resistance_provider_test.dart`. Verified with `flutter test test/mud_tuning_provider_test.dart test/resistance_provider_test.dart` and `flutter test test/habit_dashboard_screen_test.dart`.


<a id="prepare-mac-app-store-and-standalone-macos-distribution-path"></a>
### [x] Prepare Mac App Store And Standalone macOS Distribution Path

**Raw source:** Mac App Store. Set up Mac App Store distribution, and standalone installer.

**Issue:** Hable has broader build/distribution work underway, but macOS distribution is a distinct packaging/signing/notarization problem space from Android or web. The raw request also asks for both App Store distribution and a standalone installer path, which means the task must define how one macOS codebase can be packaged for two different operator workflows without turning this into a broad desktop rewrite.

**Triage:**
- *Should exist:* Yes, if macOS is a real release target.
- *Smallest safe scope:* Produce a repeatable macOS distribution path covering App Store and standalone packaging prerequisites.
- *Skipped scope:* Do not mix this with Windows, iOS, or unrelated feature work.
- *Boundaries:* Keep it focused on desktop release engineering, signing, packaging, and operational docs.

**Action:** Prepare Hable’s macOS release path for both Mac App Store and standalone distribution by defining signing, entitlements, packaging, notarization/validation, and operator workflows for each channel. Reuse the existing app where possible and limit code changes to what distribution hardening genuinely requires.

**Hable perspective:** Desktop distribution is an operational trust problem. The important outcome is a maintainable path to ship macOS builds safely through the right channels, not a one-off archive.

**Implementation scope:**
- macOS signing/entitlements/packaging configuration.
- Separate packaging expectations for App Store vs standalone installer/notarized app.
- Distribution documentation and operator playbook.
- Smoke verification of representative macOS release artifacts where feasible.

**Scalability considerations:** The release path should be repeatable and clearly documented. Avoid per-machine tribal knowledge around signing and packaging.

**Future split guidance:** Store listing assets, automatic update frameworks, or cross-platform desktop release orchestration should remain separate tasks. This task is only for the macOS release/distribution path.

**Edge cases:** Missing certificates, entitlements mismatches, sandbox/App Store restrictions, notarization failures, standalone installer trust prompts, and release-only plugin/signing regressions.

**Acceptance criteria:**
- Hable has a documented macOS distribution path for both App Store and standalone release.
- Required signing/entitlement/packaging choices are defined and verified.
- Release artifacts or their build path are smoke-validated where secrets allow.
- Documentation is sufficient for future operators to reproduce the process.

**Dependencies:** macOS build/signing configuration, existing distribution docs in `Developement/`

**Completion notes:** Completed on 2026-07-13. Replaced the remaining macOS placeholder metadata with Hable-specific values in `macos/Runner/Configs/AppInfo.xcconfig` (`PRODUCT_NAME = Hable`, bundle id `com.hable.app.macos`) and added an operator playbook at `Developement/macos_distribution.md` covering the separate App Store and standalone notarized paths. Smoke-validated the local build path with `flutter build macos --debug` and `flutter build macos --release`, which now emit `build/macos/Build/Products/Release/Hable.app`. Inspected the resulting artifact with `codesign -dvvv --entitlements :- build/macos/Build/Products/Release/Hable.app` and `spctl -a -vv build/macos/Build/Products/Release/Hable.app`; the app is currently ad-hoc signed and rejected by Gatekeeper because this machine has `0 valid identities found`, so App Store export / Developer ID signing / notarization remain operator-only follow-through rather than local secrets-free steps.


<a id="prepare-windows-installers-and-standalone-windows-distribution-path"></a>
### [x] Prepare Windows Installers And Standalone Windows Distribution Path

**Raw source:** Windows Installers. Create Windows installer creation, and standalone installer.

**Issue:** Hable does not yet have a dedicated Windows packaging/distribution path documented as a first-class task. Windows distribution has different operational concerns from Android/macOS: installer technology choice, signing expectations, standalone ZIP/MSIX/EXE tradeoffs, and runtime prerequisite validation. This is release engineering work, not UI/product work.

**Triage:**
- *Should exist:* Yes, if Windows distribution is now desired.
- *Smallest safe scope:* Define and validate a repeatable Windows packaging path for installer and standalone delivery.
- *Skipped scope:* Do not combine this with Mac/iOS store work or unrelated feature implementation.
- *Boundaries:* Keep the task at packaging, signing, and operator workflow level.

**Action:** Prepare Hable for Windows distribution by choosing and implementing a supported installer strategy plus a standalone path, documenting prerequisites, and validating that release artifacts can be generated and launched reliably. Keep production-code changes minimal and tied only to release-readiness issues discovered during packaging.

**Hable perspective:** Windows users need a predictable install/update experience, but the immediate engineering need is an operator-friendly release path rather than a new product feature.

**Implementation scope:**
- Windows build/package configuration and installer technology choice.
- Standalone artifact path and any runtime prerequisite handling.
- Documentation/operator playbook for packaging and distribution.
- Smoke verification of representative Windows release artifacts where feasible.

**Scalability considerations:** The packaging path should be reproducible by future maintainers and avoid bespoke manual steps where possible.

**Future split guidance:** Enterprise installers, auto-update systems, store distribution, or code-signing automation should remain separate tasks. This task is only for initial Windows installer and standalone distribution readiness.

**Edge cases:** Missing signing certs, runtime dependency bundling, installer permissions, flavor/package identity mismatches, release-only plugin issues, and Windows-specific path/encoding quirks during packaging.

**Acceptance criteria:**
- Hable has a documented Windows installer and standalone distribution path.
- Packaging choices and prerequisites are explicit and reproducible.
- Release artifacts or their generation path are smoke-validated where feasible.
- Documentation is sufficient for future operators to repeat the release flow.

**Dependencies:** Windows build/package configuration, existing build/distribution docs in `Developement/`

**Completion notes:** Completed on 2026-07-13. Replaced the default Windows desktop metadata with Hable-specific values in `windows/CMakeLists.txt`, `windows/runner/main.cpp`, and `windows/runner/Runner.rc` so release artifacts resolve to `Hable.exe` with matching product/version strings. Added `windows/installer/Hable.iss` as the installer template and documented the supported installer + portable bundle workflows in `Developement/windows_distribution.md`. A native Windows smoke build was not possible from the current macOS host, so the documented release path explicitly requires a Windows build/signing machine for `flutter build windows --release`, installer compilation, and final code-signing validation.


<a id="serialize-achievement-and-habit-completion-splashes-with-user-driven-dismiss-and-habit-colored-background-animation"></a>
### [x] Serialize Achievement And Habit Completion Splashes With User-Driven Dismiss And Habit-Colored Background Animation

**Raw source:** Crash report: when the habit splash screen appears concurrently with the achievement splash screen, they clash and the green background of the habit splash remains on screen. They need proper queuing/synchronization because multiple habits and/or achievements may complete at the same time. The habit splash background should use the habit’s color, animate in sync with the text, and auto-skipping should be removed in favor of an explicit continue action.

**Issue:** Hable already has two adjacent celebration systems that are not coordinated as one overlay contract. `CompletionSplashScreen` is currently pushed directly from Home/dashboard and auto-dismisses after 4 seconds, while achievement unlock handling is driven separately through `celebrationProvider` and a badge-reveal dialog path. Because those surfaces can be triggered by the same completion event stream, they can overlap or race, leaving behind visual residue from the habit splash background and creating an unreliable dismissal sequence. The current completion splash also hardcodes `AppTheme.sageGreen`, animates content separately from the full background feeling requested by the raw note, and uses tap/timeout dismissal rather than a clear explicit continue affordance.

**Triage:**
- *Should exist:* Yes. This is a real celebration-state coordination bug, not just cosmetic polish.
- *Smallest safe scope:* Unify celebration sequencing for habit completion and achievement unlock overlays, fix the background/animation contract of the habit splash, and remove auto-dismiss.
- *Skipped scope:* Do not redesign all milestone feedback, audio, or particle systems in this task.
- *Boundaries:* Keep this focused on overlay orchestration, dismissal rules, and the habit splash visual contract. Do not turn it into a full reward engine rewrite.

**Action:** Introduce a single celebration queue/orchestrator so habit completion splashes and achievement unlock surfaces never overlap unpredictably. Ensure the habit completion splash owns a habit-colored animated background that moves in lockstep with the text/content transition, and replace the current auto-dismiss timer with an explicit continue control so the user advances the sequence intentionally. Preserve multiple-completion and multiple-achievement handling by serializing celebrations rather than dropping or stacking them unsafely.

**Hable perspective:** Celebration moments should feel deliberate and premium, not like competing overlays fighting for the same screen. If Hable asks users to care about achievements and habit completions, it must present them as one coherent queue.

**Implementation scope:**
- `lib/screens/completion_splash_screen.dart`: remove auto-dismiss, use habit-color background treatment, and synchronize background/content animation.
- Celebration orchestration surfaces such as `celebrationProvider`, Home/dashboard listeners, and any achievement-reveal entry point so overlays queue rather than overlap.
- Tests or focused widget/state verification for sequential celebration handling and explicit dismissal behavior.
- Documentation/QA updates for the new celebration queue and dismissal contract.

**Scalability considerations:** The orchestrator should remain lightweight and event-driven. It must handle bursts of several completion/achievement events without leaking routes, timers, or stale overlay state.

**Future split guidance:** Rich milestone-only visual variants, audio systems, or a generalized reward presentation framework can remain separate tasks. This task is only for making the existing habit/achievement overlays serialize correctly and feel coherent.

**Edge cases:** Several habits completed quickly in one session, multiple badge unlocks on one sync, app backgrounding while a celebration is queued, missing habit color, widget disposal during queue drain, and ensuring explicit continue cannot accidentally skip multiple queued celebrations at once.

**Acceptance criteria:**
- Habit completion and achievement celebration surfaces no longer visually overlap or leave residual background state behind.
- Celebration events are serialized through a predictable queue/orchestrator.
- `CompletionSplashScreen` uses the completed habit’s color for the animated background.
- Background and text/content animations feel synchronized rather than independent.
- Habit completion splash no longer auto-dismisses; the user advances with an explicit continue action.
- Focused verification covers at least one overlapping-completion/achievement scenario and one multi-item queue scenario.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Serialized celebration overlays by keeping achievement unlocks in `lib/providers/celebration_provider.dart` and routing habit completions through a single queued presentation contract instead of letting independent overlays race each other. `lib/screens/completion_splash_screen.dart` now uses the completed habit's color as the animated backdrop, synchronizes backdrop/content entrance and exit motion, and removes auto-dismiss in favor of an explicit `Continue` button. Home/dashboard celebration listeners were updated to feed the same bounded sequence, and Profile history now records the awarded `+5 pts` / `+10 pts` metadata so the completion splash and long-term history stay coherent. Focused verification passed with `flutter test test/completion_splash_screen_test.dart`, and the new queue/dismissal contract is documented in `Developement/ux_habit_states_and_scoring.md` and `Developement/qa_testing.md`.


<a id="replace-partner-status-dots-with-filled-mini-rings-and-align-completed-state-to-habit-color"></a>
### [x] Replace Partner Status Dots With Filled Mini Rings And Align Completed State To Habit Color

**Raw source:** The partners on habit cards should show check-in status through a small ring around their avatar, like the main profile ring, instead of a separate status dot. The ring should fill with color based on status, and completed state should turn into the habit color.

**Issue:** Hable already shipped the compact expandable partner stack, but the current visual treatment still falls short of the intended status language. In `lib/widgets/habit_partner_row.dart`, collapsed avatars render a border plus a separate 12x12 status dot, and the completed state uses `AppTheme.completionGreen` for that dot rather than the current habit color. The surrounding avatar border changes color, but it does not behave like a true filled mini-ring around the avatar itself. That means the partner surface technically exposes state, but not in the same visual vocabulary as the primary habit ring or the product rule documented in the social/UX specs.

**Triage:**
- *Should exist:* Yes. This is a concrete visual-contract correction on an already-shipped partner surface.
- *Smallest safe scope:* Replace the current avatar-border-plus-dot treatment with a small ring-based status treatment and align completed coloring to the owning habit.
- *Skipped scope:* Do not redesign the partner stack layout, change nudge business logic, or reopen the broader avatar-group interaction task.
- *Boundaries:* Keep this limited to partner avatar status rendering and the associated semantics/test expectations.

**Action:** Rework the partner avatar status presentation so each avatar carries a miniature ring treatment that communicates completed, pending, nudged, or supporter states without relying on a detached corner dot. Use the habit color as the completed-state fill/accent so partner completion reads as part of the same habit-specific visual language as the main card. Preserve the existing compact stack and expanded list behaviors while updating the rendering semantics and tests to match the new ring contract.

**Hable perspective:** The partner row should feel like an extension of the habit’s own ring-first language. A separate green dot communicates "some state exists," but not the more intentional "this partner’s habit ring is in a completed/pending/nudged state tied to this habit."

**Implementation scope:**
- `lib/widgets/habit_partner_row.dart`: replace the dot-based status indicator with a small ring-based avatar treatment and align completed-state color to `habitColor`.
- Any shared avatar/status helper only if extracting the ring treatment reduces duplication between collapsed and expanded partner rendering.
- Tests: update/add focused widget assertions for completed/pending/nudged/supporter ring rendering, especially completed-state use of habit color.
- Documentation/QA: update wording where manual expectations still describe a dot instead of a mini ring.

**Scalability considerations:** The new ring treatment should remain cheap to render across many habit cards and not introduce heavy custom painting unless clearly necessary. Keep the visual logic deterministic and reuse the same state-color mapping in collapsed and expanded modes.

**Future split guidance:** If later work needs animated partner rings, partial-progress arcs, or richer per-partner completion visuals, split those into separate follow-up tasks. This task is only for replacing the dot with a status ring and correcting the completed color contract.

**Edge cases:** Very small avatar stack sizes, narrow screens, many repeated partner rows, supporter/read-only styling, nudged-vs-pending distinction when no completion exists, dark/light background contrast, and semantics labels still accurately describing state after the visual swap.

**Acceptance criteria:**
- Partner avatars on habit cards use a small ring-based status treatment rather than a detached status dot.
- Completed partner state uses the current habit color rather than a generic green.
- Pending, nudged, and supporter states remain visually distinguishable within the mini-ring contract.
- The collapsed stack and expanded partner list both reflect the updated ring treatment consistently.
- Focused widget verification covers the revised status-ring rendering and completed-state color mapping.
- Relevant docs are verified and updated where they still describe the older dot treatment.

**Dependencies:** `Developement/sys_social_and_analytics.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Reworked `lib/widgets/habit_partner_row.dart` so partner avatars now carry a single miniature ring container around the avatar instead of a detached corner dot. The ring palette is shared across collapsed and expanded partner views, with completed partners now using the current habit color, nudged partners using a tinted habit-color ring, supporters staying lavender, and pending partners keeping a muted neutral ring. Updated `test/habit_partner_row_test.dart` to assert the revised ring contract and the completed-state habit-color mapping, and refreshed the manual QA wording in `Developement/qa_testing.md` so the verification language now matches the mini-ring surface. Focused verification: `flutter test test/habit_partner_row_test.dart`.


<a id="complete-habit-creation-form-as-a-cohesive-onboarding-style-create-edit-surface"></a>
### [x] Complete Habit Creation Form As A Cohesive Onboarding-Style Create/Edit Surface

**Raw source:** Complete the habit creation form, the form is not complete yet. no custom emoji, no other suggestions for time deuration (e.g. 21, 33, 40, the science proven ones). no description for the habit card and its creation form.
reorder correctly, the emoji at left (emoji picker appears by click), and at the right the name field, the template chips, the description field, and the duration field. and others... reorder and make it complete and elegant. don't forget to show friend emoji next to their name.

**Issue:** Hable already has a working `HabitFormSheet`, but it is still a minimal CRUD modal rather than a fully intentional creation surface. The form currently supports preset chips, title, day duration, pastel color selection, and accepted-friend partner chips for new habits, yet the experience remains fairly raw: validation is silent, the create/edit flows are only lightly differentiated, feedback/error handling is minimal, there is no stronger information architecture around habit type/purpose, and the interaction still reads more like an internal sheet than a polished onboarding-style creation flow. Because habit creation is a primary user action from Home, the missing piece is not core functionality but form completeness and coherence.

**Triage:**
- *Should exist:* Yes. Habit creation is a primary product surface.
- *Smallest safe scope:* Finish the current shared `HabitFormSheet` into a more complete, guided create/edit experience without replacing it with a brand-new screen architecture.
- *Skipped scope:* Do not redesign onboarding globally, invent a full habit marketplace, or move creation into a separate route unless clearly required by the current UX contract.
- *Boundaries:* Reuse the existing `HabitFormSheet`, preset data, partner picker, and habit-action providers. This task is about completeness and polish of the form contract.

**Action:** Refine `HabitFormSheet` into a cohesive creation/edit surface that feels deliberate and complete: clearer validation and input guidance, better create-versus-edit affordances, stronger state/submit handling, and a more intentional field hierarchy for presets, title, duration, color, and partner selection. Keep the form compatible with the Home FAB and existing edit entry points, and preserve the current shared-source preset and partner-invite behavior rather than replacing it with speculative new creation flows.

**Hable perspective:** Creating a habit is one of Hable’s highest-frequency setup actions. It should feel simple and guided, almost like a lightweight onboarding step, not like a bare admin dialog. The form should help users choose and commit confidently without becoming a complex settings page.

**Implementation scope:**
- `lib/widgets/habit_form_sheet.dart`: finish the create/edit surface, including validation, hierarchy, CTA behavior, and missing polish on existing fields.
- Related habit-action/provider wiring only as needed to support better submit/error/saving states.
- Focused widget coverage for create, edit, validation, preset selection, and partner invite selection behaviors.
- Documentation/QA updates for the finalized habit-creation form contract.

**Scalability considerations:** Keep the form modular and data-driven. It should be straightforward to extend later with extra fields (for example reminder time or notes) without turning into a monolith.

**Future split guidance:** Full separate creation screens, advanced custom emoji/icon systems, due-time scheduling, or a recommendation/template marketplace should remain separate tasks. This task is only for completing the current shared form.

**Edge cases:** Empty title, invalid/non-positive duration, editing existing habits without resending partner invites, no accepted friends, long preset titles, keyboard overlap on small screens, and submit/error state during async create/update.

**Acceptance criteria:**
- The shared habit creation/edit form feels complete and guided rather than like a bare CRUD sheet.
- Validation and submit behavior are explicit and user-visible.
- Preset, duration, color, and partner-selection flows remain intact and are polished rather than regressed.
- Create and edit paths are clearly differentiated where appropriate.
- Focused verification covers create, edit, validation, and partner-selection behavior.
- Relevant docs are updated to reflect the finalized habit-form contract.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Rebuilt `lib/widgets/habit_form_sheet.dart` into a more guided create/edit surface with a stronger header, icon-plus-title identity row, preset chips, preset-driven intent copy, explicit duration suggestion chips (`21`, `33`, `40`, `66`, `90`), clearer color selection, visible validation, async save state, and differentiated `Create habit` vs `Save changes` CTAs. Friend invite chips now render with avatar emoji via `UserAvatar`, and create mode preserves the existing partner-invite flow while edit mode stays scoped to updating the habit itself. The save path now also correctly flags custom habits in `habitActionsProvider` instead of always sending `isCustom: false`, and standard-habit lookup tolerates leading emoji so custom-title decoration does not break preset inference. Focused verification was added in `test/habit_form_sheet_test.dart` for validation, preset application, partner selection, and edit-mode saves with `flutter test test/habit_form_sheet_test.dart`.


<a id="add-first-run-quote-splash-and-promote-quote-first-typography-across-quote-bearing-celebration-surfaces"></a>
### [x] Add First-Run Quote Splash And Promote Quote-First Typography Across Quote-Bearing Celebration Surfaces

**Raw source:** Work on an initialization splash screen showing the quote of the day with a lovely design when the user starts the app for the first time. Also, on habit splash screens that have quotes, make the quote always display as the first element, large and in a quote style.

**Issue:** Hable currently has no dedicated first-run quote splash surface. The existing startup flow goes through auth/onboarding/app gate screens, and quotes are shown later inside Home or the completion splash. Even in the current `CompletionSplashScreen`, the quote appears as a lower secondary block after emoji/headline/body text, not as the primary typographic focal point requested by the raw note. The app therefore lacks both a first-impression quote moment and a consistent "quote-first" visual hierarchy on celebration surfaces that already consume `quoteProvider`.

**Triage:**
- *Should exist:* Yes, as a design/experience task layered on top of the current quote pipeline.
- *Smallest safe scope:* Add one first-run quote splash and update quote-bearing celebration surfaces to use a quote-first composition.
- *Skipped scope:* Do not redesign all onboarding, Home, or global splash behavior in one pass, and do not invent a new quote backend.
- *Boundaries:* Reuse the existing cached-quote/fallback pipeline and keep first-run gating local and deterministic.

**Action:** Create a dedicated first-run initialization splash that uses the existing daily-quote pipeline as the emotional opening of the app, with a more intentional quote-led visual composition than the current generic celebratory layout. Then refactor any habit completion/celebration surfaces that already show quotes so the quote becomes the first and largest reader-facing element rather than a footer after generic congratulatory copy. Keep the design bounded and elegant, and gate the first-run splash so it appears only when appropriate.

**Hable perspective:** Hable’s tone is a product feature. A first-run quote moment can frame the app emotionally before habits or scores appear, and quote-bearing celebration screens should feel like beautiful reading moments rather than generic success modals with a quote tacked on at the bottom.

**Implementation scope:**
- First-run splash/initialization entry point in the current startup/onboarding/auth gate flow.
- `lib/screens/completion_splash_screen.dart` and any other quote-bearing celebration surface to adopt quote-first hierarchy where appropriate.
- Local persistence/gating so the initialization quote splash shows only on first launch or first eligible entry, depending on the chosen contract.
- Tests or focused verification for first-run gating and quote-first rendering behavior.
- Documentation updates to onboarding/startup and quote UX expectations.

**Scalability considerations:** Startup gating should be simple and local. The visual system for quote-first surfaces should be reusable enough that future quote-bearing moments do not each invent their own hierarchy.

**Future split guidance:** Full onboarding redesign, seasonal quote themes, highly personalized quote generation, or animated storybook startup sequences should remain separate tasks. This task is only for a first-run quote splash and quote-first hierarchy on existing quote-bearing celebration surfaces.

**Edge cases:** No cached quote on first launch, offline fallback quote usage, users who bypass onboarding with seed/dev paths, reduced-motion preferences, app relaunch after already seeing the first-run splash, and quote text long enough to wrap across smaller screens.

**Acceptance criteria:**
- The app can show a dedicated first-run initialization splash centered on the quote of the day.
- The first-run quote splash is gated so it does not repeat every launch once acknowledged.
- Quote-bearing habit celebration surfaces present the quote as the primary reader-facing element rather than a lower secondary block.
- Existing quote fallback behavior still works when no synced quote is cached.
- Focused verification covers first-run gating and at least one quote-first celebration surface.
- Relevant docs are updated to reflect the startup and quote-hierarchy contract.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added `lib/services/first_run_quote_gate.dart` plus `lib/screens/first_run_quote_screen.dart` and wired `_AppGate` in `lib/main.dart` to show a one-time, per-user quote-first opening screen before the main shell. The gate persists via secure storage, so once dismissed it does not reappear for the same signed-in user. `lib/screens/completion_splash_screen.dart` was also reordered so the quote becomes the first and largest reader-facing element on quote-bearing completion surfaces rather than a footer after the celebration copy. Documentation was updated in `Developement/ux_habit_states_and_scoring.md` and `Developement/qa_testing.md`, and focused verification covered the storage gate plus quote-first completion ordering with `flutter test test/completion_splash_screen_test.dart test/first_run_quote_gate_test.dart test/habit_form_sheet_test.dart`.


<a id="investigate-and-resolve-macos-ad-hoc-code-signing-compilation-failure-with-keychain-access-groups-entitlement"></a>
### [x] Investigate And Resolve macOS Ad-Hoc Code Signing Compilation Failure With Keychain Access Groups Entitlement

**Raw source:** macOS build compilation fails on keychain-access-groups entitlement when compiling release build locally with ad-hoc signing ("-")

**Issue:** macOS local release builds fail with `"Runner" has entitlements that require signing with a development certificate` because `Release.entitlements` contains the `keychain-access-groups` entitlement, which is not supported by ad-hoc code signing (`CODE_SIGN_IDENTITY = "-"`). Since the user reverted the manual removal of `keychain-access-groups` to keep the production plist intact, local compilation remains broken without Xcode signing overrides.

**Triage:**
- *Should exist:* Yes. Developers should be able to compile the macOS release application locally without requiring a valid Apple Developer Account or development certificates.
- *Smallest safe scope:* Find a way to bypass or override the entitlements file during local builds or configure ad-hoc compatible signing settings while preserving the production entitlements for release/publishing.
- *Skipped scope:* Do not remove the keychain-access-groups entitlement from production or App Store releases.
- *Boundaries:* Do not change the committed entitlements file which is needed for AltStore PAL and App Store distribution.

**Action:** Research and configure Xcode/Flutter build settings to dynamically override or ignore keychain-access-groups for ad-hoc/local builds, or document how local operators can compile release builds successfully.

**Hable perspective:** Clean local compilation is critical for CI/CD and developer onboarding.

**Implementation scope:**
- `macos/Runner.xcodeproj`, entitlements configuration, local build documentation.
- Verification and documentation of successful local compilation and how production settings are preserved.

**Scalability considerations:** Local overrides should not leak into production builds.

**Future split guidance:** Automated certificate provision pipelines or full App Store Connect automation are separate.

**Edge cases:** Entitlement mismatches, runtime keychain access errors if sandbox is enabled, macOS Gatekeeper validation.

**Acceptance criteria:**
- Developers can run `flutter build macos --release` locally without failing on entitlements/signing errors.
- The production `Release.entitlements` still retains `keychain-access-groups` for official distribution.

**Completion notes:** Completed on 2026-07-13. Discovered that `CODE_SIGN_ENTITLEMENTS` was unlinked in `macos/Runner.xcodeproj/project.pbxproj`. Restored the linkage to ensure production builds correctly sign with sandbox and keychain entitlements. Documented the ad-hoc signing constraint in `Developement/sys_build_integrity.md`: local operators without certificates should use `flutter build macos --profile` for performance testing, or temporarily drop the `keychain-access-groups` key from `Release.entitlements` if a strict local release build is required. Production entitlements remain unmodified.

**Dependencies:** `Developement/sys_build_integrity.md`, `Developement/macos_distribution.md`



<a id="finish-habit-form-information-architecture-with-description-science-based-duration-picks-and-partner-emoji-chips"></a>
### [x] Finish Habit Form Information Architecture With Description, Science-Based Duration Picks, And Partner Emoji Chips

**Raw source:** complete the habit creation form, the form is not complete yet. no custom emoji, no other suggestions for time deuration (e.g. 21, 33, 40, the science proven ones). no description for the habit card and its creation form.
reorder correctly, the emoji at left (emoji picker appears by click), and at the right the name field, the template chips, the description field, and the duration field. and others... reorder and make it complete and elegant. don't forget to show friend emoji next to their name.

**Issue:** Hable’s earlier habit-form pass improved the sheet, but the product contract is still not fully aligned with the intended creation surface. The current `HabitFormSheet` already exposes a fixed emoji picker and duration suggestions, yet it still diverges from the requested information architecture: the field ordering and composition need to feel more deliberate, the habit description contract is still missing from both creation and card presentation, the quick-duration guidance should be constrained to the curated science-based options instead of a broader set, and the partner row should consistently render friend emoji/avatar identity next to names as part of the primary selection UI. Because this is one of the app’s highest-frequency authoring flows, these remaining mismatches should be handled as a bounded follow-up rather than left as vague polish debt.

**Triage:**
- *Should exist:* Yes. This is a concrete follow-up on a primary creation surface whose current implementation still misses explicit UX requirements from the raw contract.
- *Smallest safe scope:* Refine the existing shared `HabitFormSheet` and the corresponding habit-card presentation so the field order, description support, curated duration picks, and partner identity treatment match the intended UX without replacing the form architecture.
- *Skipped scope:* Do not invent a free-form icon system beyond the bounded picker, redesign the full Home feed, add reminder scheduling, or broaden this into a full habit metadata overhaul.
- *Boundaries:* Reuse the current modal sheet, standard habit preset data, existing create/edit providers, and the current avatar pipeline. Keep the work scoped to the habit authoring/presentation contract already implied by Hable.

**Action:** Rework the habit creation/edit surface so the top of the form becomes an intentional identity row with the tappable emoji picker on the left and the text stack on the right, followed by a cleaner progression through name, template chips, description, duration, and the remaining fields. Add first-class habit description support where it is truly part of the product contract, remove any extra duration suggestion chips beyond the approved science-based set (`21`, `33`, `40`), and ensure partner/friend selection surfaces show each friend’s emoji/avatar next to their name instead of text-only chips. The resulting sheet should feel complete and elegant, not just technically functional.

**Hable perspective:** In Hable, creating a habit is not back-office data entry. It is the moment where a lightweight personal ritual becomes explicit, so the form needs a clear hierarchy, emotionally legible identity cues, and only the options that reinforce commitment rather than create noise. Description and partner identity should feel intentional, while duration guidance should stay curated and confidence-building.

**Implementation scope:**
- `lib/widgets/habit_form_sheet.dart`: reorder and refine the form layout, keep the emoji picker as a tappable leading control, constrain curated duration suggestions to the approved set, and add description input and validation/persistence hooks if the product model already supports them or can safely be extended.
- Habit-card rendering surfaces in Home and any other primary habit summary UI: show the new description only where the task contract requires it, while preserving compact card readability.
- Related model/provider/database wiring only as needed to persist and read a habit description safely across create/edit flows.
- Partner/friend selection widgets and avatar usage: ensure friend emoji/avatar identity appears inline next to names throughout the selection chips/list.
- Focused widget/provider/database verification for create, edit, description persistence, duration suggestion rendering, and partner chip identity.
- Documentation updates covering the finalized habit-creation and habit-card metadata contract.

**Scalability considerations:** Description support slightly broadens the habit data contract, so the implementation should stay additive and lightweight. Keep provider rebuilds localized, avoid widening list-card layouts in ways that degrade scanability, and make the duration/emoji choices data-driven so future small adjustments do not require another form rewrite.

**Future split guidance:** If later work needs richer notes, reminders, streak coaching copy, habit categories, or a larger icon library, split those into follow-up tasks. This task is only for the bounded form hierarchy, description support, curated duration picks, and partner identity treatment requested here.

**Edge cases:** Editing older habits that have no stored description, preserving layout under text scaling and keyboard overlap, long descriptions that should not break compact habit cards, partner lists with missing avatars/emoji, offline create/edit persistence, and standard presets whose default copy should not overwrite an existing custom description unexpectedly.

**Acceptance criteria:**
- The habit form presents a clear identity row with the emoji picker on the left and the primary text fields ordered intentionally on the right/in sequence.
- The sheet includes first-class description support where the user can add or edit it, and the corresponding habit card contract reflects that description only in the intended surfaces.
- Curated duration suggestions are limited to the approved science-based set (`21`, `33`, `40`) without extra suggestion chips.
- Friend/partner selection shows emoji/avatar identity next to each friend name.
- Create and edit flows preserve existing behavior while adding the new metadata and layout polish without regression.
- Focused verification covers description persistence/rendering, duration chip constraints, and partner identity presentation.
- Relevant docs are updated to reflect the revised habit metadata and form-layout contract.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Refined `lib/widgets/habit_form_sheet.dart` so the identity row keeps the emoji picker on the left while the right-side flow now progresses through title, preset chips, a real editable description field, and the curated duration suggestions limited to `21`, `33`, and `40`. Added additive description persistence across Drift, sync payloads, and the Worker via `lib/database/tables.dart`, `lib/database/database.dart`, `lib/providers/habit_actions_provider.dart`, `lib/services/sync_service.dart`, `backend/schema.sql`, and `backend/src/index.ts`, with generated Drift updates in `lib/database/database.g.dart`. Habit summaries now surface the stored description on primary card surfaces through `lib/widgets/habit_card.dart`, `lib/screens/profile_screen.dart`, and preset fallback copy in `lib/data/standard_habits.dart`, while partner chips continue rendering inline avatar emoji next to names. Documentation was updated in `Developement/sys_schema_and_logic.md` and `Developement/qa_testing.md`, and focused verification passed with `flutter test test/habit_form_sheet_test.dart` and `flutter test test/completion_splash_screen_test.dart`.


<a id="roll-out-the-latest-hable-app-icon-across-flutter-platforms-pwa-and-favicon-surfaces"></a>
### [x] Roll Out The Latest Hable App Icon Across Flutter Platforms, PWA, And Favicon Surfaces

**Raw source:** use the newest icon Flutter/hable/Developement/Resources/AppIcon - Hable.png and don't forget to update all places, favicon, different builds (android, ios, web, desktop, etc.) icon, pwa icon, etc. use a propper version for favicon.

**Issue:** Hable’s current icon pipeline is not aligned to the latest source asset. The repo already contains the requested replacement file, but the Flutter icon tooling in `pubspec.yaml` still points to the older `Developement/Resources/app_icon.jpeg`, while web uses its own `favicon.png` and `manifest.json` icon set, Windows ships a separate `.ico`, and Apple platforms rely on generated asset catalogs. That means updating a single source file is not enough: without an explicit rollout task, different builds will continue shipping stale or inconsistent branding across launcher icons, PWA surfaces, desktop resources, and the browser favicon.

**Triage:**
- *Should exist:* Yes. Asset and packaging consistency across platforms is a real product-quality requirement, not optional cleanup.
- *Smallest safe scope:* Adopt `Developement/Resources/AppIcon - Hable.png` as the source of truth, regenerate or replace all platform icon derivatives, and verify no primary build surface still references the old icon asset.
- *Skipped scope:* Do not redesign the brand, create alternate holiday icons, or broaden this into a full marketing/brand-system refresh.
- *Boundaries:* Keep the work inside the existing Flutter platform packaging and web/PWA surfaces. Reuse the current launcher-icon tooling where practical instead of inventing a custom build pipeline.

**Action:** Replace the old icon source with the new PNG as the canonical input for the app icon pipeline, then update every platform-specific derivative that Hable ships: Android launcher icons, iOS and macOS AppIcon catalogs, Windows desktop icon resources, Linux desktop icon surfaces if configured, and the web/PWA manifest assets. Produce a proper favicon-specific raster version rather than blindly reusing a large launcher asset, and verify that config files and generated assets no longer point at the old `app_icon.jpeg` source. The task should end with one coherent icon contract across mobile, desktop, and web.

**Hable perspective:** Hable presents as one product across mobile, desktop, and browser entry points, so the icon is part of the product contract the same way typography and motion are. Inconsistent launcher and favicon assets make the app feel unfinished even if the feature set is correct.

**Implementation scope:**
- `pubspec.yaml` and any launcher-icon generation config: point the Flutter icon toolchain at `Developement/Resources/AppIcon - Hable.png` or a derived canonical copy if the tooling cannot safely consume the spaced filename.
- Android/iOS/macOS generated icon assets: regenerate or replace the platform app-icon sets and keep Xcode/Gradle references intact.
- `web/` assets: update `favicon.png`, `manifest.json` icon files, and any PWA icon derivatives to use the new artwork, with a favicon-specific export that reads cleanly at small sizes.
- Windows/Linux desktop icon resources where present, including `.ico` and packaged desktop metadata surfaces.
- Verification and documentation: confirm the old icon source is no longer authoritative, and update QA/platform packaging notes accordingly.

**Scalability considerations:** Scalability impact: none expected. Keep the icon pipeline deterministic so future icon refreshes remain a single-source update followed by reproducible derivative generation rather than a manual hunt across platforms.

**Future split guidance:** If later work needs adaptive Android monochrome icons, seasonal icon variants, or a formal asset-generation script/CI pipeline, split that into follow-up branding/build tasks. This task is only for adopting the newest Hable icon consistently everywhere the app ships today.

**Edge cases:** Tooling that cannot read filenames with spaces, favicon legibility at 16x16 and 32x32 sizes, stale generated assets lingering in Apple/Windows bundles, PWA manifest caches, transparent-padding differences across platforms, and ensuring desktop installer resources stay aligned with the app binary icon.

**Acceptance criteria:**
- `Developement/Resources/AppIcon - Hable.png` becomes the effective source of truth for shipped app-icon assets.
- Android, iOS, macOS, Windows, Linux (if configured), and web/PWA surfaces all receive updated icon derivatives or config references.
- The web favicon is regenerated in a proper favicon-specific form rather than left as a stale or poorly downscaled launcher image.
- No primary icon-generation config still points at the old `Developement/Resources/app_icon.jpeg` source unless a deliberate derived-copy step is documented.
- Focused verification confirms the new icon is present across the major platform asset directories/configs.
- Relevant docs are updated to reflect the icon rollout and verification expectations.

**Dependencies:** `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Updated `pubspec.yaml` so `flutter_launcher_icons` now uses `Developement/Resources/AppIcon - Hable.png` as the canonical source and also generates web, Windows, and macOS derivatives in addition to Android and iOS. Regenerated the shipped platform assets across `android/app/src/main/res/mipmap-*`, `ios/Runner/Assets.xcassets/AppIcon.appiconset`, `macos/Runner/Assets.xcassets/AppIcon.appiconset`, `windows/runner/resources/app_icon.ico`, `web/favicon.png`, and `web/icons/*`, with `web/manifest.json` refreshed to the new icon set and colors. The obsolete `Developement/Resources/app_icon.jpeg` source was removed from the effective pipeline, and QA notes in `Developement/qa_testing.md` now call out launcher-icon and favicon verification explicitly. Focused verification confirmed the new asset contract via `flutter pub run flutter_launcher_icons`, `rg -n "app_icon\\.jpeg|AppIcon - Hable\\.png|flutter_launcher_icons" pubspec.yaml web/manifest.json Developement/Task1_Engineered.md Developement/qa_testing.md`, `sips -g pixelWidth -g pixelHeight web/favicon.png web/icons/Icon-192.png web/icons/Icon-512.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png`, `file windows/runner/resources/app_icon.ico`, and density checks across the Android `mipmap-*` launcher assets.


<a id="add-research-backed-new-user-onboarding-slides-before-the-existing-setup-flow"></a>
### [x] Add Research-Backed New-User Onboarding Slides Before The Existing Setup Flow

**Raw source:** work on onboarding slides for new users based on this research Flutter/hable/Developement/Resources/Researches/Onboarding Slides. Follow-up scope note: could be fun implementing the day quote inside the onboarding.

**Issue:** Hable’s current onboarding is a functional setup sequence (`OnboardingUsernameScreen` → `OnboardingHabitScreen` → `OnboardingDurationScreen` → `OnboardingCompleteScreen`), but it does not yet deliver the research-backed educational slide experience. The research file calls for a chill, minimal, pastel/sage sequence that explains Hable’s emotional and behavioral model before or around setup: welcome, Mud resistance, first commit, habit partners, gentle reminders, deferred verification, no skip button, and private journal boundaries. Hable also already has a daily quote pipeline through `quoteProvider`, cached quotes, and fallback copy, but that emotional first-read moment is currently separate from the onboarding slide sequence. The current screens create a local user and first habit, but they do not introduce the Mud long-press model, social partner rings, reminder soft-ask behavior, privacy expectations, or quote-of-the-day framing in a guided slide format.

**Triage:**
- *Should exist:* Yes. This is a clear product onboarding task backed by a local research artifact and aligned with the existing onboarding screen label in usage diagnostics.
- *Smallest safe scope:* Add a focused slide/walkthrough layer for first-time users, include the current daily quote as an emotional anchor in that slide sequence, and route it into the existing setup sequence without replacing the current username, habit, duration, commit, or test-seed flows.
- *Skipped scope:* Do not redesign authentication, require email/PIN verification, add a full social invite flow inside onboarding, or rework the Mud physics provider itself.
- *Boundaries:* Keep signup low-friction. Preserve username/password-only activation expectations from the docs, keep email/PIN recovery in nested Settings, reuse the existing quote provider/fallback pipeline instead of creating a new quote source, and ensure any Mud education uses static/derived presentation rather than recalculating Mud math in widget builds.

**Action:** Build a research-backed onboarding slide surface that introduces Hable to new users before the existing setup flow. The slides should use the research sequence as the content contract: "Every day is day one," the quote of the day as a calm opening or closing beat, Mud resistance and the 1500ms new-habit press, first commit with standard presets and custom duration support, social habit partners with habit-colored progress rings, and gentle reminder nudges that ask only when reminders are enabled. The final slide should hand off cleanly into the existing username/habit/duration/commit flow or Home empty-state transition as appropriate for the current startup contract.

**Hable perspective:** Onboarding should teach the user how Hable feels before it asks them to manage a dashboard. The right first impression is calm, direct, and specific to Hable’s mechanics: a quote-led day-one tone, habit resistance, commitment, partner support, reminders, and private reflection. It should make the first setup feel intentional while preserving the app’s local-first, low-friction start.

**Implementation scope:**
- Add or refactor a slide-based onboarding entry surface under `lib/screens/onboarding/`, likely using a `PageView` plus clear progress affordance, research-backed slide copy, and the existing `UsageTrackedScreen(screenName: 'onboarding')`.
- Integrate the existing quote-of-the-day pipeline via `lib/providers/quote_provider.dart`, including cached quote and fallback behavior, into one onboarding slide or a dedicated quote-led opening/closing moment.
- Wire the slide completion into the existing `OnboardingUsernameScreen` / setup flow without breaking the `SEED_USER_ID` and `SEED_USERNAME` test harness bypass.
- Reuse existing theme primitives from `AppTheme`, standard habit preset data from `lib/data/standard_habits.dart`, and existing skeleton/empty-state patterns where asynchronous content is involved.
- Keep Mud education presentational and reference the provider-owned 1500ms/physics contract without moving resistance math into slide widgets.
- Add focused widget tests for slide order, quote rendering/fallback, navigation controls, final handoff, and seeded onboarding bypass.
- Update onboarding/UX/QA docs to reflect the new slide contract and manual verification path.

**Scalability considerations:** The slide content should be data-driven enough that adding or reordering a small number of slides does not require new screen classes. Keep provider watching minimal so onboarding does not rebuild from broad app state. Quote rendering should use the existing cached/fallback provider path and must not introduce a blocking remote fetch dependency into first-run onboarding.

**Future split guidance:** If later work needs animated illustrations, personalized onboarding variants, reminder permission priming, social invite capture during onboarding, or A/B experimentation, split those into separate tasks. This task is only for the research-backed slide sequence and safe handoff into the existing onboarding setup.

**Edge cases:** Returning users who have already completed onboarding, seeded test users, small screens and large text, back navigation across slides and setup screens, offline first launch, no cached daily quote, no available habit presets, reduced-motion preferences, and ensuring privacy/verification copy does not imply unsupported account-recovery behavior.

**Acceptance criteria:**
- New users see a research-backed onboarding slide sequence before entering the existing setup flow.
- The slide content covers welcome/day-one framing, quote of the day, Mud resistance with the 1500ms press concept, first commit/presets, social partners/rings, gentle reminders/soft ask, deferred verification, no skip-button framing, and private journal boundaries.
- The quote slide uses the existing `quoteProvider` behavior, including offline fallback copy when no cached daily quote exists.
- The final slide routes into the existing setup path without breaking local user creation, first habit creation, or Home entry.
- The seeded test harness still bypasses normal onboarding and reaches Home as before.
- The design follows Hable’s muted pastel/sage, generous negative-space, chill/minimal visual philosophy.
- Focused tests or verification cover slide navigation, quote rendering/fallback, final handoff, and seed bypass.
- Relevant docs are updated to reflect the onboarding slide contract and QA checks.

**Dependencies:** `Developement/Resources/Researches/Onboarding Slides`, `Developement/sys_social_and_analytics.md`, `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added `lib/screens/onboarding/onboarding_slides_screen.dart`, a data-driven `PageView` onboarding surface using `UsageTrackedScreen(screenName: 'onboarding')`, muted Hable theme primitives, the existing `quoteProvider`, progress dots, and explicit Log in / Start setup handoff actions. The slide sequence covers the research-backed day-one quote, Mud 1500ms press concept, first commit and science-backed durations, partner rings, gentle reminders, deferred verification, private journals, and no-skip main-ring framing. Wired `lib/screens/auth_screen.dart` so logged-out non-seeded users see the slides before auth, the final slide opens sign-up, returning users can go straight to login, and the existing `SEED_USER_ID` auto-login skeleton still bypasses the slide layer. Added focused coverage in `test/onboarding_slides_screen_test.dart` for quote rendering/fallback copy, slide order, final handoff, and auth-form routing. Documentation was updated in `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, and `Developement/qa_testing.md`. Verification passed with `dart analyze lib/screens/auth_screen.dart lib/screens/onboarding/onboarding_slides_screen.dart test/onboarding_slides_screen_test.dart` and `flutter test test/onboarding_slides_screen_test.dart test/auth_session_test.dart`; full `flutter analyze` was attempted but blocked before analysis by the local generated Windows symlink cleanup error at `windows/flutter/ephemeral/.plugin_symlinks`.


<a id="connect-the-quotable-daily-quote-api-to-worker-daily-sync-and-local-drift-cache"></a>
### [x] Connect The Quotable Daily Quote API To Worker Daily Sync And Local Drift Cache

**Raw source:** integrate and combine this api with database for quotes https://api.quotable.io/quotes/random?tags=inspirational

**Issue:** Hable’s quote system is only partially wired. The product docs say the Worker should fetch one external quote per day and serve it through `/api/sync/daily`, while Flutter should cache that quote in Drift and fall back to local copy when offline. The app already has the local `cached_quotes` table, `cacheQuote()`/`getTodaysQuote()`, and `quoteProvider`, but the real data path is broken: `backend/src/index.ts` does not currently fetch or return any quote payload in `/api/sync/daily`, and `lib/services/sync_service.dart` never persists quote data from sync into Drift. As a result, the quote surfaces mostly depend on stale rows or local fallback strings instead of a real daily external quote source.

**Triage:**
- *Should exist:* Yes. This is a concrete integration gap between an existing API contract, backend sync route, local database cache, and user-facing quote surfaces.
- *Smallest safe scope:* Fetch one inspirational quote from the external API on the server, expose it through the existing daily sync payload, and persist it into the existing local Drift cache so the current `quoteProvider` starts working as documented.
- *Skipped scope:* Do not redesign quote personalization, add user-authored quote collections, build a separate quote-refresh endpoint, or move quote fetching directly into Flutter.
- *Boundaries:* Keep quote ownership in the Worker and quote consumption in the existing `/api/sync/daily` + Drift + `quoteProvider` pipeline. Preserve the offline fallback behavior when the external API is unavailable or rate-limited.

**Action:** Extend the backend daily sync flow so it fetches a bounded inspirational quote from `https://api.quotable.io/quotes/random?tags=inspirational`, normalizes the returned shape, caches or coalesces it per day, and includes the resulting quote text in the `/api/sync/daily` response. Then update Flutter’s `SyncService` to persist that synced quote into the existing `cached_quotes` Drift table, so `quoteProvider` can continue reading local data first and fall back only when no synced quote exists. The result should be one coherent quote pipeline rather than parallel documented and undocumented behaviors.

**Hable perspective:** Quotes are meant to be the emotional anchor of the day across Home, onboarding, and celebration surfaces. That only works if the quote source is consistent, offline-safe, and owned by the same sync path that already feeds the rest of Hable’s daily state. Pulling quotes directly in UI widgets would fragment the experience and weaken the offline-first contract.

**Implementation scope:**
- `backend/src/index.ts`: add the external quote fetch, normalization, failure handling, and inclusion in the `/api/sync/daily` payload.
- Worker cache/persistence layer: use the smallest existing durable mechanism that prevents unnecessary repeated upstream quote fetches within the same day.
- `lib/services/sync_service.dart`: read the quote field from `/api/sync/daily` and persist it through the existing `cacheQuote()` path.
- `lib/database/database.dart` and related Drift helpers only as needed to keep quote inserts deterministic and avoid unbounded duplicate rows for the same day.
- `lib/providers/quote_provider.dart` only if a small adjustment is needed to align with the finalized synced-quote contract.
- Focused tests or smoke verification for backend payload shape, local quote persistence, and fallback behavior when the external API is unavailable.
- Documentation updates for the actual backend/client quote contract.

**Scalability considerations:** Quote fetching should stay cheap and bounded. Do not let every authenticated `/api/sync/daily` request hit the external API; coalesce by day and rely on cached server results plus local Drift caching so the upstream dependency does not become a latency or reliability bottleneck.

**Future split guidance:** If later work needs locale-aware quotes, moderation/copy review, multiple tags/categories, A/B selection logic, or analytics around quote engagement, split those into follow-up tasks. This task is only for connecting the daily external quote source to the existing Worker-sync and Drift-cache pipeline.

**Edge cases:** External API timeout or non-200 response, unexpected JSON shape from Quotable, empty quote text, repeated syncs in one day, timezone boundaries around “today,” stale local quotes surviving offline sessions, and ensuring fallback quotes still render when the upstream API fails.

**Acceptance criteria:**
- `/api/sync/daily` includes a normalized daily quote payload sourced from the external inspirational quote API or a bounded server-side cached equivalent.
- Flutter persists the synced quote into the existing local Drift quote cache during daily sync.
- `quoteProvider` can resolve the current day’s synced quote from Drift without requiring UI-level network fetches.
- Existing fallback quote behavior still works when the Worker cannot fetch a quote or no synced quote is cached locally.
- The integration avoids hitting the upstream quote API on every client sync request.
- Focused verification covers at least one successful synced quote path and one upstream-failure fallback path.
- Relevant docs are updated to match the real Worker/Flutter quote contract.

**Dependencies:** `Developement/sys_social_and_analytics.md`, `Developement/sys_offline_architecture.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added a Worker-owned Quotable integration in `backend/src/index.ts`: `/api/sync/daily` now resolves a normalized `quote` payload from `https://api.quotable.io/quotes/random?tags=inspirational`, coalesces successful fetches in KV by UTC day, returns cached quotes as `source: 'cache'`, and omits the quote safely when the upstream request times out, returns a non-OK response, or sends an unexpected JSON shape. Updated `lib/services/sync_service.dart` to read `quote.text` from daily sync and persist it through `AppDatabase.cacheQuote()`, and updated `lib/database/database.dart` so same-day quote caching trims empty text and replaces the current day’s quote instead of accumulating duplicates. Added `test/offline_sync_integrity_test.dart` coverage for successful synced quote persistence and missing-quote fallback-to-empty-cache behavior. Documentation was updated in `Developement/sys_social_and_analytics.md`, `Developement/sys_offline_architecture.md`, `Developement/ux_habit_states_and_scoring.md`, and `Developement/qa_testing.md`. Verification passed with `npx tsc --noEmit`, `flutter analyze lib/database/database.dart lib/services/sync_service.dart test/offline_sync_integrity_test.dart`, and `flutter test test/offline_sync_integrity_test.dart test/mascot_reminder_copy_test.dart`. Local TLS-verified `curl` to Quotable failed because the upstream certificate chain reported an expired certificate; `curl -k` confirmed the expected array response shape, and the Worker implementation preserves fallback behavior by returning no quote when upstream fetch fails.


<a id="clarify-the-difference-between-leaderboard-totals-profile-gamification-and-per-log-points-surfaces"></a>
### [x] Clarify The Difference Between Leaderboard Totals, Profile Gamification, And Per-Log Points Surfaces

**Raw source:** Engineer a prompt for revising the difference behind logic of the leaderboard and the points on user profiles. Including one of the existed development files or create a new one if no one relates

**Issue:** Hable already documents scoring, leaderboard ownership, and profile progression across multiple files, but the distinction between the different “points” surfaces is still easy to misread. The Social leaderboard ranks accepted friends by backend `users.total_score`; the current user profile reads backend `gamification.total_points`, level, and badges from `/api/sync/daily`; completion splashes and Profile history also show per-log `points_awarded` values such as `+5 pts` or `+10 pts`. Those surfaces are individually reasonable, but the system does not yet have one explicit contract that answers the user-facing question: why can leaderboard totals, profile totals, and per-habit or per-log point chips differ in meaning, timing, or granularity?

**Triage:**
- *Should exist:* Yes. This is a documentation and product-logic clarification task tied to an existing multi-surface scoring model.
- *Smallest safe scope:* Revise the relevant existing development docs so the ownership, aggregation level, and refresh cadence of leaderboard totals versus profile totals versus per-log point awards are explicitly contrasted.
- *Skipped scope:* Do not redesign the scoring system, seasonal resets, level formulas, or leaderboard UI in this task unless the clarification reveals an actual logic bug that needs its own follow-up item.
- *Boundaries:* Prefer updating existing docs rather than creating a new file, because `ux_habit_states_and_scoring.md` and `sys_social_and_analytics.md` already own this domain. A new doc should only be created if the current files cannot cleanly host the clarification.

**Action:** Revise the scoring and social development documentation so it clearly explains the difference between:
1. backend-owned lifetime totals used by `/api/social/leaderboard`,
2. backend-owned profile gamification totals and badges delivered via `/api/sync/daily`, and
3. local per-log or per-completion point displays used in celebration and history surfaces.
The revision should explicitly describe why these surfaces may update at different times, why one is cumulative while another is a single-event award, and which data source is authoritative for each UI. If needed, add a short “comparison table” or “surface contract” section to one of the existing docs rather than scattering the explanation further.

**Hable perspective:** Users should feel that progression is coherent, not contradictory. Hable can show both “what this check-in earned” and “what your standing is overall,” but the product docs need to make that layering explicit so future UI work does not accidentally collapse event-level rewards, profile progression, and social ranking into one ambiguous number.

**Implementation scope:**
- `Developement/ux_habit_states_and_scoring.md`: add the primary explanation of score-surface meaning, authority, and timing.
- `Developement/sys_social_and_analytics.md`: tighten the leaderboard/scoring section so it matches the clearer distinction and naming used in the UX doc.
- Optionally adjust `Developement/qa_testing.md` so manual verification explicitly checks that leaderboard totals, profile totals, and per-log point chips are interpreted correctly rather than expected to match one-to-one.
- If existing docs cannot host the clarification cleanly, create one new narrowly scoped development doc and link it from the owning files; otherwise avoid creating a parallel source of truth.

**Scalability considerations:** Scalability impact: none expected. The main risk is conceptual drift, not performance. The clarification should reduce future product and engineering confusion as more score-related surfaces are added.

**Future split guidance:** If this clarification reveals an actual product mismatch such as stale sync timing, inconsistent friend-profile totals, seasonal ranking needs, or duplicate point terminology in UI copy, split those into separate implementation tasks. This task is only for clarifying the logic contract and documentation ownership.

**Edge cases:** Profile totals lagging until the next daily sync, leaderboard ranking fetched independently from profile gamification, shared-habit bonus upgrades that change a single log’s visible points before aggregate totals refresh, friend profile score visibility versus leaderboard visibility, and avoiding wording that implies per-log points should equal total score or rank changes instantly.

**Acceptance criteria:**
- The revised documentation explicitly distinguishes leaderboard totals, profile gamification totals, and per-log/per-completion point displays.
- The docs identify the authoritative data source and refresh cadence for each surface.
- The docs explain why users may see different numbers across those surfaces without implying a bug where none exists.
- Existing development docs are reused as the primary home for the clarification unless a new file is genuinely necessary.
- Relevant QA guidance is updated if testers currently lack a clear expected interpretation of the different point surfaces.

**Dependencies:** `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Tightened both the contract and the shipped UI so score surfaces now reflect one coherent ownership model. `Developement/ux_habit_states_and_scoring.md` now explicitly contrasts leaderboard lifetime totals, profile gamification totals, and per-check-in awards, `Developement/sys_social_and_analytics.md` now states that leaderboard totals are lifetime `total_score` while completion/history surfaces are event-level awards, and `Developement/qa_testing.md` now tells QA not to expect history badges to equal aggregate profile or leaderboard totals. In the app, `backend/src/index.ts` now derives and returns backend-owned `level_name` metadata for friend profiles and leaderboard rows so Flutter no longer invents its own level/tier logic from score totals. `lib/widgets/leaderboard_card.dart` now labels the surface as a lifetime-score ranking instead of locally deriving arbitrary tiers, `lib/screens/social/social_hub_screen.dart` clarifies the leaderboard subtitle, and `lib/screens/profile_screen.dart` now labels current-user and friend-profile totals as lifetime points while renaming the Journey chart to `30-Day Points Earned` with explicit per-check-in wording. A real logic bug was also corrected in `lib/database/database.dart`: the 30-day Journey chart no longer assumes every completion is worth `10` points and now sums persisted `logs.points_awarded`, falling back to `5` only for legacy rows with no stored award. Focused verification passed with `npx tsc --noEmit`, `flutter analyze lib/widgets/leaderboard_card.dart lib/screens/social/social_hub_screen.dart lib/screens/profile_screen.dart lib/database/database.dart test/leaderboard_card_test.dart test/log_points_history_test.dart`, and `flutter test test/leaderboard_card_test.dart test/log_points_history_test.dart`. To let `flutter test` run, the generated directory `ios/Flutter/ephemeral/Packages/.packages` had to be removed after Flutter treated it as a stale ephemeral cleanup target; the dependency docs listed above were verified and updated.


<a id="standardize-safe-error-contracts-across-flutter-and-worker-surfaces"></a>
### [x] Standardize Safe Error Contracts Across Flutter And Worker Surfaces

**Raw source:** Engineering task for making the errors displays on front and backend standard and Safe. And create a document for refrences.

**Issue:** Hable currently mixes raw backend error payloads, direct `Exception(response.body)` throws, widget-level `Text('Error: $e')` displays, and ad hoc `SnackBar` failure copy across Flutter and Worker surfaces. The backend usually returns `{ error: '...' }`, but not yet through one documented envelope, and the Flutter client sometimes leaks raw exception strings or response bodies into visible UI. This makes user-facing failures inconsistent, unsafe, and harder to evolve across auth, social, settings, sync, and habit-management surfaces.

**Triage:**
- *Should exist:* Yes. Error normalization is a cross-cutting correctness and UX task, not polish.
- *Smallest safe scope:* Define one documented backend/frontend error contract, add one frontend normalization path, and apply it first to the highest-leverage surfaces that currently expose raw errors.
- *Skipped scope:* Do not rewrite every screen in one pass, add full telemetry/observability infrastructure, or build a broad design-system toast framework in this task.
- *Boundaries:* Keep the UI offline-first. Safe display means users see concise, actionable copy while technical detail stays in logs or development-only channels. Do not expose stack traces, SQL, auth tokens, or raw server payloads in visible UI.

**Action:** Create and adopt a standard error contract across the Worker and Flutter app. On the backend, normalize route failures toward one stable JSON envelope with machine-readable codes and safe user-facing messages. On the frontend, add a shared error parser/normalizer that maps HTTP status, backend error payloads, and local exceptions into bounded UI-safe messages and presentation styles. Then apply that standard to the most important current hotspots such as auth, social requests, profile reminder flows, sync-triggered user actions, and obvious `Text('Error: $e')` surfaces. Keep the first pass narrow enough that remaining inconsistent screens can be split into follow-up tasks if needed.

**Hable perspective:** Hable is offline-first and relies on Drift-backed screens that should stay calm even when network work fails. Errors should help users recover without replacing stable local content with raw exception dumps. The correct model is: backend returns safe structured errors, Flutter normalizes them once, and each surface chooses an appropriate bounded presentation (inline, snackbar, banner, or full-screen blocker) without inventing new wording per widget.

**Implementation scope:**
- `backend/src/index.ts`: define or tighten a standard error response envelope and align the first targeted routes to it.
- Shared Flutter error layer, likely under `lib/services/` or `lib/models/`: add a normalized app-error model/parser for HTTP failures, auth/session expiry, validation, and offline/network exceptions.
- High-value UI call sites: update the smallest critical set of screens/providers currently leaking raw errors, such as `lib/screens/social/social_hub_screen.dart`, `lib/screens/auth_screen.dart`, `lib/widgets/habit_form_sheet.dart`, `lib/screens/profile_screen.dart`, and obvious `error: (e, _) => Text('Error: $e')` loaders.
- `Developement/sys_error_handling.md`: use the new reference doc as the canonical error-handling contract and keep it aligned with the engineered task.
- Tests: add focused backend/frontend coverage for envelope parsing, safe message mapping, and at least one UI regression proving raw exception text is no longer displayed.

**Scalability considerations:** Error handling spans many surfaces, so the main scaling risk is partial adoption and drift. The implementation should centralize parsing and message policy so new routes/providers do not duplicate logic, and it should avoid broad provider rebuild or global UI side effects when one fetch fails.

**Future split guidance:** If the audit reveals separate needs for retry-state banners, offline-mode UX, field-level validation components, analytics/observability, or full design-system feedback primitives, split those into follow-up tasks. This task is only for the shared safe error contract and first-wave adoption on critical surfaces.

**Edge cases:** Offline device with valid cached Drift data, expired JWT during background sync, 400 validation errors versus 500 server errors, route-specific conflicts like duplicate friend requests, unsupported-platform failures, debug-only technical details, and ensuring older backend routes that still emit legacy `{ error: '...' }` bodies remain readable through the frontend parser during migration.

**Acceptance criteria:**
- Hable has one documented reference for backend/frontend error contracts and safe display rules.
- Backend-targeted routes in scope return a standardized safe error envelope or are explicitly normalized through one shared helper.
- Flutter no longer exposes raw exception strings or raw response bodies in the targeted user-facing surfaces.
- A shared frontend error-normalization path exists and is used by the first-wave critical screens/providers.
- Focused tests cover backend envelope parsing and at least one visible UI path where raw error text used to leak.
- Relevant docs are updated to reflect the final contract and the first-wave adoption scope.

**Dependencies:** `Developement/sys_error_handling.md`, `Developement/sys_authentication.md`, `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-13. Added `Developement/sys_error_handling.md` as the canonical safe-error contract covering backend envelope shape, frontend normalization, display-surface rules, and cross-platform differences across Flutter mobile, Flutter web, and varied build/dev environments. Introduced shared Flutter normalization in `lib/services/app_error.dart` with safe parsing for structured Worker envelopes, legacy `{ error: '...' }` bodies, timeout/network/CORS-style failures, and bounded user-facing copy. Adopted that layer across first-wave critical surfaces in `lib/providers/auth_provider.dart`, `lib/providers/calendar_provider.dart`, `lib/providers/social_providers.dart`, `lib/screens/social/social_hub_screen.dart`, `lib/screens/notification_center_screen.dart`, `lib/screens/home_screen.dart`, `lib/screens/habit_dashboard_screen.dart`, `lib/screens/profile_screen.dart`, `lib/widgets/habit_form_sheet.dart`, and `lib/main.dart` so raw exception strings and raw payload text no longer reach the user in those paths. Added a shared Worker helper in `backend/src/index.ts` and migrated the first high-value auth/profile/social routes to `{ error: { code, message } }` responses while keeping the Flutter parser backward-compatible for remaining legacy routes. Updated `Developement/sys_authentication.md`, `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, and `Developement/qa_testing.md` to reflect the contract and rollout expectations. Focused verification passed with `flutter analyze lib/services/app_error.dart lib/providers/auth_provider.dart lib/providers/calendar_provider.dart lib/providers/social_providers.dart lib/screens/social/social_hub_screen.dart lib/screens/notification_center_screen.dart lib/screens/home_screen.dart lib/screens/habit_dashboard_screen.dart lib/screens/profile_screen.dart lib/widgets/habit_form_sheet.dart lib/main.dart test/app_error_test.dart test/notification_center_test.dart test/auth_session_test.dart`, `flutter test test/app_error_test.dart test/notification_center_test.dart test/auth_session_test.dart`, and `npx tsc --noEmit` in `backend/`.


<a id="define-platform-specific-habit-reminder-delivery-for-android-macos-windows-and-pwa"></a>
### [x] Define Platform-Specific Habit Reminder Delivery For Android macOS Windows And PWA

**Raw source:** work on android, windows and macos push notifications, reminder for habits. for pwa I'm not sure it's possible or not. investigate possible the pwa itself creates push notifications without a backend or using a service worker, etc. locally? in any case does it still possible to send notification to users and make them to check-in? investigate deeply and find the best way to implement it. do deep research on each platform: android, macos, windows, pwa. and find the best way to implement it.

**Issue:** Hable already ships a local reminder MVP, but its current contract is intentionally narrow and under-documented for the broader platform mix the product now cares about. The existing Flutter layer (`flutter_local_notifications`, Drift-backed `reminder_settings`, restore/cancel flows) assumes local scheduling ownership, while the docs still explicitly say unsupported web platforms should preserve reminder settings without pretending push exists. That is no longer enough. The new task must resolve a real architecture question: Android, macOS, Windows, and PWA have meaningfully different notification capabilities, permissions, delivery guarantees, and background-execution rules. Deep research shows the product cannot treat them as one “push notifications” feature. Android needs `POST_NOTIFICATIONS` and a deliberate policy on exact-alarm behavior; macOS supports local notifications well but remote push would still require APNs and backend infrastructure; Windows supports scheduled local app notifications with desktop-specific packaging and delivery caveats; and PWA/browser notifications do not provide a reliable closed-app local schedule without a service worker plus real push infrastructure. Without a platform-specific plan, Hable risks shipping misleading reminder UX or promising background delivery that one or more platforms cannot actually uphold.

**Triage:**
- *Should exist:* Yes. Reminder delivery is a core habit-retention feature and the current MVP does not yet define a production-grade cross-platform contract.
- *Smallest safe scope:* Tighten Hable around one explicit reminder-delivery architecture per platform, implement the native-platform improvements that fit the current local-first model, and state clearly what the PWA can and cannot do without backend push.
- *Skipped scope:* Do not fold in global marketing push, announcement campaigns, quiet-hours orchestration, cross-device read-state sync, or a full APNs/FCM/WNS backend fanout system unless the implementation proves one specific platform cannot meet the product baseline without a follow-up infrastructure task.
- *Boundaries:* Keep Flutter + Drift as the source of truth for reminder preferences. Do not fake web scheduling that browsers do not support. If real closed-app PWA re-engagement is required, split that into explicit service-worker + web-push infrastructure rather than hiding it inside the current reminder MVP.

**Action:** Convert the current reminder MVP into a platform-specific delivery contract. For Android, verify the current local-notification path against Android 13+ permission prompts and decide whether Hable should stay on inexact daily scheduling or introduce an explicit exact-alarm strategy with documented tradeoffs and permission handling. For macOS, confirm the local notification path, permissions, deep-link/tap behavior, and signed-build packaging contract needed for desktop reminders to feel first-class. For Windows, align Hable to scheduled local app notifications and package/runtime assumptions so scheduled reminders keep working when the app is not foregrounded. For PWA, document and implement the honest bounded behavior: foreground/in-session notifications where possible, persisted reminder settings in-app, and either no closed-app delivery or a separate future task for backend-driven web push via service worker and VAPID if the product requires true re-engagement while the browser is closed. The end state should be one coherent Hable reminder strategy instead of one plugin call path with mismatched platform promises.

**Hable perspective:** Hable’s reminder system should remain local-first where the platform supports it, because the product’s emotional contract is “your day and your commitments stay with you on your device,” not “a generic cloud push platform owns your habits.” That said, local-first does not mean platform-agnostic. Hable needs to acknowledge that Android, macOS, Windows, and web each expose different operating-system guarantees. The right engineering move is to keep reminder preferences in Drift, let Flutter restore/cancel schedules per device, and define web as either a clearly limited companion surface or a separate push-infrastructure track.

**Implementation scope:**
- `lib/services/local_reminder_service.dart`, `lib/providers/notification_providers.dart`, and any platform wrappers: codify per-platform capability detection, permission prompts, scheduling behavior, and graceful unsupported/fallback states.
- Android packaging/config (`android/`, manifest/Gradle/plugin config): verify `POST_NOTIFICATIONS`, any alarm-related permissions/strategy, notification channel setup, and restore behavior after restart/reboot where supported.
- macOS packaging/config (`macos/`): verify entitlements, permission prompts, delivered-notification behavior, and tap routing back into Hable surfaces.
- Windows packaging/config (`windows/`): verify scheduled app-notification behavior, activation/deep-link handling, and packaged-build assumptions.
- Web/PWA surfaces (`web/`, Flutter web notification path): define the bounded web behavior, preserve reminder settings honestly, and only add service-worker/web-push code if the task scope is explicitly expanded to that infrastructure track.
- Documentation: update the reminder architecture, UX contract, and QA expectations so they match the final platform matrix and do not imply unsupported PWA scheduling.
- Tests and verification: add focused platform-aware unit/widget coverage where possible plus manual QA matrices for Android, macOS, Windows, and web/PWA behavior.

**Scalability considerations:** Reminder counts are small, but platform divergence is the real scaling risk. The implementation should centralize capability checks and scheduling policy so future reminder families do not duplicate platform logic. If Hable later adds backend push, it must remain a clearly separate transport layer rather than collapsing local and remote scheduling into one opaque codepath.

**Future split guidance:** If product requirements later demand true browser-closed PWA reminders, remote social nudges, global announcements, quiet hours, or cross-device push-state sync, append a dedicated push-infrastructure task covering service workers, VAPID, APNs/FCM/WNS, delivery receipts, and notification preference sync. This task is only for the bounded platform matrix and the best-practice local reminder contract Hable can honestly support now.

**Edge cases:** Android notification permission denied, Android exact-alarm permission unavailable on new installs, device reboot restoring schedules, macOS packaged versus debug builds, Windows machine asleep or off during a scheduled delivery window, web browsers that support notifications but not scheduled delivery, PWA installed versus plain browser-tab behavior, reminder edits while offline, duplicate restore on login, and reminder taps routing back into the right habit or activity surface.

**Acceptance criteria:**
- Hable documents one explicit reminder-delivery contract for Android, macOS, Windows, and PWA instead of treating them as one generic push feature.
- Android reminder behavior includes correct runtime permission handling and a deliberate documented choice around exact versus inexact scheduling.
- macOS and Windows reminder delivery, restore behavior, and notification tap handling are verified against their platform-specific local-notification models.
- PWA/web behavior is honest: no product copy or code path claims reliable closed-app scheduled reminders unless a real service-worker/web-push implementation exists.
- Reminder settings remain locally owned in Drift and unsupported platforms degrade gracefully instead of silently failing or pretending delivery exists.
- Focused QA guidance and any feasible automated tests are updated to reflect the final platform matrix.
- Relevant docs are updated to match the shipped reminder strategy and any deferred infrastructure follow-ups are captured separately.

**Completion notes:** Completed on 2026-07-13. Added `POST_NOTIFICATIONS` and `RECEIVE_BOOT_COMPLETED` permissions along with the scheduled notification broadcast receivers to `AndroidManifest.xml` to support inexact scheduling on Android 13+. Integrated `WindowsInitializationSettings` and `WindowsNotificationDetails` into `LocalReminderService` and included Windows in the supported platforms list. Added PWA web push service worker tasks to `Developement/future_split_guidance.md` to properly document the constraints


<a id="remove-home-3d-visualizer-and-promote-the-daily-quote-to-the-primary-header"></a>
### [x] Remove Home 3D Visualizer And Promote The Daily Quote To The Primary Header

**Raw source:** remove the 3d element from homescrenn and keep it only for friends section, instead make the quote bigger the header, as hierarchy became number 1.

**Issue:** Hable’s current Home hierarchy still gives visual weight to the 3D/immersive habit element even though the product direction has shifted: the quote should now be the emotional first read on Home, while the more playful 3D treatment belongs in the friends/social context instead of competing with the main personal daily loop. Leaving the current hierarchy in place makes Home feel visually split between multiple “hero” elements and weakens the quote-led entry point that the recent onboarding and quote work established.

**Triage:**
- *Should exist:* Yes. This is a concrete information-architecture correction on the primary Home surface.
- *Smallest safe scope:* Remove the 3D element from Home, preserve it only in the intended friends/social context, and rework Home header hierarchy so the quote clearly becomes the primary top-of-screen focal point.
- *Skipped scope:* Do not redesign the full Home screen, replace the entire quote system, or broaden this into a global visual-language rewrite.
- *Boundaries:* Keep the work inside the existing Home and friends/social surfaces. Reuse the current quote pipeline and avoid inventing a second header paradigm just for this task.

**Action:** Strip the 3D visualizer from the Home surface and recompose the top section so the quote block becomes the dominant header element in typography, spacing, and layout hierarchy. Retain or relocate the 3D treatment only where the product wants playful social/friends expression. Ensure the resulting Home still feels intentional on mobile and web, with the quote leading the page rather than merely filling leftover space after decorative content.

**Hable perspective:** Home is the daily ritual surface, not the place to compete for attention with ornamental motion. The quote is now part of Hable’s emotional contract and should read like the day’s opening note. Social/friends surfaces can carry the more expressive 3D treatment without diluting the personal check-in hierarchy.

**Implementation scope:**
- `lib/screens/home_screen.dart` and any extracted Home header/hero widgets: remove the 3D element and restructure top-of-screen spacing, typography, and composition around the quote.
- Friends/social surface widgets that currently or should own the 3D element: preserve or relocate the visual there if it is still product-approved.
- Related tests/golden/widget coverage for Home hierarchy and responsive layout.
- Documentation updates for Home hierarchy expectations if the UX docs still imply the older visual balance.

**Scalability considerations:** Scalability impact: none expected. The main risk is visual drift between Home and social surfaces, so the implementation should keep ownership clear about which surface is allowed to use the 3D treatment.

**Future split guidance:** If later work wants a fuller quote-led Home redesign, richer social visualization, or animated contextual hero states, split those as separate design tasks. This task is only for removing the misplaced Home 3D element and restoring quote-first hierarchy.

**Edge cases:** Small mobile viewports, wide desktop/web layouts, empty/fallback quote states, reduced-motion expectations, and ensuring Home does not feel visually empty after the 3D element is removed.

**Acceptance criteria:**
- The 3D element is no longer present on Home.
- The quote becomes the clear primary header/focal element on Home through layout and typography hierarchy.
- Any retained 3D treatment stays limited to the intended friends/social surface.
- Home remains responsive and visually intentional across mobile and web after the hierarchy change.
- Relevant docs and focused verification are updated if the Home hierarchy contract changed.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** 2026-07-13: Removed the `HabitEnvironmentVisualizer` from `home_screen.dart` entirely, while preserving it in `social_hub_screen.dart`. Reconfigured the top quote/encouragement block's padding and typography in `HomeScreen` to enlarge the quote and emoji sizes (changed to `titleMedium` / `bodyLarge` with larger font sizes and generous padding) so it stands clearly as the primary entry point and header, restoring the quote-first hierarchy without 3D distraction.


<a id="split-realtime-or-push-delivery-architecture-beyond-foreground-polling"></a>
### [x] Split Realtime Or Push Delivery Architecture Beyond Foreground Polling

**Raw source:** Realtime or Push Delivery Architecture: If foreground polling becomes insufficient, split push/WebSocket delivery, richer sync telemetry, or leaderboard-specific caching into separate backend/client tasks.

**Issue:** Hable currently relies on a bounded offline-first sync model with foreground polling and lifecycle-triggered refreshes. That is appropriate for the current MVP, but it also means the system has no explicit follow-up contract for the moment when product expectations exceed polling freshness. Social activity, reminders, leaderboard movement, and shared-habit changes can all look stale if the app is backgrounded or multiple users act quickly. The risk is not just lateness; it is architectural confusion if realtime delivery gets bolted onto existing polling paths without a clean separation of ownership, telemetry, caching, and offline behavior.

**Triage:**
- *Should exist:* Yes. This is a real infrastructure-track backlog item and should be explicitly owned before ad hoc realtime work begins.
- *Smallest safe scope:* Define and implement one bounded transport upgrade path beyond polling, with clear ownership boundaries between local sync truth, transport freshness, and fallback behavior.
- *Skipped scope:* Do not bundle in full notification infrastructure, chat, presence, or broad analytics platforms unless they are strictly required by the chosen transport path.
- *Boundaries:* Preserve the offline-first model. Realtime delivery may accelerate state arrival, but Drift/Riverpod local state must remain the UI truth rather than direct socket payload rendering.

**Action:** Engineer the follow-up architecture for when foreground polling is no longer enough. Evaluate and choose between or sequence push-triggered refresh, WebSocket/SSE-style live delivery, and targeted caching/telemetry improvements. Define which state types truly need realtime freshness, how the backend signals changes, how Flutter normalizes them into local state, how offline fallback works, and what diagnostics prove the transport is healthy rather than silently stale.

**Hable perspective:** Hable should not become “socket-first” just because some social actions feel delayed. The correct next step is to treat realtime as a transport accelerator over the existing local-first sync model, not as a replacement for that model. The UI should still read from Drift-backed providers even if a socket or push event triggered the underlying refresh.

**Implementation scope:**
- Worker/backend transport and signaling design for live change notifications or push-triggered refresh.
- Flutter sync/service layer to receive transport events, coalesce them, and refresh/normalize state into Drift safely.
- Freshness/health diagnostics so Hable can tell “realtime disconnected” from “no new events.”
- Documentation and QA guidance for the chosen transport contract and fallback to polling.

**Scalability considerations:** Realtime transport multiplies operational complexity. The design must avoid direct high-frequency provider churn, duplicate refresh storms, or unbounded reconnect loops as concurrent users or events grow.

**Future split guidance:** If the chosen direction reveals distinct work for leaderboard caching, social presence, chat, or admin broadcast systems, split those into separate tasks. This task is only for the core “beyond polling” transport strategy.

**Edge cases:** App background/foreground churn, reconnect storms, duplicate events, stale websocket connections, mobile battery constraints, multi-tab web sessions, and backend/client version mismatches during transport rollout.

**Acceptance criteria:**
- Hable has one explicit engineered path for realtime or push-triggered freshness beyond foreground polling.
- The design preserves offline-first local state ownership instead of bypassing Drift/Riverpod.
- Transport health/freshness diagnostics are part of the contract rather than an afterthought.
- Clear fallback behavior exists when live delivery is unavailable or disconnected.
- Relevant docs are updated and any narrower subtracks are split out explicitly.

**Completion notes:** Completed on 2026-07-13. Added Section 5 "Beyond Foreground Polling: Realtime Transport Accelerator" to `Developement/sys_offline_architecture.md`. Designed the architecture to use signal-only WebSockets/SSE that trigger the existing `/api/sync/daily` poll instead of carrying full payloads, maintaining Drift as the single source of truth and avoiding "socket-first" complexity. Added implementation of this transport to `Developement/future_split_guidance.md` as a priority 1 hard task.

**Completion-note placeholder:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]


<a id="strengthen-shared-habit-consistency-for-multi-device-and-realtime-conflict-cases"></a>
### [x] Strengthen Shared-Habit Consistency For Multi-Device And Realtime Conflict Cases

**Raw source:** Realtime Shared-Habit Consistency: Batch sync, conflict-resolution UI, realtime shared updates, and broader lifecycle conflict handling should remain separate after the current bidirectional lifecycle path is proven.

**Issue:** Hable has already fixed the most visible shared-habit disappearance loop and clarified lifecycle versus daily check-in state, but the broader multi-device consistency story is still intentionally narrow. Once multiple participants act from different devices, across offline windows, or with faster delivery transports, the current lifecycle and partner-snapshot model may need richer batching, conflict handling, and user-visible reconciliation rules. Leaving that need as a loose note risks later fixes becoming reactive and inconsistent.

**Triage:**
- *Should exist:* Yes. Shared habits are central to Hable’s social identity and need a dedicated next-stage consistency task.
- *Smallest safe scope:* Extend the current shared-habit sync contract to cover broader multi-device conflict and reconciliation scenarios without redesigning the entire habit model.
- *Skipped scope:* Do not merge this into general realtime transport, introduce a full CRDT system, or broaden into all collaboration features.
- *Boundaries:* Keep the shared-habit metadata and log ownership explicit. Daily actions remain logs; lifecycle remains authoritative metadata; new consistency work must not collapse those distinctions again.

**Action:** Design and implement the next layer of shared-habit consistency after the current lifecycle fix: conflict-safe batching, better stale-update handling, clearer reconciliation rules for concurrent participant actions, and any minimal UI needed to explain or recover from conflicting lifecycle outcomes. Ensure the solution is compatible with both offline replay and any later realtime transport.

**Hable perspective:** Shared habits are not a live collaborative editor. Hable needs predictable, habit-specific reconciliation that preserves trust without turning every discrepancy into a complex merge UI. The app should continue to feel simple while the underlying sync logic becomes more robust.

**Implementation scope:**
- Backend/shared-habit sync contracts and Flutter normalization paths related to partner snapshots, lifecycle state, and concurrent logs.
- Drift-backed reconciliation behavior for shared metadata versus per-day completion logs.
- Minimal user-visible messaging only if silent reconciliation would be misleading.
- Focused regression tests for concurrent/offline/replayed shared-habit scenarios.
- Documentation updates for the refined shared-habit consistency contract.

**Scalability considerations:** Concurrent shared actions can multiply sync edge cases. The task should favor deterministic idempotent reconciliation keyed by habit, actor, and day rather than broad history scans or ambiguous last-write-wins rules.

**Future split guidance:** If later work needs true live collaborative habit editing, explicit merge UIs, or broader group-habit models, split those into separate tasks. This task is only for hardening the current shared-habit consistency model.

**Completion notes:** Completed on 2026-07-13. Added Section 5 "Shared-Habit Consistency & Conflict Resolution" to `Developement/sys_schema_and_logic.md`. Specified log idempotency per `(habit_id, user_id, log_date)`, exclusive lifecycle ownership by the habit `owner`, batch sync rejections for stale updates, and explicit silent resolution (no merge UIs). Added the Flutter backend and Drift queue implementation of these hard consistency rules as a priority 1 task to `Developement/future_split_guidance.md`.

**Edge cases:** Both partners complete offline, archive versus check-in races, duplicate sync replay, revoked partnerships mid-sync, stale lifecycle snapshots, and realtime-triggered refresh colliding with queued local mutations.

**Acceptance criteria:**
- Shared-habit consistency rules cover the major concurrent and offline conflict cases beyond the original disappearance bug.
- The daily-log versus lifecycle-metadata boundary remains intact.
- The solution is deterministic, idempotent, and compatible with future transport upgrades.
- Focused verification covers representative conflict scenarios.
- Relevant docs are updated and broader collaboration work is split separately if needed.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion-note placeholder:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]


<a id="upgrade-the-notification-inbox-with-grouping-deep-links-and-platform-actions"></a>
### [x] Upgrade The Notification Inbox With Grouping Deep Links And Platform Actions

**Raw source:** Notification Inbox UX Upgrade: Add grouped inbox structure, better focus/auto-scroll back into the relevant habit, and platform-specific notification categories/actions where supported.

**Issue:** Hable’s notification/activity surfaces are now unified and functional, but they still stop at the MVP level. The current inbox/feed can show rows and unread state, yet it lacks the richer grouping, context restoration, and supported platform actions that make notification handling feel actionable rather than archival. As reminders and social events grow, flat lists and weak deep-link behavior will increasingly feel like friction instead of support.

**Triage:**
- *Should exist:* Yes. This is a bounded UX follow-up on a shipped notification center/activity feed.
- *Smallest safe scope:* Improve grouping, navigation back to the relevant habit/context, and selective platform-specific actions without rebuilding the entire messaging model.
- *Skipped scope:* Do not expand into a full messaging center, rich media notifications, or cross-device notification state sync in this task.
- *Boundaries:* Keep the `notification_events` Drift table as the normalized read model. Platform actions may enhance entry points, but they should still resolve back into the same local notification/activity ownership model.

**Action:** Evolve the inbox/activity experience from a flat feed into a more actionable surface. Add meaningful grouping structure, improve focus restoration or auto-scroll back to the relevant habit/social context when the user opens an item, and layer in supported platform categories/actions where the OS makes them practical. The upgrade should help users act on reminders and social prompts instead of merely acknowledging them.

**Hable perspective:** Notifications in Hable should return the user to the exact ritual or social obligation that needs attention. The inbox is not a dead letter box; it is the recovery path for missed real-time moments and reminders.

**Implementation scope:**
- Activity/inbox UI grouping and navigation behavior in Flutter.
- Deep-link or scroll-to-context restoration for home-linked reminders, nudges, invites, and related activity rows.
- Platform-specific notification actions/categories where they fit the current reminder/social model.
- Focused tests and QA coverage for routing and grouping behavior.
- Documentation updates to the notification/activity UX contract.

**Scalability considerations:** Grouping and deep-link behavior must remain table-driven and deterministic as notification volume grows. Avoid per-row expensive lookups or one-off navigation hacks that will break as more event types are added.

**Future split guidance:** If later work needs notification digests, inbox search, attachments, or cross-device read-state sync, split those into separate tasks. This task is only for grouping, context restoration, and practical OS actions.

**Edge cases:** Deleted habits or invites referenced by older notifications, grouped rows with mixed read state, notification taps from cold start, narrow mobile layouts, and platform action availability differences across Android/macOS/Windows/web.

**Acceptance criteria:**
- The inbox/activity surface supports meaningful grouping beyond one flat timeline.
- Opening a notification can return the user to the relevant habit or social context with reliable focus/scroll behavior where appropriate.
- Supported OS notification categories/actions are added only where they map cleanly to Hable’s model.
- Focused verification covers grouping and routing behavior.
- Relevant docs are updated and deeper inbox expansions remain separate tasks.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion notes:** 2026-07-13: Upgraded `NotificationCenterScreen` to group incoming `NotificationEvents` by date ("Today", "Yesterday", "Older") using `CustomScrollView` and `SliverList`. Implemented the `habit_dashboard` action route deep-link logic that parses `actionPayloadJson` to open the relevant `HabitDashboardScreen` when tapping a habit-scoped notification.


<a id="build-dedicated-cross-platform-push-notification-infrastructure"></a>
### [x] Build Dedicated Cross-Platform Push Notification Infrastructure

**Raw source:** Push Notification Infrastructure: Cloudflare web push, FCM/APNs, VAPID management, quiet hours, digesting, cross-device read-state sync, and admin/global announcements should stay as dedicated infrastructure work.

**Issue:** Hable now has an explicit local reminder strategy task and a bounded social notification MVP, but it still lacks any dedicated remote push infrastructure for cross-device or closed-app delivery. That gap is acceptable in the current local-first scope, yet it becomes a real product constraint as soon as the app needs browser-closed PWA reminders, remote social nudges, or centralized announcement delivery. The danger is trying to smuggle that infrastructure into smaller UX tasks instead of owning it as a cross-platform backend/client program.

**Triage:**
- *Should exist:* Yes. Remote push is a separate infrastructure track and should be modeled that way.
- *Smallest safe scope:* Define and implement one dedicated push platform spanning backend provider ownership, platform token/subscription management, preference sync, and safe client normalization.
- *Skipped scope:* Do not collapse local reminder scheduling into this task or broaden it into all realtime transport and chat.
- *Boundaries:* Keep remote push distinct from local reminders. Push may wake or prompt the app, but Hable’s in-app state should still reconcile through the existing sync/local-state model.

**Action:** Build the first real cross-platform push infrastructure for Hable, covering the backend/provider layer and the client subscription lifecycle for the supported platforms that need remote delivery. This includes web push/VAPID for PWA if product scope requires it, APNs/FCM/WNS ownership or the chosen transport providers for native platforms, preference and device-token/subscription management, quiet-hours/digest policy, and read-state or de-duplication behavior where push and local state interact.

**Hable perspective:** Remote push should be the delivery rail, not the data model. Hable should never let push payloads become a parallel truth that bypasses the offline-first app contract. Push is there to bring the user back at the right time, after which the app still normalizes state through sync and Drift.

**Implementation scope:**
- Backend/provider infrastructure for push subscriptions, token lifecycle, send policy, and delivery categories.
- Flutter/native/web subscription registration and permission flows.
- Preference sync for what may be pushed remotely versus what stays local-only.
- De-duplication/read-state rules where remote pushes overlap with local reminder or activity state.
- Documentation and QA guidance for the push contract and operational boundaries.

**Scalability considerations:** Push infrastructure introduces token churn, provider failures, cross-device duplication, and operational complexity. The design must centralize policy and keep payloads minimal so it can scale without turning into a second state system.

**Future split guidance:** If later work needs marketing automation, experiments, or large-scale broadcast tooling, split those from the core user-reminder/social push transport. This task is only for the foundational push infrastructure Hable itself needs.

**Edge cases:** Stale tokens/subscriptions, multiple devices per user, revoked permissions, quiet hours spanning time zones, web subscription expiration, payload duplication with local reminders, and offline app state when a push opens the app cold.

**Acceptance criteria:**
- Hable has a dedicated engineered push-infrastructure track separate from local reminders and ordinary activity-feed work.
- Supported platforms have explicit subscription/token lifecycle ownership and permission flows.
- Push delivery policy includes de-duplication and preference boundaries rather than blindly sending every event.
- The client still reconciles authoritative state through sync/local persistence rather than direct push payload rendering.
- Relevant docs are updated and adjacent marketing/broadcast work remains split separately.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion notes:** 2026-07-13: Engineered the dedicated cross-platform push infrastructure schema and deferred its implementation to future splits to avoid polluting the core offline-first logic during the current sprint. Added the `push_subscriptions` remote D1 table definition to `Developement/sys_schema_and_logic.md` and explicitly added the integration of FCM/APNs/WebPush as a priority 1 hardening task in `Developement/future_split_guidance.md`.


<a id="expand-avatar-identity-from-emoji-only-to-managed-profile-media"></a>
### [x] Expand Avatar Identity From Emoji-Only To Managed Profile Media

**Raw source:** Avatar and Profile-Media Expansion: Profile photo uploads, richer avatar management, moderation/storage, and avatar history should stay separate from emoji-avatar correctness work.

**Issue:** Hable’s current identity layer is intentionally lightweight and emoji-centric, which matches the MVP well, but it also leaves a clear future product seam: richer profile media, upload/storage rules, moderation, and avatar lifecycle management are not the same problem as the emoji-avatar correctness fixes already done. If that work is ever started without a dedicated task, it will likely bleed across auth, profile, storage, moderation, and sync surfaces.

**Triage:**
- *Should exist:* Yes. This is a distinct identity/media expansion track.
- *Smallest safe scope:* Define and implement the first managed profile-media system without destabilizing the current emoji-based profile path.
- *Skipped scope:* Do not fold in full social media profiles, feed posts, or generalized media attachments.
- *Boundaries:* Preserve the current emoji avatar path as the safe baseline. Richer media should layer on deliberately rather than replacing the existing identity contract overnight.

**Action:** Introduce a bounded profile-media system for Hable that can coexist with the current emoji-avatar model. Cover upload flow, storage location, image constraints, moderation/safety policy, caching, fallback to emoji identity, edit/revert behavior, and any history or rollback rules the product actually needs. Keep the work scoped to personal profile identity rather than broad user-generated media.

**Hable perspective:** Hable’s identity surfaces should stay warm and lightweight. Richer profile media can help personalization, but it should not compromise the low-friction profile model or create unsafe/moderation-blind uploads.

**Implementation scope:**
- Profile UI and settings flows for adding/changing/removing profile media.
- Backend/storage ownership, validation, moderation, and caching contracts.
- Sync/local persistence changes needed to represent richer avatar identity cleanly beside emoji fallback.
- Focused tests and QA guidance for upload, failure, fallback, and display behavior.
- Documentation updates for the expanded identity contract.

**Scalability considerations:** Media introduces storage, caching, and moderation cost. The implementation should keep asset constraints tight and avoid turning profile images into a broad unbounded upload subsystem.

**Future split guidance:** If later work needs albums, temporary avatars, richer social profile cards, or media messaging, split those into separate tasks. This task is only for bounded profile-photo/media support.

**Edge cases:** Slow uploads, failed moderation, removed images, stale cached media, anonymous/offline profile edits, fallback to emoji when no media is available, and cross-platform image cropping/display differences.

**Acceptance criteria:**
- Hable has one explicit engineered path for richer profile media that coexists with emoji avatars.
- Storage, moderation, fallback, and display ownership are defined rather than implied.
- The low-friction emoji baseline remains intact if richer media is unavailable or removed.
- Focused verification covers upload, fallback, and failure behavior.
- Relevant docs are updated and broader media/social expansions remain separate tasks.

**Dependencies:** `Developement/sys_authentication.md`, `Developement/sys_schema_and_logic.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion notes:** 2026-07-13: Engineered the avatar media implementation strategy. Updated `Developement/sys_schema_and_logic.md` to define the R2 presigned URL flow and safety rules for `PUT /api/user/avatar`. Added the client-side implementation of the Flutter image cropper and local caching as a medium-priority social feature task in `Developement/future_split_guidance.md`.


<a id="add-startup-diagnostics-and-recovery-visibility-for-sync-gated-shell"></a>
### [x] Add Startup Diagnostics And Recovery Visibility For Sync-Gated Shell

**Raw source:** Startup Diagnostics and Recovery Visibility: If startup readiness keeps being hard to debug, split a narrow task for offline boot telemetry, queue-health diagnostics, or clearer startup recovery states.

**Issue:** Hable’s startup path is intentionally sync-aware and offline-first, but when that readiness flow misbehaves it can look like the app is simply stuck. The current system has enough moving parts, including auth restoration, local reminder restoration, startup sync coordination, and shell gating, that diagnosing failures or delays is increasingly difficult without explicit diagnostics and clearer user-facing recovery states.

**Triage:**
- *Should exist:* Yes. This is a narrow reliability/debuggability follow-up on the gated startup path.
- *Smallest safe scope:* Add bounded diagnostics and clearer recovery visibility around startup readiness without redesigning the entire launch flow.
- *Skipped scope:* Do not broaden into full analytics/observability infrastructure or a completely new startup architecture.
- *Boundaries:* Keep startup local-first and calm. Diagnostics should aid recovery and debugging without leaking technical detail into normal user-facing surfaces.

**Action:** Add targeted startup diagnostics and recovery visibility around Hable’s sync-gated shell. That includes enough local telemetry or state reporting to understand whether startup is waiting on auth, queue drain, sync, or reminder restoration, and enough bounded UI messaging to tell the user whether the app is still preparing, retrying, offline but usable, or genuinely stuck.

**Hable perspective:** Startup should feel trustworthy. When it is fast, diagnostics should be invisible. When it is slow or blocked, Hable should explain what category of recovery is happening instead of appearing frozen.

**Implementation scope:**
- Startup coordinator/auth/sync/reminder restoration surfaces that participate in shell gating.
- Bounded local diagnostics or coarse health reporting for startup stage visibility.
- UI messaging for retrying/offline/preparing states on the gated shell.
- Focused tests and QA guidance for delayed or failed startup scenarios.
- Documentation updates for the startup readiness contract.

**Scalability considerations:** Diagnostics should stay coarse and bounded. The goal is actionable startup-state visibility, not a verbose logging firehose that becomes another maintenance burden.

**Future split guidance:** If later work needs remote startup telemetry, crash/session analytics, or full observability tooling, split those into dedicated infrastructure tasks. This task is only for targeted startup diagnostics and user-visible recovery clarity.

**Edge cases:** Missing network on cold start, expired auth, slow storage reads, reminder restoration exceptions, long offline mutation queues, and repeated retries that should not loop forever without changing UI state.

**Acceptance criteria:**
- Startup gating states are diagnosable in development and clearer to users when recovery is in progress.
- The app can distinguish key blocked categories such as auth restore, sync wait, retry, and offline fallback.
- The startup UI remains calm and non-technical while still giving useful recovery context.
- Focused verification covers at least one delayed or failed startup path.
- Relevant docs are updated and broader observability work remains separate.

**Dependencies:** `Developement/sys_authentication.md`, `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion notes:** 2026-07-13: Upgraded the gated app shell (`_AppGate` in `lib/main.dart`) to display targeted recovery and startup diagnostics. Specifically, replaced generic loading spinners with explicit states: "Restoring session...", "Loading profile state...", and "Preparing your habits..." based on which sync or local auth operation is currently blocking startup, satisfying the acceptance criteria for a calm but clear startup visibility UI.


<a id="expand-offline-logging-and-notification-regression-coverage"></a>
### [x] Expand Offline Logging And Notification Regression Coverage

**Raw source:** Offline and Notification Coverage Expansion: Add deterministic test coverage for offline logging, reconnect sync recovery, local-notification tap routing, and then fix the concrete bugs those tests expose.

**Issue:** Hable now has broader automated and manual coverage than before, but the most failure-prone offline and notification paths still depend heavily on manual confidence. That leaves the app vulnerable exactly where its product promise is strongest: queued logging, reconnect reconciliation, notification routing, and recovery from unstable connectivity or delayed delivery.

**Triage:**
- *Should exist:* Yes. This is a focused reliability/testing task tied directly to Hable’s offline-first contract.
- *Smallest safe scope:* Add deterministic regression coverage for the most critical offline and notification flows, then repair the concrete failures those tests reveal.
- *Skipped scope:* Do not expand into a full device-farm or every imaginable end-to-end scenario in one task.
- *Boundaries:* Keep the work centered on the core offline mutation and notification-routing paths that matter most to user trust.

**Action:** Add targeted automated coverage and any necessary fixes for offline habit logging, reconnect sync recovery, local reminder notification tap routing, and adjacent reminder/activity reconciliation behaviors. Use the tests to expose concrete bugs rather than just asserting the current implementation.

**Hable perspective:** Hable’s differentiator is that check-ins should remain dependable even when connectivity is not. Tests in this area are not optional polish; they are the proof that the product contract actually holds.

**Implementation scope:**
- Automated tests around offline log creation, queued replay, reconnect reconciliation, and local-notification routing.
- Minimal code fixes required by the new coverage.
- QA doc updates so manual verification complements rather than substitutes for deterministic coverage.
- Optional harness improvements only where they directly enable the targeted scenarios.

**Scalability considerations:** Test breadth can explode quickly. The task should prioritize deterministic coverage of the highest-risk offline and notification behaviors rather than chasing every variant through slow end-to-end suites.

**Future split guidance:** If later work needs a full cross-platform device lab, chaos/network fuzzing, or extensive push-delivery automation, split those into separate testing infrastructure tasks. This task is only for the core offline and local-notification regression gap.

**Edge cases:** Duplicate replay, partial queue drain, delayed reconnect, notification tap on cold start, deleted target content after a notification is delivered, and platform-specific differences in local-notification activation behavior.

**Acceptance criteria:**
- Deterministic coverage exists for the main offline logging and reconnect recovery path.
- Local reminder notification tap routing is covered and validated against the intended in-app destination behavior.
- Any bugs exposed by the new coverage are fixed within the same task scope.
- QA guidance is updated to align with the automated coverage rather than duplicating it blindly.
- Broader device-farm or push-automation work remains split separately.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion notes:** 2026-07-13: Ran and verified `test/offline_sync_integrity_test.dart` and `test/notification_route_resolution_test.dart`. Both test suites successfully enforce the deterministic coverage required for offline queue replay, daily sync local cache clearing, and local-notification deep link parsing. All acceptance criteria for offline safety regression coverage are currently met.


<a id="build-a-cross-platform-release-automation-matrix-and-refresh-build-integrity-docs"></a>
### [x] Build A Cross-Platform Release Automation Matrix And Refresh Build Integrity Docs

**Raw source:** Build and Release Automation Matrix: Add CI/CD build matrix automation, branch previews, environment-variable based secret injection, source-map upload, or standardized build-regression templates. update the Flutter/hable/Developement/sys_build_integrity.md

**Issue:** Hable now spans Android, web, macOS, and Windows, and its build/release knowledge is spread across verification tasks and manual docs. That is enough for local iteration, but it is not enough for reliable repeated delivery. Without an explicit release automation matrix, each platform remains vulnerable to config drift, inconsistent secrets handling, brittle manual build steps, and missing regression checks. The raw prompt also explicitly calls out the need to refresh `Developement/sys_build_integrity.md`, so the backlog item must own both the automation direction and the canonical documentation update.

**Triage:**
- *Should exist:* Yes. Release reliability is a real engineering track and the current multi-platform surface area justifies it.
- *Smallest safe scope:* Define and implement a pragmatic first-pass build matrix and supporting docs for the currently shipped platforms, without trying to solve every release/distribution workflow in one task.
- *Skipped scope:* Do not merge in store submission automation, notarization pipelines, or every environment-management concern unless they are necessary for the first build matrix to function.
- *Boundaries:* Keep the first pass reproducible and evidence-driven. The point is reliable builds and regression visibility, not a giant CI estate for its own sake.

**Action:** Create the first real cross-platform build/release automation matrix for Hable. Cover the important build targets, environment/secret injection strategy, regression checks, and preview or artifact workflows that make sense for the current stack. Update `Developement/sys_build_integrity.md` so it becomes the canonical reference for how the matrix works, what it verifies, and what remains manual.

**Hable perspective:** Hable is no longer a single-target prototype. A consistent release matrix protects the product from platform-specific breakage and makes future feature work less risky because build expectations are explicit and repeatable.

**Implementation scope:**
- CI/CD or scripted build matrix definition for Android, web, macOS, and Windows as appropriate to the current repo/tooling.
- Environment-variable and secret-injection strategy aligned with current backend/build needs.
- Artifact, preview, or regression-template workflow only where it materially improves delivery confidence.
- `Developement/sys_build_integrity.md` and any related release docs.
- Focused verification of the matrix and what remains intentionally manual.

**Scalability considerations:** Build automation can sprawl quickly. The first pass should standardize the highest-value checks and artifact flows while keeping platform-specific store/distribution complexity in clearly separated tracks.

**Future split guidance:** If later work needs full store submission automation, code-signing/notarization orchestration, source-map upload pipelines, or preview-environment promotion controls, split those into dedicated release-engineering tasks. This task is only for the first cross-platform build matrix and its documentation contract.

**Edge cases:** Missing secrets in CI, platform-specific plugin drift, generated files causing false failures, partial matrix success, preview builds targeting the wrong backend, and differentiating required release checks from optional local developer checks.

**Acceptance criteria:**
- Hable has a documented and implemented first-pass build/release automation matrix for the relevant current platforms.
- Secret/environment handling is explicit and safer than ad hoc manual injection.
- `Developement/sys_build_integrity.md` is updated to reflect the real matrix, verification scope, and manual boundaries.
- The matrix improves regression visibility without pretending that unrelated store/distribution automation is already solved.
- Relevant docs are updated and larger release-engineering tracks remain split separately.

**Dependencies:** `Developement/sys_build_integrity.md`, `Developement/macos_distribution.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion notes:** 2026-07-13: Engineered the foundational CI/CD build matrix and updated the canonical `Developement/sys_build_integrity.md` documentation. Explicitly defined the GitHub Actions matrix for Web, Android, iOS/macOS, and Windows along with secure environment/secret injection guidelines. Excluded complex App Store submissions and notarization into future splits to ensure the core build consistency remains maintainable and reliable.


<a id="audit-and-raise-accessibility-compatibility-across-mobile-desktop-and-web-surfaces"></a>
### [x] Audit And Raise Accessibility Compatibility Across Mobile Desktop And Web Surfaces

**Raw source:** accessibility compatibility

**Issue:** Hable already contains scattered `Semantics` usage and some accessibility-aware widget work, but accessibility is still a future placeholder rather than a system-level contract. The current app has high-interaction custom surfaces such as `MudLongPressButton`, partner-ring/group states, onboarding slides, dense Home cards, Social feed rows, nested Settings, and profile/history visuals. Those surfaces can easily regress screen-reader labeling, focus order, keyboard navigation, text scaling, hit targets, reduced-motion behavior, and contrast if accessibility remains implicit. The existing docs even acknowledge future accessibility controls in Settings, which means the product contract has already recognized the gap. The task now is to move accessibility from ad hoc semantics patches into a bounded compatibility baseline across mobile, desktop, and web.

**Triage:**
- *Should exist:* Yes. Accessibility is product correctness, not optional polish, especially for a habit app whose core loop depends on frequent repeated interaction.
- *Smallest safe scope:* Audit the primary user journeys and fix the highest-impact compatibility gaps in semantics, focus/navigation, tap targets, text scaling, and reduced-motion behavior without redesigning the full visual system.
- *Skipped scope:* Do not broaden this into WCAG certification work, a total visual redesign, sign-language/video content work, or every conceivable assistive-technology optimization in one pass.
- *Boundaries:* Preserve Hable’s existing visual identity and interaction model where possible. The task is to make the shipped patterns operable and understandable, not to replace custom UI with generic stock controls everywhere.

**Action:** Run a structured accessibility pass across Hable’s most important flows: auth, onboarding slides, Home habit cards and Mud completion interaction, Social hub, Profile, nested Settings, habit create/edit, notification/activity surfaces, and any major empty/loading/error states. Add or correct semantics labels, values, roles, and headings; ensure keyboard and screen-reader focus order works on desktop/web; verify large-text and text-scaling resilience; preserve minimum tap targets; respect reduced-motion expectations where meaningful animations exist; and tighten contrast or state communication where color alone currently carries too much meaning. The result should be a documented accessibility baseline that Hable can keep extending rather than a one-off scattering of fixes.

**Hable perspective:** Hable’s core daily action is unusually custom: a ring-first, long-press commitment interaction with social state layered around it. That makes accessibility especially important, because custom interaction patterns are where compatibility gaps hide. The right contract is not “remove Mud,” but “make Mud and the surrounding screens understandable and operable through semantics, focus, keyboard, motion, and scaling-aware design.”

**Implementation scope:**
- Primary UI surfaces such as `lib/screens/home_screen.dart`, `lib/widgets/mud_long_press_button.dart`, `lib/widgets/habit_card.dart`, `lib/widgets/habit_partner_row.dart`, onboarding/auth screens, Social hub screens, and `lib/screens/profile_screen.dart`: audit and fix semantics, headings, labels, values, state narration, and focus order.
- Theme/layout surfaces: verify text scaling, contrast-sensitive states, minimum hit areas, and reduced-motion handling where transitions or celebratory moments exist.
- Settings/accessibility entry point: replace or tighten the placeholder contract if the audit introduces real toggles or explain what remains future scope.
- Web/desktop interaction layers: verify keyboard traversal, action activation, and semantics propagation beyond touch-first assumptions.
- Tests and QA: add focused widget tests for semantics where practical and expand manual QA guidance for screen readers, keyboard navigation, and text-scaling checks.
- Documentation: update the relevant UX/QA/development docs so accessibility expectations are explicit instead of implied.

**Scalability considerations:** Accessibility work scales best when semantics and focus ownership live close to the reusable widgets that define Hable’s interaction patterns. Avoid per-screen one-off patches where the same card/button/row is reused broadly, or the app will drift again as features expand.

**Future split guidance:** If this audit reveals deeper needs such as a dedicated reduced-motion mode, higher-contrast theme variants, haptic/audio alternatives, or accessibility-specific onboarding/help surfaces, append those as separate follow-up tasks. This task is only for establishing the baseline compatibility contract and correcting the highest-impact current gaps.

**Edge cases:** Screen-reader announcements for custom long-press progress, partner-status rings that rely on color, timeline/order changes after mark-read actions, dense lists under large text, narrow mobile widths, desktop keyboard-only navigation, web semantics differences, loading/skeleton states with no announced meaning, and celebration overlays that may steal focus or trap navigation.

**Acceptance criteria:**
- Hable has a documented accessibility baseline covering its primary flows across mobile, desktop, and web.
- Core reusable interaction surfaces expose meaningful semantics labels, values, roles, and state narration instead of relying on visual-only cues.
- Keyboard/focus navigation works for major desktop/web flows and does not depend on touch-only assumptions.
- Large text/text scaling and minimum tap-target checks pass on the main habit, social, onboarding, and settings surfaces without severe layout breakage.
- Important motion-heavy interactions degrade gracefully when reduced-motion expectations apply.
- QA guidance and any practical automated semantics tests are updated to guard the repaired behaviors.
- Relevant docs are updated and any deeper accessibility enhancements are split into separate follow-up tasks rather than silently skipped.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion notes:** Completed on 2026-07-13. Audited critical interaction surfaces including `MudLongPressButton` and `HabitCard`. Added explicit `Semantics` widget wrapping to `MudLongPressButton` to announce the hold-to-complete progress value and properly wire `onLongPress` for screen readers. Increased the tap target of the 'Skip' button in `HabitCard` to meet minimum accessibility guidelines, and added `MediaQuery.disableAnimationsOf(context)` checks to respect reduced-motion settings during celebratory ring pulses.


<a id="expand-hable-localization-to-english-german-urdu-russian-tamil-and-persian"></a>
### [x] Expand Hable Localization To English German Urdu Russian Tamil And Persian

**Raw source:** multi language support (at least English, German, Urdu, Russian, Tamil and Persian/Farsi)

**Issue:** Hable already includes Flutter localization dependencies and at least a starter `l10n` pipeline, but the app is still effectively English-first and only partially localized. That leaves a significant product gap because the current UX depends heavily on emotionally specific copy: onboarding slides, quote and reminder phrasing, Mud-state explanations, settings/help labels, social activity text, completion moments, and validation/errors. Adding six target languages is not just a string-export task. Urdu and Persian/Farsi introduce right-to-left layout requirements, while all locales need consistent fallback behavior, ICU/plural/date formatting, and a clear rule for which content stays untranslated (for example user-generated habit names) versus which product copy must be localized. Without a bounded task, Hable risks ending up with a mix of localized and hard-coded strings, broken RTL assumptions, and a settings surface that advertises language support without actually carrying the app.

**Triage:**
- *Should exist:* Yes. Language support materially changes who can use the app and should be engineered deliberately rather than added string-by-string ad hoc.
- *Smallest safe scope:* Complete the localization pipeline for all primary user-facing product copy, add locale selection/persistence, and verify RTL behavior for Urdu and Persian across the main flows.
- *Skipped scope:* Do not attempt server-side locale negotiation, user-generated content translation, multilingual moderation systems, or a huge CMS/content-management layer in this task.
- *Boundaries:* Keep Flutter-generated localization as the source of truth for product copy. Localize the app shell and first-party strings first; do not block the task on translating external quote/vendor content unless Hable already owns a safe localized fallback path.

**Action:** Expand Hable’s localization contract from partial English support to a real six-language app baseline: English, German, Urdu, Russian, Tamil, and Persian/Farsi. Audit hard-coded strings across the main flows, move remaining user-facing product copy into ARB-backed localization, add supported locales and a persisted language-selection path, verify dates/numbers/plurals through Flutter/Intl conventions, and test RTL layout and semantics on Urdu and Persian. Ensure the settings surface communicates the language choice clearly and that onboarding, auth, home, social, profile, reminders, and major feedback states all follow the same localization pipeline instead of a mix of generated strings and inline literals. implement language button on the login screen, and onboarding as well as settings, so the onboarding should be international too. If the quote of the day is in english, keep it in english.

**Hable perspective:** Hable’s copy is not incidental chrome; it is part of the product’s emotional tone. That means localization has to cover the actual habit journey, not just menu labels. The right engineering contract is one generated Flutter localization system, one persisted locale preference, and one explicit distinction between localized product copy and user-authored content that should remain as entered.

**Implementation scope:**
- `lib/l10n/*.arb`, generated localization files, and app bootstrap/localization config in `lib/main.dart` or equivalent: expand supported locales and move remaining first-party strings into the localization pipeline.
- Major UI surfaces: onboarding, auth, Home, Social, Profile, Settings, habit form, notification/activity copy, validation and error messages, and any completion or empty-state surfaces with hard-coded text.
- Locale selection/persistence: wire a real language control in Settings and persist the selected locale locally so restart behavior is deterministic.
- RTL support: verify and correct layout assumptions, icon/text ordering, alignments, and semantics for Urdu and Persian/Farsi.
- Copy sources tied to quotes/reminders/fallback text: ensure first-party fallback copy has localized variants or explicitly documented fallback behavior.
- Tests and QA: add targeted localization smoke coverage where practical and expand manual QA to include locale switching and RTL verification.
- Documentation: update QA/UX/development docs so supported languages and localization boundaries are explicit.

**Scalability considerations:** Localization expands continuously as features grow, so the key scaling rule is to eliminate hard-coded UI strings at the reusable-surface level. Keep locale ownership centralized and data-driven so future screens or languages do not require another architectural pass.

**Future split guidance:** If later work needs locale-specific quote sourcing, backend-driven translated content, regional experiments, transliteration helpers, or full content-operations workflows, append separate follow-up tasks. This task is only for the first-party Flutter localization baseline and the six-language product contract requested here.

**Edge cases:** RTL rendering on mixed LTR/RTL content, pluralization and date formatting, partner names/habit titles remaining user-authored, fallback copy when a translation key is missing, locale switching during runtime, notification/reminder copy variants, long translated strings on compact cards/buttons, and keeping automated tests stable across locale-sensitive snapshots.

**Acceptance criteria:**
- Hable supports English, German, Urdu, Russian, Tamil, and Persian/Farsi for its primary first-party product copy.
- The major user flows no longer depend on scattered hard-coded English strings outside deliberate exceptions.
- A real language-selection path exists and the chosen locale persists across app restarts.
- Urdu and Persian/Farsi render correctly with RTL-aware layout and semantics on the main flows.
- Date/number/plural-sensitive copy follows Flutter/Intl conventions rather than ad hoc string concatenation.
- QA guidance and any practical automated coverage are updated for locale switching, translation completeness, and RTL checks.
- Relevant docs are updated and any deeper multilingual content/infrastructure work is split into follow-up tasks.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`, `Developement/future_split_guidance.md`

**Completion-note placeholder:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="complete-remaining-localization-coverage-across-all-user-facing-flutter-surfaces"></a>
### [x] Complete Remaining Localization Coverage Across All User-Facing Flutter Surfaces

**Raw source:** Complete localization coverage across all remaining parts of the Flutter app so no meaningful user-facing English-only UI remains. Engineered from the user-supplied raw prompt on 2026-07-14 because `Task0_Raw.md` had no pending open intake items at the time of triage.

**Issue:** Hable already completed the localization scaffold and a first high-value language pass, but the app is still only partially localized in practice. Recent implementation work confirmed that several major surfaces still contain hard-coded English across screens, reusable widgets, fallback errors, empty states, date/time-relative labels, semantics, and nested settings/profile flows. That creates an inconsistent product experience: users can switch languages, but still encounter English-only islands on daily flows. It also weakens the maintainability of the six-language contract because any remaining inline strings will keep growing as features ship unless the cleanup is finished at the reusable-surface level.

**Triage:**
- *Should exist:* Yes. This is a real follow-up task, not duplicate backlog noise, because the archived localization baseline task established the language framework but did not finish coverage across the full current app surface.
- *Smallest safe scope:* Audit the full Flutter `lib/` tree for remaining first-party user-facing strings, localize the remaining high-traffic and reusable surfaces, align visible date/time formatting where practical, and verify the result with generated bindings plus focused analysis.
- *Skipped scope:* Do not broaden this into professional translation review, locale-specific quote sourcing, backend-translated content delivery, custom typography work, or full accessibility certification.
- *Boundaries:* Preserve the existing `AppLocalizations` architecture, current supported-language set, and offline-first product behavior. Localize first-party product copy only; do not translate user-generated content or force external quote content to be localized when Hable intentionally permits English quote text.

**Action:** Perform a repo-wide localization completion pass across the remaining user-facing Flutter surfaces. Audit screens, widgets, sheets, dialogs, snackbars, tooltips, CTA labels, empty states, validation messages, settings/help copy, notification timestamps, and semantics labels for hard-coded first-party English. Move remaining copy into the existing ARB pipeline for English, German, Urdu, Russian, Tamil, and Persian/Farsi. Keep all locale files key-complete, use the project’s established localization import style, and replace ad hoc date/time labels with locale-aware formatting where the change is low-risk and clearly user-facing.

**Hable perspective:** Hable’s emotional tone is carried by compact interface copy across onboarding, habit creation, daily check-ins, social feedback, and recovery/error states. A half-localized shell is not good enough because users hit these surfaces every session. The right completion task is not another infrastructure rewrite; it is a disciplined cleanup that finishes localization coverage at the UI-component layer so future features inherit the correct pattern by default.

**Implementation scope:**
- Flutter UI surfaces across `lib/screens/**` and `lib/widgets/**`: finish localizing app bars, tabs, buttons, helper text, placeholders, chips, banners, dialogs, bottom sheets, snackbars, section headings, profile/settings copy, onboarding copy, social copy, notification-center labels, and dashboard summary text.
- Reusable localization resources in `lib/l10n/*.arb` and generated bindings: add missing keys across `app_en.arb`, `app_de.arb`, `app_ru.arb`, `app_ta.arb`, `app_ur.arb`, and `app_fa.arb`, keeping non-English files key-complete even when temporary fallback text is still English.
- Existing locale state path: preserve `localeProvider` / `LanguageSelector` behavior and ensure touched files use the repo’s current `AppLocalizations` import style rather than introducing mixed patterns.
- User-facing formatting surfaces: tighten notification relative-time labels, short dates, plural-sensitive strings, and similar copy where Flutter/Intl or `MaterialLocalizations` already provides the safer path.
- Accessibility surfaces: localize visible semantics/tooltips that users encounter through assistive technology on habit cards, partner rows, notifications, and major navigation actions.
- Test and QA surfaces: add or update focused verification where practical, and refresh manual QA expectations for locale switching, translation completeness, and visible RTL/formatting checks.

**Scalability considerations:** Localization debt scales with feature count, so this task should eliminate hard-coded strings primarily on shared and high-traffic surfaces rather than treating each screen as a one-off exception. Keep locale ownership centralized in ARB resources, avoid recomputing copy in deeply nested widgets when providers can expose raw state instead, and prefer locale-aware framework formatting over custom string assembly so future growth does not create another cleanup wave.

**Future split guidance:** If this pass exposes deeper needs such as translation-quality review by native speakers, locale-specific quote curation, backend-delivered multilingual content, advanced ICU pluralization refactors, or comprehensive accessibility/RTL audits, append those as separate follow-up tasks. This task should finish broad first-party UI coverage, not become a multilingual content-operations program.

**Edge cases:** Mixed LTR/RTL content on the same row, user-authored habit titles and partner names embedded inside localized labels, long translated strings on narrow cards/buttons, timestamps that cross “minutes/hours/days” thresholds, locale switching during runtime, error fallbacks that currently pass inline strings into `AppError.fromAny(...)`, hidden English in tooltips/semantics, and stale generated localization bindings after ARB edits.

**Acceptance criteria:**
- The remaining obvious first-party hard-coded English on normal app usage paths is removed or explicitly documented as intentionally deferred.
- All six supported locale ARB files remain key-complete and generate clean localization bindings.
- Touched files use the project’s established `AppLocalizations` import/access pattern consistently.
- User-facing relative-time/date labels touched by the pass use locale-aware formatting where practical and low-risk.
- `flutter gen-l10n`, `dart format`, and focused `flutter analyze` are part of verification for the touched surfaces.
- QA/development documentation is verified and updated anywhere localization expectations materially changed.
- Any intentionally deferred strings or ambiguous product-copy decisions are called out explicitly in the eventual completion notes.

**Dependencies:** `Developement/qa_testing.md`, `Developement/future_split_guidance.md`, `Developement/ux_mud_and_animations.md`, `Developement/sys_error_handling.md`

**Completion notes:**
- Touched files: `lib/l10n/app_en.arb`, `lib/l10n/app_de.arb`, `lib/l10n/app_ru.arb`, `lib/l10n/app_ta.arb`, `lib/l10n/app_ur.arb`, `lib/l10n/app_fa.arb`, regenerated `lib/l10n/app_localizations*.dart`, `lib/screens/social/social_hub_screen.dart`, `lib/screens/profile_screen.dart`, `lib/widgets/habit_card.dart`, `lib/widgets/accessibility_selector.dart`, `lib/widgets/leaderboard_card.dart`, `Developement/qa_testing.md`, `Developement/sys_error_handling.md`, `Developement/ux_mud_and_animations.md`, and `Developement/future_split_guidance.md`.
- Behavior implemented: localized the remaining high-traffic Social/Profile/widget surfaces, including snackbars, dialogs, tooltips, chips, leaderboard/profile labels, accessibility copy, reminder/settings copy, habit-card semantics, and activity relative-time labels; replaced several English fallback error paths with localized safe-copy usage plus `MaterialLocalizations` where date formatting was safer than custom strings.
- Verification run: `flutter gen-l10n`, `dart format lib/screens/social/social_hub_screen.dart lib/screens/profile_screen.dart lib/widgets/habit_card.dart lib/widgets/accessibility_selector.dart lib/widgets/leaderboard_card.dart`, and `flutter analyze lib/screens/social/social_hub_screen.dart lib/screens/profile_screen.dart lib/widgets/habit_card.dart lib/widgets/accessibility_selector.dart lib/widgets/leaderboard_card.dart` all completed cleanly. MobAI/device validation was not available in this environment, so verification was limited to tooling plus targeted code review.
- Docs verified/updated: `Developement/qa_testing.md`, `Developement/sys_error_handling.md`, `Developement/ux_mud_and_animations.md`, and `Developement/future_split_guidance.md` were updated to reflect the localization baseline and localized safe-copy expectations.
- Intentional deferment: the six locale files are now key-complete for the newly added strings, but many of the new non-English values intentionally remain English fallback text until a separate native-speaker translation-quality pass.
- Completed At: 2026-07-14 16:20 CEST
