# 09: Cross-Platform Build Integrity Guideline (AI Agent Workflow)

This document provides explicit guidelines for AI Agents on how to investigate and repair build failures across Hable's target platforms: Web, iOS, Android, macOS, and Windows. 

The goal is to maintain a disciplined, sequential workflow that prevents build-archaeology tasks from spiraling into unbounded, multi-platform repair sessions.

## 1. Investigation Order & Prioritization

When a cross-platform or general dependency update causes build failures, always investigate in the following order:

1. **Web (Highest Priority)**
   - **Reasoning:** The Web build is the primary target for Hable's serverless Cloudflare Pages deployment. It must compile successfully for the CI/CD pipeline to deploy. Furthermore, because Hable uses `sql-wasm` for Drift in the browser, web build failures often highlight the most rigid dependency constraints.
   - **Action:** Fix Web first before progressing to other platforms.

2. **Android & iOS (Mobile)**
   - **Reasoning:** These are the primary application targets. They rely on different toolchains (Gradle/Java/Kotlin vs. Xcode/CocoaPods) and use different offline SQLite binaries than the web target.
   - **Action:** Can be investigated sequentially once Web is stable.

3. **macOS & Windows (Desktop)**
   - **Reasoning:** These are secondary desktop targets.
   - **Action:** macOS can be verified locally on a Mac host. Windows can **only** be built/verified on a Windows host or CI runner; AI Agents operating from a macOS host must flag Windows checks as host-limited follow-ups or rely on CI.

## 2. Web Build Investigation Workflow

**Constraint:** The web build is tightly coupled to Cloudflare Pages.
- **Analyzer gate:** `flutter analyze --no-fatal-infos --fatal-warnings`
- **Analyzer policy:** Informational diagnostics remain visible in CI logs, but
  only warnings and errors fail the shared Flutter job.
- **Command:** `flutter build web --release --base-href / --dart-define=HABLE_APP_ENV=production` (or another explicit environment override when intentionally targeting non-production).
- **Workflow:** 
  1. Run the build command.
  2. If it fails, capture the exact error output in the current task's completion notes or walkthrough.
  3. Resolve the dependency, package version, or Dart compilation error.
  4. Verify the build succeeds locally. Note: A successful local build does not guarantee the Pages deployment smoke test will pass, but it is the prerequisite.

### Backend Targeting Contract

All Flutter builds should resolve backend targets through the central `lib/config/api_config.dart` contract:

1. `HABLE_API_BASE_URL` manual override wins for unusual smoke setups.
2. `HABLE_APP_ENV` selects an environment preset: `local`, `staging`, or `production`.
3. If neither define is supplied, debug/profile builds fall back to `local` and release builds fall back to `production`.

`staging` is valid even if Hable does not yet have a permanent staging alias. In that case it deterministically falls back to production unless `HABLE_STAGING_API_BASE_URL` is provided.

## 3. Concurrency Rules & Branching

**Do NOT attempt to fix all platforms in a single "omnibus" execution step.**

- **Web-First Stabilization:** Once the web build is stabilized and compiles successfully, **STOP**. Record the evidence in the current GitHub issue and leave native gaps in focused child issues.
- **Separation of Concerns:** If a single dependency change (e.g., upgrading a package to fix the web build) breaks Android or iOS, **DO NOT** fix the Android/iOS failure in the same task *unless* the fix is trivially shared (like bumping a core Dart package version). 
- **Branching:** If a platform requires specific native adjustments (for example, Android SDK targets or iOS Pod/Xcode settings), record the finding and open a focused raw GitHub child issue under `Developement/ai_agent_contract.md`.
- **Host Limitations:** If the host environment does not support building a platform (e.g., compiling Windows from macOS), explicitly document this host limitation in the task notes and mark the task as "Blocked on Environment" rather than indefinitely retrying impossible commands.

## 4. Platform-Specific Constraints & Evidence Capture

### Startup continuity

The shared Flutter startup surface is the cross-platform continuity layer.
Android and iOS already provide non-blank native launch surfaces, Windows keeps
its window hidden until Flutter's first frame, and macOS/web hand off directly
to that first frame. Keep native launch files minimal; do not duplicate auth,
sync, timing, localization, or animated splash logic per platform. If native
branding is expanded later, track it as a separate platform task.

When investigating and fixing platform builds, agents must adhere to Hable-specific constraints:

### Android
- **Constraints:** Hable uses a multi-flavor architecture (`primary` and `friend`).
- **Verification Commands:** 
  - `flutter build apk --release --flavor primary -t lib/main.dart --dart-define=HABLE_APP_ENV=production`
  - `flutter build apk --release --flavor friend -t lib/main.dart --dart-define=HABLE_APP_ENV=production`
- **Evidence:** Record success/failure logs and artifact hashes for both flavors. Inspect both certificates with `apksigner`; a release APK signed by `Android Debug` is a failed distribution gate even when compilation succeeds.
- **Built-in Kotlin audit (2026-07-16):** Both release flavors build successfully with AGP `9.2.1`, Kotlin `2.3.20`, and Gradle `9.6.1`, but Flutter still warns that `flutter_timezone 5.1.0` and `workmanager_android 0.9.0+2` apply KGP. `flutter pub outdated` reports no newer compatible releases, so `android.builtInKotlin` remains `false` and an upstream plugin report is required before enabling it.
- **Local smoke note:** For local Wrangler testing keep `HABLE_APP_ENV=local` and use `HABLE_API_BASE_URL` only when the device cannot reach `127.0.0.1:8787` directly (for example Android emulator `10.0.2.2`).

### iOS
- **Constraints:** iOS builds depend on CocoaPods and Xcode. `sql_wasm` does not apply here; it uses the native `sqlite3` plugin.
- **Verification Commands:** `flutter build ios --release --no-codesign --flavor primary -t lib/main.dart --dart-define=HABLE_APP_ENV=production` and the matching `friend` command. `--no-codesign` verifies compilation only; it does not prove archive identity or distribution signing.
- **Evidence:** Record Xcode version, installed platform/simulator runtimes, eligible destination, flavor identity, and `pod install` output when dependencies change. No eligible destination is `blocked`, not `pass`.

### macOS
- **Constraints:** macOS relies on desktop entitlements, pods, configuration-specific signing, and notarization. Current auth is intentionally process-local and must not access Keychain or credential autofill; every new process starts signed out.
- **Verification Commands:** `flutter build macos --release --dart-define=HABLE_APP_ENV=production`, followed by entitlement inspection, `codesign --verify --deep --strict --verbose=4`, and `spctl -a -vv` against the built app.
- **Evidence:** Record bundle/version, executable hash, effective entitlements, signature/team identity, Gatekeeper result, launch/relaunch behavior, and any permission failure. Compilation with an ad-hoc signature is only a local build pass.
- **Local Release Builds:** Do not edit entitlements temporarily to force a pass. Preserve the real project configuration and report missing identities, invalid nested code, Gatekeeper rejection, or notarization limits as release blockers.

### Windows
- **Constraints:** Cannot be compiled from a macOS host.
- **Verification Commands:** `flutter build windows` (Only on Windows host).
- **Evidence:** If running on a Mac host, document the OS mismatch. Do not attempt to run this command.

## 5. Documenting Fixes
For current work, record each platform failure in a focused GitHub child issue
under `Developement/ai_agent_contract.md`; do not append new work to the legacy
`Task1_Engineered.md` ledger. The engineered issue completion reply must include:
1. The exact command run.
2. A summary of the failure (if any).
3. The exact file changes made to fix it (e.g., `android/app/build.gradle` SDK version bump).
4. The confirmation of the successful build log.
5. Notes on downstream platform impact and any new focused raw child issue.

## 6. Current CI Gate And Target Release Matrix

Do not infer automation from this document. The workflow file is the source of
truth. As verified on `2026-07-16`, `.github/workflows/ci.yml` contains:

- **Flutter / Ubuntu:** `flutter pub get`, analyzer with fatal warnings,
  `flutter test --coverage`, and the production Web release build.
- **Backend / Ubuntu:** `npm ci` and `npx tsc --noEmit` on Node.js 22.

It does **not** currently compile Android, iOS, macOS, or Windows, publish a
Pages preview, inject Android signing material, or validate Apple signing. The
native matrix previously described here was a target design, not implemented
behavior. Restoring that matrix and commit-traceable artifacts is tracked in
[#172](https://github.com/EmilGabibov/HABLE_Project/issues/172).

### Target matrix

| Target | Required runner and bounded gate | Signing/publishing boundary |
|---|---|---|
| Web/PWA | Ubuntu: analyzer, unit/widget tests, production web build, deterministic isolated smoke | Publish one `build/web` artifact only after required gates; record source/deployment revision |
| Android | Ubuntu: compile primary and friend release artifacts, inspect package identity and certificate | Inject production keystore only in protected release jobs; fail closed when absent |
| iOS | macOS: pin Xcode/platform, compile primary and friend without signing, run deterministic simulator smoke | Archive/export only in protected jobs or operator workflow with profiles |
| macOS | macOS: release compile, entitlement/signature inspection, fixture smoke | Developer ID/App Store signing and notarization remain secret-gated |
| Windows | Windows: release compile and bounded smoke | Installer signing remains secret-gated |

### Environment and artifact contract

- Every release build passes an explicit `HABLE_APP_ENV`; unusual endpoints use
  the central override contract and must be recorded in sanitized evidence.
- Production deployment uses exactly one Flutter artifact root. Do not deploy
  stale `backend/public` assets as the client release.
- Record commit SHA, version/build number, artifact hash, toolchain/runtime,
  flavor, target environment, and signing result. Never record secrets,
  passwords, tokens, keystores, certificates, or provisioning profiles.
- Local build success and CI success are separate evidence fields. A platform
  with no runner/destination remains `blocked` or `not run`.

### Backend Toolchain Dependency Updates
The backend Cloudflare toolchain keeps `wrangler` and
`@cloudflare/workers-types` in the Dependabot `cloudflare-worker-toolchain`
group. Review these updates together because Wrangler major releases can require
matching Workers type ranges, and split PRs can fail `npm ci` before backend
type-checking begins.

### Excluded Scope (Future Splits)
The following remain manual or handled by focused follow-up tracks:
1. Automated App Store Connect or Google Play Console submission.
2. macOS developer certificate notarization.
3. Complex end-to-end device farm UI testing.
