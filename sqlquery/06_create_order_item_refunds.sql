-- Table: order_item_refunds
-- Description: Refund records for order items
CREATE TABLE order_item_refunds (
    order_item_refund_id INTEGER PRIMARY KEY,
    created_at TEXT,
    order_item_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    refund_amount_usd REAL,
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
