-- View: Funnel Revenue Analysis
-- Revenue, profit, and AOV metrics
CREATE VIEW funnel_revenue_analysis AS
WITH session_page_flags AS (
    SELECT 
        ws.website_session_id,
        MAX(CASE WHEN wp.pageview_url IN ('/home', '/lander-1', '/lander-2', '/lander-3', '/lander-4', '/lander-5') THEN 1 ELSE 0 END) as landed,
        MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) as purchased
    FROM website_sessions ws
    INNER JOIN website_pageviews wp 
        ON ws.website_session_id = wp.website_session_id
    WHERE ws.created_at >= '2014-10-01'
      AND ws.created_at <= '2015-03-19 23:59:59'
    GROUP BY ws.website_session_id
)
SELECT 
    COUNT(DISTINCT CASE WHEN landed = 1 THEN spf.website_session_id END) as total_sessions,
    COUNT(DISTINCT CASE WHEN purchased = 1 THEN spf.website_session_id END) as converting_sessions,
    SUM(o.price_usd) as total_revenue,
    SUM(o.cogs_usd) as total_cogs,
    SUM(o.price_usd) - SUM(o.cogs_usd) as total_profit,
    ROUND(AVG(o.price_usd), 2) as average_order_value,
    ROUND(SUM(o.price_usd) / NULLIF(COUNT(DISTINCT CASE WHEN landed = 1 THEN spf.website_session_id END), 0), 2) as revenue_per_session,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN purchased = 1 THEN spf.website_session_id END) 
          / NULLIF(COUNT(DISTINCT CASE WHEN landed = 1 THEN spf.website_session_id END), 0), 2) as overall_conversion_pct
FROM session_page_flags spf
LEFT JOIN orders o 
    ON spf.website_session_id = o.website_session_id;
