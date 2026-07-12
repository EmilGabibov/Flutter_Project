# Hable TODO Inventory

*Generated on 2026-07-12*

This document serves as a centralized inventory of all `TODO`, `FIXME`, `HACK`, and `XXX` markers found in the Hable repository. The goal is to separate actionable product and release work from generated, template, or vendor comments.

## 1. Actionable Hable Tasks
*None found in current app source (`lib/`)*

## 2. Release & Configuration Tasks
These items represent pending configuration for production builds and have been appended as raw tasks for future engineering.

| File | Context | Recommendation | Future Raw Task? |
|---|---|---|---|
| `android/app/build.gradle.kts` | Line 23: `// TODO: Specify your own unique Application ID` | Set a unique Android Application ID for production builds | Yes |
| `android/app/build.gradle.kts` | Line 50: `// TODO: Add your own signing config for the release build.` | Configure release keystore and signing | Yes |

## 3. Template & Vendor Comments
These comments are part of generated Flutter templates or third-party vendored assets. They should be left alone unless they cause a verifiable app bug.

| File | Context | Recommendation | Future Raw Task? |
|---|---|---|---|
| `linux/flutter/CMakeLists.txt` | Line 9: `# TODO: Move the rest of this into files in ephemeral.` | Ignore (Flutter Linux template) | No |
| `windows/flutter/CMakeLists.txt` | Line 9: `# TODO: Move the rest of this into files in ephemeral.` | Ignore (Flutter Windows template) | No |
| `web/sql-wasm.js` | Line 13: `// TODO: Make this not declare a global if used in the browser` | Ignore (Vendored SQLite WASM asset) | No |

## 4. Ignored Findings
- `Developement/` task queue markdown files mentioning this task.
- `backend/package-lock.json` false positives matching `hacks`.
- `lib/screens/profile_screen.dart` false positives matching `toDouble()`.
- Binary files (`ic_launcher.png`, `Icon-App-72x72@1x.png`).
