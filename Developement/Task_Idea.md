# Hable: Raw Ideas & Feature Backlog

## 1. Database Roles & Relationships (High Priority Blocker)
* **Objective:** Expand the D1 `partnerships` table to support Role-Based Access Control (RBAC) via a `role` enum to prevent client-side state conflicts.
* **Owner:** Can edit/delete the habit, complete/skip, and nudge participants.
* **Partner:** Can complete/skip, view details, and nudge others. Cannot edit/delete the habit.
* **Supporter:** Read-only view of progress, can send encouragement/nudges. by pressing and holding the habit ring and completing it (with same difficulty as owner/partner). Cannot complete/skip or edit. 
* **Relationship Types:** Sole creator, mutual friendships (send/accept), and multi-partner habits.
* **Action:** Engineer a D1 schema migration and update the Cloudflare Worker to enforce these permissions before updating the Flutter UI.

## 2. Gamification: Achievements, Badges & Points
* **Objective:** Implement a server-side progression system returned via the `/api/sync/daily` payload to keep the Flutter client lightweight and prevent spoofing.
* **Points System:** Award 5 points per check-in. Award bonus points when all partners in a shared habit check in.
* **Levels:** Map total points to named tiers (e.g., "Newbie") to replace raw numbers on the user profile.
* **Badges:** Track milestones (first check-in, 10/100/1000 streaks, first nudge, first supporter) entirely on the backend.
* **Action:** Update the Cloudflare Worker to calculate and append unlocked achievements to the user payload during the `SyncQueue` flush.

## 3. Habit Card & Profile UI Polish
* **Objective:** Update the client UI to reflect the new roles and gamification data (Strictly blocked by Item 1).
* **User Card:** Compact the profile view to show the profile picture, name, username, and the dynamic Level Name.
* **Habit Card Data:** Display habit title, icon, current streak, target days, and a horizontal progress line along the bottom border.
* **Social Ring:** Show the habit icon inside a color-coded ring. Fill the ring upon completion; leave it empty for active/skipped states.
* **Partner Visibility:** Display a maximum of 4 partner/supporter avatars per card, adding a status ring around their profile pictures to indicate daily completion.

## 4. Edge-Native Calendar Integration (iCal)
* **Objective:** Allow users to view daily habits in their native phone calendar without adding heavy, permission-bloated Flutter calendar dependencies.
* **Architecture:** Create a Cloudflare Worker route that generates a dynamic, read-only `.ics` (iCalendar) feed subscription link per user.
* **Event Title:** Generate dynamic motivational messages based on progress. Group multiple daily habits into a single summary event to prevent calendar app clutter.
* **Event Description:** Keep descriptions highly concise. Include partner names and the current target fraction (e.g., 3/5 days).

## 5. System Architecture Documentation
* **Objective:** Replace manual, text-heavy documentation tasks with maintainable, code-native diagrams.
* **Database Schema:** Generate a `Mermaid.js` Entity-Relationship (ER) diagram mapping D1 tables, columns, and relationships.
* **System Flow:** Create a `Mermaid.js` sequence diagram illustrating the offline-first sync architecture, showing interactions between Flutter, Riverpod, Drift, and Cloudflare Workers.