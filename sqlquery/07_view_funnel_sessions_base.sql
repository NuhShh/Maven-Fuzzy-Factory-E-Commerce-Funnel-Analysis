-- View: Funnel Session Base
-- Returns all sessions within date range (2014-10-01 to 2015-03-19)
CREATE VIEW funnel_sessions_base AS
SELECT 
    ws.website_session_id,
    ws.created_at as session_start,
    ws.user_id,
    ws.device_type,
    ws.utm_source,
    ws.utm_campaign
FROM website_sessions ws
WHERE ws.created_at >= '2014-10-01'
  AND ws.created_at <= '2015-03-19 23:59:59';
