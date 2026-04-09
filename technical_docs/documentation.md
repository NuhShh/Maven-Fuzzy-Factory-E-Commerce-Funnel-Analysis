# Technical Documentation - E-Commerce Funnel Analysis

## 1. Project Overview

This document provides the technical details of the Maven Fuzzy Factory funnel analysis project. For the business context and storytelling, see the main README.md.

---

## 2. Data Source

### Raw Data Files

| File | Records | Location |
|------|---------|----------|
| products.csv | 4 | data/ |
| website_sessions.csv | 472,872 | data/ |
| website_pageviews.csv | 1,188,125 | data/ |
| orders.csv | 32,314 | data/ |
| order_items.csv | 40,026 | data/ |
| order_item_refunds.csv | 1,732 | data/ |

### Database

- **Type**: SQLite
- **Location**: database/ecommercemavendb.db
- **Date Range**: Full data spans March 2012 - March 2015
- **Analysis Period**: October 2014 - March 2015 (last 6 months)

---

## 3. SQL Pipeline

### Database Schema

Six tables were created in SQLite with the following relationships:

```
products (product_id)
    ↓
order_items (product_id)
    ↑
orders (primary_product_id)
    ↓
order_items (order_id)
    ↓
order_item_refunds (order_item_id, order_id)

website_sessions (website_session_id, user_id)
    ↓
website_pageviews (website_session_id)
    ↓
orders (website_session_id, user_id)
```

### Table Creation Scripts

| Script | Purpose |
|--------|---------|
| sqlquery/01_create_products.sql | Create products table |
| sqlquery/02_create_website_sessions.sql | Create website_sessions table |
| sqlquery/03_create_website_pageviews.sql | Create website_pageviews table |
| sqlquery/04_create_orders.sql | Create orders table |
| sqlquery/05_create_order_items.sql | Create order_items table |
| sqlquery/06_create_order_item_refunds.sql | Create order_item_refunds table |

### Views for Funnel Analysis

Nine views were created to enable Power BI integration:

| View Name | SQL Script | Purpose |
|-----------|------------|----------|
| funnel_sessions_base | 07_view_funnel_sessions_base.sql | Sessions within date range |
| funnel_pageviews_joined | 08_view_funnel_pageviews_joined.sql | Sessions + pageviews combined |
| funnel_session_flags | 09_view_funnel_session_flags.sql | Session-level funnel step flags |
| funnel_conversion_rates | 10_view_funnel_conversion_rates.sql | Overall conversion metrics |
| funnel_device_breakdown | 11_view_funnel_device_breakdown.sql | Mobile vs Desktop comparison |
| funnel_utm_breakdown | 12_view_funnel_utm_breakdown.sql | Marketing channel performance |
| funnel_monthly_trend | 13_view_funnel_monthly_trend.sql | Monthly conversion trends |
| funnel_revenue_analysis | 14_view_funnel_revenue_analysis.sql | Revenue, profit, AOV metrics |
| funnel_dropoff_analysis | 15_view_funnel_dropoff_analysis.sql | Drop-off analysis by step |

### Funnel Definition

The funnel is defined by the following page URLs:

| Step | Page URL(s) | Description |
|------|-------------|-------------|
| 1 | `/home`, `/lander-1` to `/lander-5` | Landing |
| 2 | `/products`, product detail pages | Product Browse |
| 3 | `/cart` | Add to Cart |
| 4 | `/shipping` | Shipping |
| 5 | `/billing`, `/billing-2` | Billing |
| 6 | `/thank-you-for-your-order` | Purchase |

All views filter by: `created_at >= '2014-10-01' AND created_at <= '2015-03-19 23:59:59'`

---

## 4. Power BI Implementation

### ETL Process

For detailed ETL steps, see: `../temporaryforopencode/Power BI Documentation.md`

**Key Transformations:**
- Converted date columns from TEXT to Date type in Power Query
- Created Date table for time intelligence (pbiquery/datestbl.txt)
- Established proper data relationships in Model View

### Data Model

- Connected directly to SQLite database
- Created star schema with fact and dimension tables
- Verified relationship directions and active status

### Dashboard Pages

| Page | Visualizations |
|------|----------------|
| Page 1 | KPI cards (sessions, conversion, revenue), Funnel chart |
| Page 2 | Device breakdown (bar chart), Monthly trends (line chart) |
| Page 3 | UTM channel performance (table), Dropoff analysis (bar chart) |

### Slicers Created
- Device Type
- Month
- UTM Source

---

## 5. Key Technical Notes

- **Date Handling**: All timestamps stored as TEXT in SQLite, converted to Date type in Power BI
- **Query Optimization**: Views use CTEs and aggregate functions to pre-calculate funnel metrics
- **Scope**: All funnel calculations limited to last 6 months via WHERE clause in each view
- **Foreign Keys**: Defined in table creation but require `PRAGMA foreign_keys = ON` to enforce

---

## 6. File Structure

```
toystore_analysis/
├── README.md                           (Storytelling)
├── technical_docs/
│   └── documentation.md                (This file)
├── data/
│   └── [6 CSV files]
├── sqlquery/
│   ├── 01-06_create_tables.sql
│   └── 07-15_view_funnel_*.sql
├── database/
│   └── ecommercemavendb.db
├── pbi/
│   ├── Funnel Analysis Dashboard.pbix
│   └── [Dashboard screenshots]
├── temporaryforopencode/
│   └── Power BI Documentation.md
└── pbiquery/
    └── datestbl.txt
```

---

## 7. How to Recreate

### Database Setup
```bash
# Create tables
sqlite3 database/ecommercemavendb.db < sqlquery/01_create_products.sql
# ... continue for 02-06

# Import data (using .import or preferred method)

# Create views
sqlite3 database/ecommercemavendb.db < sqlquery/07_view_funnel_sessions_base.sql
# ... continue for 08-15
```

### Power BI Connection
1. Use SQLite ODBC driver
2. Connect to `database/ecommercemavendb.db`
3. Import Date table from pbiquery/datestbl.txt
4. Build visualizations using the 9 views

---

*Last updated: April 2026*