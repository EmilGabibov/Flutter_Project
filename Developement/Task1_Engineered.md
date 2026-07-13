<!-- AI AGENT OPERATING CONTRACT — See ai_agent_contract.md for full rules. This file hosts the compact completed-task index and the active engineered queue (§5 / §2). -->

## Completed Tasks

- 2026-07-13 22:04 CEST: [Standardize Safe Error Contracts Across Flutter And Worker Surfaces](Task1_Engineered.md#standardize-safe-error-contracts-across-flutter-and-worker-surfaces)

- 2026-07-13 16:12 CEST: [Introduce Explicit Environment-Based Backend Targeting For Flutter And Release Builds](Task2_Archived.md#introduce-explicit-environment-based-backend-targeting-for-flutter-and-release-builds)

- 2026-07-12 14:35 Z: [Add Playwright Multi-User Regression Harness For Shared Habits And Social Interactions](Task2_Archived.md#add-playwright-multi-user-regression-harness-for-shared-habits-and-social-interactions)

- 2026-07-13 11:46 CEST: [Auto-Archive Completed Habits Into Profile History And Expand Lifecycle Actions](Task2_Archived.md#auto-archive-completed-habits-into-profile-history-and-expand-lifecycle-actions)

- 2026-07-12 14:28 CEST: [x] Fix Shared-Habit Hold-To-Complete Cancellation Before Threshold — **Completion notes:** 2026-07-12: Switched `GestureDetector` to `Listener` (`onPointerDown`/`Up`/`Cancel`) in `MudLongPressButton` to avoid 500ms delay and capture early releases reliably. Added `_isHolding` and `_completedDuringCurrentHold` flags to prevent completion callback from firing after cancellation. Implemented widget tests in `test/mud_long_press_button_test.dart` to verify early release cancellation and full hold completion. Tests pass.

- 2026-07-11 21:19 CEST: Reorganize Social Hub From 5 Tabs To 3 (Friends + Inline Requests, Activity Feed, Leaderboard) — Merged Inbox and Notification Center into Activity tab, moved Find Friends to bottom sheet, Home bell switches to Social→Activity.

- 2026-07-11 21:05 CEST: [Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification](Task2_Archived.md#complete-cross-app-habit-lifecycle-sync-and-twin-harness-verification)

- 2026-07-11 20:31 CEST: [Replace Core Loading Spinners With Consistent Skeleton Empty States](Task2_Archived.md#replace-core-loading-spinners-with-consistent-skeleton-empty-states)

- 2026-07-11 20:24 CEST: [Repair Account And Social API Regression Across Auth Avatar Nudge Leaderboard And Search](Task2_Archived.md#repair-account-and-social-api-regression-across-auth-avatar-nudge-leaderboard-and-search)

- 2026-07-11 20:19 CEST: [Wire Friend Requests Through Social Hub And Twin-Harness Verification](Task2_Archived.md#wire-friend-requests-through-social-hub-and-twin-harness-verification)

- 2026-07-11 16:06 CEST: [Lock Hable To Three-Tab IA With Nested Profile Settings](Task2_Archived.md#lock-hable-to-three-tab-ia-with-nested-profile-settings)

- 2026-07-11 16:06 CEST: [Rework Daily Navigation And Screen Information Architecture](Task2_Archived.md#rework-daily-navigation-and-screen-information-architecture)

- 2026-07-11 15:51 CEST: [Keep Partner Shared Habits Visible After Check-In And Surface Nudges](Task2_Archived.md#keep-partner-shared-habits-visible-after-check-in-and-surface-nudges)

- 2026-07-11 15:38 CEST: [Add Friend Profile Drilldown And Habit-Scoped Nudge Actions](Task2_Archived.md#add-friend-profile-drilldown-and-habit-scoped-nudge-actions)

- 2026-07-11 15:32 CEST: [Build Notification Center And Local Reminder MVP](Task2_Archived.md#build-notification-center-and-local-reminder-mvp)

- 2026-07-11 14:02 CEST: [Add Privacy-Preserving Anonymous Usage Aggregates For Development Diagnostics](Task2_Archived.md#add-privacy-preserving-anonymous-usage-aggregates-for-development-diagnostics)
- 2026-07-11 13:50 CEST: [Audit And Align Hable Development Docs With Current Code](Task2_Archived.md#audit-and-align-hable-development-docs-with-current-code)
- 2026-07-11 13:17 CEST: [Repair SignUp SignIn And Forgot Password Network Failures](Task2_Archived.md#repair-signup-signin-and-forgot-password-network-failures)
- 2026-07-11 04:15 UTC: [Add Revocable iCal Feed For Native Calendar Subscriptions](Task2_Archived.md#add-revocable-ical-feed-for-native-calendar-subscriptions)
- 2026-07-11 05:30 UTC: [Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes](Task2_Archived.md#run-adb-smoke-tests-for-auth-friend-harness-and-recent-ui-changes)
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

- 2026-07-11 14:30 CEST: [Refine Habit Card Ring Icon Partner Rings And Responsive State Model](Task2_Archived.md#refine-habit-card-ring-icon-partner-rings-and-responsive-state-model)
- 2026-07-11 02:56 CEST: [Add Partnership Roles And Enforce Habit Permissions In Backend](Task2_Archived.md#add-partnership-roles-and-enforce-habit-permissions-in-backend)
- 2026-07-11 03:05 CEST: [Add Server-Side Gamification Progression To Daily Sync](Task2_Archived.md#add-server-side-gamification-progression-to-daily-sync)
- 2026-07-11 03:22 CEST: [Polish Habit Cards And Profile With Role-Aware Progression Data](Task2_Archived.md#polish-habit-cards-and-profile-with-role-aware-progression-data)
- 2026-07-12 08:23 CEST: [Inventory Project TODO Comments Into A Prioritized Backlog](Task2_Archived.md#inventory-project-todo-comments-into-a-prioritized-backlog)
- 2026-07-12 08:29 CEST: [Document Hable Authentication System Context](Task2_Archived.md#document-hable-authentication-system-context)
- 2026-07-12 08:36 CEST: [Configure Android Release Signing For Production Builds](Task2_Archived.md#configure-android-release-signing-for-production-builds)
- 2026-07-12 08:36 CEST: [Replace Template Android Application ID With Stable Hable Package Names](Task2_Archived.md#replace-template-android-application-id-with-stable-hable-package-names)
- 2026-07-12 10:16 CEST: [Reconcile Task_Idea Prompts Into The Active Hable Backlog](Task2_Archived.md#reconcile-task-idea-prompts-into-the-active-hable-backlog)
- 2026-07-12 10:23 CEST: [Implement foreground daily-sync polling and lifecycle flush for social/habit updates](Task2_Archived.md#implement-foreground-daily-sync-polling-and-lifecycle-flush)
- Unknown time: [Top-Align Primary Content And Remove Wasted Vertical Space](Task2_Archived.md#top-align-primary-content-and-remove-wasted-vertical-space)
- Unknown time: [Restore Inline Habit Card State After Completion Feedback](Task2_Archived.md#restore-inline-habit-card-state-after-completion-feedback)
- Unknown time: [Make Avatar Updates Optimistic And Failure-Safe](Task2_Archived.md#make-avatar-updates-optimistic-and-failure-safe)
- 2026-07-12 10:45 CEST: [Gate Authenticated Shell On Startup Sync Readiness](Task2_Archived.md#gate-authenticated-shell-on-startup-sync-readiness)
- 2026-07-12 11:05 CEST: [Verify iOS Build Integrity (Blocked on Environment)](Task2_Archived.md#verify-ios-build-integrity)
- 2026-07-12 11:15 CEST: [Verify Android Build Integrity](Task2_Archived.md#verify-android-build-integrity)
- 2026-07-12 11:20 CEST: [Verify MacOS Build Integrity](Task2_Archived.md#verify-macos-build-integrity)
- 2026-07-12 11:22 CEST: [Verify Windows Build Integrity (Blocked on Environment)](Task2_Archived.md#verify-windows-build-integrity)
- 2026-07-12 11:00 CEST: [Document AI Agent Guideline For Cross-Platform Build Fix Workflow](Task2_Archived.md#document-ai-agent-guideline-for-cross-platform-build-fix-workflow)
- 2026-07-12 09:20 UTC+2: [Refine And Organize Development Documentation](Task2_Archived.md#refine-and-organize-development-documentation)
- 2026-07-12 10:37 UTC+2: [Design Web Multi-User Browser Test Plan For Core Social Habit And Leaderboard Flows](Task2_Archived.md#design-web-multi-user-browser-test-plan-for-core-social-habit-and-leaderboard-flows)
- 2026-07-12 10:37 UTC+2: [Document Scoring Leaderboard Quotes Rewards And Habit State Moments](Task2_Archived.md#document-scoring-leaderboard-quotes-rewards-and-habit-state-moments)

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
### [ ] Add Startup Diagnostics And Recovery Visibility For Sync-Gated Shell

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

**Completion-note placeholder:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="expand-offline-logging-and-notification-regression-coverage"></a>
### [ ] Expand Offline Logging And Notification Regression Coverage

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

**Completion-note placeholder:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="build-a-cross-platform-release-automation-matrix-and-refresh-build-integrity-docs"></a>
### [ ] Build A Cross-Platform Release Automation Matrix And Refresh Build Integrity Docs

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

**Completion-note placeholder:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

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
