# 08: Testing Procedures & Smoke Tests

**Target Stack:** Flutter / Browser / ADB / Xcode / Integration Tests

## CI Parity

Use this when a dependency PR or release-prep change needs to match the shared
GitHub Actions Flutter gate exactly:

1. `flutter pub get`
2. `flutter analyze --no-fatal-infos --fatal-warnings`
3. `flutter test --coverage`
4. `flutter build web --release --base-href / --dart-define=HABLE_APP_ENV=production`
5. `node scripts/prepare_web_service_worker.mjs`

The analyzer policy is intentional: informational diagnostics stay visible for
cleanup, but only warnings and errors block the shared Flutter job.

## Cross-Platform Parity And Release Gate (Issue #159)

This is the fixed release-readiness matrix for Web/PWA, Android, iOS, and
macOS. Web/PWA is the product baseline, but a baseline defect is still a gate
failure rather than behavior for native clients to copy.

### Audit identity and decision

- Test date: `2026-07-16` (Europe/Berlin)
- Clean audit source: `5949de52701879cc9fd5d4c4da6ec15a0023ae78`
- Follow-up macOS auth change: `77900a37301b42fff358a19eeadbce8cccd8b4e5`
- App version: `1.0.0+1`
- Flutter/Dart: `3.44.4` / `3.12.2`
- Node.js: `22.22.3`
- Apple host: macOS `26.5.2`, Xcode `26.6` (`17F113`)
- Target environment: explicit `--dart-define=HABLE_APP_ENV=production`,
  resolved by `lib/config/api_config.dart` to `https://hable.pages.dev`
- Result: **FAIL — keep #159 open.** Android passed the bounded signed-out
  runtime smoke, but the shared analyzer/test gates are red, Web/PWA has no
  functioning service-worker/offline path, iOS cannot compile on the available
  runtime, and macOS is not distribution-signed or fully UI-smoked.

The audit re-read `sys_authentication.md`, `sys_offline_architecture.md`,
`sys_error_handling.md`, `qa_accessibility.md`, `macos_distribution.md`, and
`windows_distribution.md` as governing contracts. The local-first Drift model,
safe-error rules, and accessibility expectations remain unchanged. Windows is
not one of #159's four runtime targets; it appears only where the inaccurate CI
matrix claim also required correction.

Status meanings:

- `PASS`: exercised with sanitized evidence on the named build.
- `PARTIAL`: a bounded portion passed, but the full row was not exercised.
- `FAIL`: a concrete failure was reproduced.
- `BLOCKED`: the host/toolchain cannot currently execute the check.
- `NOT RUN`: safe fixture or target-specific harness is not yet available.

### Target build evidence

| Target | Build identifier and configuration | Build result | Runtime/recovery evidence | Release gate |
|---|---|---|---|---|
| Web/PWA | Current local source; production environment | Release build `PASS`; analyzer `PASS` with informational diagnostics only; full tests `FAIL` on friend-profile expectation | Local source smoke has one activated app-scope controller, bounded readiness, offline shell reload, and no browser-owned Quotable request; production deployment still requires rerun | `FAIL`: [#161](https://github.com/EmilGabibov/HABLE_Project/issues/161), [#172](https://github.com/EmilGabibov/HABLE_Project/issues/172), [#173](https://github.com/EmilGabibov/HABLE_Project/issues/173) |
| Android primary/friend | Source `5949de5`; APK SHA-256 primary `8cf071e9…5047`, friend `b61e59a3…b58c`; target SDK 36; production environment | Both release flavor APKs `PASS` compilation | Pixel 9 / Android 17 primary fresh install reached onboarding, invalid login returned a safe backend message, cold relaunch passed with no `adb reverse`; authenticated/offline flows not run | `FAIL`: both release artifacts use the Android Debug certificate; [#164](https://github.com/EmilGabibov/HABLE_Project/issues/164)-[#166](https://github.com/EmilGabibov/HABLE_Project/issues/166), [#174](https://github.com/EmilGabibov/HABLE_Project/issues/174) |
| iOS primary/friend | Source `5949de5`; production environment; Xcode reports required iOS 26.5 platform unavailable | Primary `BLOCKED`: no simulator runtimes and every destination ineligible; friend build not run after the shared destination blocker | No runtime smoke; bundle IDs/display names are placeholders and no signing identity/profile is installed | `FAIL`: [#167](https://github.com/EmilGabibov/HABLE_Project/issues/167)-[#169](https://github.com/EmilGabibov/HABLE_Project/issues/169), [#174](https://github.com/EmilGabibov/HABLE_Project/issues/174) |
| macOS | Source `77900a3`; executable SHA-256 `02ab5da7…50fe`; `com.hable.app.macos`; production environment | Release build `PASS` compilation | Auth/flag tests prove zero macOS secure-storage access; launch process stayed stable with no Keychain error log. Direct UI inspection was blocked by the locked host | `FAIL`: ad-hoc signature, no team ID, Gatekeeper/nested-code validation failure; reminder and direct UI gates open in [#160](https://github.com/EmilGabibov/HABLE_Project/issues/160), [#170](https://github.com/EmilGabibov/HABLE_Project/issues/170), [#171](https://github.com/EmilGabibov/HABLE_Project/issues/171), [#174](https://github.com/EmilGabibov/HABLE_Project/issues/174) |

Production Web Push binding names were present during the audit. An
unauthenticated `/api/push/config` request correctly returned `401`; do not
reopen the stale missing-secret finding without an authenticated check.

### Representative flow matrix

| Flow | Web/PWA baseline | Android | iOS | macOS |
|---|---|---|---|---|
| Launch / startup recovery | `PARTIAL`: online onboarding loads; service-worker wait exceeds 4 s | `PASS`: fresh cold launch reached usable onboarding in 2360 ms | `BLOCKED`: no eligible destination | `PARTIAL`: release process stable after #160; visible UI check blocked by locked host |
| Authentication | `NOT RUN`: no production credentials/account mutation | `PARTIAL`: invalid login reached production and showed actionable error | `BLOCKED` | `PARTIAL`: process-local session policy and no-Keychain tests pass; explicit release login not run |
| Primary navigation | `NOT RUN`: authenticated shell fixture missing | `NOT RUN` | `BLOCKED` | `NOT RUN` |
| Core data read | `NOT RUN`: authenticated fixture missing | `NOT RUN` | `BLOCKED` | `NOT RUN` |
| Core write / repeated action | `NOT RUN`: mutable production E2E intentionally skipped | `NOT RUN` | `BLOCKED` | `NOT RUN` |
| Loading and empty states | `PARTIAL`: onboarding/initial shell only | `PARTIAL`: onboarding only | `BLOCKED` | `PARTIAL`: startup widgets tested; release window not inspected |
| Actionable error state | `PARTIAL`: local source has bounded worker/push failure handling; full authenticated recovery remains unrun | `PASS` for invalid credentials only | `BLOCKED` | `PARTIAL`: auth failures are normalized in tests; runtime path not exercised |
| Offline startup | `FAIL`: reload returns `ERR_INTERNET_DISCONNECTED` | `NOT RUN` | `BLOCKED` | `NOT RUN` |
| Retry / reconnect | `FAIL`: no bounded PWA shell recovery | `NOT RUN` | `BLOCKED` | `NOT RUN` |
| Logout | `NOT RUN` | `NOT RUN` | `BLOCKED` | `PARTIAL`: state/storage unit coverage only |
| Session restoration | `NOT RUN` | `PARTIAL`: release backup rules exclude credentials/preferences and allow only Drift restore; device restore smoke remains host/device evidence | `BLOCKED` | `PARTIAL`: policy/unit tests prove restoration is disabled; direct visible signed-out relaunch remains open in #160 |
| Relaunch | `PARTIAL`: online fresh browser load only | `PASS`: signed-out cold relaunch in 615 ms | `BLOCKED` | `PARTIAL`: process launch stable; visible signed-out screen pending |
| Visible copy / accessibility | `PARTIAL`: onboarding semantics visible | `PARTIAL`: onboarding semantics visible | `BLOCKED` | `PARTIAL`: widget coverage only |

Rows marked `NOT RUN`, `PARTIAL`, `FAIL`, or `BLOCKED` must be rerun through
the deterministic fixture tracked in
[#174](https://github.com/EmilGabibov/HABLE_Project/issues/174). A successful
compile never upgrades a runtime row to `PASS`.

### Intentional platform differences

| Difference | Reason and expected behavior |
|---|---|
| Local database | Web uses Drift's browser/SQL-Wasm executor; native targets use SQLite. All UI still reads through the same Riverpod/Drift model and sync contract. |
| Session persistence | Android, iOS, and Web retain their existing persisted-session behavior. macOS deliberately keeps auth in memory only, disables credential autofill, and requires explicit login after every app process launch ([#160](https://github.com/EmilGabibov/HABLE_Project/issues/160)). |
| Notifications | Web uses VAPID plus one app-scope service worker. Native targets use OS notification scheduling and lifecycle adapters. Every tap must still resolve once through the shared shell ([#163](https://github.com/EmilGabibov/HABLE_Project/issues/163)). |
| Background recap prefetch | Android may use Workmanager. The current iOS delayed-task assumption is unsafe and must be disabled or redesigned; macOS does not run Workmanager prefetch ([#169](https://github.com/EmilGabibov/HABLE_Project/issues/169)). |
| Back/navigation conventions | Android system back returns secondary tabs to Home before exit. Web paths require an auth-gated browser adapter. Apple targets retain native window/lifecycle conventions. |
| Flavor/package identity | Android and iOS retain `primary` and `friend` variants for the twin-app harness. macOS and Web ship one client identity. Flavor behavior must not fork backend contracts. |
| Release packaging | APK/AAB signing, Apple archive/notarization, and PWA deployment have different evidence, but every artifact must be traceable to one commit and explicit environment. |

### Child blocker ledger

| Issue | Lifecycle | Blocking scope |
|---|---|---|
| [#160](https://github.com/EmilGabibov/HABLE_Project/issues/160) | `engineered`; commit `77900a3`; direct UI smoke pending | macOS auto-login, Keychain prompts, and credential autofill |
| [#161](https://github.com/EmilGabibov/HABLE_Project/issues/161) | `proceeded`; commit `d016bb7` | PWA service-worker ownership, supported interop, offline shell |
| [#162](https://github.com/EmilGabibov/HABLE_Project/issues/162) | `proceeded`; commit recorded in GitHub | Browser-owned Quotable fallback removed; Flutter now reads Worker-synced Drift quote or first-party fallback |
| [#163](https://github.com/EmilGabibov/HABLE_Project/issues/163) | `proceeded` after commit | Exact-once notification/deep-link routing is owned by AppGate with bounded handoff |
| [#164](https://github.com/EmilGabibov/HABLE_Project/issues/164) | `proceeded` after commit | Android production signing fails closed; both flavor identities are checked before release evidence |
| [#165](https://github.com/EmilGabibov/HABLE_Project/issues/165) | `proceeded` after commit | Android backup/auth/local-data restore policy is explicit; device restore smoke remains release evidence |
| [#166](https://github.com/EmilGabibov/HABLE_Project/issues/166) | `proceeded` after commit | Android build/device/smoke tooling uses PATH/ANDROID_HOME discovery, explicit flavor/environment/device arguments, normal onboarding by default, and bounded sanitized evidence |
| [#167](https://github.com/EmilGabibov/HABLE_Project/issues/167) | `proceeded` after commit | iOS preflight/smoke pins the supported runtime, fails closed on unavailable destinations, and records bounded flavor launch evidence plus named fixture checkpoints |
| [#168](https://github.com/EmilGabibov/HABLE_Project/issues/168) | `proceeded` after commit | iOS flavor identities and display names are non-placeholder; shared Keychain group derives from final IDs; unsigned identity checks are static and protected archive validation is documented |
| [#169](https://github.com/EmilGabibov/HABLE_Project/issues/169) | `proceeded` after commit | iOS recap prefetch is disabled because the Apple adapter ignores requested delays; local reminders remain independent and Android-only prefetch has stable replacement identity |
| [#170](https://github.com/EmilGabibov/HABLE_Project/issues/170) | `proceeded` after commit | macOS permission/status use the Darwin local-notifications adapter, denied state opens System Settings, and reminder schedule/cancel identity remains deterministic |
| [#171](https://github.com/EmilGabibov/HABLE_Project/issues/171) | `proceeded` after commit | macOS Debug/Profile/Release entitlements are distinct; Release is hardened/manual-signing and `verify_macos_distribution.sh` fails closed on missing team, nested signature, Gatekeeper, or staple evidence |
| [#172](https://github.com/EmilGabibov/HABLE_Project/issues/172) | `proceeded` after commit | CI runs web/backend plus Android, Apple, and Windows compile gates; canonical web root and bounded provenance records are enforced; distribution remains secret-gated |
| [#173](https://github.com/EmilGabibov/HABLE_Project/issues/173) | `raw` | Friend-profile regression test failure |
| [#174](https://github.com/EmilGabibov/HABLE_Project/issues/174) | `raw` | Deterministic authenticated cross-platform smoke fixture |

### Evidence record for every rerun

Record these fields in #159 or its child before changing a matrix status:

1. Commit SHA, app version/build number, target/flavor, and artifact hash.
2. Flutter/Dart plus native toolchain/runtime/device identifiers.
3. Explicit `HABLE_APP_ENV` and sanitized configuration source; never log
   tokens, passwords, VAPID private material, certificates, or profiles.
4. Exact build and smoke commands, timestamps, pass/fail result, and the
   smallest relevant sanitized log/screenshot reference.
5. Offline/retry setup, fixture identity, cleanup result, and whether the test
   changed backend data.
6. Signing identity/team or an explicit `blocked`/ad-hoc result.

Do not mark #159 complete until every child is resolved or explicitly accepted,
all four targets compile from a clean checkout, every required flow row is
`PASS` (or a documented intentional difference with its own passing expected
behavior), and no verified path retains a crash, hang, blank state, infinite
loading state, data-loss risk, or unrecoverable authentication failure.

## 0. Android Online Connectivity Preflight

Use this before any presentation Android build. The goal is to confirm the APK can reach the deployed backend directly, not through local development plumbing.

1. Build the primary release APK with an explicit online target:
   `flutter build apk --release --flavor primary -t lib/main.dart --dart-define=HABLE_APP_ENV=production`
2. Confirm no `HABLE_API_BASE_URL` override points at `localhost`, `127.0.0.1`, `10.0.2.2`, or a LAN host.
3. Confirm `android/app/src/main/AndroidManifest.xml` declares `INTERNET` and `ACCESS_NETWORK_STATE`.
4. Install on a clean Android device/emulator without `adb reverse`:
   `adb install -r build/app/outputs/flutter-apk/app-primary-release.apk`
5. Clear stale state if the device previously ran debug builds:
   `adb shell pm clear com.hable.app.primary`
6. Launch the app and verify login/sign-up reaches `https://hable.pages.dev` directly. A release presentation smoke must not depend on local Wrangler, seeded debug users, or device port forwarding.

## 1. ADB Twin-App Smoke Test

> [!NOTE]
> For the standalone step-by-step operational guide (preferred for manual passes), see [`qa_twin_test_harness.md`](qa_twin_test_harness.md). This section documents the full checklist and execution history.

Because Hable involves mutual habit tracking and a offline-first sync engine, it is necessary to test interactions between two distinct users on physical hardware.

### Pre-requisites
1. A physical Android device connected via ADB (`adb devices`).
2. Cloudflare Worker backend running locally (`npm run dev` in `backend/`).
3. Local D1 schema applied: `npm run db:setup` in `backend/`.
4. Port forwarding active: `adb reverse tcp:8787 tcp:8787`.
5. Normal debug auth now resolves through the explicit backend-target contract: `HABLE_API_BASE_URL` override first, then `HABLE_APP_ENV` (`local`, `staging`, `production`), then fallback with debug/profile -> local and release -> production.
6. For the standard local twin pass, use `HABLE_APP_ENV=local`; add `--dart-define=HABLE_API_BASE_URL=...` only when targeting a non-default host such as `10.0.2.2` on an emulator.

### Execution
1. Install the primary app (Alice):
   `flutter build apk --debug --flavor primary --dart-define=HABLE_APP_ENV=local --dart-define=SEED_USER_ID=local-user-1 --dart-define=SEED_USERNAME=Alice`
   `adb install build/app/outputs/flutter-apk/app-primary-debug.apk`
2. Install the friend app (Bob):
   `flutter build apk --debug --flavor friend --dart-define=HABLE_APP_ENV=local --dart-define=SEED_USER_ID=local-user-2 --dart-define=SEED_USERNAME=Bob`
   `adb install build/app/outputs/flutter-apk/app-friend-debug.apk`

### Smoke Verification Checklist
- **Unauthenticated State:** Ensure logged-out users are routed to `AuthScreen` and cannot access Home, Profile, or Social Hub.
- **Friend Requests:** Use the search icon in the Social Hub header to open the Find Friends sheet, search for "Bob" (from Alice's app), send a friend request, verify the row flips to a pending outgoing state in place, revoke it from the same row, then send again and verify duplicate taps stay idempotent while the row action is in flight.
- **Request Actions:** In Bob's app, open Social Hub → Friends tab, verify inline pending request section shows Accept and Decline for incoming requests, and accept Alice's request for the main habit-sharing pass.
- **Habit Sync:** Create a new habit in Alice's app. Verify it syncs to the Cloudflare Worker.
- **Role Authorization:** After Bob accepts the habit invite, verify Alice can still edit/archive the shared habit, Bob can complete/skip it but cannot edit/archive it, and a future supporter account cannot complete/skip it.
- **Three-Tab Shell:** Verify authenticated users land in a shell with exactly Home, Social, and Profile as primary destinations. Android back from Social/Profile should return to Home before exiting.
- **New-User Onboarding Slides:** From a logged-out, non-seeded launch, verify the first surface is the research-backed onboarding slide sequence. Confirm the quote slide renders provider copy or fallback copy, Next advances through Mud resistance, first commit, partners, reminders, privacy, and no-skip framing, Log in routes directly to the login form, and Start setup routes to the sign-up form. Re-run with `SEED_USER_ID` and verify the auto-login skeleton bypasses the slides.
- **Home Habit Creation:** From Home, tap the persistent **Habit** FAB and verify it opens `HabitFormSheet`. In the empty state, tap **Add habit** and verify it opens the same sheet. After creating a habit, verify the suggested preset strip no longer crowds the active habit card.
- **Habit Form Contract:** In `HabitFormSheet`, verify create mode exposes the icon/title row, preset suggestions, a first-class description field, curated duration anchors (`21`, `33`, `40`), a bounded slider with a minimum of `1` day and a default of `21`, color selection, and friend chips with avatar emoji. Create a custom habit with a single-code-point and a ZWJ emoji, then reload/edit it and confirm the selected emoji remains in the central ring as well as round-tripping through the readable title. Confirm the reduced helper-copy hierarchy still reads clearly, that edit mode swaps to `Save changes` and hides partner invites, and that selecting a preset updates the title, default description, and duration without overwriting an already customized description unexpectedly.
- **Nested Settings:** From Profile, tap the gear icon and verify Settings opens with account/avatar, cloud activation, daily reminder, accessibility controls, language selection, and sign out. Settings must not appear as a fourth tab.
- **App Icon Contract:** Verify the installed launcher icon matches the latest `Developement/Resources/AppIcon - Hable.png` artwork on Android, iOS, macOS, Windows, and web/PWA entry points. On web, confirm the browser tab favicon is the regenerated small-size raster rather than a stale leftover from the prior JPEG-based pipeline.
- **Preset Habit Partner Invite:** Create a preset habit in Alice's app, select Bob from the accepted-friend chips, verify the queued habit sync runs before `sendHabitInvitation`, then open Bob's app and accept/decline the invitation banner. After either action, trigger or wait for a stale pending daily-sync response and confirm the banner does not reappear; after reconnect, confirm the queued action reaches the Worker and survives app restart.
- **Shared Check-In Retention:** After Bob accepts Alice's habit invite, have Bob complete the shared habit on his app. Verify Bob's shared habit card remains visible on Home after check-in instead of disappearing from active habits.
- **Solo Challenge Auto-Archive:** Complete the final remaining day on a solo habit and verify the card leaves Home, appears under Profile → Archived history, and still exposes history/rerun actions without affecting backend-owned achievement badges.
- **Nudges:** Tap the separate hand/nudge action on a partnered habit card to enqueue a habit-scoped nudge. Wait for background sync and verify the receiving twin app shows a card-local ring pulse/chip such as "Nudged by Alice" and also records the notification-center row.
- **Notification Center:** After sending a nudge, message, invite, or friend request, verify the receiver's Home bell switches to Social → Activity tab showing the event. Verify the unread badge clears after "Mark all read" is tapped.
- **Celebration Queue And Points Visibility:** Trigger a habit completion that also unlocks a badge, plus a second queued celebration if possible, and verify each overlay appears one at a time with an explicit `Continue` button rather than overlapping. Confirm the habit splash uses the habit color, shows `5 points earned` for a solo completion or `10 points earned` when the shared bonus lands, and that Profile → habit history shows the matching `+5 pts` / `+10 pts` badge on the completion row.
- **Score Surface Semantics:** Verify the leaderboard subtitle and rows read as lifetime-score surfaces, while Profile → Journey and habit-history labels read as per-check-in award surfaces. Do not expect a single `+5` or `+10` history badge to equal the full profile or leaderboard total.
- **Leaderboard & Score Coherence:** Complete at least one habit, pull `/api/sync/daily`, then open Profile, a friend profile, and Social → Leaderboard. Verify the backend-owned point totals stay coherent across all three surfaces and that replaying the same `log_id` does not increase score again.
- **Friend Profile Safe Visibility:** Open an accepted friend's profile and verify it shows only safe active-habit summaries, lifetime score/level, and compact backend-owned achievements. Confirm a non-friend cannot load the same payload, and verify the profile never exposes journal text, raw habit logs, or unrestricted third-party social graph data.
- **Daily Reminder:** From Profile, add two daily reminder times, grant OS permission, restart the app, and verify both settings persist locally and both schedules restore without another prompt. Delete one reminder and verify the remaining reminder still exists and still fires on its own schedule. Then disable the remaining reminder and verify its schedule is canceled.
- **macOS Signed-Out Relaunch And Credential Isolation:** On macOS, verify launch starts signed out without a Keychain prompt, auth fields do not offer platform credential autofill, and explicit login remains usable for the current process. Quit and relaunch, then verify the app returns to signed-out onboarding/login with no restored token, no credential prompt, and local Drift data still intact.
- **Safe Error Copy:** Trigger one backend validation error and one network-style failure. Verify the UI does not show raw `Exception(...)`, raw JSON bodies, `Failed to fetch`, backend URLs, stack traces, or route-specific server wording directly.
- **Localization Coverage:** Switch between English, German, Urdu, Russian, Tamil, and Persian/Farsi from Settings, then revisit Social → Friends/Activity/Leaderboard, Profile, friend profiles, reminder settings, accessibility settings, and habit-history sheets. Verify section headers, snackbars, tooltips, dialog buttons, semantics-backed labels, and relative-time copy re-render through `AppLocalizations` without obvious first-party English-only islands. For Urdu and Persian/Farsi, confirm mixed-direction rows stay readable and action chips/buttons do not overflow.
- **Localization batch:** Verify the completion, shared-completion, and Web Push reminder strings load from generated ARB localizations in English and RTL test coverage.
- **Cross-Platform Error Normalization:** On web or a browser-like failure path, verify fetch/CORS-style failures normalize to the same safe copy family used by mobile/desktop timeout or socket failures.
- **Offline-First Error Stability:** With cached local data already present, force a sync/read failure and verify the screen stays usable from Drift while showing only bounded recovery messaging.
- **Personalized Copy:** With a recent skipped day, verify the offline quote/reminder fallback shifts into comeback-style copy rather than generic rotation. With a recent partner nudge or partner completion activity, verify the fallback quote/reminder copy can switch to social-momentum wording while still staying deterministic for the same day.
- **Daily Quote Sync:** Pull `/api/sync/daily` and verify the response can include a normalized `quote.text` and optional `quote.author` from the Worker’s Quotable daily cache. Verify text exactly 180 Unicode code points is accepted and text at 181 is rejected before KV/Drift caching. Then restart offline and confirm Home/onboarding/first-run/completion quote surfaces preserve the author from Drift `cached_quotes`; simulate a missing or rejected Worker quote and verify deterministic fallback copy renders instead.
- **First-Run Quote Splash:** Sign in with a user who has not seen the startup quote splash yet and verify the app shows a dedicated quote-first opening screen before the main shell. Dismiss it once, relaunch with the same user, and confirm it does not repeat. While checking a habit completion splash, verify the quote now renders above the celebration headline rather than below it.
- **Universal Startup Splash:** Cold-launch while logged out, with a restored offline session, and with a deliberately slow web/version response. Verify the minimal Hable startup surface appears on the first Flutter frame, remains for at least 800 ms, fades exactly once only after auth and startup guards resolve, and never duplicates sync or the first-run quote splash. Repeat with reduced motion, high contrast, 200% text, German, and an RTL locale. Confirm Android/iOS native launch surfaces, macOS, Windows first-frame presentation, and web refresh/deep-link startup do not expose a blank interval; Windows compilation remains CI/Windows-host verified.
- **Social Recap Freshness:** With recent social events or partner check-ins available locally, run the social reminder prefetch path and verify the generated recap can summarize partner completion activity in addition to unread notification rows. Confirm development diagnostics stay at the coarse freshness-bucket level only.
- **Habit Dashboard:** From Home, open the dashboard via the grid icon and verify the app presents a dedicated habit dashboard rather than reusing the Home scroll path. On narrow widths it should stay single-column; on tablet/desktop widths it should expand to multiple columns with the summary rail/card remaining visible.
- **Shared Habit Card Surface:** Verify Home habit tiles and dashboard tiles still use the same interactive ring-first card behavior, then open Profile and a friend profile and confirm their active-habit cards reuse the same title/card chrome, surface the stored habit description when present, and avoid exposing Home-only completion actions in read-only contexts. Confirm Home/dashboard cards render an intentional low-opacity tint from the habit color without Material surface tint overpowering text or controls. On a `320px`-class mobile viewport, confirm two compact card shells are discoverable without a layout overflow, partner avatars remain inside their padded header zone, and descriptions do not cross the `120px` Mud-ring safe zone. Confirm the standard card settles from its brief green completion feedback to the configured habit color with a `12px` established ring, the footer progress bar is `8px`, and the `12px` day/streak labels do not overflow on narrow cards.
- **Nudge Authorization Rejection:** With an accepted friend who is not a participant in the selected shared habit, trigger or replay a stale queued nudge and verify the Worker returns 403, the local mutation is not retried on the next flush, and the UI does not claim the nudge was delivered. Confirm network/5xx failures remain retryable.
- **Profile History Expansion:** Open history from both active and archived/finished habits, verify recent completion/skip rows remain bounded and completion rows show their event-level points. Seed a legacy completed row with no stored points and verify the documented `+5 pts` fallback appears without changing lifetime score or achievement ownership.
- **Challenge Timeline Day:** On a finite-duration habit, verify `Day X of Y` remains stable before and after a same-day check-in and only advances after the next local calendar-day boundary. Verify the visible day label and the completion progress bar no longer move in lockstep.
- **Activity Feed Routing:** In Social → Activity, verify notifications are grouped into meaningful sections (`Unread`, `Today`, `Earlier`) instead of one flat list. Tap at least one notification with a home-linked payload and verify it returns to the relevant in-app destination rather than only marking the row as read.
- **Friend Profile Drilldown:** From a habit card, tap a partner identity and verify it opens the friend's profile. Tap the separate hand/nudge action and verify a `sendNudge` queue item is created for that partner without navigating away. From the friend profile, tap `Follow` on an active habit and verify `HabitFormSheet` opens with the title prefilled; tap encourage and verify it uses the same queued nudge path.
- **Partner Avatar Stack:** On a shared-habit card, verify the default partner surface is a compact overlapping avatar stack with bounded overflow. Confirm each avatar carries a mini status ring rather than a detached dot, that completed partners use the current habit color, and that long-pressing the stack still expands into per-partner rows with the same ring treatment while keeping profile-open taps distinct from the separate nudge button.
- **Mud Feel Tuning:** From Profile → Settings, open **Mud feel**, switch between Gentle, Standard, and Intense, and verify the hold duration changes while the ring widget continues consuming only provider-produced scalar values. Disable mud haptics, relaunch the app, and verify the same signed-in user keeps the selected preset and haptic toggle.
- **Completion Feedback Choreography:** Complete the same habit from Home and dashboard with each mud preset and verify the ring feedback uses the same `1200ms` window and standard/milestone haptic mapping. Disable haptics and enable reduced motion, then confirm completion still logs normally, no haptic is emitted, and the transient ring delay is removed while the serialized celebration overlay remains available.
- **Offline Sync Recovery:** Queue at least one outbound mutation while the network/API is unavailable, then restore connectivity and verify the queue drains without dropping later items behind the failed entry. After reconnect, verify transient invitation/request/nudge notifications that are no longer present in `/api/sync/daily` disappear from the local unread badge and invitation surfaces instead of lingering indefinitely.

*(Note: Automated Flutter `integration_test` scripts are currently known to time out during the ADB install phase on physical devices, so this manual twin-harness remains the primary smoke procedure for Android hardware.)*

### Automated Web E2E Alternative (Playwright)
To combat regressions without manual Android ADB passes, there is an automated Playwright suite located in the `e2e/` directory. It uses isolated browser contexts to simulate Alice and Bob interacting concurrently.
1. Ensure the Flutter web build is running locally (e.g. `flutter run -d web-server --web-port 8080`).
   Prefer `flutter run -d web-server --web-port 8080 --dart-define=HABLE_APP_ENV=local` for local Worker testing, or `--dart-define=HABLE_APP_ENV=production` when intentionally exercising the deployed backend from a local web shell.
2. Ensure the Cloudflare backend is running (`cd backend && npm run dev`).
3. Run the E2E suite:
   ```bash
   cd e2e
   npm run test
   ```
This test covers friend requests, shared habit invites, mutual completion holds, nudges, and score validation.
The current harness also includes a third isolated browser user so invite acceptance, nudge visibility, and friend-profile `Follow` flows can be exercised without reusing one of the partner sessions.
True native APNs/FCM delivery remains out of scope for this local/web harness. For PWA Web Push, deploy VAPID secrets (`VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`, `VAPID_SUBJECT`) and the dispatch token, open Profile → reminders in a supported HTTPS browser, grant permission from the explicit web-reminder button, verify the subscription upsert, send a bounded test reminder through the protected dispatch route, and click the notification to return to Home or Social. Verify denied/unsupported permission leaves local reminder settings intact and that 404/410 endpoints are removed.


## 2. ADB Smoke Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. **Unauthenticated Pass:** Clearing the app data and launching the app defaults to the `AuthScreen`. Without setting the test identities, the user cannot access the Home, Profile, or Social Hub screens, confirming that the unauthenticated gates work correctly.
2. **Primary (Alice) Pass:** 
   - Installed `app-primary-debug.apk` with `SEED_USER_ID=local-user-1`.
   - The app bypassed the Auth screen and successfully seeded the Drift DB.
   - Searching for "Bob" originally returned a 500 error due to a schema mismatch on the backend (the `total_score` column was missing in the local SQLite state).
   - After applying `ALTER TABLE users ADD COLUMN total_score INTEGER NOT NULL DEFAULT 0;` to the local D1 SQLite state, the search API successfully returned Bob.
   - Clicked "Add Friend", and the API successfully created a `pending` friend request.
3. **Friend (Bob) Pass:**
   - Installed `app-friend-debug.apk` with `SEED_USER_ID=local-user-2`.
   - Navigated to Social Hub -> Requests tab.
   - Alice's pending friend request successfully appeared in the UI.
   - Clicked "Accept", and the API successfully changed the friend request status to `accepted` in the database.

**Failures Encountered & Resolved:**
- **Android Auto Backup policy:** Release manifests explicitly allow only Drift database restoration for later explicit-login reconciliation and exclude SharedPreferences/files/root/external storage. Credentials are not restored as auth state. Validate clean install, restored database without credentials, expired session, logout, and account-switch behavior on a device before changing this policy.
- **D1 Schema Mismatch:** The local D1 state was missing the `total_score` column added in a recent task. Resolved by manually applying the ALTER TABLE statement to the local `.wrangler` state files.

- The `.gitignore` was missing `backend/.wrangler/` and `.env`. These have been appended to prevent committing local database states and environment variables.

---

## 3. ADB 3D Environment & Inbox Features Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. **App Installation & Startup:**
   - Both `app-primary-release.apk` (Alice) and `app-friend-release.apk` (Bob) were successfully built and installed over ADB.
   - Using `adb reverse tcp:8787 tcp:8787`, both instances successfully connected to the local Cloudflare D1 environment.
2. **3D Abstract Habit Environment:**
   - Evaluated the `HomeScreen` UI. The new `HabitEnvironmentVisualizer` is now successfully rendered on the homescreen above the invitation banner.
   - Rendering verified: The `CustomPainter` efficiently renders the pseudo-3D abstract space on the physical Android device without significant UI thread locking or jitter.
    - The newly merged **Activity** tab (Social → Activity) serves as the unified notification and message feed. The former **Inbox** tab is no longer a standalone surface.
   - The **Find Friends** search is now a bottom sheet triggered by the search icon in the Social header, no longer a separate tab.
4. **Overall Pass:** 
   - All newly built features are integrated successfully into the primary app flow, meeting the multi-user social features acceptance criteria.

---

## 4. ADB Preset Habit Invite Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. Applied `backend/schema.sql` with `npm run db:setup`, then launched local Wrangler on `127.0.0.1:8787`.
2. Built and installed `primary` as Alice and `friend` as Bob with the seed-user dart defines.
3. Alice opened Home, pulled `/api/sync/daily`, and the habit creation sheet showed shared standard presets, a `21` day duration, and Bob as an accepted-friend partner chip.
4. Alice selected Bob and saved the Hydration preset. Device logs showed `POST SYNC_HABIT successful` followed by `POST HABIT_INVITATION successful`.
5. Bob opened the friend app, pulled `/api/sync/daily`, saw the invitation banner, accepted it, and device logs showed `POST ACCEPT_INVITATION successful`.
6. API verification after accept showed no pending invitations and symmetric partner visibility for the Hydration habit with `target_duration = 21`.

**Backend hardening checks:**
- Duplicate pending habit invite returned the same invitation id.
- Self-invite returned HTTP `400`.
- Non-friend invite returned HTTP `403`.

---

## 5. ADB Home Habit Creation Test Execution Log

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Observations:**
1. Built and installed `app-primary-debug.apk` with Alice seed defines, cleared app data, and launched Home.
2. Verified the authenticated shell exposes Home, Social, and Profile as primary destinations.
3. Tapped the Home **Habit** FAB and confirmed it opens the shared `HabitFormSheet`.
4. Closed the sheet, tapped the empty-state **Add habit** button, selected the Hydration preset, and saved.
5. Verified the new Hydration habit appeared immediately through local Home state and the suggested preset strip no longer rendered above the active habit card.
6. Device logs showed `POST SYNC_HABIT successful`; no Flutter `RenderFlex` overflow was present in the Home creation flow.

## 6. Cloudflare Pages Web Smoke Test

**Date:** 2026-07-09
**Target:** `https://hable.pages.dev`

**Build/Deploy:**
1. Built the web bundle from the repo root with `flutter build web --release --base-href /` and prepared the finite shell list with `node scripts/prepare_web_service_worker.mjs`.
2. Deployed from `backend/` with `wrangler pages deploy ../build/web --project-name hable --branch main --commit-dirty=true --cwd backend`.
3. Confirmed the live production alias eventually served the new deployment after propagation.

**Smoke Verification Checklist:**
- Opening `https://hable.pages.dev` returns the Flutter shell with the `Hable` title and manifest metadata.
- `POST /api/auth/register` returns a JWT and seed user payload on the deployed origin.
- `POST /api/sync/habit` accepts an authenticated habit write.
- `GET /api/sync/daily` returns the expected JSON payload from the deployed origin.
- The production alias is the one exercised by the browser/web smoke flow, not the local Wrangler dev server.

**Notes:**
- The first direct upload produced a preview URL, but the production alias updated after propagation.
- Remote D1 schema had to be synchronized with `backend/schema.sql` before habit sync smoke tests passed.

## 8. Local Worker RBAC Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Pre-step for old local D1 state:** If `npm run db:setup` fails with `no such column: role`, run:
`npx wrangler d1 execute hable_db --local --command "ALTER TABLE partnerships ADD COLUMN role TEXT NOT NULL DEFAULT 'partner';"`
Then rerun `npm run db:setup`.

**Executed checks:**
1. Logged in seeded `local-user-1` and `local-user-2` through `POST /api/auth/login`.
2. Sent and accepted a friend request, created `role-habit-1` as Alice, invited Bob, and accepted the invite as Bob.
3. Verified Bob receives `403` on `POST /api/sync/habit` for the shared habit, while Alice can archive it successfully.
4. Verified Bob receives `200` on `POST /api/sync/log` for the shared habit.
5. Registered `CharlieRole`, inserted a `supporter` partnership row locally for the same habit, and verified Charlie receives `403` on `POST /api/sync/log` but `200` on `POST /api/social/nudge`.

**Outcome:** Owner edit/archive, partner log, partner edit rejection, supporter log rejection, and supporter nudge authorization all matched the RBAC contract.

## 9. Local Worker Gamification Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Executed checks:**
1. Logged in seeded `local-user-1` and `local-user-2`, captured each user's initial `/api/sync/daily.gamification.total_points`, then created a unique shared habit from Alice.
2. Alice completed the habit once and replayed the same `log_id`; the replay returned `accepted: false`.
3. Bob accepted the habit invite, completed the same habit for the same date, and replayed the same `log_id`; the replay returned `accepted: false`.
4. Bob skipped the habit on a later date; skip was accepted but did not add points.
5. Bob nudged Alice and received `first_nudge`; both users received `first_check_in`.
6. Posting to deprecated `/api/sync/score` returned HTTP `410`.

**Outcome:** Alice and Bob each gained exactly `10` points from one completed check-in plus one shared-habit bonus. Duplicate log replays did not change the score, and `/api/sync/daily` returned `gamification.level`, `badges`, and `newly_unlocked_badges`.

## 10. Widget Smoke For Role-Aware Partner Row

**Date:** 2026-07-11  
**Target:** Flutter widget test

**Executed checks:**
1. Rendered `HabitPartnerRow` with five mixed-role partner snapshots.
2. Verified only four visible partner chips render, with the fifth collapsed into a `+1` overflow chip.
3. Verified visible role copy still renders (`owner`) so the chip exposes role state even when avatar-only space is tight.

**Outcome:** The per-card partner row preserves the avatar cap and overflow behavior required for narrow layouts without depending on network state.

## 13. Three-Tab IA Widget Smoke

**Date:** 2026-07-11  
**Target:** Flutter widget test

**Executed checks:**
1. Rendered `MainNavigationShell` with an in-memory Drift database.
2. Verified the shell exposes Home, Social, and Profile in the primary `NavigationBar`.
3. Verified the Home **Habit** FAB opens `HabitFormSheet`.
4. Verified switching to Social exposes three internal tabs: **Friends**, **Activity**, and **Leaderboard**.
5. Verified the **Find Friends** search icon is present in the Social header.
6. Verified switching to Profile exposes the settings gear.
7. Verified Android back from non-Home returns to Home.

**Outcome:** The refined three-tab IA with reorganized Social (3 sub-tabs, inline requests, Activity feed, Find Friends sheet) is covered at the widget level.

## 12. Shared Habit Retention And Nudge State Smoke

**Date:** 2026-07-11  
**Target:** Flutter database/widget tests plus backend type-check

**Executed checks:**
1. Verified `completeHabitDay(..., keepActiveWhenDurationEnds: true)` leaves a partner-side shared habit active at zero remaining days so `watchActiveHabits` keeps rendering the card.
2. Verified `markPartnerNudgeReceived` coalesces repeated nudges into the same `PartnerSnapshots.lastNudgeAt` row for a sender/habit without touching unrelated shared habits.
3. Verified `HabitPartnerRow` renders a visible `nudged` state for a recent `lastNudgeAt`.
4. Type-checked the Cloudflare worker after adding optional `habit_id` nudge payload support.

**Outcome:** Shared cards stay visible after partner check-in, received nudges have a durable local Home-card state, and repeated sender/habit nudges stay bounded.

## 14. Local Worker Friend Request Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Commands/Checks:**
1. Ran `npm run db:setup` in `backend/`.
2. Started local Worker with `npm run dev`.
3. Ran `npm run smoke:social`.
4. Ran `npm run smoke:lifecycle`.

**Coverage verified:**
- Fresh-user social smoke registered two users, verified privacy-safe search fields and relationship state, rejected self-request, kept duplicate pending sends idempotent, listed incoming requests, declined, resent, accepted, and verified accepted-state search.
- Lifecycle smoke still passed after idempotent friend-request handling, including shared normal habit sync, shared multi-day habit sync, Bob-owned habit visibility, owner-only metadata update rejection, archive propagation, and private habit exclusion.
- Flutter verification covered `friend_relationships` cache behavior with `test/friend_relationship_cache_test.dart`, plus the full `flutter test` suite.

**Android twin-harness follow-up:** Later on 2026-07-11, `emulator-5554` became available through the SDK-local `adb` binary. Re-applied `adb reverse tcp:8787 tcp:8787`, rebuilt `app-primary-debug.apk` and `app-friend-debug.apk` with seeded Alice/Bob identities, installed both packages, and launched both flavors. Android UI hierarchy dumps confirmed Alice and Bob each reached Home with the reciprocal shared `Hydration` card, partner identity, FAB, and Home/Social/Profile shell. MobAI MCP tools were still not exposed, so validation used `adb` launch plus UI hierarchy evidence instead of MobAI DSL.

## 15. Account And Social API Regression Smoke

**Date:** 2026-07-11  
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8787`

**Commands/Checks:**
1. Ran `flutter analyze`.
2. Ran `flutter test`.
3. Ran `npx tsc --noEmit` in `backend/`.
4. Ran `npm run db:setup` in `backend/`.
5. Started local Worker with `npm run dev`.
6. Ran `npm run smoke:regression`.

**Coverage verified:**
- Username/password registration returned JWT/user payloads, and case-insensitive username login returned the same user.
- Authenticated Profile activation PIN request completed in local development and printed the PIN to Wrangler logs.
- Emoji avatar update succeeded, and URL/non-emoji avatar update was rejected by the Worker.
- Friend search returned privacy-safe state, friend request/accept worked, and leaderboard returned the current user plus accepted friend instead of hanging.
- Created a shared habit, accepted the invite, sent a habit-scoped nudge, and verified the receiver's `/api/sync/daily` payload contained the nudge.

**Outcome:** PASS. The route/method regressions covered by the task now resolve to successful data paths or clear 400/error responses instead of 405s, ambiguous API failures, or indefinite loading.

## 16. Skeleton Empty State Widget Smoke

**Date:** 2026-07-11  
**Target:** Flutter widget tests

**Commands/Checks:**
1. Ran `flutter analyze`.
2. Ran `flutter test test/skeletons_test.dart`.
3. Ran full `flutter test`.

**Coverage verified:**
- Added reusable skeleton blocks/cards/lists and structured empty-state cards.
- Verified the empty-state card scrolls instead of overflowing in a short viewport.
- Existing shell, notification, profile CRUD, partner row, leaderboard, and app-launch tests all pass with the skeleton replacements.

**Outcome:** PASS. Main loading states now preserve screen shape with skeletons or structured empty cards instead of abrupt full-screen spinners/blank gaps.

## 7. Android Web-Era Regression Smoke

**Date:** 2026-07-09
**Device ID:** `wsgagamfkzealzeq` (Physical Device)
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Build/Install:**
1. Ran `flutter analyze` and `flutter test` from the canonical `Flutter/hable` app. Both passed after a small async-context fix in `lib/screens/social/social_hub_screen.dart`.
2. Built fresh debug APKs:
   - `flutter build apk --debug --flavor primary --dart-define=SEED_USER_ID=local-user-1 --dart-define=SEED_USERNAME=Alice`
   - `flutter build apk --debug --flavor friend --dart-define=SEED_USER_ID=local-user-2 --dart-define=SEED_USERNAME=Bob`
3. Installed both APKs with `adb install -r` and set `adb reverse tcp:8787 tcp:8787`.

**Smoke Verification Checklist:**
- The `primary` APK launches on the device and shows Alice's Home screen.
- Social Hub opens from Home and renders the accepted-friends cache, including Bob.
- The `friend` APK launches on the same device and shows Bob's Home screen.
- The friend flavor uses the native Android database path and does not crash on startup after the web-specific database split.
- The shared Android flows continue to work after the web deployment work: Home rendering, social navigation, and flavor-specific installs.

**Notes:**
- The historical run used an SDK-local `adb` because it was not on PATH; the
  current portable harness resolves `adb` from PATH, `ANDROID_HOME`, or
  `ANDROID_SDK_ROOT` and requires an explicit device when discovery is not
  unambiguous.
- The Android smoke did not require any web-only assets; the shared code path remained compatible with Android.

## 11. ADB Fresh Registration Smoke Test (Emulator)

**Date:** 2026-07-11  
**Device ID:** `emulator-5554` (Google Emulator, Android 17 API 37)  
**Backend Target:** Local Cloudflare Wrangler (`http://127.0.0.1:8787` via `adb reverse`)

**Setup:**
1. Started backend: `cd backend && npm run dev` on port 8787.
2. Configured ADB port forward: `adb reverse tcp:8787 tcp:8787`.
3. Cleared primary app data: `adb shell pm clear com.hable.app.primary`.
4. Verified both APK flavors installed: `com.hable.app.primary` and `com.hable.app.friend`.

**Execution & Observations:**

**Phase 1: Backend Connectivity**
- Initial app launch showed "Cannot reach the backend at http://10.0.2.2:8787" error (expected without reverse forward or prior restart).
- After `adb reverse tcp:8787 tcp:8787` and restarting the app, error cleared immediately.
- Backend health confirmed: `curl http://127.0.0.1:8787/` returned Hable API landing page.

**Phase 2: Unauthenticated State**
- Fresh app install landed directly on `AuthScreen`.
- UI hierarchy confirmed: Username field, Password field, "Forgot Password?" button, "Log In" button, "Sign up" toggle.
- Logged-out users cannot access Home, Profile, or Social Hub; gating works correctly. ✅

**Phase 3: Registration & Auth Flow**
- Tapped "Sign up" button -> Registration form appeared with Username and Password fields.
- Entered credentials: `testuser_smoke1` / `TestPass123`.
- Tapped "Sign Up" → Request sent to backend, registration completed in ~2 seconds.
- Post-registration: App automatically routed to `HomeScreen` without requiring manual login. ✅

**Phase 4: Authenticated Home & UI**

## 12. Anonymous Usage Diagnostics Checks

**Date:** 2026-07-11  
**Targets:** Flutter unit test + backend TypeScript compile

**Executed checks:**
1. Ran `flutter analyze` from the app root and verified the diagnostics additions introduced no analyzer issues.
2. Ran `flutter test test/usage_diagnostics_service_test.dart`.
3. Ran `npx tsc --noEmit` in `backend/`.

**Coverage verified:**
- `UsageDiagnosticsService` records only aggregate counters (`app_open`, `screen_visit`) and rounded visible duration totals.
- Visible duration rounds to 5-second buckets before persistence.
- Upload payload generation omits user/account/device identifiers and auth fields.
- Remote upload does not run unless explicitly enabled.
- Worker-side development routes typecheck cleanly after adding `usage_aggregate_buckets` handling and the aggregate HTML/JSON report surface.
- Home screen displayed with:
  - Welcome message "Good morning" ✅
  - User display name: `testuser_smoke1` ✅
  - Three suggested habit presets: Hydration (💧), Reading (📖), Meditation (🧘) ✅
  - "Add habit" button in header ✅
  - "Open profile" button ✅
  - "Open social hub" button ✅
  - Empty state message: "No active habits yet. Start one from Home." ✅
  - Daily quote footer ✅

**Phase 5: APK Flavor Isolation**
- Both flavors remain installed and isolated:
  - `com.hable.app.primary` (package: `...primary`) ✅
  - `com.hable.app.friend` (package: `...friend`) ✅
- Each maintains separate local Drift database (verified via app data paths).

**Failures Encountered:** None. All core flows passed without errors.

**Repo Hygiene:**
- `.gitignore` already contains `backend/.wrangler/` and `.env` to prevent committing local state. ✅
- No new untracked generated files discovered.

**Smoke Pass Conclusion:** ✅ PASS

All acceptance criteria met:
- Unauthenticated users gate to AuthScreen only.
- Authenticated users access Home, Profile, Social Hub.
- Backend connectivity via `adb reverse` successful.
- Registration end-to-end flow confirmed.
- Both `primary` and `friend` flavors installed side-by-side with isolation.
- `.gitignore` properly configured.

## 12. Auth Repair And Profile Activation Smoke

**Date:** 2026-07-11
**Target:** Local Pages Functions Worker on `http://127.0.0.1:8788` because port `8787` was already occupied by another local process.

**Commands/Checks:**
- Ran `npm run db:setup` to apply `backend/schema.sql` locally.
- Ran `npx wrangler pages dev public --port 8788`.
- Verified `POST /api/auth/register` accepts username/password only and returns JWT/user payload.
- Verified `POST /api/auth/login` accepts uppercase username input for the same stored lowercase username.
- Verified browser CORS preflight for `Origin: http://localhost:59999` returns `Access-Control-Allow-Origin`.
- Verified authenticated `POST /api/user/email/request-pin` prints a development Profile Activation PIN locally.
- Verified authenticated `POST /api/user/email/verify-pin` stores `email` and `email_verified_at`.
- Verified `POST /api/auth/request-pin`, `POST /api/auth/reset-password`, and login with the changed password for the activated email.

**Outcome:** PASS. Signup no longer requires email, username login is case-insensitive, Profile owns optional email/PIN activation, and password reset works after activation.

## 13. Production Auth Deployment Repair

**Date:** 2026-07-11
**Target:** `https://hable.pages.dev`

**Issue reproduced:**
- `POST /api/auth/register` returned `405` with an empty body on production.
- `POST /api/auth/login` returned `405` with an empty body on production.
- `OPTIONS /api/auth/register` returned `405`, so browser CORS preflight could fail before app auth requests.
- `POST /api/user/email/request-pin` reached the function after redeploy but returned `502` because production email delivery was not configured for Hable.

**Repair:**
- Ran `npx wrangler d1 execute hable_db --remote --file=./schema.sql`.
- Ran `npm run deploy` from `backend/` so Pages Functions were deployed with the API bundle.
- `sendPinEmail` now uses Hable's direct Cloudflare Email Sending path with `PRIVATE_EMAIL_SENDER_HABLE`, `CLOUDFLARE_ACCOUNT_ID`, and `PRIVATE_CLOUDFLARE_EMAIL_API_TOKEN`.
- Added a Doppler-to-Pages secret sync helper so the email secrets can be pushed into the Hable Pages project from `hable/dev`.

**Production checks:**
- `POST https://hable.pages.dev/api/auth/register` returned `200` and a JWT/user payload.
- `POST https://hable.pages.dev/api/auth/login` returned `200` and a JWT/user payload.
- `OPTIONS https://hable.pages.dev/api/auth/register` returned `204` with `Access-Control-Allow-Methods: GET,POST,PUT,DELETE,OPTIONS`.
- Authenticated `POST https://hable.pages.dev/api/user/email/request-pin` returned `200` with `Verification PIN sent`.
- `POST https://hable.pages.dev/api/auth/request-pin` returned `200` with `Verification PIN sent` for an account with an attached email.

**Outcome:** PASS. The reported production 405 auth failures and production PIN delivery failure are repaired.
