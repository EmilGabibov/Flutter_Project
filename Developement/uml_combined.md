# Hable UML Diagrams

This file combines the Mermaid diagrams from `Developement` into one documented reference.

## Contents

1. Authentication Flow
2. Offline Architecture
3. Schema & Core Logic
4. Social & Analytics
5. Habit States & Scoring
6. Mud Button & Animations

## 1. Authentication Flow

Source: [`sys_authentication.mmd`](sys_authentication.mmd)

Sequence diagram for PIN-based login and password reset.

```mermaid
sequenceDiagram
    participant User
    participant Flutter UI
    participant Backend API
    participant D1 DB
    
    User->>Flutter UI: Enter email & request PIN
    Flutter UI->>Backend API: POST /api/auth/request-pin
    Backend API->>D1 DB: Store PIN
    Backend API->>User: Send Email with PIN
    User->>Flutter UI: Enter PIN & new password
    Flutter UI->>Backend API: POST /api/auth/reset-password
    Backend API->>D1 DB: Validate PIN & Update Hash
    Backend API->>Flutter UI: Success
```

## 2. Offline Architecture

Source: [`sys_offline_architecture.mmd`](sys_offline_architecture.mmd)

Flowchart for the local-first data path using Riverpod, Drift, sync services, and Cloudflare backend sync.

```mermaid
flowchart TD
    UI[Flutter UI] --> Riverpod[Riverpod Providers]
    Riverpod --> LocalDB[(Drift SQLite)]
    LocalDB --> SyncQueue[Sync Queue]
    SyncService[Sync Service] --> SyncQueue
    SyncService <--> Internet((Cloudflare Backend))
    UI -.->|Invalidates & Calls| SyncService
```

## 3. Schema & Core Logic

Source: [`sys_schema_and_logic.mmd`](sys_schema_and_logic.mmd)

Relational table summary for the core user, habit, log, and friendship model.

| Table | Primary Key | Foreign Keys | Relationship Notes |
| --- | --- | --- | --- |
| `USERS` | `user_id` | - | One user can create many habits and logs. |
| `HABITS` | `id` | `user_id` → `USERS.user_id` | Each habit belongs to one user. |
| `LOGS` | `id` | `user_id` → `USERS.user_id`, `habit_id` → `HABITS.id` | Each log belongs to one user and one habit. |
| `PARTNERSHIPS` | composite or generated ID | `user_id` → `USERS.user_id`, `partner_id` → `USERS.user_id` | Connects users to shared habit participation. |
| `friend_requests` | request ID | `requester_id` → `USERS.user_id`, `recipient_id` → `USERS.user_id` | Tracks pending or completed friend request relationships. |

```mermaid
erDiagram
    USERS ||--o{ HABITS : creates
    USERS ||--o{ LOGS : creates
    HABITS ||--o{ LOGS : has
    USERS ||--o{ PARTNERSHIPS : engages
    USERS }|--|{ USERS : friend_requests
```

## 4. Social & Analytics

Source: [`sys_social_and_analytics.mmd`](sys_social_and_analytics.mmd)

Component flowchart for the social hub, leaderboard, friends tab, and sync service.

```mermaid
flowchart LR
    SocialHub[Social Hub Screen]
    Leaderboard[Leaderboard Tab]
    Friends[Friends Tab]
    SyncService[Sync Service]
    Backend((Cloudflare Backend))
    
    SocialHub --> Leaderboard
    SocialHub --> Friends
    Leaderboard --> Backend
    Friends --> SyncService
    SyncService --> Backend
```

## 5. Habit States & Scoring

Source: [`ux_habit_states_and_scoring.mmd`](ux_habit_states_and_scoring.mmd)

State diagram for the habit lifecycle, including check-ins, skips, and abandonment.

```mermaid
stateDiagram-v2
    [*] --> Active
    Active --> Completed : Check In
    Active --> Skipped : Skip Day
    Completed --> Active : Next Day
    Skipped --> Active : Next Day
    Active --> Abandoned : Too many misses
```

## 6. Mud Button & Animations

Source: [`ux_mud_and_animations.mmd`](ux_mud_and_animations.mmd)

State diagram for the long-press mud interaction and its completion/reset flow.

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Pressing : Pointer Down
    Pressing --> Idle : Pointer Up (Too early)
    Pressing --> Completed : Hold reaches 100%
    Completed --> Idle : Animation Reset
```
