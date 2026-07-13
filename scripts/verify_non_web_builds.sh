#!/bin/bash
set -e

echo "=== Cleaning build cache ==="
flutter clean

echo "=== Fetching dependencies ==="
flutter pub get

echo "=== Building Android (Primary flavor) ==="
flutter build apk --flavor primary -t lib/main.dart

echo "=== Building Android (Friend flavor) ==="
flutter build apk --flavor friend -t lib/main.dart

echo "=== Building Web ==="
flutter build web --no-tree-shake-icons

echo "=== Building macOS ==="
# Temporarily strip keychain-access-groups to allow local ad-hoc release signing
git checkout macos/Runner/Release.entitlements
sed -i '' '/keychain-access-groups/,+1d' macos/Runner/Release.entitlements
flutter build macos
git checkout macos/Runner/Release.entitlements

echo "=== Checking Windows Build ==="
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" || "$OSTYPE" == "windows" ]]; then
  echo "Building Windows..."
  flutter build windows
else
  echo "Skipping Windows build (current OS: $OSTYPE is not Windows)"
fi

echo "=== Cleaning up build artifacts to save disk space ==="
flutter clean

echo "=== All builds passed successfully! ==="
