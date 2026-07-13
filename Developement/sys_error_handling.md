# Error Handling and Safe Display Reference

This document defines the current reference direction for error handling across Hable's Flutter client and Cloudflare Worker backend.

The goal is to keep errors:
- safe for users to read,
- useful for debugging,
- consistent across screens and routes,
- and aligned with Hable's offline-first architecture.

## 1. Current Problem Shape

The codebase currently mixes several patterns:
- backend JSON responses like `{ "error": "..." }` with route-specific wording,
- frontend `throw Exception(response.body)` paths that can leak raw payloads,
- widget-level `Text('Error: $e')` fallbacks that expose internal exception strings,
- and ad hoc success/failure `SnackBar` copy across screens.

This creates three risks:
- inconsistent user experience,
- accidental leakage of implementation details,
- and duplicated parsing/display logic across Flutter screens and providers.

## 2. Core Safety Rules

### Frontend

- Never show raw exception objects directly to users.
- Never render `response.body` verbatim in UI.
- Prefer bounded user-facing copy such as:
  - `Couldn't load your friends right now.`
  - `Couldn't save this change. Try again.`
  - `Session expired. Please sign in again.`
- Log richer technical details only to debug output, not to visible UI.
- Use one normalization layer so screens do not each invent their own parsing.
- Prefer modern, calm wording with a light Hable touch: direct, slightly warm, and never blamey.

### Backend

- Return structured JSON for failures.
- Keep user-facing `message` text safe and concise.
- Keep optional debug-only detail separate from the default user-facing field.
- Do not expose stack traces, SQL, token contents, internal URLs, or plugin/runtime details in public responses.
- Use HTTP status codes consistently so Flutter can map them deterministically.

## 2.1 Tone Reference

Error copy should feel:
- calm,
- concise,
- actionable,
- and a little human.

Examples:
- `That took too long. Give it another try.`
- `That habit did not stick yet. Please try again.`
- `Hable could not load your friends right now.`
- `That PIN does not look right.`

Avoid:
- `Error: Exception: ...`
- `Failed to fetch`
- `Unauthorized: Not accepted friends`
- jokey copy that makes failures feel dismissive

## 2.2 Cross-Platform / Cross-Build Differences

Hable needs one visible error language across:
- Flutter web browser fetch/CORS failures,
- Android and iOS network timeouts,
- macOS and Windows desktop connectivity issues,
- local development builds using localhost/tunnels,
- and offline-first screens that still have cached Drift data.

Important differences:
- Web often surfaces failures as `XMLHttpRequest error`, `TypeError`, or `Failed to fetch`.
- Native mobile and desktop more often surface `SocketException`, `HandshakeException`, or timeout exceptions.
- Development builds can fail due to backend boot/CORS/base-URL issues more often than production.

Raw platform/build exceptions may differ, but the user-facing copy should normalize to one safe message policy.

## 3. Target Contract

### Backend response shape

Preferred error envelope:

```json
{
  "error": {
    "code": "friend_request_self",
    "message": "You can't send a friend request to yourself."
  }
}
```

Guidance:
- `code`: stable machine-readable identifier.
- `message`: safe user-facing message.
- Optional diagnostics should stay server-side or be gated to development only.

### Frontend normalized shape

Preferred normalized model:

```dart
class AppError {
  final String code;
  final String message;
  final AppErrorKind kind;
}
```

Where `kind` can help the UI choose presentation:
- `inline`
- `snackbar`
- `banner`
- `fullscreen`
- `retryable`
- `auth`
- `validation`

## 4. Display Rules by Surface

### Inline form errors

Use for:
- validation failures,
- auth form issues,
- field-specific correction.

Examples:
- missing username/password,
- invalid email,
- short password,
- invalid PIN.

### SnackBars

Use for:
- short-lived action feedback,
- non-blocking failures after user actions,
- success/failure on local mutations where the user remains on the same screen.

Do not use SnackBars as the only recovery path for persistent permission problems.

### Empty/error panels

Use for:
- failed section loads,
- retryable fetch failures,
- offline-unavailable secondary content.

These should avoid raw `Error: ...` text.

### Full-screen blockers

Use only when the user cannot proceed safely:
- startup auth bootstrap failure,
- required session loss,
- unrecoverable route bootstrap states.

## 5. Offline-First Boundaries

Because Hable is offline-first:
- network failure should usually degrade to cached Drift-backed UI rather than a hard failure,
- sync failures should prefer quiet logging plus bounded retry state,
- UI should distinguish:
  - `no local data yet`,
  - `offline with cached data`,
  - `request failed but local state is still usable`.

Do not let one sync failure replace stable local content with a noisy raw error.

When cached content exists:
- keep the content visible,
- show bounded inline or banner feedback only where needed,
- and prefer retry/recovery over full-screen blocking states.

## 6. Status-Code Mapping Guidance

Recommended default mapping:
- `400`: validation or malformed request
- `401`: auth/session expired
- `403`: not allowed
- `404`: missing resource
- `409`: state conflict / already handled / duplicate action
- `422`: semantically invalid input if introduced later
- `429`: throttled / try again later
- `500+`: generic server failure

Frontend should map these into safe copy first, then use backend `error.code` and `error.message` where present.

## 7. Immediate Audit Targets

Known current hotspots:
- `lib/screens/social/social_hub_screen.dart`
- `lib/screens/profile_screen.dart`
- `lib/screens/auth_screen.dart`
- `lib/widgets/habit_form_sheet.dart`
- `lib/main.dart`
- `lib/services/sync_service.dart`
- `lib/providers/calendar_provider.dart`
- `backend/src/index.ts`

Common anti-patterns to remove:
- `Text('Error: $e')`
- `throw Exception(response.body)`
- `SnackBar(content: Text('Failed ...: $e'))`

## 8. Testing Reference

Verification should cover:
- backend route returns stable error envelope,
- frontend parser extracts safe message and code,
- raw exception text is not shown in visible UI,
- offline/cached surfaces remain usable during fetch failure,
- auth-expired flows redirect or re-prompt cleanly,
- retry affordances exist where the action is retryable.

Cross-platform verification should include:
- one web-style fetch/CORS normalization path,
- one timeout/network-failure path representative of native builds,
- and one offline-with-cached-data path where the screen remains usable.

## 9. Related Documents

- `Developement/sys_authentication.md`
- `Developement/sys_offline_architecture.md`
- `Developement/sys_schema_and_logic.md`
- `Developement/qa_testing.md`
