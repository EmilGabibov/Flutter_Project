#!/usr/bin/env bash
# Produce a fail-closed release-smoke report for every target.
# Authenticated UI evidence is never inferred from a compile or launch.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/release_smoke.sh --target backend-fixture|web|android|ios|macos|all
       --env local|staging|production [--flavor primary|friend]
       [--device DEVICE_ID] [--evidence-dir DIR]

The backend-fixture target is the only mutation-capable path and requires
HABLE_RELEASE_SMOKE_ALLOW_MUTATION=1 against a local fixture. Web/native
targets report BLOCKED unless their authenticated UI harness is explicitly
available; launch/build success is recorded separately and never promoted.
EOF
}

TARGET=""
ENVIRONMENT=""
FLAVOR="primary"
DEVICE_ID="${ANDROID_DEVICE_ID:-}"
EVIDENCE_DIR="build/release-smoke"

while (($#)); do
  case "$1" in
    --target) TARGET="${2:?missing value for --target}"; shift 2 ;;
    --env) ENVIRONMENT="${2:?missing value for --env}"; shift 2 ;;
    --flavor) FLAVOR="${2:?missing value for --flavor}"; shift 2 ;;
    --device) DEVICE_ID="${2:?missing value for --device}"; shift 2 ;;
    --evidence-dir) EVIDENCE_DIR="${2:?missing value for --evidence-dir}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$TARGET" in backend-fixture|web|android|ios|macos|all) ;; *) echo "--target is required" >&2; usage >&2; exit 2 ;; esac
case "$ENVIRONMENT" in local|staging|production) ;; *) echo "--env is required: local, staging, or production" >&2; exit 2 ;; esac
case "$FLAVOR" in primary|friend) ;; *) echo "--flavor must be primary or friend" >&2; exit 2 ;; esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
mkdir -p "$EVIDENCE_DIR"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPORT="${EVIDENCE_DIR}/${STAMP}-${TARGET}.txt"
COMMIT_SHA="$(git rev-parse HEAD)"
APP_VERSION="$(sed -n 's/^version: //p' pubspec.yaml | head -1)"
FLUTTER_VERSION="$(flutter --version --machine 2>/dev/null | sed -n 's/.*"frameworkVersion":"\([^"]*\)".*/\1/p' | head -1 || true)"

{
  echo "commit=${COMMIT_SHA}"
  echo "app_version=${APP_VERSION}"
  echo "target=${TARGET}"
  echo "flavor=${FLAVOR}"
  echo "environment=${ENVIRONMENT}"
  echo "flutter_version=${FLUTTER_VERSION:-unavailable}"
  echo "generated_at=${STAMP}"
} > "$REPORT"

record() {
  local status="$1" reason="$2"
  echo "status=${status}" >> "$REPORT"
  echo "reason=${reason}" >> "$REPORT"
  echo "${TARGET}: ${status} — ${reason}"
}

run_backend_fixture() {
  if [[ "$ENVIRONMENT" != local ]]; then
    record BLOCKED "fixture-owned writes are disabled outside local; production/staging smoke is read-only"
    return
  fi
  if [[ "${HABLE_RELEASE_SMOKE_ALLOW_MUTATION:-0}" != 1 ]]; then
    record BLOCKED "set HABLE_RELEASE_SMOKE_ALLOW_MUTATION=1 to permit the bounded local fixture write/reset"
    return
  fi
  if (cd backend && npm run smoke:release-fixture) >> "$REPORT" 2>&1; then
    record PASS "authenticated login, safe auth error, profile read, bounded write/log, and fixture cleanup"
  else
    record BLOCKED "backend fixture command failed; see ${REPORT}"
  fi
}

run_web() {
  record BLOCKED "no resettable authenticated browser fixture command is configured; run the serialized Playwright/operator flow from Developement/qa_testing.md"
}

run_android() {
  if [[ -z "$DEVICE_ID" ]]; then
    record BLOCKED "no explicit Android device was supplied; authenticated UI evidence requires --device DEVICE_ID"
    return
  fi
  if scripts/android_smoke.sh --flavor "$FLAVOR" --env "$ENVIRONMENT" --device "$DEVICE_ID" --skip-build >> "$REPORT" 2>&1; then
    record BLOCKED "launch evidence passed, but scripts/android_smoke.sh does not exercise authenticated navigation, offline/retry, logout, or relaunch"
  else
    record BLOCKED "Android launch/preflight failed; see ${REPORT}"
  fi
}

run_ios() {
  if scripts/ios_smoke.sh --flavor "$FLAVOR" --env "$ENVIRONMENT" --preflight-only >> "$REPORT" 2>&1; then
    record BLOCKED "iOS preflight passed, but no authenticated UI fixture harness is available in this checkout"
  else
    record BLOCKED "iOS host/runtime preflight failed; see ${REPORT}"
  fi
}

run_macos() {
  record BLOCKED "direct authenticated macOS UI evidence requires an unlocked host/operator session; compile output is not a runtime pass"
}

case "$TARGET" in
  backend-fixture) run_backend_fixture ;;
  web) run_web ;;
  android) run_android ;;
  ios) run_ios ;;
  macos) run_macos ;;
  all)
    run_backend_fixture
    TARGET=web run_web
    TARGET=android run_android
    TARGET=ios run_ios
    TARGET=macos run_macos
    ;;
esac

echo "Evidence report: ${REPORT}"
