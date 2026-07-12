<!-- AI AGENT OPERATING CONTRACT — See ai_agent_contract.md for full rules. This file hosts the compact completed-task index and the active engineered queue (§5 / §2). -->

## Completed Tasks

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

## Remaining Tasks

<a id="add-playwright-multi-user-regression-harness-for-shared-habits-and-social-interactions"></a>
### [ ] Add Playwright Multi-User Regression Harness For Shared Habits And Social Interactions

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

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]
