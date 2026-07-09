# 07: Multi-User Social & 3D Environment Ideation

## Concept Overview
Hable is evolving beyond simple habit tracking into an inspiring, social experience. The vision is to visualize both your own and your friends' habits in a **3D abstract environment**. By seeing how friends spend their time, users can draw inspiration and plan their own schedules accordingly.

## Core Features

### 1. 3D Abstract Habit Environment
- **Visualization:** Instead of standard lists, habits are represented as elements in a 3D abstract space (e.g., floating orbs, growing trees, or building blocks in a personal galaxy).
- **Social Exploration:** Users can visit a friend's 3D environment to see their habit landscape.
- **Inspiration & Planning:** Viewing a friend's impressive habit structure (e.g., a massive, glowing orb for a 100-day reading streak) inspires the user to adopt similar habits. Users can "clone" or plan their own habits based on what they see.
- **Cool & Engaging:** The UI must feel premium, fluid, and gamified. Interactions should include smooth camera pans, particle effects on habit completion, and satisfying micro-animations.

### 2. Contextual & Milestone-based Wishes (Private Messaging)
- **Private Celebrations:** Users can send private, one-to-one messages or "best wishes" to friends based on their habit milestones.
- **Smart Suggestions:** 
  - *Midway:* When a friend reaches the halfway point of a challenge, suggest messages like "Keep it up! 🔥" or "You're halfway there! 🚀".
  - *Near End:* Approaching a goal triggers suggestions like "Almost at the finish line! 🏆" or "Last push! 💪".
  - *Special Days:* Similar to LinkedIn's birthday reminders, the system detects special occasions (e.g., 365-day streak, new year, birthday) and provides a carousel of pre-written, context-aware wishes with emojis.
- **Customization:** Users can choose from the smart suggestions or write their own custom message.

### 3. Habit Partnerships & Invitations
- **Adding New Habits:** Streamlined flow for adding new habits inspired by friends.
- **Partnering Up:** When creating a habit, a user can invite a friend to become a "Habit Partner".
- **Mutual Tracking:** If the friend accepts, the habit becomes a shared entity. Both users' progress is visually linked in the 3D environment (e.g., a dual-colored orb or a bridge connecting their spaces).

### 4. Friend Search & Partner Invite Flow
- **Friends List:** Users can view a list of accepted friends directly in the "Friends" tab of the Social Hub, which updates instantly when a friend request is accepted locally.
- **Friend Search:** Users can search for friends by username or exact user code. Results must be privacy-limited: username, avatar, and whether the user is already a friend or already invited.
- **Friend Request Gate:** Habit partner invites can only be sent to accepted friends. If the searched user is not already a friend, the UI should offer "Send friend request" first.
- **Invite From Habit Creation/Edit:** When creating or editing a habit, the user can search accepted friends and send a habit-partner invite for that specific habit.
- **Current MVP:** Habit creation reuses the shared standard-habit presets and presents accepted friends from the local Drift cache as compact chips. Sending an invite is queued offline after the habit is created.
- **Private Invitation State:** Pending invites are visible only to sender and recipient. Accepting an invite creates the partnership rows for that habit; declining does not expose progress.
- **Mutual Tracking After Accept:** Only after acceptance does the partner appear in social surfaces such as `PartnerTicker`, daily sync payloads, and future 3D linked habit views.

## Technical Implementation Considerations

### Frontend (Flutter)
- **3D Rendering:** Investigate Flutter 3D rendering options. Options include `flutter_3d_controller` (wrapping Filament/glTF), `ditto` or custom WebGL/CanvasKit shaders for abstract shapes and particle effects.
- **State Management:** Riverpod streams listening to Drift for real-time updates of the 3D scene state.

### Backend (Cloudflare Workers & D1)
- **Data Models:**
  - `milestone_events`: Table to track when users hit halfway or near-end marks to trigger wish suggestions.
  - `private_messages`: Secure, private table for storing the wishes sent between users.
  - `habit_invitations`: Table to manage the state of partner invitations (pending, accepted, rejected).
- **Search API:** Add a minimal friend search endpoint returning only safe profile fields and relationship state. Do not expose habit data from search.
- **Invitation API:** Habit invitation endpoints must verify accepted friendship before creating a pending habit invite, and must create symmetric `partnerships` rows only after recipient acceptance.
- **Push Notifications:** WebSockets or push notifications to alert users when they receive a wish or a partnership invite.

## Next Steps
1. Prototype a basic 3D abstract visual using Flutter shaders or a lightweight 3D engine.
2. Design the database schema for private messages and milestone events.
3. Build the UI for friend search, friend requests, and habit partnership invitations.
4. Build the UI for sending contextual wishes.
