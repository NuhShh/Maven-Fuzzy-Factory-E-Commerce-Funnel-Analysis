-- View: Funnel Conversion Rates
-- Overall conversion at each funnel step
CREATE VIEW funnel_conversion_rates AS
WITH session_page_flags AS (
    SELECT 
        ws.website_session_id,
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
    GROUP BY ws.website_session_id, ws.device_type, ws.utm_source, ws.utm_campaign
)
SELECT 
    COUNT(DISTINCT CASE WHEN landed = 1 THEN website_session_id END) as sessions_landed,
    COUNT(DISTINCT CASE WHEN viewed_product = 1 THEN website_session_id END) as sessions_viewed_product,
    COUNT(DISTINCT CASE WHEN added_to_cart = 1 THEN website_session_id END) as sessions_added_to_cart,
    COUNT(DISTINCT CASE WHEN reached_shipping = 1 THEN website_session_id END) as sessions_reached_shipping,
    COUNT(DISTINCT CASE WHEN reached_billing = 1 THEN website_session_id END) as sessions_reached_billing,
    COUNT(DISTINCT CASE WHEN purchased = 1 THEN website_session_id END) as sessions_purchased,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN viewed_product = 1 THEN website_session_id END) 
          / NULLIF(COUNT(DISTINCT CASE WHEN landed = 1 THEN website_session_id END), 0), 2) as landed_to_product_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN added_to_cart = 1 THEN website_session_id END) 
          / NULLIF(COUNT(DISTINCT CASE WHEN viewed_product = 1 THEN website_session_id END), 0), 2) as product_to_cart_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN reached_shipping = 1 THEN website_session_id END) 
          / NULLIF(COUNT(DISTINCT CASE WHEN added_to_cart = 1 THEN website_session_id END), 0), 2) as cart_to_shipping_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN reached_billing = 1 THEN website_session_id END) 
          / NULLIF(COUNT(DISTINCT CASE WHEN reached_shipping = 1 THEN website_session_id END), 0), 2) as shipping_to_billing_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN purchased = 1 THEN website_session_id END) 
          / NULLIF(COUNT(DISTINCT CASE WHEN reached_billing = 1 THEN website_session_id END), 0), 2) as billing_to_purchase_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN purchased = 1 THEN website_session_id END) 
          / NULLIF(COUNT(DISTINCT CASE WHEN landed = 1 THEN website_session_id END), 0), 2) as overall_conversion_pct
FROM session_page_flags;
