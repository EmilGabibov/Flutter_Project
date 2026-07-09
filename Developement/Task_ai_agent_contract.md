# AI Agent Operating Contract — Project Hable

> Canonical source of truth for all AI agent behavioral rules governing the Project Hable task pipeline.  
> Referenced by: [`Task0_Raw.md`](Task0_Raw.md), [`Task1_Engineered.md`](Task1_Engineered.md), [`Task2_Archived.md`](Task2_Archived.md).

---

## 1. File Roles

| File | Role | What lives here |
|---|---|---|
| [`Task0_Raw.md`](Task0_Raw.md) | **Raw intake queue** | Rough, user-written, or partially specified tasks. Never implement directly from here. |
| [`Task1_Engineered.md`](Task1_Engineered.md) | **Engineered implementation queue** | Actionable tasks with full scope, edge cases, and acceptance criteria. Also hosts the compact completed-task index under `# Completed Tasks`. |
| [`Task2_Archived.md`](Task2_Archived.md) | **Full-body archive** | Preserves the complete markdown bodies of completed engineered tasks after they are compacted out of the active queue. |

---

## 2. Engineering a Task

### 2.1 Intake → Engineering Flow

1. **Select exactly one** pending raw item from `Task0_Raw.md`.
2. **Query the knowledge graph** using `/graphify query "your question"` (or `mcp_graphify_query_graph`) to gather context on existing files, Flutter widgets, Riverpod providers, and Drift tables.
3. **Read related domain documentation** in the `Developement/` folder depending on the prompt's subject (e.g., `03_UI_UX_and_Animations.md` for widgets, `02_Offline_Architecture.md` for background sync) to maintain architectural standards.
4. Run a **Ponytail triage** before expanding the raw item.
   - Use the active Ponytail binding for the host: `@ponytail` / `/ponytail` when exposed, or the installed Ponytail skill/instructions/hooks.
   - Treat Ponytail as an instruction bond, not an MCP/tool dependency. Let it evaluate scope safety, non-negotiable architectural boundaries (e.g., Offline-First), and what to skip.
5. If the raw prompt is **not clear** after plugin triage, write the required triage questions for the user to answer before proceeding.
6. **Preserve the user's intent**, expand it from the Hable web/mobile app perspective using gathered context, and keep the engineered scope to the smallest safe version determined by the Ponytail triage.
7. **Append** the engineered version to `Task1_Engineered.md`, explicitly listing the related development document in the "Dependencies" section so subsequent tasks will read and update it.
8. **Verify** that the appended task exists in `Task1_Engineered.md`, add a stable HTML anchor (`<a id="task-slug"></a>`) immediately before the task heading, and capture that anchor.
9. **Only then** remove the raw item or mark it as transferred with the engineered task title, date, and `Task1_Engineered.md#task-slug` anchor.

> [!IMPORTANT]
> Engineering a task and implementing/proceeding with a task must be completed **separately**, not one after another in the same response.

### 2.2 Required Shape for Engineered Entries

Every new entry in `Task1_Engineered.md` must include:

- **Title** (Must be descriptive and specific. Do NOT use single-word titles)
- **Raw source** (the original user prompt)
- **Issue** (problem statement)
- **Ponytail triage** (whether the task should exist, smallest safe scope, skipped scope, and boundaries)
- **Action** (what to do)
- **Hable perspective** (Flutter/Riverpod/Drift-specific context)
- **Implementation scope** (name likely Flutter widgets, Riverpod providers, Drift DAOs, background sync queues, and test surfaces)
- **Scalability considerations** (see §4)
- **Future split guidance** (when a scaling approach would broaden the work, name what is deferred and whether follow-up tasks should be appended)
- **Edge cases** (e.g., offline states, failed syncs, UI thread jank)
- **Acceptance criteria**
- **Dependencies** (Which `0x_...md` docs are touched)
- **Completion-note placeholder**: `[Placeholder for completion notes, touched files, behavior verified, and completion timestamp]`

### 2.3 Documentation Alignment

If your implementation changes the underlying Drift schema, Riverpod logic, or UX flow, you **MUST** proactively update the corresponding `Developement/0x_*.md` documentation to keep it strictly aligned with the codebase. 

> [!IMPORTANT]
> When moving a task to completion, the agent MUST explicitly state in the `Completion notes` whether the documents listed in the task's `Dependencies` were verified and updated.

---

## 3. Implementing a Task

### 3.1 Completion Workflow

1. Change `[ ]` to `[x]` and replace the completion-note placeholder with files changed, behavior verified, confirmation of doc updates, and a **completion timestamp** (e.g., `Completed At: YYYY-MM-DD HH:MM Z`).
   - **Strict Rule:** Do not mark a task as complete (`[x]`) if its completion notes still contain the `[Placeholder for completion notes...]` string.
2. Run the archive validation script (if available) to ensure there are no hygiene defects before archiving.
3. Execute the archive script (if available) to automatically move the full completed task body into `Task2_Archived.md`.
4. Do **not** manually copy the task to `Task2_Archived.md`. The archive script handles this to reduce token usage.
5. **STRICT RULE ON INCOMPLETE TASKS:** Agents must NEVER manually move uncompleted (`[ ]`) tasks from `Task1_Engineered.md` or `Task0_Raw.md` into `Task2_Archived.md`.

### 3.2 Completion Behavior

- Do **not** mark a task complete just because it was engineered.
- **Mandatory Archive Update:** When a task is archived, any related `Task0_Raw.md` transfer notes MUST use the stable HTML anchor (`Task2_Archived.md#task-slug`) as the authoritative lookup key.
- Active engineered-task links should also prefer stable HTML anchors (`Task1_Engineered.md#task-slug`) instead of line-number anchors.
- Prompt links must not use `#Lx-Ly` line anchors.

### 3.3 Task Selection

- When instructed to work on the remaining tasks, automatically select the oldest (first) remaining uncompleted task from the `# Remaining Tasks` queue in `Task1_Engineered.md` and begin implementing it without asking for confirmation.

### 3.4 Handling Anomalies and Concurrent Changes

- **Completed Tasks Left in `# Remaining Tasks`**: If a script skips a completed task (`[x]`), ensure the `[Placeholder...` string has been completely removed.
- **Documentation-Integrity Backlog**: Treat raw tasks related to documentation integrity just like any other raw task. They must be engineered first.

---

## 4. Scalability Considerations Requirement

Every engineered task must either name concrete scaling assumptions/risks or explicitly state: *"Scalability impact: none expected."*

### Hable-Specific Scaling Domains

- **Drift Database Growth**: SQLite performance as the local history log scales to thousands of habit events.
- **Offline Sync Queue (Workmanager)**: Managing backpressure, batching HTTP requests, and handling merge conflicts when the sync queue is large after prolonged offline use.
- **UI Thread Blocking**: Ensuring math-heavy physics (e.g., mud resistance coefficient) or large data parsing NEVER occurs on the main UI thread. Keep logic in isolations or `StateNotifier`s.
- **Riverpod Provider Rebuilds**: Watching fine-grained streams rather than whole tables to prevent excessive widget rebuilds (`select` filters).
- **Inverted Index Engine**: Handling text tokenization without blocking the app during large multi-threaded indexing tasks.

### Future-Oriented Scope Splitting

If a professional long-term approach is clearly useful but would turn a small task into a large implementation, the engineered task must keep the immediate scope small and add **Future split guidance** that names the deferred work. Append raw tasks for the deferred items.

---

## 5. Ordering & File Structure Contracts

### `Task0_Raw.md`
- If empty, do **not** invent a raw backlog item unless the user supplied new context in the same prompt. 

### `Task1_Engineered.md`
- Keep only **compact completed-task index notes** under `# Completed Tasks`.
- Keep all still-open work in a dedicated `# Remaining Tasks` section at the end of the file.

### `Task2_Archived.md`
- Keep archived task bodies as close to their original engineered form as possible.

### Lookup Contract
Use `Task1_Engineered.md` for the fast completed-task index and open queue, then open the archive only when the compact index indicates deeper historical context is needed.

---

## 6. Implementation Guidance Defaults

Keep implementation guidance **concrete**. Name the likely:

- Flutter widgets (UI layer)
- Riverpod providers (State layer)
- Drift DAOs/Tables (Persistence layer)
- Workmanager handlers (Sync layer)
- Cloudflare D1/Workers bindings (Backend expectations)
- Accessibility surfaces (Semantics)
- Test surfaces (Widget tests, Provider unit tests)

---

## 7. Known Script Limits and Boundaries

- **Validation Gaps**: Scripts (if ported to Hable) check for broken links and placeholders, but do NOT enforce the presence of Ponytail triage fields. The agent must enforce these manually.
- **Manual Repair Boundaries**: If a formatting error breaks a script, the agent must fix the formatting in `Task1_Engineered.md` (e.g., ensuring `# Remaining Tasks` exists exactly once).
- **Follow-up Raw Tasks**: Append separate raw tasks to `Task0_Raw.md` for any concrete tool/process gaps discovered during an audit.
