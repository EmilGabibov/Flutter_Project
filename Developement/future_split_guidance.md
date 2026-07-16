## Future Split Guidance

*Updated from proceeded GitHub issues through 2026-07-16 07:55 CEST.*
*Last future-guidance prompt extracted from the issue ledger: 2026-07-16 07:55 CEST (`Unblock Flutter CI analyzer gate for Dependabot PRs`, issue `#141`).*
*Resume future extraction from the first later proceeded GitHub issue closed after this timestamp.*
*Backlog reconciliation note on 2026-07-16 08:00 CEST: this file now treats GitHub engineered issue comments as the canonical source and keeps only still-deferred split guidance to avoid duplicate ownership with active issue scopes.*

This document aggregates the still-relevant "Future split guidance" from recently completed Hable tasks. It is organized by implementation hardness so future raw tasks can be added with less duplication and less scope creep.

### Easy
- **Social Integrity Cleanup Follow-Ups:** If more edge cases appear, split targeted fixes for reciprocal-request UX, deleted-account reconciliation, or local social-cache cleanup instead of broad social refactors.
  - *Source tasks:* `Harden Self-Friend Request Guarding And Social Cache Cleanup`.
  - *User perspective:* Friends/search states stay trustworthy and do not show ghost or impossible relationships.

- **Advanced Friend Management:** Unfriending, blocking, deleted-account handling, and clearer reciprocal-request UX should remain separate targeted tasks.
  - *Source tasks:* social integrity fixes, accepted-friend primitive tasks.
  - *User perspective:* You can control who interacts with you and clean up stale relationships safely.

- **Visual Density and Layout Follow-Ups:** If more inconsistencies remain, split targeted web layout polish, card-spacing cleanup, or fuller responsive passes rather than broad redesigns.
  - *Source tasks:* `Top-Align Primary Content And Remove Wasted Vertical Space`.
  - *User perspective:* The app feels tighter and more intentional across phone and web.

- **Completion and Haptic Polish:** Platform-specific gesture tuning, advanced haptic choreography, or richer completion celebrations should stay separate from correctness fixes.
  - *Source tasks:* hold-cancel fix, inline completion reset, completion splash.
  - *User perspective:* Check-ins feel more satisfying without changing the rules.

### Medium
- **Automated Device Smoke Harness:** If manual ADB verification keeps recurring, split a small automated smoke harness for install/reset/auth/home/social critical paths.
  - *Source tasks:* `Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes`.
  - *User perspective:* Fewer regressions reach a manual tester before being caught.

- **CI Failure Triage Follow-Ups:** If constructor/analyzer failures or test breakages reproduce only in CI, split a focused CI-triage task with the exact GitHub Actions log, Flutter/Dart versions, and failing command instead of expanding local cleanup work.
  - *Source tasks:* `Fix Flutter analyze constructor errors`, `Stabilize failing Flutter tests`.
  - *User perspective:* Build failures get isolated and fixed faster without blocking unrelated feature work.

- **Cloudflare Tooling And Audit Maintenance:** If Wrangler or other backend dev-tool upgrades expose build/deploy incompatibilities, split those into dedicated tooling tasks. Keep dev-only dependency audit maintenance separate from production route or application-behavior changes.
  - *Source tasks:* `Review backend development dependency audit warnings`.
  - *User perspective:* Infrastructure maintenance stays predictable without surprising app behavior changes.

- **Cloudflare Toolchain Pairing:** If future backend Dependabot updates try to split `wrangler` and `@cloudflare/workers-types` again, keep them grouped or document the coupling as a single backend toolchain change.
  - *Source tasks:* `Reconcile stale paired Cloudflare Dependabot PRs`.
  - *User perspective:* Backend tool upgrades stay mergeable and do not generate stale half-updates.

- **Dependency PR Gate Noise Follow-Ups:** If future dependency PRs still hit the shared Flutter analyzer gate because of known baseline infos, split cleanup by surface and keep the gate policy explicit rather than hiding dependency signal.
  - *Source tasks:* `Unblock Flutter CI analyzer gate for Dependabot PRs`.
  - *User perspective:* Dependency updates stay readable without turning CI policy into a moving target.

- **Partner and Invite Flow Expansion:** Split follow-ups for partner management after creation, invite cancellation, bulk invites, friend search inside the form, or habit invite from create/edit surfaces.
  - *Source tasks:* habit creation/Home add tasks, accepted-friend primitive tasks.
  - *User perspective:* Shared-habit setup becomes flexible without making the current create flow confusing.

- **Environment-Based Backend Targeting:** If release Android/web builds need something stronger than `kDebugMode`, split a task for explicit environment-based API configuration.
  - *Source tasks:* Android APK verification and manual smoke guidance.
  - *User perspective:* Test builds and production builds talk to the correct backend reliably.

- **Backend-Driven Web Push For PWA Reminders:** If Hable requires true closed-browser re-engagement, split a dedicated infrastructure task for web-push service workers and VAPID. The current local reminder system cannot schedule closed-app deliveries on web.
  - *Source tasks:* `Define Platform-Specific Habit Reminder Delivery For Android macOS Windows And PWA`.
  - *User perspective:* PWA users get reliable notifications even when the Hable tab is closed, matching native platforms.

- **Partner Request Protocol Repair:** If missing partner requests prove to be a deeper sync-contract problem rather than a bounded client-state bug, split the protocol repair into a dedicated backend/social-sync task.
  - *Source tasks:* `issue: no registering the partner requests`.
  - *User perspective:* Invite flows stay trustworthy without mixing protocol redesign into ordinary UI fixes.

- **Profile Media and R2 Storage Implementation:** Following the engineered API contract, implement the Flutter image cropper, R2 presigned URL upload flow, local caching, and fallback logic for richer profile media.
  - *Source tasks:* `Expand Avatar Identity From Emoji-Only To Managed Profile Media`.
  - *User perspective:* Users can upload real photos for their profile that load instantly and fall back to emojis cleanly if offline.

- **Three-Player Social QA Harness:** Expand browser automation from the current two-user loop into deterministic three-user invite/nudge/follow scenarios.
  - *Source tasks:* web multi-user plan, Playwright regression harness.
  - *User perspective:* Multi-user features keep working when the social graph is larger than one pair.

- **Shareable Achievement Card Expansion:** Add template variants, stronger OS share-sheet support, PDF certificates, or optional server-rendered assets as a focused sharing task.
  - *Source tasks:* achievement/share follow-ups.
  - *User perspective:* Accomplishments are easier to share in polished formats.

- **Achievement and History Expansion:** Shareable completion certificates, milestone recap cards, richer history pages, or a unified "Achievements & History" redesign should build on the new archive/history lane as separate work.
  - *Source tasks:* `Auto-Archive Completed Habits Into Profile History And Expand Lifecycle Actions`.
  - *User perspective:* Finished habits and milestones become easier to revisit and celebrate.

- **Mud Personalization:** Dynamic per-user mud tuning, haptic calibration presets, and persistent mud preferences should remain a separate interaction-settings task.
  - *Source tasks:* mud-resistance alignment work.
  - *User perspective:* The signature hold interaction can match different users and devices better.

- **Onboarding Variant Expansion:** Animated illustrations, personalized onboarding variants, reminder permission priming, social invite capture during onboarding, or A/B experimentation should stay as separate onboarding tasks rather than expanding the current slide/setup flow.
  - *Source tasks:* research-backed onboarding slides task, first-run quote splash work.
  - *User perspective:* First-run education can grow richer without destabilizing the low-friction auth/setup path.

- **Quote Engine Expansion:** Locale-aware quotes, copy moderation/review, multiple tags/categories, remote experiments, or quote-engagement analytics should remain separate from the current bounded daily quote integration.
  - *Source tasks:* external quote API integration, contextual fallback quote work, quote-length reduction follow-up.
  - *User perspective:* The app can get smarter or broader quote content later without weakening the current offline-safe daily quote path.

- **Notification Audio Engine Optimization:** If out-of-schedule reminder audio is caused by plugin warm-up or playback-engine latency rather than scheduling logic, split a focused audio-engine optimization task.
  - *Source tasks:* `bug: notification announcements out of schedule`.
  - *User perspective:* Reminder timing becomes more reliable without overhauling the broader notification model.

- **Score-Surface Copy And Sync Follow-Ups:** If the clarified scoring contract reveals stale sync timing, confusing point terminology, or friend-profile/leaderboard mismatch, split those into targeted product or sync tasks instead of reopening the entire scoring model.
  - *Source tasks:* leaderboard/profile/per-log points clarification task.
  - *User perspective:* Lifetime ranking, profile progression, and per-check-in rewards stay understandable even as more progression surfaces are added.

- **Empty-Day and Streak Moments:** Split specific tasks for empty-day encouragement states, streak-specific haptics, shared-habit celebration feedback, or richer quote-driven moment design.
  - *Source tasks:* scoring/habit-state document, completion splash task.
  - *User perspective:* The app responds more intelligently to good days, missed days, and streaks.

- **Accessibility Mode Expansion:** Dedicated reduced-motion controls, higher-contrast variants, alternative feedback channels, or accessibility-specific onboarding/help should stay separate from the baseline accessibility compatibility pass.
  - *Source tasks:* `Audit And Raise Accessibility Compatibility Across Mobile Desktop And Web Surfaces`.
  - *User perspective:* Accessibility can deepen over time without blocking the baseline compatibility contract.

- **Localized Content Operations:** First-party Flutter shell coverage is now expected across high-traffic screens and reusable surfaces. Locale-specific quote sourcing, native-speaker translation review, translated fallback-content governance, regional experimentation, or backend-delivered multilingual content should remain separate from that baseline.
  - *Source tasks:* `Expand Hable Localization To English German Urdu Russian Tamil And Persian`, quote-engine follow-ups.
  - *User perspective:* More languages and smarter localized content can grow after the app shell itself is consistently multilingual.

### Hard
- **Authentication Hardening Beyond MVP:** Add refresh rotation, revocation, account deletion/export, stronger abuse telemetry, production email hardening, passkeys/OAuth, or multi-device session management as separate auth tasks.
  - *Source tasks:* auth docs, password-reset/auth tasks, JWT-auth tasks.
  - *User perspective:* Account security feels production-ready rather than prototype-grade.

- **Desktop and Store Distribution Tracks:** Keep macOS App Store + standalone distribution, Windows installer/standalone packaging, Play Console metadata, app links, and store-release hardening as separate release-engineering tasks.
  - *Source tasks:* platform build integrity tasks, Android signing/package identity tasks.
  - *User perspective:* Installing Hable from each platform feels official and low-friction.

- **Realtime Transport Accelerator Implementation:** Following the new architecture design, implement the signal-only WebSockets/SSE on the Cloudflare Worker and Flutter client as a dedicated infrastructure task. Do not try to rewrite the full sync loop in one go; keep the Drift invalidation pattern.
  - *Source tasks:* `Split Realtime Or Push Delivery Architecture Beyond Foreground Polling`.
  - *User perspective:* Shared actions and nudges sync instantly when the app is open without battery-draining full-payload sockets.

- **Shared-Habit Consistency Hardening Implementation:** Following the established design, add deeper sync-queue batched conflict-handling, explicit partner removal state, and timestamp-based stale snapshot rejections without turning habits into complex merge CRDTs.
  - *Source tasks:* `Strengthen Shared-Habit Consistency For Multi-Device And Realtime Conflict Cases`.
  - *User perspective:* Shared habit states never regress or appear confusing when offline devices reconnect simultaneously.

- **Cross-Platform Push Infrastructure Implementation:** Establish a dedicated push backend layer and client subscription lifecycles spanning FCM/APNs and WebPush. Manage `push_subscriptions` idempotently alongside preferences without leaking remote messaging into authoritative local state.
  - *Source tasks:* `Build Dedicated Cross-Platform Push Notification Infrastructure`.
  - *User perspective:* Cross-platform notifications reliably re-engage users when the app is closed, with deduplication and quiet-hours support.

- **Follow Model and Friend Activity Feed:** Durable "follow habit" relationships, friend activity feeds, public habit templates, richer encouragement messages, and recommendation logic should be split out from the current MVP social model.
  - *Source tasks:* friend-profile/nudge/follow-related tasks.
  - *User perspective:* Social feels like an ecosystem rather than a narrow invite-only workflow.

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
- If a failure appears only in CI or only after a tooling upgrade, split the environment/toolchain diagnosis from product-surface fixes and preserve the exact failing log or version context in the raw task.
