# Hable TODO Inventory

*Generated on 2026-07-12. Last reviewed: 2026-07-12.*

This document serves as a centralized inventory of all `TODO`, `FIXME`, `HACK`, and `XXX` markers found in the Hable repository. The goal is to separate actionable product and release work from generated, template, or vendor comments.

## 1. Actionable Hable Tasks
*None found in current app source (`lib/`)*

## 2. Release & Configuration Tasks
*None found.*

## 3. Template & Vendor Comments
These comments are part of generated Flutter templates or third-party vendored assets. They should be left alone unless they cause a verifiable app bug.

| File | Context | Recommendation | Future Raw Task? |
|---|---|---|---|
| `linux/flutter/CMakeLists.txt` | Line 9: `# TODO: Move the rest of this into files in ephemeral.` | Ignore (Flutter Linux template) | No |
| `windows/flutter/CMakeLists.txt` | Line 9: `# TODO: Move the rest of this into files in ephemeral.` | Ignore (Flutter Windows template) | No |
| `web/sql-wasm.js` | Line 13: `// TODO: Make this not declare a global if used in the browser` | Ignore (Vendored SQLite WASM asset) | No |

## 4. Ignored Findings
- `Developement/` task queue markdown files mentioning this task.
- `Developement/` documentation spec files (`.md`) are excluded from this scan — they are documentation artifacts, not source code.
- `backend/package-lock.json` false positives matching `hacks`.
- `lib/screens/profile_screen.dart` false positives matching `toDouble()`.
- Binary files (`ic_launcher.png`, `Icon-App-72x72@1x.png`).
