# Future Split Guidance

*Updated from completed tasks through 2026-07-13 21:09 CEST.*
*Last future-guidance prompt extracted from active/completed queue: 2026-07-13 21:09 CEST (`Clarify The Difference Between Leaderboard Totals, Profile Gamification, And Per-Log Points Surfaces`).*
*Resume future extraction from the first later completed task in `Task2_Archived.md` or newly archived items added after this timestamp.*

This document aggregates the still-relevant "Future split guidance" from recently completed Hable tasks. It is organized by delivery priority and implementation hardness so future raw tasks can be added with less duplication and less scope creep.

## Priority 1: Reliability, Sync Integrity, Testing, and Release Operations
*These items protect Hable's offline-first contract, multi-user correctness, and release safety.*

### Easy
- **Startup Diagnostics and Recovery Visibility:** If startup readiness keeps being hard to debug, split a narrow task for offline boot telemetry, queue-health diagnostics, or clearer startup recovery states.
  - *Source tasks:* `Gate Authenticated Shell On Startup Sync Readiness`, recent sync-coordinator work.
  - *User perspective:* The app explains "still syncing" or "retrying" states cleanly instead of feeling frozen at launch.

- **Social Integrity Cleanup Follow-Ups:** If more edge cases appear, split targeted fixes for reciprocal-request UX, deleted-account reconciliation, or local social-cache cleanup instead of broad social refactors.
  - *Source tasks:* `Harden Self-Friend Request Guarding And Social Cache Cleanup`.
  - *User perspective:* Friends/search states stay trustworthy and do not show ghost or impossible relationships.

### Medium
- **Automated Device Smoke Harness:** If manual ADB verification keeps recurring, split a small automated smoke harness for install/reset/auth/home/social critical paths.
  - *Source tasks:* `Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes`.
  - *User perspective:* Fewer regressions reach a manual tester before being caught.

- **Offline and Notification Coverage Expansion:** Add deterministic test coverage for offline logging, reconnect sync recovery, local-notification tap routing, and then fix the concrete bugs those tests expose.
  - *Source tasks:* `Add Playwright Multi-User Regression Harness For Shared Habits And Social Interactions`, later QA follow-ups.
  - *User perspective:* Check-ins and reminders still behave correctly when connectivity is unstable.

- **Build and Release Automation Matrix:** Add CI/CD build matrix automation, branch previews, environment-variable based secret injection, source-map upload, or standardized build-regression templates.
  - *Source tasks:* web deploy, signing/package-name tasks, build-integrity guideline task.
  - *User perspective:* Releases break less often and are easier to reproduce across Android, web, macOS, and Windows.

- **Environment-Based Backend Targeting:** If release Android/web builds need something stronger than `kDebugMode`, split a task for explicit environment-based API configuration.
  - *Source tasks:* Android APK verification and manual smoke guidance.
  - *User perspective:* Test builds and production builds talk to the correct backend reliably.

### Hard
- **Realtime or Push Delivery Architecture:** If foreground polling becomes insufficient, split push/WebSocket delivery, richer sync telemetry, or leaderboard-specific caching into separate backend/client tasks.
  - *Source tasks:* `Implement foreground daily-sync polling and lifecycle flush`, notification-center follow-ups.
  - *User perspective:* Social changes arrive quickly without requiring app reopen or repeated manual refresh.

- **Authentication Hardening Beyond MVP:** Add refresh rotation, revocation, account deletion/export, stronger abuse telemetry, production email hardening, passkeys/OAuth, or multi-device session management as separate auth tasks.
  - *Source tasks:* auth docs, password-reset/auth tasks, JWT-auth tasks.
  - *User perspective:* Account security feels production-ready rather than prototype-grade.

- **Desktop and Store Distribution Tracks:** Keep macOS App Store + standalone distribution, Windows installer/standalone packaging, Play Console metadata, app links, and store-release hardening as separate release-engineering tasks.
  - *Source tasks:* platform build integrity tasks, Android signing/package identity tasks.
  - *User perspective:* Installing Hable from each platform feels official and low-friction.

## Priority 2: Social Product Depth and Multi-User Scale
*These items grow Hable beyond the current accepted-friend + shared-habit MVP.*

### Easy
- **Advanced Friend Management:** Unfriending, blocking, deleted-account handling, and clearer reciprocal-request UX should remain separate targeted tasks.
  - *Source tasks:* social integrity fixes, accepted-friend primitive tasks.
  - *User perspective:* You can control who interacts with you and clean up stale relationships safely.

- **Avatar and Profile-Media Expansion:** Profile photo uploads, richer avatar management, moderation/storage, and avatar history should stay separate from emoji-avatar correctness work.
  - *Source tasks:* avatar optimism/correctness follow-ups.
  - *User perspective:* Profiles feel more personal without risking the core profile flow.

### Medium
- **Partner and Invite Flow Expansion:** Split follow-ups for partner management after creation, invite cancellation, bulk invites, friend search inside the form, or habit invite from create/edit surfaces.
  - *Source tasks:* habit creation/Home add tasks, accepted-friend primitive tasks.
  - *User perspective:* Shared-habit setup becomes flexible without making the current create flow confusing.

- **Notification Inbox UX Upgrade:** Add grouped inbox structure, better focus/auto-scroll back into the relevant habit, and platform-specific notification categories/actions where supported.
  - *Source tasks:* notification-center and Social Activity consolidation tasks.
  - *User perspective:* Tapping an activity or reminder takes you to the exact thing that needs attention.

- **Three-Player Social QA Harness:** Expand browser automation from the current two-user loop into deterministic three-user invite/nudge/follow scenarios.
  - *Source tasks:* web multi-user plan, Playwright regression harness.
  - *User perspective:* Multi-user features keep working when the social graph is larger than one pair.

### Hard
- **Follow Model and Friend Activity Feed:** Durable "follow habit" relationships, friend activity feeds, public habit templates, richer encouragement messages, and recommendation logic should be split out from the current MVP social model.
  - *Source tasks:* friend-profile/nudge/follow-related tasks.
  - *User perspective:* Social feels like an ecosystem rather than a narrow invite-only workflow.

- **Push Notification Infrastructure:** Cloudflare web push, FCM/APNs, VAPID management, quiet hours, digesting, cross-device read-state sync, and admin/global announcements should stay as dedicated infrastructure work.
  - *Source tasks:* `Build Notification Center And Local Reminder MVP`, nudge/reminder follow-ups.
  - *User perspective:* Notifications remain timely and consistent even when the app is closed.

- **Realtime Shared-Habit Consistency:** Batch sync, conflict-resolution UI, realtime shared updates, and broader lifecycle conflict handling should remain separate after the current bidirectional lifecycle path is proven.
  - *Source tasks:* shared-habit lifecycle sync and polling tasks.
  - *User perspective:* Shared habits behave predictably even when multiple people act from different devices at the same time.

## Priority 3: UX, Gamification, and Product Polish
*These items improve feel, delight, and larger-surface product expression after the core loop is stable.*

### Easy
- **Visual Density and Layout Follow-Ups:** If more inconsistencies remain, split targeted web layout polish, card-spacing cleanup, or fuller responsive passes rather than broad redesigns.
  - *Source tasks:* `Top-Align Primary Content And Remove Wasted Vertical Space`.
  - *User perspective:* The app feels tighter and more intentional across phone and web.

- **Completion and Haptic Polish:** Platform-specific gesture tuning, advanced haptic choreography, or richer completion celebrations should stay separate from correctness fixes.
  - *Source tasks:* hold-cancel fix, inline completion reset, completion splash.
  - *User perspective:* Check-ins feel more satisfying without changing the rules.

### Medium
- **Achievement and History Expansion:** Shareable completion certificates, milestone recap cards, richer history pages, or a unified "Achievements & History" redesign should build on the new archive/history lane as separate work.
  - *Source tasks:* `Auto-Archive Completed Habits Into Profile History And Expand Lifecycle Actions`.
  - *User perspective:* Finished habits and milestones become easier to revisit and celebrate.

- **Shareable Achievement Card Expansion:** Add template variants, stronger OS share-sheet support, PDF certificates, or optional server-rendered assets as a focused sharing task.
  - *Source tasks:* achievement/share follow-ups.
  - *User perspective:* Accomplishments are easier to share in polished formats.

- **Mud Personalization:** Dynamic per-user mud tuning, haptic calibration presets, and persistent mud preferences should remain a separate interaction-settings task.
  - *Source tasks:* mud-resistance alignment work.
  - *User perspective:* The signature hold interaction can match different users and devices better.

- **Onboarding Variant Expansion:** Animated illustrations, personalized onboarding variants, reminder permission priming, social invite capture during onboarding, or A/B experimentation should stay as separate onboarding tasks rather than expanding the current slide/setup flow.
  - *Source tasks:* research-backed onboarding slides task, first-run quote splash work.
  - *User perspective:* First-run education can grow richer without destabilizing the low-friction auth/setup path.

- **Quote Engine Expansion:** Locale-aware quotes, copy moderation/review, multiple tags/categories, remote experiments, or quote-engagement analytics should remain separate from the current bounded daily quote integration.
  - *Source tasks:* external quote API integration, contextual fallback quote work.
  - *User perspective:* The app can get smarter or broader quote content later without weakening the current offline-safe daily quote path.

- **Score-Surface Copy And Sync Follow-Ups:** If the clarified scoring contract reveals stale sync timing, confusing point terminology, or friend-profile/leaderboard mismatch, split those into targeted product or sync tasks instead of reopening the entire scoring model.
  - *Source tasks:* leaderboard/profile/per-log points clarification task.
  - *User perspective:* Lifetime ranking, profile progression, and per-check-in rewards stay understandable even as more progression surfaces are added.

- **Empty-Day and Streak Moments:** Split specific tasks for empty-day encouragement states, streak-specific haptics, shared-habit celebration feedback, or richer quote-driven moment design.
  - *Source tasks:* scoring/habit-state document, completion splash task.
  - *User perspective:* The app responds more intelligently to good days, missed days, and streaks.

### Hard
- **Seasonal Leaderboards and Score Resets:** Seasonal ladders/reset policy, richer score-history surfaces, badge ceremonies, and QA for score-event idempotency should remain separate from the current cumulative scoring system.
  - *Source tasks:* scoring/gamification documentation, server-side gamification tasks.
  - *User perspective:* Competition can reset fairly without destabilizing lifetime progress.

- **Quote Source Resilience And Vendor Strategy:** If the external quote provider remains unreliable, split provider rotation, self-hosted quote curation, upstream caching policy, or certificate-health monitoring into dedicated backend/content tasks.
  - *Source tasks:* daily quote API integration and fallback-hardening work.
  - *User perspective:* Daily quotes remain dependable even if one external source degrades.

- **Tablet/Grid Dashboard Track:** A dedicated all-habits grid/dashboard, reusable `HabitTile` foundation, and large-screen IA should be a separate task from Home-card polish.
  - *Source tasks:* Home card/grid/dashboard follow-ups.
  - *User perspective:* Tablets and wide screens use space well instead of just stretching the phone layout.

- **Full Design-System or Immersive Social Worlds:** 3D habit environments, richer badge reveal systems, custom icon libraries, leaderboard visual redesign, and other broad visual-system work should remain isolated from feature tasks.
  - *Source tasks:* role/gamification polish follow-ups, visual polish tasks.
  - *User perspective:* The app can become more expressive later without destabilizing the current MVP surfaces.

## Task-Splitting Rules

- Prefer narrow correctness tasks over broad "social refactor" or "UX redesign" tasks.
- Keep offline-first ownership intact: Flutter writes locally first, Drift/Riverpod remain the UI truth, and backend work should not bypass that model.
- Treat remote push, realtime transport, store distribution, and auth hardening as infrastructure tracks, not incidental add-ons to UI tasks.
- When a follow-up is mostly QA coverage, pair it with fixing the concrete regressions that coverage reveals.
