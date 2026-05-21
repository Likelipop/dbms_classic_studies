-- TR
TRUNCATE TABLE staging.stg_orders;

-- II + SDOF + WOR + OCDU
INSERT INTO staging.stg_orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT DISTINCT ON (oo.order_id)
    CAST(oo.order_id AS UUID),
    CAST(oo.customer_id AS UUID),
    oo.order_status,
    CAST(oo.order_purchase_timestamp AS TIMESTAMP),
    CAST(NULLIF(oo.order_approved_at, '') AS TIMESTAMP),
    CAST(NULLIF(oo.order_delivered_carrier_date, '') AS TIMESTAMP),
    CAST(NULLIF(oo.order_delivered_customer_date, '') AS TIMESTAMP),
    CAST(NULLIF(oo.order_estimated_delivery_date, '') AS TIMESTAMP)
FROM raw.olist_orders_dataset AS oo
WHERE 
    oo.order_id IS NOT NULL
ORDER BY 
    oo.order_id, 
    oo.order_purchase_timestamp DESC
ON CONFLICT (order_id) DO UPDATE SET 
    customer_id = EXCLUDED.customer_id,
    order_status = EXCLUDED.order_status,
    order_purchase_timestamp = EXCLUDED.order_purchase_timestamp,
    order_approved_at = EXCLUDED.order_approved_at,
    order_delivered_carrier_date = EXCLUDED.order_delivered_carrier_date,
    order_delivered_customer_date = EXCLUDED.order_delivered_customer_date,
    order_estimated_delivery_date = EXCLUDED.order_estimated_delivery_date;