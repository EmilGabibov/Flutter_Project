#!/bin/bash
set -e
echo "Building Android Friend flavor..."
flutter build apk --flavor friend -t lib/main.dart --dart-define=HABLE_APP_ENV=production

echo "Building macOS..."
flutter build macos

echo "Note: Windows build cannot run on macOS host."
echo "All builds complete."
