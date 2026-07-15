# Hable Project Commands

Quick reference for all build, install, and deploy shell commands across platforms.

## Doppler Setup
Backend tooling uses Wrangler 4, which requires Node.js 22 or newer. Verify with
`node --version` before running the commands below.

Initialize the local Doppler project for backend secrets:
```bash
cd /Flutter/hable/backend && npm run setup:doppler
```

Run the local Pages dev server with Doppler secrets loaded:
```bash
cd /Flutter/hable/backend && npm run dev
```

Sync the Hable email secrets from Doppler `hable/dev` into the Pages project:
```bash
cd /Flutter/hable/backend && npm run sync:pages-secrets
```

## Web Deployment
Deploy the web version of the Flutter app to Cloudflare Pages:
```bash
cd /Flutter/hable && \
flutter build web --release --base-href / --dart-define=HABLE_APP_ENV=production && \
cd backend && \
npx wrangler pages deploy ../build/web --project-name=hable
```

```bash
cd /Flutter/hable/backend && \
npx wrangler pages deploy public --project-name=hable
```

Deploy only the backend from the existing `backend/public` output:
```bash
cd /Flutter/hable/backend && \
npx wrangler pages deploy public --project-name=hable
```

## CI Parity
Run the same Flutter quality gate used in GitHub Actions:
```bash
cd /Flutter/hable && \
flutter pub get && \
flutter analyze --no-fatal-infos --fatal-warnings && \
flutter test --coverage && \
flutter build web --release --base-href / --dart-define=HABLE_APP_ENV=production
```

This policy keeps informational analyzer diagnostics visible in the log while
still failing CI on warnings and errors.

## Build Android APKs
Build the **primary** Android APK:
```bash
flutter build apk --flavor primary -t lib/main.dart
```

Build the **partner/friend** Android APK:
```bash
flutter build apk --flavor friend -t lib/main.dart
```

For local backend testing, debug builds now default to `http://127.0.0.1:8787`.
The backend target is resolved in this order:
1. `HABLE_API_BASE_URL` manual override
2. `HABLE_APP_ENV` preset: `local`, `staging`, or `production`
3. Fallback when no define is passed: debug/profile -> `local`, release -> `production`

`staging` currently resolves to `production` unless `HABLE_STAGING_API_BASE_URL` is also provided.

Use `adb reverse tcp:8787 tcp:8787` on a physical Android device.
If you need to target a different backend host, pass:
```bash
flutter build apk --debug --flavor primary -t lib/main.dart \
  --dart-define=HABLE_APP_ENV=local \
  --dart-define=HABLE_API_BASE_URL=http://10.0.2.2:8787
```
The override above is the usual emulator case; replace the URL as needed.

Build the **primary** Android APK for the online presentation backend:
```bash
flutter build apk --release --flavor primary -t lib/main.dart \
  --dart-define=HABLE_APP_ENV=production
```

Run the **primary** Android flavor against the online backend on a connected device:
```bash
flutter run --release --flavor primary -t lib/main.dart \
  --dart-define=HABLE_APP_ENV=production
```

Connectivity guard for Android presentation builds:
- Do not set `HABLE_API_BASE_URL` to a localhost or LAN URL.
- Do not rely on `adb reverse`; the app must reach `https://hable.pages.dev` directly.
- Confirm `android/app/src/main/AndroidManifest.xml` includes `INTERNET` and `ACCESS_NETWORK_STATE`.

To target a dedicated staging backend alias:
```bash
flutter run --release --flavor primary -t lib/main.dart \
  --dart-define=HABLE_APP_ENV=staging \
  --dart-define=HABLE_STAGING_API_BASE_URL=https://staging-hable.pages.dev
```

## Install APKs via ADB
Install the **primary** APK on a connected USB device:
```bash
~/Library/Android/sdk/platform-tools/adb install build/app/outputs/flutter-apk/app-primary-release.apk
```

Install the **partner/friend** APK on a connected USB device:
```bash
~/Library/Android/sdk/platform-tools/adb install build/app/outputs/flutter-apk/app-friend-release.apk
```

## Build & Install on iOS via USB
To build and install the **primary** flavor directly to a connected iOS device:
```bash
flutter run --release --flavor primary -t lib/main.dart
```
```bash
flutter build ios --no-codesign --flavor primary -t lib/main.dart
```
To build for iOS simulator:
```bash
flutter build ios --simulator --flavor primary -t lib/main.dart
```


To build and install the **partner/friend** flavor to a connected iOS device:
```bash
flutter run --release --flavor friend -t lib/main.dart
```

*(Note: For iOS, `flutter run --release` is the most reliable way to compile and transfer the app to your device over USB in one step. If you only want to install an already-built iOS app without running it, you can simply use `flutter install`.)*

## macOS
### Clean
Clean Flutter artifacts and remove the native macOS build folder:
```bash
flutter clean
rm -rf build/macos
```

### Build
Build a local debug macOS app:
```bash
flutter build macos --debug
```

Build a release macOS app:
```bash
flutter build macos --release
```

### Run
Run the macOS app from source during local development:
```bash
flutter run -d macos \
  --dart-define=HABLE_APP_ENV=local
```

### Verify
Verify the built release bundle on macOS:
```bash
codesign -dvvv --entitlements :- "build/macos/Build/Products/Release/Hable.app"
spctl -a -vv "build/macos/Build/Products/Release/Hable.app"
```

---

## Windows
### Clean
Clean Flutter artifacts. Removing the Windows build folder must be done from a Windows shell:
```bash
flutter clean
```
```powershell
Remove-Item -Recurse -Force build\windows
```
```cmd
rmdir /s /q build\windows
```

### Build
Build a local debug Windows app:
```bash
flutter build windows --debug
```

Build a release Windows app:
```bash
flutter build windows --release
```

### Run
Run the Windows app from source during local development:
```bash
flutter run -d windows \
  --dart-define=HABLE_APP_ENV=local
```

### Output
The release bundle is written to:
```text
build/windows/x64/runner/Release/
```

---

## Linux
### Clean
Clean Flutter artifacts and remove the native Linux build folder:
```bash
flutter clean
rm -rf build/linux
```

### Build
Build a local debug Linux app:
```bash
flutter build linux --debug
```

Build a release Linux app:
```bash
flutter build linux --release
```

### Run
Run the Linux app from source during local development:
```bash
flutter run -d linux \
  --dart-define=HABLE_APP_ENV=local
```

### Output
The release bundle is written to:
```text
build/linux/x64/release/bundle/
```

## Host Constraints
- `flutter build macos` and `flutter run -d macos` require a macOS host.
- `flutter build windows` and `flutter run -d windows` require a Windows host.
- `flutter build linux` and `flutter run -d linux` require a Linux host.
- Windows installer packaging is a separate Windows-only step after `flutter build windows --release`; see `Developement/windows_distribution.md`.
- macOS signing, notarization, and App Store export are separate operator steps after `flutter build macos --release`; see `Developement/macos_distribution.md`.

## Clean Build Cache
Use these commands when you want a fuller reset before rebuilding.

### Cross-platform Flutter cleanup
```bash
flutter clean
```

### Android
```bash
rm -rf build/app
```

### iOS
```bash
rm -rf build/ios
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec
```

### Web
```bash
rm -rf build/web
```

### macOS
```bash
rm -rf build/macos
```

### Windows
```powershell
Remove-Item -Recurse -Force build\windows
```
```cmd
rmdir /s /q build\windows
```

### Linux
```bash
rm -rf build/linux
```
