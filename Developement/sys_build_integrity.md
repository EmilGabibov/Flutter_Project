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
- **Command:** `flutter build web --release --base-href /` (or `flutter build web` as seen in `commands.md`).
- **Workflow:** 
  1. Run the build command.
  2. If it fails, capture the exact error output in the current task's completion notes or walkthrough.
  3. Resolve the dependency, package version, or Dart compilation error.
  4. Verify the build succeeds locally. Note: A successful local build does not guarantee the Pages deployment smoke test will pass, but it is the prerequisite.

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
  - `flutter build apk --flavor primary -t lib/main.dart`
  - `flutter build apk --flavor friend -t lib/main.dart`
- **Evidence:** Record success/failure logs for both flavors. Address any signing or keystore issues if release builds are requested.

### iOS
- **Constraints:** iOS builds depend on CocoaPods and Xcode. `sql_wasm` does not apply here; it uses the native `sqlite3` plugin.
- **Verification Commands:** `flutter build ios --no-codesign --flavor primary -t lib/main.dart` (Note: `--no-codesign` allows testing compilation without provisioning profiles on the local agent host).
- **Evidence:** Record `pod install` output if dependencies are updated. Document any Xcode/Swift version incompatibility.

### macOS
- **Constraints:** macOS relies on desktop entitlements and pods.
- **Verification Commands:** `flutter build macos`
- **Evidence:** Document any permission/entitlement failures. Ensure local SQLite binaries link correctly.

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
