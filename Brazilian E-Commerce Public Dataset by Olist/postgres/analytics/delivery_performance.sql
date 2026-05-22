-- =============================================================================
-- delivery_performance.sql
-- Nguồn: warehouse.fact_orders, warehouse.dim_customers
-- =============================================================================

CREATE OR REPLACE VIEW analytics.vw_delivery_performance AS
SELECT
    dc.state                                    AS destination_state,
    COUNT(fo.order_id)                          AS total_delivered_orders,
    COUNT(CASE WHEN fo.is_late_delivery = TRUE THEN 1 END) AS delayed_orders,
    COALESCE(AVG(fo.delivery_time_days), 0)     AS avg_delivery_time_days,
    ROUND(
        (COUNT(CASE WHEN fo.is_late_delivery = TRUE THEN 1 END)::NUMERIC / NULLIF(COUNT(fo.order_id), 0)) * 100, 2
    )                                           AS delay_rate_percentage
FROM warehouse.fact_orders fo
JOIN warehouse.dim_customers dc ON fo.customer_key = dc.customer_key
WHERE fo.order_status = 'delivered'
GROUP BY dc.state;