# macOS Distribution Path

## Goal

Ship Hable on macOS through two channels:

1. Mac App Store build
2. Standalone notarized `.app` / `.dmg`

The desktop app has a sandboxed release-entitlement file, but the effective
project configuration, nested-code signing, runtime adapters, archive/export,
and notarization still require focused release work.

## Repo State

- Product name: `Hable`
- Bundle identifier: `com.hable.app.macos`
- Release entitlements:
  - `com.apple.security.app-sandbox = true`
  - `com.apple.security.network.client = true`
- Smoke-validated locally on 2026-07-16:
  - `flutter build macos --release --dart-define=HABLE_APP_ENV=production`
  - `codesign -dvvv --entitlements :- build/macos/Build/Products/Release/Hable.app`
  - `codesign --verify --deep --strict --verbose=4 build/macos/Build/Products/Release/Hable.app`
  - `spctl -a -vv build/macos/Build/Products/Release/Hable.app`
- Build source: `77900a37301b42fff358a19eeadbce8cccd8b4e5`
- Executable SHA-256: `02ab5da7206345967cc9490d24b4da0f5d7b2e2b783478434c7fb742ab0450fe`
- Bundle/version: `com.hable.app.macos`, `1.0.0` (`1`)

Local signing state during validation:

- `security find-identity -p codesigning -v` returned `0 valid identities found`
- Result: buildable locally, but the release app is ad-hoc signed (`Signature=adhoc`, `TeamIdentifier=not set`), its effective signature includes `get-task-allow`, and strict deep verification fails on modified `Contents/Frameworks/App.framework`; `spctl` also reports `nested code is modified or invalid`. App Store export, Developer ID signing, and notarization were not executable on this machine because no signing identities are installed.
- Runtime probe: the release process remained stable for eight seconds and the launch log contained no `SecItemCopyMatching` or `CSSMERR_CSP_USER_CANCELED` event after the process-local auth change. The Mac was locked, so the visible signed-out window and absence of a graphical prompt remain a pending direct UI check in [#160](https://github.com/EmilGabibov/HABLE_Project/issues/160).

Runtime authentication policy:

- macOS starts signed out on every process launch and does not read, write, or delete authentication credentials through Keychain.
- Explicit login remains valid in Riverpod memory for the current process; quitting the app requires a new login next time.
- Auth text fields disable platform credential autofill on macOS.
- Non-sensitive first-run and revealed-badge flags use SharedPreferences so they cannot trigger a Keychain prompt after login.
- This is an intentional reliability policy for the current macOS client, not a substitute for the signing and entitlement work required for distribution.

## App Store Path

1. Install the Apple distribution assets in Xcode:
   - App Store Connect-ready bundle id for `com.hable.app.macos`
   - Mac App Store provisioning profile
   - Apple Distribution signing identity
2. Open `macos/Runner.xcworkspace` in Xcode.
3. Set the `Runner` target signing team and archive in `Release`.
4. Use Xcode Organizer:
   - `Product > Archive`
   - `Distribute App`
   - `App Store Connect`
5. Validate and upload from Organizer.

Recommended validation commands after archive/export:

```bash
codesign -dvvv --entitlements :- "Hable.app"
spctl -a -vv "Hable.app"
```

## Standalone Path

1. Install a Developer ID Application certificate in the login keychain.
2. Build the release app:

```bash
flutter build macos --release --dart-define=HABLE_APP_ENV=production
```

3. Verify nested signatures in the exported app bundle.
4. Sign the final bundle with Developer ID if Xcode/Flutter did not already do so under the selected signing setup.
5. Package either:
   - a zipped `.app` for direct download, or
   - a `.dmg` wrapper for friendlier distribution
6. Submit the artifact for notarization, then staple the result before publishing.

Recommended post-export checks:

```bash
codesign -dvvv --entitlements :- "build/macos/Build/Products/Release/Hable.app"
spctl -a -vv "build/macos/Build/Products/Release/Hable.app"
```

## Operator Checklist

- Confirm the build machine has at least 10-15 GiB free before archive/export.
- Verify `PRODUCT_BUNDLE_IDENTIFIER` still matches the registered Apple identifier.
- Keep App Store and standalone signing identities separate.
- Recheck sandbox entitlements whenever a new plugin adds file system, camera, notification, or login-item requirements.
- Treat the current code-asset framework-name warnings during release build as package-level follow-up items if notarization starts rejecting nested assets.

## Current Gaps

- No local code-signing identities are installed on the current machine.
- Duplicate `CODE_SIGN_ENTITLEMENTS` assignments currently collapse configuration separation and must be repaired in [#171](https://github.com/EmilGabibov/HABLE_Project/issues/171).
- The source `Release.entitlements` contains only sandbox and outbound-network access, but the effective ad-hoc signature includes `get-task-allow`; `spctl` fails and reports invalid/modified nested code.
- macOS reminder permission/delivery still needs the supported adapter and direct smoke tracked in [#170](https://github.com/EmilGabibov/HABLE_Project/issues/170).
- The final direct signed-out launch/relaunch UI check for the no-Keychain auth policy is pending because the host was locked.
- No notarized standalone artifact was produced in this session.
- No App Store archive/upload was possible from this environment.
