-- TR
TRUNCATE TABLE staging.stg_order_items;

-- II + SDOF + WOR + OCDU
INSERT INTO staging.stg_order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT DISTINCT ON (oi.order_id, oi.order_item_id) 
    CAST(oi.order_id AS UUID),
    CAST(oi.order_item_id AS INTEGER),
    CAST(oi.product_id AS UUID),
    CAST(oi.seller_id AS UUID),
    CAST(oi.shipping_limit_date AS TIMESTAMP),
    CAST(oi.price AS DECIMAL(10, 2)),
    CAST(oi.freight_value AS DECIMAL(10, 2))
FROM raw.olist_order_items_dataset AS oi
WHERE 
    oi.order_id IS NOT NULL AND
    oi.order_item_id IS NOT NULL
ORDER BY 
    oi.order_id, 
    oi.order_item_id, 
    oi.shipping_limit_date DESC
ON CONFLICT (order_id, order_item_id) DO UPDATE SET 
    product_id = EXCLUDED.product_id,
    seller_id = EXCLUDED.seller_id,
    shipping_limit_date = EXCLUDED.shipping_limit_date,
    price = EXCLUDED.price,
    freight_value = EXCLUDED.freight_value;