-- View: Funnel Pageviews Joined
-- Returns all pages visited by each session within date range
CREATE VIEW funnel_pageviews_joined AS
SELECT 
    ws.website_session_id,
    ws.created_at as session_start,
    ws.device_type,
    wp.pageview_url,
    wp.created_at as pageview_time
FROM website_sessions ws
INNER JOIN website_pageviews wp 
    ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at >= '2014-10-01'
  AND ws.created_at <= '2015-03-19 23:59:59';
