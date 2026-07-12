# Hable: Raw Ideas & Feature Backlog to discuss them with ai chat bots
_______________________________


Based on the strategic goals in `Task_Idea.md` and the system architecture in `ux_mud_and_animations.md`, the following tasks are prioritized for immediate coding implementation. The focus is on resolving the "Completion Loop" bug, refining the "Mud" ring interaction, and cleaning up the Home Screen Information Architecture.

-----

## Phase 1: Critical Logic & Infrastructure (Priority: High)

> \[\!IMPORTANT\]
> **Task 1: Resolve Habit Completion Sync Loop**
> 
>   * **Issue:** Habits currently disappear and reappear upon completion due to sync conflicts between partners.
>   * **Action:** Modify `SyncService.pullDailySync` and the local habit watcher to distinguish between "Daily Check-In" and "Challenge Lifecycle Completion". Ensure partner-side check-ins do not trigger the `archive` or `completed` status for the shared metadata row.
>   * **Files:** `lib/services/sync_service.dart`, `lib/database/database.dart`.

**Task 2: Implement "Mud" Resistance State Notifier**

  * **Action:** Extract the physics-driven resistance math ($R = 1.0 - (d/D)$) into a dedicated Riverpod `StateNotifier` as mandated by the `sys_offline_architecture.md`.
  * **Rationale:** This isolates physics calculations from the UI thread to ensure fluid animations on mobile devices.
  * **Files:** `lib/providers/habit_providers.dart`, `lib/widgets/mud_long_press_button.dart`.

-----

### Phase 2: Refined Habit Card & Ring States (Priority: Medium)

**Task 3: Engineering the Five Ring States**

  * **Action:** Implement the visual cycle for the habit ring:
    1.  **Empty:** Idle state awaiting interaction.
    2.  **Completing:** Long-press scaling animation where a faded emoji shrinks as the ring fills.
    3.  **Completion:** Trigger a brief checkmark animation on the ring before settling.
    4.  **Complete:** Solid colored ring with the final emoji.
    5.  **Missed:** Dimmed/Pastel state for overdue tasks.
  * **Note:** Remove all percentage labels; move them to ARIA Semantics for accessibility.

**Task 4: Consolidated Card Information Architecture**

  * **Action:** Redesign the habit card to be narrower:
      * **Continuous Lifestyle:** Move 🔥 streak icon to the header.
      * **Challenge-Based:** Embed 🔥 icon and "Day X of Y" notation within the progress bar.
      * **Social:** Replace "Solo Today" with "Partners Remains" on the right-hand side.
  * **Files:** `lib/widgets/habit_card.dart`.

-----

### Phase 3: Engagement & Growth (Priority: Low)

**Task 5: The "Completion Moment" Splash Screen**

  * **Action:** Create a dynamic typographic splash screen triggered upon final habit completion. It must display a dynamic congratulation message and the "Quote of the Day" fetched from the daily sync.
  * **Files:** `lib/screens/completion_splash_screen.dart`.

**Task 6: Shareable Achievement Cards (MVP)**

  * **Action:** Implement a background service to render a shareable PNG card containing the habit name, duration, participant emojis, and the Hable logo.
  * **Technical Constraint:** Use the server-owned `total_points` and achievement data as the source of truth for the certificate.

-----

### Implementation Priority Roadmap

| Priority | Task                     | Dependency              |
| :------- | :----------------------- | :---------------------- |
| **P0**   | Fix Completion Sync Loop | Backend D1 Schema       |
| **P0**   | Remove "Skip" Button     | Automatic Overdue Logic |
| **P1**   | 5-State Ring Interaction | Mud Resistance Notifier |
| **P1**   | IA Shell Cleanup (3-Tab) | `MainNavigationShell`   |
| **P2**   | Completion Splash Screen | Quote API               |
| **P3**   | Shareable PNG Generator  | Achievement Backend     |
