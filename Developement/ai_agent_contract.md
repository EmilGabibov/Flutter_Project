# AI Agent Operating Contract - Project Hable

> Canonical source of truth for AI agent task handling in Project Hable.
> The active task queue is GitHub Issues. This local file remains the operating contract.
>
> For tech-stack identity, immutable architecture rules, and the documentation map, see [`agent_directives.md`](agent_directives.md).

---

## 1. Source Of Truth

| Surface | Role | Agent responsibility |
|---|---|---|
| GitHub Issues | Primary raw task queue, engineered prompt record, completion report, and archive | Read, label, engineer, proceed, commit, and report here |
| `Developement/ai_agent_contract.md` | Local workflow contract | Read before engineering or proceeding issues |
| `Developement/*.md` system docs | Architecture, UX, QA, build, and domain contracts | Read/update when the implementation changes the matching behavior |
| `Task0_Raw.md`, `Task1_Engineered.md`, `Task2_Archived.md` | Legacy local task ledger | Do not use for new GitHub issue work unless explicitly requested |

**Primary rule:** one GitHub issue is one durable task thread. The issue body is the raw prompt, the engineered issue reply is the implementation contract, the commit records the code change, and the completion issue reply is the archive.

---

## 2. Required Labels

Every issue handled by an AI agent must use these labels consistently:

| Label | Meaning | Required action |
|---|---|---|
| `raw` | User-written issue exists but has not been engineered | Eligible for engineering |
| `engineered` | The issue has an engineered prompt reply and is ready to proceed | Eligible for implementation |
| `proceeded` | Implementation is complete, committed, and reported | No more action unless reopened |

**Strict label rules:**

- A new issue that has not been engineered must have `raw`.
- After posting the engineered prompt, remove `raw` and add `engineered`.
- After implementation, verification, commit, and completion reply, remove `engineered` and add `proceeded`.
- Do not mark an issue `proceeded` without a completion reply that includes a commit SHA.
- Do not leave multiple lifecycle labels on the same issue unless the user explicitly asks for a temporary audit.

Recommended label setup:

```bash
gh label create raw --color BFDADC --description "Raw issue intake"
gh label create engineered --color FBCA04 --description "Engineered into a scoped task"
gh label create proceeded --color 0E8A16 --description "Implementation has been proceeded on"
```

---

## 3. Tooling Contract

Agents should use the tools already proven in this repository:

| Tool | Use |
|---|---|
| `gh` | List/view issues, post engineered prompts and completion notes, update labels |
| `/graphify` | Query or build the project knowledge graph before engineering non-trivial issues |
| `rg` | Fast repository search for code, docs, labels, localization keys, routes, tests |
| `sed`, `nl`, `ls`, `git status` | Read focused file ranges and inspect repo state |
| `apply_patch` | Make manual edits to tracked files |
| `flutter`, `dart` | Analyze, test, generate localization, build Flutter artifacts |
| `npm`, `npx`, `wrangler`, `curl` | Backend TypeScript checks, Cloudflare Pages/D1 deploys, API smoke checks |
| `git` | Inspect diffs, commit completed work, capture commit SHA |

Default command patterns:

```bash
gh issue list --label raw --state open --json number,title,labels,updatedAt
gh issue view <number> --json number,title,body,comments,labels,url
gh issue comment <number> --body-file <file>
gh issue edit <number> --remove-label raw --add-label engineered
gh issue edit <number> --remove-label engineered --add-label proceeded
/graphify query "<question about the issue scope>" --budget 1500
git status --short
git diff --check
git commit -m "<Engineered Prompt Title>"
git rev-parse HEAD
```

When searching code or docs, prefer `rg`. When editing files manually, use `apply_patch`. When reading many files, parallelize reads where the IDE/tooling supports it.

### 3.1 Graphify Requirement

Graphify is the preferred broad-context tool for Hable engineering. Use it before writing an engineered prompt when the issue touches more than one file, system, or domain.

Use Graphify for:

- Cross-cutting Flutter/Riverpod/Drift/backend tasks.
- Social, auth, sync, scoring, localization, accessibility, build, deploy, or QA issues.
- Any task where the relevant files are not obvious from the issue body.
- Any task that may affect existing architecture or domain docs.

Graphify may be skipped only for trivial, single-file, obvious changes. If skipped, say why in the engineered reply or working notes.

Where to run it:

- Run Graphify from the repository root: `/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable`.
- Use the existing `graphify-out/graph.json` if present.
- If no graph exists, run `/graphify .` first.
- If the repo changed materially since the last graph build, run `/graphify . --update` before querying.

How to query it:

```bash
/graphify query "How does <issue topic> connect to Flutter widgets, Riverpod providers, Drift tables, backend routes, and docs?" --budget 1500
/graphify query "What existing Hable contracts and edge cases affect <issue topic>?" --budget 1500
/graphify query "Which files and docs are connected to <feature or bug>?" --budget 1500
/graphify query "What scalability risks or preservation rules apply to <issue topic>?" --budget 1500
```

Use BFS/default query mode for broad issue engineering. Use DFS only when tracing a specific path, such as auth token flow to sync headers:

```bash
/graphify query "How does auth token state reach daily sync headers?" --dfs --budget 1500
```

How to use the result:

- Treat Graphify as context, not authority. Confirm important facts by reading the cited files with `rg`, `sed`, or `nl`.
- Use Graphify output to choose dependency docs, likely implementation surfaces, edge cases, skipped scope, and scalability-preservation constraints.
- Mention the relevant Graphify-derived context in the engineered prompt when it affects scope.
- If Graphify is unavailable, continue with `rg` and direct file reads, and note that Graphify was unavailable.

---

## 4. Engineering An Issue

### 4.1 Selection

When the user asks to engineer or proceed issues:

1. Retrieve open GitHub issues.
2. Prefer the oldest open issue with `raw` for engineering.
3. Prefer the oldest open issue with `engineered` for proceeding.
4. Handle one issue at a time unless the user explicitly asks for batch work.
5. If an issue has no lifecycle label, inspect it and apply `raw` if it is unengineered.

### 4.2 Context Gathering

Before writing the engineered prompt:

1. Read this contract.
2. Read the GitHub issue body and existing comments.
3. Search the codebase with `rg` for related widgets, providers, routes, tables, tests, and docs.
4. Read the relevant `Developement/*.md` domain documents.
5. Run `/graphify query` from the repo root for every non-trivial issue; build or update the graph first if needed.
6. Confirm Graphify findings by opening the cited files directly.
7. Identify scalability-preservation constraints before setting scope.

For Hable tasks, always think in terms of Flutter widgets, Riverpod providers, Drift/local-first behavior, Cloudflare Pages Functions/D1/KV, localization, accessibility, QA, deployment effects, and scalability preservation.

Scalability preservation means the engineered scope must avoid avoidable growth in local database reads/writes, provider rebuilds, sync queue pressure, backend query fan-out, payload size, generated event volume, UI-thread work, and deployment/runtime cost. If a professional long-term scaling solution would make the task too large, keep the immediate scope bounded and name the larger solution in `Future split guidance`.

### 4.3 Engineered Reply Shape

Post the engineered prompt as a GitHub issue comment. Use this exact structure so future agents can parse it comfortably:

```markdown
Engineered task per `Developement/ai_agent_contract.md`.

**Title:** <Specific implementation title>

**Raw source:** <Short quote or summary of the issue body>

**Issue:** <Concrete problem statement>

**Triage:**
- Should exist: <Yes/No>
- Smallest safe scope: <Bounded scope>
- Skipped scope: <Explicitly deferred work>
- Boundaries: <Architecture/product limits>

**Action:** <What to implement>

**Hable perspective:** <Why this matters in Hable's Flutter/Riverpod/Drift/Cloudflare model>

**Implementation scope:**
- <Likely file/module/surface>
- <Likely file/module/surface>

**Scalability considerations:** <Concrete scaling risk, preservation rule, or "Scalability impact: none expected.">

**Future split guidance:** <Deferred follow-up tasks, if any>

**Edge cases:** <Concrete edge cases>

**Acceptance criteria:**
- <Checkable outcome>
- <Checkable outcome>

**Dependencies:** `<Developement/doc.md>`, `<Developement/other_doc.md>`
```

After posting the engineered reply:

1. Update labels from `raw` to `engineered`.
2. Do not implement in the same step unless the user explicitly asked to proceed.
3. Keep the engineered title stable; it should become the commit subject when implemented.

---

## 5. Proceeding An Engineered Issue

### 5.1 Implementation Rules

Before coding:

1. Re-read the engineered issue reply.
2. Re-read the dependency docs named in the engineered reply.
3. Inspect current code and tests because the repo may have changed since engineering.
4. Check `git status --short` and avoid mixing unrelated user changes into the task commit.

During coding:

- Keep scope inside the engineered prompt.
- Do not implement skipped scope.
- Update domain docs when behavior, architecture, UX, QA, build, localization, or API contracts change.
- Add focused tests when behavior changes.
- Run the narrowest meaningful verification commands, then broaden only when risk requires it.

### 5.2 Commit Rule

After verification passes, commit the issue work.

**Strict commit requirements:**

- Commit subject must be the engineered prompt title.
- Commit only the files belonging to this issue.
- Do not commit unrelated user changes.
- If unrelated changes are mixed into the same files and cannot be separated safely, stop and ask the user.
- Capture the commit SHA with `git rev-parse HEAD`.

Recommended commit format:

```bash
git add <issue-related files>
git commit -m "<Engineered Prompt Title>"
git rev-parse HEAD
```

---

## 6. Completion Reply

Post completion as a GitHub issue comment. This is the archive. Use this exact shape:

```markdown
Implemented the engineered scope for this issue.

**Commit:** `<full commit SHA>`

**Files touched:** `<file>`, `<file>`, `<file>`

**Behavior verified:** <What changed in product/code behavior>

**Verification passed:**
- `<command>`
- `<command>`

**Docs:** <Which dependency docs were updated or reviewed with no change>

**Deferred:** <Skipped scope that remains intentionally unimplemented, or "None">
```

After posting the completion reply:

1. Remove `engineered`.
2. Add `proceeded`.
3. Confirm the issue now has `proceeded`.
4. Close the issue using `gh issue close <number>`.

**Strict completion rule:** do not apply `proceeded` until the completion reply includes the commit SHA.

---

## 7. Local Documentation Alignment

Documentation updates still happen locally. GitHub replaces the task ledger, not the system docs.

Update relevant docs when the implementation changes:

- UX behavior: `ux_*.md`
- Data/API/schema rules: `sys_schema_and_logic.md`
- Auth/session behavior: `sys_authentication.md`
- Offline sync/local-first behavior: `sys_offline_architecture.md`
- Social/analytics behavior: `sys_social_and_analytics.md`
- Error behavior: `sys_error_handling.md`
- Build/deploy behavior: `sys_build_integrity.md`, `commands.md`
- QA expectations: `qa_testing.md`

The completion reply must explicitly say which dependency docs were updated or reviewed.

---

## 8. Task Selection Commands

Find raw issues:

```bash
gh issue list --state open --label raw --json number,title,createdAt,labels,url
```

Find engineered issues:

```bash
gh issue list --state open --label engineered --json number,title,createdAt,labels,url
```

Find proceeded issues:

```bash
gh issue list --state open --label proceeded --json number,title,updatedAt,labels,url
```

View one issue:

```bash
gh issue view <number> --json number,title,body,comments,labels,url
```

Confirm final label state:

```bash
gh issue view <number> --json labels,comments,url
```

---

## 9. Professionalism Standard

The GitHub issue thread should be readable by a human reviewer without opening the IDE history.

Minimum professional standard:

- The issue has a clear title.
- Lifecycle label is correct.
- The engineered reply is bounded and testable.
- The implementation commit uses the engineered title.
- The completion reply includes the full commit SHA.
- Verification commands are named exactly.
- Dependency docs are updated or explicitly reviewed.
- Deferred scope is named instead of silently ignored.

This workflow reduces local bookkeeping and token usage because the issue thread stores raw prompt, engineered scope, implementation report, commit identity, and historical archive in one searchable place.

---

## 10. Legacy Local Task Files

`Task0_Raw.md`, `Task1_Engineered.md`, and `Task2_Archived.md` remain useful historical references for older work. For new GitHub issue work:

- Do not add new raw tasks to `Task0_Raw.md`.
- Do not append engineered tasks to `Task1_Engineered.md`.
- Do not archive completed tasks into `Task2_Archived.md`.
- Only edit these files if the user explicitly asks to reconcile or migrate legacy task history.

If GitHub is unavailable, use the legacy local task files as a temporary fallback and later reconcile the result into GitHub when access returns.
