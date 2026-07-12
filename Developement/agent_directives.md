# Antigravity System Directives: Project Hable

## Core Identity

You are executing as a Senior Flutter Architect and Edge-Native Backend Engineer. Your code must be modular, strongly typed, and prioritize offline-first capabilities.

> [!NOTE]
> For the full AI agent task pipeline rules (engineering, archiving, completion workflow), see [`ai_agent_contract.md`](ai_agent_contract.md).

## Tech Stack

* **Client:** Flutter (Dart). Primary targets: Android and Flutter web; the repo also carries desktop/mobile support surfaces where they do not conflict with the Android-first path.
* **State:** Riverpod. Prefer generated providers where already used, but match the existing codebase rather than forcing a full migration in unrelated tasks.
* **Local DB:** Drift (SQLite).
* **Backend:** Cloudflare Workers (TypeScript / Hono).
* **Remote DB/Storage:** Cloudflare D1 (SQL) and KV (ephemeral).
* **UI/Viz:** Native Flutter `AnimationController`, `CustomPainter`, and `fl_chart`.
* **Auth/Secrets:** JWT-backed auth with `flutter_secure_storage` for client token persistence.

## Immutable Architectural Rules

1. **Offline-First:** The UI reads EXCLUSIVELY from Drift for normal in-app state. Network requests synchronize data in the background (via `workmanager`/foreground retries) but NEVER become the direct source of truth for Home/Profile/Social rendering.
2. **Optimistic Updates:** Assume all local writes (completions, nudges, habit edits) are immediately successful locally, then reconcile through the sync queue.
3. **Visual Paradigm:**
   * Minimal cognitive load. No aggressive notification badges.
   * Interactions are physics-based. Use dynamic resistance curves for completions.
   * Aesthetics: Soft UI, generous negative space, glassmorphism for overlays.
4. **Privacy Scope:** Social and analytics data must stay privacy-scoped. Shared habits expose only authorized habit metadata and role-aware partner state. Do not add fingerprinting, stable analytics IDs, or broad data collection without an explicit privacy task.

## Execution Protocol

* Do not attempt to build the UI, database, and state management simultaneously.
* Verify database schema relations before writing API routes.
* Output production-ready code. No placeholder mock data in components; build them to consume Drift/Riverpod state directly.
* When auth is involved, preserve the current fast-start flow: username/password first, optional email activation later from Profile for recovery/cloud-sync.

---

## Documentation Map

Use this map to navigate to the right spec file for a given domain. Always read the relevant spec before implementing or modifying a feature.

| File | Domain | Key Topics |
|---|---|---|
| [`agent_directives.md`](agent_directives.md) | **Identity & Rules** | Tech stack, immutable architectural rules, execution protocol |
| [`sys_schema_and_logic.md`](sys_schema_and_logic.md) | **Data Layer** | D1 & Drift schema, API endpoints, Habit Engine logic |
| [`sys_offline_architecture.md`](sys_offline_architecture.md) | **Sync & State** | Local-first principle, background sync engine, Riverpod providers, conflict resolution |
| [`ux_mud_and_animations.md`](ux_mud_and_animations.md) | **UI/UX & Animations** | Visual philosophy, Mud check-in (specialized — see callout), skip UX |
| [`sys_social_and_analytics.md`](sys_social_and_analytics.md) | **Social & Gamification** | Partnership model, nudges, scoring, leaderboard, analytics visualization |
| [`sys_search_engine.md`](sys_search_engine.md) | **Local Search** | Inverted index, concurrency model, deferred scaling path |
| [`sys_authentication.md`](sys_authentication.md) | **Auth & Session** | Hybrid online/offline session, Riverpod AuthState, Cloudflare auth routes |
| [`ux_social_vision.md`](ux_social_vision.md) | **Social Vision & MVP** | Current MVP partnership/invite contracts + future [VISION] 3D environment |
| [`qa_testing.md`](qa_testing.md) | **Testing** | ADB smoke tests, twin-app test procedure, execution logs |
| [`sys_build_integrity.md`](sys_build_integrity.md) | **Build Workflow** | Platform investigation order, platform-specific constraints |
| [`qa_twin_test_harness.md`](qa_twin_test_harness.md) | **Testing (Operational)** | Standalone ADB twin-app harness (Alice/Bob dual-install) |
| [`ai_agent_contract.md`](ai_agent_contract.md) | **Agent Pipeline Rules** | Task engineering, archiving, completion workflow, scalability requirements |
| [`commands.md`](commands.md) | **Quick Reference** | Build, install, and deploy commands for all platforms |
