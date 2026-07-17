# Hable — Investor Development Timeline

## Executive summary

Hable progressed from a documented product and technical baseline to a deployable, socially connected habit product in one concentrated delivery cycle: **July 8–15, 2026**.

The development sequence reduced risk in the order investors typically care about:

1. **Technical foundation** — authentication, data sync, authorization, and server-owned scoring.
2. **Core product loop** — habit creation, completion, social partnership, and progress.
3. **Engagement layer** — friends, nudges, reminders, notifications, leaderboards, and history.
4. **Reliability and presentation readiness** — multi-user QA, localization, release builds, deployment, and production smoke testing.

**Current position:** The product is in the final online Android presentation-readiness phase. The core product and social contracts are implemented; the remaining work is a clean production-targeted demonstration against the deployed backend, while the live backlog is focused on Android connectivity/notifications and Android build compatibility warnings.

> **Date basis:** Milestone dates are derived from the completion dates and timestamps recorded in the engineering and archived issue notes. The active presentation-readiness phase is dated from its current backlog status, not presented as completed.

## Milestone view

| Date | Milestone | Investor relevance | Outcome |
|---|---|---|---|
| **Jul 8** | Backend and data foundation | Establishes a scalable control plane for identity, social permissions, sync, and scoring. | Authenticated users, friend relationships, habit sync, and leaderboard data became possible. |
| **Jul 9** | First complete product loop | Demonstrates that the product can move from onboarding to habit creation and social participation. | Habit creation, partner selection, profile CRUD, leaderboard presentation, deployed web target, and Android verification. |
| **Jul 10–11** | Social engagement and shared habits | Converts a solo habit tracker into a permission-aware social product. | Shared-habit roles, server-owned progression, reminders, notifications, friend profiles, nudges, and calendar feeds. |
| **Jul 11** | Product structure and lifecycle | Reduces UX complexity and proves the system works across multiple users and state transitions. | Three-tab navigation, consolidated Social Hub, skeleton loading, habit history/archive, and cross-user lifecycle verification. |
| **Jul 12–14** | Reliability and release hardening | Moves the product from feature-complete toward credible external demonstration. | Sync recovery, safe errors, accessibility, localization, QA harnesses, signing/package identity, distribution paths, and session restoration. |
| **Jul 15+** | Online Android presentation readiness | Creates the investor-demo gate: a clean build running against production infrastructure. | Production preflight, clean installation, online end-to-end smoke test, and blocker capture. |

## Product evolution: from foundation to defensible experience

### 1. Foundation — July 8

Hable first established the infrastructure required for a trustworthy social product:

- Cloudflare Worker backend with D1/KV integration.
- JWT authentication and friend-request authorization.
- Account, friend search, habit-record sync, and leaderboard contracts.
- Offline local document search and a documented raw → engineered → verified → archived delivery process.

**Business significance:** The architecture separates client experience from server authority. Identity, permissions, and score outcomes are not left to the device.

### 2. Core habit loop — July 9

The first usable product journey was assembled:

```text
Onboarding → create a finite habit → choose a partner
           → complete/check in → sync progress → view social context
```

Delivered capabilities included onboarding presets, Home-based habit creation, profile habit management, friend selection, leaderboard presentation, Cloudflare Pages deployment, and Android verification.

**Business significance:** Hable moved from infrastructure to an observable user journey that can be demonstrated end to end.

### 3. Social engagement layer — July 10–11

The product’s differentiation was expanded around accountability and shared progress:

- partnership roles and action permissions;
- server-owned, idempotent scoring and progression;
- friend profiles, habit-scoped nudges, and social recaps;
- reminders, notification center, and revocable calendar feeds;
- shared-habit visibility after check-in;
- friend requests and partner workflows through Social Hub.

**Business significance:** Social interaction became part of the habit lifecycle rather than a separate community feature.

### 4. Retention and product clarity — July 11–13

The experience was organized around repeat use and visible progress:

- three primary tabs and a consolidated Social Hub;
- activity, leaderboard, friend discovery, and notification flows;
- completed-habit history and automatic archive behavior;
- Mud progression, completion moments, milestones, badges, and achievement surfaces;
- daily quotes, celebration surfaces, reminder refinement, and offline fallback;
- Playwright multi-user regression coverage.

**Business significance:** The product began to support a recurring engagement loop: plan, act, receive accountability, see progress, and return.

### 5. Reliability and readiness — July 12–14

The delivery cycle closed with cross-cutting hardening:

- foreground sync polling, startup gating, and lifecycle flush;
- explicit environment targeting and safe error contracts;
- Android signing and package identity;
- macOS and Windows distribution paths;
- accessibility semantics and canonical habit states;
- localization across English, German, Urdu, Russian, Tamil, and Persian/Farsi;
- architecture, schema, authentication, social, offline, and QA documentation;
- macOS keychain/session restoration and recovery UX.

**Business significance:** The product is increasingly suitable for external users, partners, and investor-facing demonstrations—not only local development.

## Current investor-demo gate

### Online Android presentation readiness — active

The final active milestone is a controlled production demonstration using the primary Android release build:

```bash
flutter build apk --release --flavor primary -t lib/main.dart \
  --dart-define=HABLE_APP_ENV=production
```

The acceptance path is:

1. Verify production backend routes, schema, bindings, CORS, JWT, and secrets.
2. Install the release APK on a clean Android device or emulator.
3. Demonstrate sign-up/login, Home, habit creation, check-in, sync, and restart/reopen.
4. Demonstrate a safe two-user social path: search, request/accept, shared habit, or documented substitute.
5. Show Activity/notifications, profile, reminders, localization, leaderboard, and bounded offline fallback.
6. Record device, build path, backend target, test-account policy, commands, result, and timestamp.

**Presentation exit condition:** One clean primary Android build completes the main Hable experience against the deployed online backend without local development infrastructure.

### Latest tasks - July 17, 2026

The current open issue queue has two active tasks:

- `#185` `bug: Android connectivity issue, and notification` - fix the Android login/connectivity path and make notifications respect the configured schedule while still delivering friend requests and nudges on Android and web.
- `#184` `build: remove Android Gradle and plugin compatibility warnings` - remove the restricted Java/native-access warning, resolve the legacy Kotlin Gradle Plugin warnings, and make `flutter build apk --debug` report the expected artifact reliably.

**Why these are the latest tasks:** they are the current open issues in the GitHub-first backlog and sit directly on the path to a clean production demo.

## What has been de-risked

| Risk area | Evidence in the development record |
|---|---|
| Backend authority | Server-owned authentication, permissions, sync, and scoring contracts. |
| Social complexity | Friend requests, partnership roles, nudges, shared habits, and multi-user regression coverage. |
| Offline/mobile reliability | Drift-backed local state, sync polling, lifecycle handling, recovery paths, and offline fallback. |
| Product usability | Simplified navigation, skeleton loading, lifecycle/history, reminders, and accessibility semantics. |
| Release readiness | Cloudflare deployment, Android verification, signing/package identity, localization, and platform documentation. |

## Forward opportunity

The following are deliberately separated from the current investor-demo milestone and should be positioned as scale and expansion opportunities:

- production push infrastructure across FCM, APNs, and Web Push;
- deeper authentication hardening, including refresh rotation, revocation, export, and passkeys;
- store-distribution hardening for Play Console, App Store, macOS, and Windows;
- richer profile media and managed uploads through R2;
- expanded social feeds, follow models, and larger multi-user scale;
- deeper accessibility modes, achievements, seasonal scoring, and quote/content strategy.

## Investor takeaway

Hable’s development path shows a deliberate progression from **technical control → complete habit loop → social differentiation → retention mechanics → production readiness**. The immediate objective is to convert that completed engineering base into a clean, repeatable online Android demonstration suitable for investor evaluation.

## Source documents

- `Developement/Task0_Raw.md`
- `Developement/Task1_Engineered.md`
- `Developement/Task2_Archived.md`
- `Developement/todo_inventory.md`
- `Developement/ai_agent_contract.md`
- `Developement/future_split_guidance.md`
