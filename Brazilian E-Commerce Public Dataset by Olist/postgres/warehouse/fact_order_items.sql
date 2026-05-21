-- =============================================================================
-- fact_order_items.sql
-- Load: staging.stg_order_items + dim_products + dim_sellers
--       → warehouse.fact_order_items
-- Grain: 1 row / (order_id, order_item_id)
-- Dependency: fact_orders, dim_products, dim_sellers phải load trước
-- =============================================================================

INSERT INTO warehouse.fact_order_items (
    order_id,
    order_item_id,
    product_key,
    seller_key,
    shipping_date_key,
    price,
    freight_value
)
SELECT
    oi.order_id,
    oi.order_item_id,

    dp.product_key,
    ds.seller_key,

    TO_CHAR(oi.shipping_limit_date, 'YYYYMMDD')::INTEGER    AS shipping_date_key,

    oi.price,
    oi.freight_value

FROM staging.stg_order_items oi
JOIN warehouse.dim_products dp ON dp.product_id = oi.product_id
JOIN warehouse.dim_sellers  ds ON ds.seller_id  = oi.seller_id
-- Chỉ load items thuộc orders đã tồn tại trong fact_orders
WHERE EXISTS (
    SELECT 1 FROM warehouse.fact_orders fo WHERE fo.order_id = oi.order_id
)
ON CONFLICT (order_id, order_item_id) DO UPDATE
    SET product_key         = EXCLUDED.product_key,
        seller_key          = EXCLUDED.seller_key,
        shipping_date_key   = EXCLUDED.shipping_date_key,
        price               = EXCLUDED.price,
        freight_value       = EXCLUDED.freight_value;
