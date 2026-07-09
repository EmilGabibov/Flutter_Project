## Hable Project Commands

### Web Deployment
Deploy the web version of the Flutter app to Cloudflare Pages:
```bash
flutter build web
npx wrangler pages deploy build/web --project-name=hable
```

### Build Android APKs
Build the **primary** Android APK:
```bash
flutter build apk --flavor primary -t lib/main.dart
```

Build the **partner/friend** Android APK:
```bash
flutter build apk --flavor friend -t lib/main.dart
```

For local backend testing, debug builds now default to `http://127.0.0.1:8787`.
Use `adb reverse tcp:8787 tcp:8787` on a physical Android device.
If you need to target a different backend host, pass:
```bash
flutter build apk --debug --flavor primary -t lib/main.dart \
  --dart-define=HABLE_API_BASE_URL=http://10.0.2.2:8787
```
The override above is the usual emulator case; replace the URL as needed.

### Install APKs via ADB
Install the **primary** APK on a connected USB device:
```bash
~/Library/Android/sdk/platform-tools/adb install build/app/outputs/flutter-apk/app-primary-release.apk
```

Install the **partner/friend** APK on a connected USB device:
```bash
~/Library/Android/sdk/platform-tools/adb install build/app/outputs/flutter-apk/app-friend-release.apk
```

### Build & Install on iOS via USB
To build and install the **primary** flavor directly to a connected iOS device:
```bash
flutter run --release --flavor primary -t lib/main.dart
```

To build and install the **partner/friend** flavor to a connected iOS device:
```bash
flutter run --release --flavor friend -t lib/main.dart
```

*(Note: For iOS, `flutter run --release` is the most reliable way to compile and transfer the app to your device over USB in one step. If you only want to install an already-built iOS app without running it, you can simply use `flutter install`.)*
