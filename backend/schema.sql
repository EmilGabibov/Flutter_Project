CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL,
    avatar_url TEXT
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
    PRIMARY KEY (user_id, partner_id, habit_id)
);

CREATE TABLE IF NOT EXISTS friend_requests (
    id TEXT PRIMARY KEY,
    requester_id TEXT NOT NULL,
    recipient_id TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'accepted', 'rejected'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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

CREATE TABLE IF NOT EXISTS milestone_events (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    habit_id TEXT NOT NULL,
    milestone_type TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert some dummy data for local testing
INSERT OR IGNORE INTO users (id, username, avatar_url) VALUES 
('local-user-1', 'Alice', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice'),
('local-user-2', 'Bob', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob');

INSERT OR IGNORE INTO habit_progress (user_id, habit_id, current_duration) VALUES
('local-user-2', 'shared-habit-1', 45);

INSERT OR IGNORE INTO partnerships (user_id, partner_id, habit_id) VALUES
('local-user-1', 'local-user-2', 'shared-habit-1'),
('local-user-2', 'local-user-1', 'shared-habit-1');
