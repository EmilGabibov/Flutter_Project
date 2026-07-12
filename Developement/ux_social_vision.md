# 07: Multi-User Social Features — Vision & MVP Contracts

> [!IMPORTANT]
> **This document contains two distinct registers of content:**
> - Sections marked **`[CURRENT MVP]`** describe production contracts that are already implemented or actively being implemented in code. Treat these as authoritative behavioral specs.
> - Sections marked **`[VISION]`** are exploratory long-term ideation. They are **NOT implemented** and must NOT be acted on without a dedicated engineered task in `Task1_Engineered.md`.

## Concept Overview

Hable is evolving beyond simple habit tracking into an inspiring, social experience. The vision is to visualize both your own and your friends' habits in a **3D abstract environment**. By seeing how friends spend their time, users can draw inspiration and plan their own schedules accordingly.

## Core Features

### 1. [VISION] 3D Abstract Habit Environment
- **Visualization:** Instead of standard lists, habits are represented as elements in a 3D abstract space (e.g., floating orbs, growing trees, or building blocks in a personal galaxy).
- **Social Exploration:** Users can visit a friend's 3D environment to see their habit landscape.
- **Inspiration & Planning:** Viewing a friend's impressive habit structure (e.g., a massive, glowing orb for a 100-day reading streak) inspires the user to adopt similar habits. Users can "clone" or plan their own habits based on what they see.
- **Cool & Engaging:** The UI must feel premium, fluid, and gamified. Interactions should include smooth camera pans, particle effects on habit completion, and satisfying micro-animations.

### 2. [VISION] Contextual & Milestone-based Wishes (Private Messaging)
- **Private Celebrations:** Users can send private, one-to-one messages or "best wishes" to friends based on their habit milestones.
- **Server-Owned Progression:** Completion points, shared-habit bonuses, levels, and achievement badges are calculated in the Worker and returned through daily sync. Social UI should consume that payload instead of recomputing achievements locally.
- **Smart Suggestions:** 
  - *Midway:* When a friend reaches the halfway point of a challenge, suggest messages like "Keep it up! 🔥" or "You're halfway there! 🚀".
  - *Near End:* Approaching a goal triggers suggestions like "Almost at the finish line! 🏆" or "Last push! 💪".
  - *Special Days:* Similar to LinkedIn's birthday reminders, the system detects special occasions (e.g., 365-day streak, new year, birthday) and provides a carousel of pre-written, context-aware wishes with emojis.
- **Customization:** Users can choose from the smart suggestions or write their own custom message.

### 3. [CURRENT MVP] Habit Partnerships & Invitations
- **Adding New Habits:** Streamlined flow for adding new habits inspired by friends.
- **Partnering Up:** When creating a habit, a user can invite a friend to become a "Habit Partner".
- **Mutual Tracking:** If the friend accepts, the habit becomes a shared entity. Both users' progress is visually linked in the 3D environment (e.g., a dual-colored orb or a bridge connecting their spaces).
- **Role Foundation:** Shared habits are now role-scoped at the backend. `Owner` controls habit metadata, `partner` can log progress, and future `supporter` views must stay read-only for progress while still allowing encouragement.

### 4. [CURRENT MVP] Friend Search & Partner Invite Flow
- **Friends List:** Users can view a list of accepted friends in the "Friends" tab (Social → Friends). Pending incoming friend requests appear inline at the top of this tab with Accept/Decline actions. The list updates instantly when a request is accepted.
- **Friend Search:** Users search for friends by username prefix via a **bottom sheet** triggered by the search icon in the Social header. Results are privacy-limited to user id, username, avatar, and relationship state (`none`, `pending_incoming`, `pending_outgoing`, `accepted`).
- **Activity Feed:** The "Activity" tab (Social → Activity) provides a unified chronological feed of all social events: nudges, friend requests, habit invites, private messages, and reminder settings. This merges the former standalone Notification Center and Inbox. The Home bell icon switches to this tab instead of pushing a separate screen.
- **Friend Request Gate:** Habit partner invites can only be sent to accepted friends. If the searched user is not already a friend, the UI should offer "Send friend request" first.
- **Invite From Habit Creation/Edit:** When creating or editing a habit, the user can search accepted friends and send a habit-partner invite for that specific habit.
- **Current MVP:** Habit creation reuses the shared standard-habit presets and presents accepted friends from the local Drift cache as compact chips. Sending an invite is queued offline after the habit is created.
- **Private Invitation State:** Pending invites are visible only to sender and recipient. Accepting an invite creates the partnership rows for that habit; declining does not expose progress.
- **Mutual Tracking After Accept:** Only after acceptance does the partner appear in social surfaces such as `PartnerTicker`, daily sync payloads, and future 3D linked habit views.
- **Current Card Surface:** The practical MVP surface is the Home habit card itself: role-aware avatars, daily-completion state, and capped partner counts should sit next to the habit rather than in a disconnected global strip.
- **Lifecycle Reconciliation:** Daily sync must carry enough metadata for the receiving install to keep shared habits aligned with backend truth, including archive state and the viewer's own remaining-days progress, instead of only showing the partner's snapshot.
- **Shared Check-In Retention:** A partner-side check-in must not remove the shared habit card from Home when the viewer's remaining days reaches zero. Owner-owned habits may complete normally; partner-synced cards stay active so the shared accountability surface remains available.
- **Unified Notification Surface:** The same daily sync pass should also hydrate a Drift-backed notification center for nudges, friend requests, accepted-friend changes, invites, and private messages. Social events should not stay trapped inside their source tabs if the user misses them live.
- **Habit-Scoped Nudge State:** Nudges should be habit-scoped when possible and coalesced into `PartnerSnapshots.lastNudgeAt`, allowing Home cards to show the relevant sender/habit without building an unbounded event stream.
- **Friend Drilldown:** Partner/friend identity should consistently open the existing friend profile. Habit-card nudges stay habit-scoped through a separate action, and friend-profile `Follow` only pre-fills local habit creation from safe active-habit metadata.

## Technical Implementation Considerations

> [!NOTE]
> The 3D rendering investigation below (`flutter_3d_controller`, `ditto`, WebGL/CanvasKit shaders) is **future/vision scope**. Current implementation uses standard Flutter widgets, `CustomPainter`, and `fl_chart`. Do not add 3D rendering dependencies without a dedicated engineered task.

### Frontend (Flutter)
- **3D Rendering:** Investigate Flutter 3D rendering options. Options include `flutter_3d_controller` (wrapping Filament/glTF), `ditto` or custom WebGL/CanvasKit shaders for abstract shapes and particle effects.
- **State Management:** Riverpod streams listening to Drift for real-time updates of the 3D scene state.

### Backend (Cloudflare Workers & D1)
- **Data Models:**
  - `milestone_events`: Table to track when users hit halfway or near-end marks to trigger wish suggestions.
  - `private_messages`: Secure, private table for storing the wishes sent between users.
  - `habit_invitations`: Table to manage the state of partner invitations (pending, accepted, rejected).
  - `user_score_events` and `user_achievements`: Backend-owned progression tables for idempotent point awards and badge unlocks.
- **Search API:** The minimal friend search endpoint returns only safe profile fields and relationship state. Do not expose habit data, score totals, logs, or private messages from search.
- **Invitation API:** Habit invitation endpoints must verify accepted friendship before creating a pending habit invite, and after recipient acceptance must create role-aware directed `partnerships` rows so all participants see only authorized shared-habit data.
- **Push Notifications:** WebSockets or push notifications to alert users when they receive a wish or a partnership invite.

## Next Steps

> [!NOTE]
> These "Next Steps" are **aspirational roadmap items**, not an active implementation queue. Track these against `Task0_Raw.md` only when the project is ready to prioritize them.

1. Prototype a basic 3D abstract visual using Flutter shaders or a lightweight 3D engine.
2. Design the database schema for private messages and milestone events.
3. Extend friend request UI only after the current search/request/accept/decline primitive needs pagination, blocking, QR codes, or contact import.
4. Build the UI for sending contextual wishes.
