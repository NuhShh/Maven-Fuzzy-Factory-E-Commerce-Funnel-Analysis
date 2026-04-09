-- Table: order_items
-- Description: Individual items within each order
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    created_at TEXT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    is_primary_item INTEGER,
    price_usd REAL,
    cogs_usd REAL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
