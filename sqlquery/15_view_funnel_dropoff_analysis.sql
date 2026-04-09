-- View: Funnel Dropoff Analysis
-- Identifies the biggest drop-off points in the funnel
CREATE VIEW funnel_dropoff_analysis AS
WITH session_page_flags AS (
    SELECT 
        ws.website_session_id,
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
    GROUP BY ws.website_session_id
),
funnel_counts AS (
    SELECT 
        COUNT(DISTINCT CASE WHEN landed = 1 THEN website_session_id END) as step1_landed,
        COUNT(DISTINCT CASE WHEN viewed_product = 1 THEN website_session_id END) as step2_viewed_product,
        COUNT(DISTINCT CASE WHEN added_to_cart = 1 THEN website_session_id END) as step3_added_to_cart,
        COUNT(DISTINCT CASE WHEN reached_shipping = 1 THEN website_session_id END) as step4_reached_shipping,
        COUNT(DISTINCT CASE WHEN reached_billing = 1 THEN website_session_id END) as step5_reached_billing,
        COUNT(DISTINCT CASE WHEN purchased = 1 THEN website_session_id END) as step6_purchased
    FROM session_page_flags
)
SELECT 
    'Landed -> Viewed Product' as funnel_step,
    step1_landed as from_step,
    step2_viewed_product as to_step,
    step1_landed - step2_viewed_product as drop_off,
    ROUND(100.0 * (step1_landed - step2_viewed_product) / NULLIF(step1_landed, 0), 2) as dropoff_pct
FROM funnel_counts
UNION ALL
SELECT 
    'Viewed Product -> Added to Cart' as funnel_step,
    step2_viewed_product,
    step3_added_to_cart,
    step2_viewed_product - step3_added_to_cart,
    ROUND(100.0 * (step2_viewed_product - step3_added_to_cart) / NULLIF(step2_viewed_product, 0), 2)
FROM funnel_counts
UNION ALL
SELECT 
    'Added to Cart -> Shipping' as funnel_step,
    step3_added_to_cart,
    step4_reached_shipping,
    step3_added_to_cart - step4_reached_shipping,
    ROUND(100.0 * (step3_added_to_cart - step4_reached_shipping) / NULLIF(step3_added_to_cart, 0), 2)
FROM funnel_counts
UNION ALL
SELECT 
    'Shipping -> Billing' as funnel_step,
    step4_reached_shipping,
    step5_reached_billing,
    step4_reached_shipping - step5_reached_billing,
    ROUND(100.0 * (step4_reached_shipping - step5_reached_billing) / NULLIF(step4_reached_shipping, 0), 2)
FROM funnel_counts
UNION ALL
SELECT 
    'Billing -> Purchase' as funnel_step,
    step5_reached_billing,
    step6_purchased,
    step5_reached_billing - step6_purchased,
    ROUND(100.0 * (step5_reached_billing - step6_purchased) / NULLIF(step5_reached_billing, 0), 2)
FROM funnel_counts
ORDER BY dropoff_pct DESC;
