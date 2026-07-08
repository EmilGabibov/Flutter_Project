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

## Technical Implementation Considerations

### Frontend (Flutter)
- **3D Rendering:** Investigate Flutter 3D rendering options. Options include `flutter_3d_controller` (wrapping Filament/glTF), `ditto` or custom WebGL/CanvasKit shaders for abstract shapes and particle effects.
- **State Management:** Riverpod streams listening to Drift for real-time updates of the 3D scene state.

### Backend (Cloudflare Workers & D1)
- **Data Models:**
  - `milestone_events`: Table to track when users hit halfway or near-end marks to trigger wish suggestions.
  - `private_messages`: Secure, private table for storing the wishes sent between users.
  - `habit_invitations`: Table to manage the state of partner invitations (pending, accepted, rejected).
- **Push Notifications:** WebSockets or push notifications to alert users when they receive a wish or a partnership invite.

## Next Steps
1. Prototype a basic 3D abstract visual using Flutter shaders or a lightweight 3D engine.
2. Design the database schema for private messages and milestone events.
3. Build the UI for sending contextual wishes and habit partnership invitations.
