# E-Commerce Funnel Analysis for Maven Fuzzy Factory

## Executive Summary:

Maven Fuzzy Factory, an e-commerce toy store, needed to understand where users were dropping off in their online purchase journey. Using SQL and Power BI, I analyzed website traffic and order data to create a conversion funnel dashboard. The analysis revealed that the largest opportunity lies at the "Add to Cart" stage, where significant user drop-off occurs. I also identified a notable conversion gap between mobile and desktop users. Based on these findings, I recommend focusing on cart abandonment recovery and optimizing the mobile shopping experience to increase overall conversion rates and revenue.

---

### Business Problem: 

Maven Fuzzy Factory relies on completed purchases for revenue, but stakeholders noticed the website's conversion rate was lower than expected. The challenge was to determine exactly where users were falling out of the purchase workflow and identify actionable improvements. This analysis directly addresses revenue leakage by pinpointing the funnel stages with the highest drop-off rates.

![Page 1 - Dashboard Overview](pbi/Funnel%20Analysis%20Dashboard_page-0001.jpg)

---

### Methodology: 

1. **Project Planning & Task Tracking**: Used OpenCode AI assistant as a structured project management tool to plan analysis scope, track task progress, and maintain documentation throughout the project lifecycle. This ensured systematic execution rather than ad-hoc exploration.

2. **SQL Pipeline**: Extracted and transformed raw data from multiple tables (website_sessions, website_pageviews, orders, order_items) using complex queries with CTEs, joins, and conditional aggregation. Created nine reusable views to standardize funnel metrics for Power BI.

3. **Power BI Dashboard**: Connected directly to SQLite database to pull live data. Transformed date columns and established proper data relationships in the data model. Built a multi-page interactive dashboard featuring KPI cards, funnel charts, trend lines, and detailed breakdowns by device and marketing channel.

4. **Filtering & Scope**: Focused on the last six months of available data (October 2014 - March 2015) to ensure relevance and actionable insights.

---

### Skills:

**SQL**: CTEs, Joins, Case statements, Aggregate functions, Window functions, View creation

**Power BI**: DAX functions, ETL in Power Query, Data modeling (star schema), Data visualization, Interactive dashboard design, Slicers and filters

---

### Results & Business Recommendations: 

The funnel analysis dashboard provides stakeholders with real-time visibility into conversion performance across all stages of the purchase journey. The key insight is that the "Add to Cart" stage has the highest drop-off rate, representing the biggest opportunity for improvement. Additionally, mobile users convert at a significantly lower rate than desktop users, indicating a need for mobile experience optimization.

![Page 2 - Device & Monthly Trends](pbi/Funnel%20Analysis%20Dashboard_page-0002.jpg)

Based on the data, here are the recommended actions:

1. **Address Cart Abandonment**: Implement cart abandonment emails or push notifications to encourage users to complete their purchase after adding items to cart.

2. **Optimize Mobile Experience**: Investigate and improve the mobile checkout flow to reduce the conversion gap between mobile and desktop users.

3. **Focus Marketing Budget**: Concentrate advertising spend on higher-converting channels and device types based on UTM performance data.

4. **Monitor Monthly Trends**: Track conversion rate changes over time to measure the impact of implemented improvements.

![Page 3 - UTM Channels & Dropoff Analysis](pbi/Funnel%20Analysis%20Dashboard_page-0003.jpg)

These changes target the largest drop-off points in the funnel, which will directly impact revenue growth and improve overall conversion efficiency.

---

### Next Steps: 

1. A/B test copy changes at the cart stage to improve completion rates
2. Conduct user research on mobile checkout to identify friction points
3. Implement and measure cart abandonment email campaign effectiveness
4. Set up automated monitoring for monthly conversion trend alerts