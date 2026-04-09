-- Table: orders
-- Description: Order transactions
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    created_at TEXT,
    website_session_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    primary_product_id INTEGER,
    items_purchased INTEGER,
    price_usd REAL,
    cogs_usd REAL,
    FOREIGN KEY (website_session_id) REFERENCES website_sessions(website_session_id),
    FOREIGN KEY (primary_product_id) REFERENCES products(product_id)
);
