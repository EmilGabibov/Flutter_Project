#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <primary-apk> <friend-apk>" >&2
  exit 2
fi

ANDROID_SDK="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
if [[ -z "$ANDROID_SDK" && -f android/local.properties ]]; then
  ANDROID_SDK="$(sed -n 's/^sdk\.dir=//p' android/local.properties | head -n 1)"
fi

ANDROID_BUILD_TOOLS="${ANDROID_BUILD_TOOLS:-${ANDROID_SDK:+$ANDROID_SDK/build-tools/36.1.0}}"
APKSIGNER="${APKSIGNER:-$ANDROID_BUILD_TOOLS/apksigner}"
AAPT="${AAPT:-$ANDROID_BUILD_TOOLS/aapt}"
APKANALYZER="${APKANALYZER:-$(command -v apkanalyzer || true)}"

if [[ ! -x "$APKSIGNER" ]]; then
  echo "apksigner not found; set APKSIGNER or ANDROID_BUILD_TOOLS." >&2
  exit 1
fi
if [[ ( -z "$APKANALYZER" || ! -x "$APKANALYZER" ) && ! -x "$AAPT" ]]; then
  echo "Neither apkanalyzer nor aapt was found; set APKANALYZER or ANDROID_BUILD_TOOLS." >&2
  exit 1
fi

verify_artifact() {
  local artifact="$1"
  local expected_application_id="$2"
  local certificate application_id

  certificate="$("$APKSIGNER" -J-enable-native-access=ALL-UNNAMED verify --print-certs "$artifact")"
  if grep -q "CN=Android Debug" <<<"$certificate"; then
    echo "Debug certificate found in production artifact: $artifact" >&2
    exit 1
  fi

  if [[ -x "$AAPT" ]]; then
    application_id="$("$AAPT" dump badging "$artifact" | sed -n "s/^package: name='\([^']*\)'.*/\1/p" | head -n 1)"
  else
    application_id="$("$APKANALYZER" manifest application-id "$artifact")"
  fi
  if [[ "$application_id" != "$expected_application_id" ]]; then
    echo "Unexpected application id for $artifact: $application_id" >&2
    exit 1
  fi

  echo "$artifact: certificate is non-debug; application id is $application_id"
}

verify_artifact "$1" com.hable.app.primary
verify_artifact "$2" com.hable.app.friend
