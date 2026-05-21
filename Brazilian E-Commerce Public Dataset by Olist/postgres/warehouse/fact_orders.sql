-- =============================================================================
-- fact_orders.sql
-- Load: staging.stg_orders + dim_customers → warehouse.fact_orders
-- Grain: 1 row / order_id
-- =============================================================================

INSERT INTO warehouse.fact_orders (
    order_id,
    customer_key,
    purchase_date_key,
    approved_date_key,
    delivered_carrier_date_key,
    delivered_customer_date_key,
    estimated_delivery_date_key,
    order_status,
    approval_time_hours,
    carrier_time_days,
    delivery_time_days,
    estimated_delivery_days,
    is_late_delivery
)
SELECT
    o.order_id,

    -- Foreign key → dim_customers
    dc.customer_key,

    -- Date keys (YYYYMMDD integer)
    TO_CHAR(o.order_purchase_timestamp,         'YYYYMMDD')::INTEGER    AS purchase_date_key,
    TO_CHAR(o.order_approved_at,                'YYYYMMDD')::INTEGER    AS approved_date_key,
    TO_CHAR(o.order_delivered_carrier_date,     'YYYYMMDD')::INTEGER    AS delivered_carrier_date_key,
    TO_CHAR(o.order_delivered_customer_date,    'YYYYMMDD')::INTEGER    AS delivered_customer_date_key,
    TO_CHAR(o.order_estimated_delivery_date,    'YYYYMMDD')::INTEGER    AS estimated_delivery_date_key,

    o.order_status,

    -- Approval time: purchase → approved (hours)
    ROUND(
        EXTRACT(EPOCH FROM (o.order_approved_at - o.order_purchase_timestamp)) / 3600.0
    , 2)                                                                AS approval_time_hours,

    -- Carrier time: approved → carrier pickup (days)
    ROUND(
        EXTRACT(EPOCH FROM (o.order_delivered_carrier_date - o.order_approved_at)) / 86400.0
    , 2)                                                                AS carrier_time_days,

    -- Actual delivery time: carrier pickup → customer (days)
    ROUND(
        EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_delivered_carrier_date)) / 86400.0
    , 2)                                                                AS delivery_time_days,

    -- Estimated window: purchase → estimated delivery (days)
    ROUND(
        EXTRACT(EPOCH FROM (o.order_estimated_delivery_date - o.order_purchase_timestamp)) / 86400.0
    , 2)                                                                AS estimated_delivery_days,

    -- Late flag: actual delivery > estimated delivery date
    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
         AND o.order_estimated_delivery_date IS NOT NULL
         AND o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN TRUE
        ELSE FALSE
    END                                                                 AS is_late_delivery

FROM staging.stg_orders o
JOIN warehouse.dim_customers dc ON dc.customer_id = o.customer_id

ON CONFLICT (order_id) DO UPDATE
    SET customer_key                = EXCLUDED.customer_key,
        purchase_date_key           = EXCLUDED.purchase_date_key,
        approved_date_key           = EXCLUDED.approved_date_key,
        delivered_carrier_date_key  = EXCLUDED.delivered_carrier_date_key,
        delivered_customer_date_key = EXCLUDED.delivered_customer_date_key,
        estimated_delivery_date_key = EXCLUDED.estimated_delivery_date_key,
        order_status                = EXCLUDED.order_status,
        approval_time_hours         = EXCLUDED.approval_time_hours,
        carrier_time_days           = EXCLUDED.carrier_time_days,
        delivery_time_days          = EXCLUDED.delivery_time_days,
        estimated_delivery_days     = EXCLUDED.estimated_delivery_days,
        is_late_delivery            = EXCLUDED.is_late_delivery;
