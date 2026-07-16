CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE,
    email_verified_at DATETIME,
    password_hash TEXT,
    avatar_url TEXT,
    total_score INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_users_score ON users(total_score DESC);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

CREATE TABLE IF NOT EXISTS push_subscriptions (
    user_id TEXT NOT NULL,
    device_token TEXT NOT NULL,
    platform TEXT NOT NULL,
    endpoint_url TEXT NOT NULL,
    auth_keys TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    quiet_hours_enabled INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, device_token)
);

CREATE INDEX IF NOT EXISTS idx_push_subscriptions_endpoint
ON push_subscriptions(endpoint_url);

CREATE TABLE IF NOT EXISTS auth_pins (
    email TEXT PRIMARY KEY,
    pin_hash TEXT NOT NULL,
    expires_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS habit_progress (
    user_id TEXT NOT NULL,
    habit_id TEXT NOT NULL,
    current_duration INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, habit_id)
);

CREATE TABLE IF NOT EXISTS partnerships (
    user_id TEXT NOT NULL,
    partner_id TEXT NOT NULL,
    habit_id TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'partner' CHECK (role IN ('owner', 'partner', 'supporter')),
    PRIMARY KEY (user_id, partner_id, habit_id)
);

CREATE INDEX IF NOT EXISTS idx_partnerships_user_habit_role
ON partnerships(user_id, habit_id, role);

CREATE INDEX IF NOT EXISTS idx_partnerships_partner_habit
ON partnerships(partner_id, habit_id);

CREATE TABLE IF NOT EXISTS friend_requests (
    id TEXT PRIMARY KEY,
    requester_id TEXT NOT NULL,
    recipient_id TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'accepted', 'declined'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_friend_requests_recipient_status_created
ON friend_requests(recipient_id, status, created_at);

CREATE INDEX IF NOT EXISTS idx_friend_requests_requester_status_created
ON friend_requests(requester_id, status, created_at);

CREATE INDEX IF NOT EXISTS idx_friend_requests_pair_status
ON friend_requests(requester_id, recipient_id, status);

CREATE TABLE IF NOT EXISTS private_messages (
    id TEXT PRIMARY KEY,
    sender_id TEXT NOT NULL,
    recipient_id TEXT NOT NULL,
    message TEXT NOT NULL,
    milestone_type TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS habit_invitations (
    id TEXT PRIMARY KEY,
    requester_id TEXT NOT NULL,
    recipient_id TEXT NOT NULL,
    habit_id TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'accepted', 'rejected'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_habit_invitations_pending_pair
ON habit_invitations(requester_id, recipient_id, habit_id, status);

CREATE TABLE IF NOT EXISTS milestone_events (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    habit_id TEXT NOT NULL,
    milestone_type TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS habits (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    target_duration INTEGER NOT NULL,
    color_hex TEXT,
    status TEXT NOT NULL DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS habit_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    habit_id TEXT NOT NULL,
    status TEXT NOT NULL,
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_habit_logs_user_habit_status_date
ON habit_logs(user_id, habit_id, status, logged_at);

CREATE TABLE IF NOT EXISTS user_score_events (
    user_id TEXT NOT NULL,
    source_event_id TEXT NOT NULL,
    points INTEGER NOT NULL,
    reason TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, source_event_id)
);

CREATE INDEX IF NOT EXISTS idx_score_events_user_created
ON user_score_events(user_id, created_at);

CREATE TABLE IF NOT EXISTS user_achievements (
    user_id TEXT NOT NULL,
    achievement_id TEXT NOT NULL,
    unlocked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    source_event_id TEXT NOT NULL,
    PRIMARY KEY (user_id, achievement_id)
);

CREATE INDEX IF NOT EXISTS idx_achievements_user_unlocked
ON user_achievements(user_id, unlocked_at);

CREATE TABLE IF NOT EXISTS calendar_feed_tokens (
    user_id TEXT PRIMARY KEY,
    token TEXT NOT NULL,
    token_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    rotated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    revoked_at DATETIME
);

CREATE INDEX IF NOT EXISTS idx_calendar_feed_tokens_hash
ON calendar_feed_tokens(token_hash);

CREATE TABLE IF NOT EXISTS usage_aggregate_buckets (
    bucket_date TEXT NOT NULL,
    platform TEXT NOT NULL,
    build_channel TEXT NOT NULL,
    screen_name TEXT NOT NULL,
    metric_name TEXT NOT NULL,
    count INTEGER NOT NULL DEFAULT 0,
    total_duration_ms INTEGER NOT NULL DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (bucket_date, platform, build_channel, screen_name, metric_name)
);

CREATE INDEX IF NOT EXISTS idx_usage_aggregate_buckets_date
ON usage_aggregate_buckets(bucket_date, platform, build_channel);

-- Insert some dummy data for local testing
INSERT OR IGNORE INTO users (id, username, avatar_url) VALUES 
('local-user-1', 'Alice', '🌱'),
('local-user-2', 'Bob', '🌞');

INSERT OR IGNORE INTO habit_progress (user_id, habit_id, current_duration) VALUES
('local-user-2', 'shared-habit-1', 45);

INSERT OR IGNORE INTO partnerships (user_id, partner_id, habit_id, role) VALUES
('local-user-1', 'local-user-1', 'shared-habit-1', 'owner'),
('local-user-1', 'local-user-2', 'shared-habit-1', 'owner'),
('local-user-2', 'local-user-2', 'shared-habit-1', 'partner'),
('local-user-2', 'local-user-1', 'shared-habit-1', 'partner');
