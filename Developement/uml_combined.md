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

Source: [`sys_authentication.md`](sys_authentication.md)

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

Source: [`sys_offline_architecture.md`](sys_offline_architecture.md)

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

Source: [`sys_schema_and_logic.md`](sys_schema_and_logic.md)

Advanced relational schema for the core user, habit, log, and friendship model.

```mermaid
erDiagram
    USERS {
        uuid user_id PK
        string username UK
        string email UK
        datetime email_verified_at
        string password_hash
        string avatar_url
        int total_score
        datetime updated_at
        boolean is_synced
    }

    HABITS {
        uuid id PK
        uuid user_id FK
        string title
        string description
        int target_duration
        string color_hex
        string status
        datetime created_at
        datetime updated_at
        boolean is_synced
    }

    LOGS {
        uuid id PK
        uuid user_id FK
        uuid habit_id FK
        string status
        datetime logged_at
        string journal_entry
        datetime updated_at
        boolean is_synced
    }

    HABIT_PROGRESS {
        uuid id PK
        uuid user_id FK
        uuid habit_id FK
        int current_duration
        datetime updated_at
        boolean is_synced
    }

    PARTNERSHIPS {
        uuid id PK
        uuid user_id FK
        uuid partner_id FK
        uuid habit_id FK
        string role
        datetime updated_at
        boolean is_synced
    }

    FRIEND_REQUESTS {
        uuid id PK
        uuid requester_id FK
        uuid recipient_id FK
        string status
        datetime created_at
        datetime updated_at
        boolean is_synced
    }

    USER_SCORE_EVENTS {
        uuid id PK
        uuid user_id FK
        uuid source_event_id PK
        int points
        string reason
        datetime created_at
        datetime updated_at
        boolean is_synced
    }

    USER_ACHIEVEMENTS {
        uuid id PK
        uuid user_id FK
        string achievement_id PK
        datetime unlocked_at
        uuid source_event_id
        datetime updated_at
        boolean is_synced
    }

    HABIT_INVITATIONS {
        uuid id PK
        uuid requester_id FK
        uuid recipient_id FK
        uuid habit_id FK
        string status
        datetime created_at
        datetime updated_at
        boolean is_synced
    }

    USERS ||--o{ HABITS : owns
    USERS ||--o{ LOGS : writes
    HABITS ||--o{ LOGS : records
    USERS ||--o{ HABIT_PROGRESS : tracks
    HABITS ||--o{ HABIT_PROGRESS : tracks
    USERS ||--o{ PARTNERSHIPS : source_user
    USERS ||--o{ PARTNERSHIPS : partner_user
    HABITS ||--o{ PARTNERSHIPS : scopes
    USERS ||--o{ FRIEND_REQUESTS : requester
    USERS ||--o{ FRIEND_REQUESTS : recipient
    USERS ||--o{ USER_SCORE_EVENTS : earns
    USERS ||--o{ USER_ACHIEVEMENTS : unlocks
    USERS ||--o{ HABIT_INVITATIONS : requests
    USERS ||--o{ HABIT_INVITATIONS : receives
    HABITS ||--o{ HABIT_INVITATIONS : targets
```

## 4. Social & Analytics

Source: [`sys_social_and_analytics.md`](sys_social_and_analytics.md)

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

Source: [`ux_habit_states_and_scoring.md`](ux_habit_states_and_scoring.md)

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

Source: [`ux_mud_and_animations.md`](ux_mud_and_animations.md)

State diagram for the long-press mud interaction and its completion/reset flow.

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Pressing : Pointer Down
    Pressing --> Idle : Pointer Up (Too early)
    Pressing --> Completed : Hold reaches 100%
    Completed --> Idle : Animation Reset
```
