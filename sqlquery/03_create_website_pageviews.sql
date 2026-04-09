-- Table: website_pageviews
-- Description: Individual page views per session
CREATE TABLE website_pageviews (
    website_pageview_id INTEGER PRIMARY KEY,
    created_at TEXT,
    website_session_id INTEGER NOT NULL,
    pageview_url TEXT,
    FOREIGN KEY (website_session_id) REFERENCES website_sessions(website_session_id)
);
