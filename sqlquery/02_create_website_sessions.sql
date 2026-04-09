-- Table: website_sessions
-- Description: Traffic and session data
CREATE TABLE website_sessions (
    website_session_id INTEGER PRIMARY KEY,
    created_at TEXT,
    user_id INTEGER NOT NULL,
    is_repeat_session INTEGER,
    utm_source TEXT,
    utm_campaign TEXT,
    utm_content TEXT,
    device_type TEXT,
    http_referer TEXT
);
