-- View: Funnel Session Flags
-- Session-level funnel step indicators
CREATE VIEW funnel_session_flags AS
SELECT 
    ws.website_session_id,
    ws.created_at as session_start,
    ws.device_type,
    ws.utm_source,
    ws.utm_campaign,
    MAX(CASE WHEN wp.pageview_url IN ('/home', '/lander-1', '/lander-2', '/lander-3', '/lander-4', '/lander-5') THEN 1 ELSE 0 END) as landed,
    MAX(CASE WHEN wp.pageview_url IN ('/products', '/the-original-mr-fuzzy', '/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') THEN 1 ELSE 0 END) as viewed_product,
    MAX(CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END) as added_to_cart,
    MAX(CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END) as reached_shipping,
    MAX(CASE WHEN wp.pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) as reached_billing,
    MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) as purchased
FROM website_sessions ws
INNER JOIN website_pageviews wp 
    ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at >= '2014-10-01'
  AND ws.created_at <= '2015-03-19 23:59:59'
GROUP BY ws.website_session_id, ws.created_at, ws.device_type, ws.utm_source, ws.utm_campaign;
