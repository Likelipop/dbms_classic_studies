-- =============================================================================
-- customer_retention.sql
-- Nguồn: warehouse.fact_orders, warehouse.fact_order_items, warehouse.dim_customers
-- =============================================================================

CREATE OR REPLACE VIEW analytics.vw_customer_segmentation AS
SELECT
    dc.state                                    AS customer_state,
    dc.city                                     AS customer_city,
    COUNT(DISTINCT dc.customer_unique_id)       AS unique_customers,
    COUNT(DISTINCT fo.order_id)                 AS total_orders,
    COALESCE(SUM(foi.total_amount), 0)          AS total_spend,
    CASE 
        WHEN COUNT(DISTINCT dc.customer_unique_id) > 0 
        THEN COALESCE(SUM(foi.total_amount), 0) / COUNT(DISTINCT dc.customer_unique_id)
        ELSE 0 
    END                                         AS avg_spend_per_customer
FROM warehouse.fact_orders fo
JOIN warehouse.dim_customers dc ON fo.customer_key = dc.customer_key
LEFT JOIN warehouse.fact_order_items foi ON fo.order_id = foi.order_id
GROUP BY dc.state, dc.city;