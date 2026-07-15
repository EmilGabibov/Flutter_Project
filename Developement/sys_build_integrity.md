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

- **Web-First Stabilization:** Once the web build is stabilized and compiles successfully, **STOP**. Record the fix in the current task (e.g., `[Verify Web Build Integrity](Task1_Engineered.md#verify-web-build-integrity)`).
- **Separation of Concerns:** If a single dependency change (e.g., upgrading a package to fix the web build) breaks Android or iOS, **DO NOT** fix the Android/iOS failure in the same task *unless* the fix is trivially shared (like bumping a core Dart package version). 
- **Branching:** If a platform requires specific native adjustments (e.g., changing Android SDK targets, updating Podfiles), log those findings and open or transition to the dedicated platform task in `Task1_Engineered.md` (e.g., `Verify Android Build Integrity`).
- **Host Limitations:** If the host environment does not support building a platform (e.g., compiling Windows from macOS), explicitly document this host limitation in the task notes and mark the task as "Blocked on Environment" rather than indefinitely retrying impossible commands.

## 4. Platform-Specific Constraints & Evidence Capture

When investigating and fixing platform builds, agents must adhere to Hable-specific constraints:

### Android
- **Constraints:** Hable uses a multi-flavor architecture (`primary` and `friend`).
- **Verification Commands:** 
  - `flutter build apk --flavor primary -t lib/main.dart --dart-define=HABLE_APP_ENV=production`
  - `flutter build apk --flavor friend -t lib/main.dart --dart-define=HABLE_APP_ENV=production`
- **Evidence:** Record success/failure logs for both flavors. Address any signing or keystore issues if release builds are requested.
- **Local smoke note:** For local Wrangler testing keep `HABLE_APP_ENV=local` and use `HABLE_API_BASE_URL` only when the device cannot reach `127.0.0.1:8787` directly (for example Android emulator `10.0.2.2`).

### iOS
- **Constraints:** iOS builds depend on CocoaPods and Xcode. `sql_wasm` does not apply here; it uses the native `sqlite3` plugin.
- **Verification Commands:** `flutter build ios --no-codesign --flavor primary -t lib/main.dart` (Note: `--no-codesign` allows testing compilation without provisioning profiles on the local agent host).
- **Evidence:** Record `pod install` output if dependencies are updated. Document any Xcode/Swift version incompatibility.

### macOS
- **Constraints:** macOS relies on desktop entitlements and pods. Local ad-hoc signing (`-`) does not support the `keychain-access-groups` entitlement present in `Release.entitlements`.
- **Verification Commands:** `flutter build macos` (uses debug). For release performance testing locally, prefer `flutter build macos --profile`.
- **Evidence:** Document any permission/entitlement failures. Ensure local SQLite binaries link correctly.
- **Local Release Builds:** If a local operator strictly requires `flutter build macos --release` without a valid Apple Development Certificate, they must temporarily remove the `keychain-access-groups` key from `macos/Runner/Release.entitlements` during compilation and avoid committing that change. Production distribution requires this entitlement.

### Windows
- **Constraints:** Cannot be compiled from a macOS host.
- **Verification Commands:** `flutter build windows` (Only on Windows host).
- **Evidence:** If running on a Mac host, document the OS mismatch. Do not attempt to run this command.

## 5. Documenting Fixes
When checking off one of the pre-engineered tasks from `Developement/Task1_Engineered.md` (e.g. `Verify iOS Build Integrity`), update the **Completion notes** with:
1. The exact command run.
2. A summary of the failure (if any).
3. The exact file changes made to fix it (e.g., `android/app/build.gradle` SDK version bump).
4. The confirmation of the successful build log.
5. Notes on whether this fix might impact downstream platforms (which should prompt the start of the next platform's task).

## 6. Release Automation Matrix (CI/CD)

Hable maintains a structured CI/CD matrix using GitHub Actions to prevent cross-platform build drift and secure release pipelines.

### Matrix Scope
The automated build matrix covers the following required platforms on every `main` branch push and PR:
* **Web:** Uses `ubuntu-latest` runner to run `flutter analyze --no-fatal-infos --fatal-warnings`, `flutter test --coverage`, and the production-targeted Flutter web build for Cloudflare Pages branch previews.
* **Android:** Uses `ubuntu-latest` runner to build the `primary` and `friend` APK/AppBundle flavors. Runs unit and widget tests.
* **iOS / macOS:** Uses `macos-latest` runner to verify compilation without code signing. Production distribution and notarization steps remain intentionally manual for now.
* **Windows:** Uses `windows-latest` runner to verify Windows desktop compilation.

### Environment and Secret Injection
Instead of relying on fragile local `.env` files for production builds, the CI/CD pipeline securely injects environment variables:
* **API Config:** The matrix dynamically injects `--dart-define=HABLE_APP_ENV=production` or `staging` depending on the target branch.
* **Cloudflare Credentials:** Stored securely as repository secrets to enable automatic Wrangler publishing and Pages deployments.
* **Signing Keys:** Android keystores are base64-encoded as GitHub Secrets and injected during the release build matrix job.

### Excluded Scope (Future Splits)
The following are intentionally excluded from this foundational automation matrix and remain manual or handled by future split tracks:
1. Automated App Store Connect or Google Play Console submission.
2. macOS developer certificate notarization.
3. Complex end-to-end device farm UI testing.
