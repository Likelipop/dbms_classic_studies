-- =============================================================================
-- sales_overview.sql
-- Nguồn: warehouse.fact_orders, warehouse.fact_order_items, warehouse.dim_date
-- =============================================================================

CREATE OR REPLACE VIEW analytics.vw_sales_overview_daily AS
SELECT
    d.full_date                                 AS order_date,
    COUNT(DISTINCT fo.order_id)                 AS total_orders,
    COUNT(CASE WHEN fo.order_status = 'delivered' THEN 1 END) AS delivered_orders,
    COUNT(CASE WHEN fo.order_status = 'canceled' THEN 1 END)  AS canceled_orders,
    COALESCE(SUM(foi.price), 0)                 AS total_product_revenue,
    COALESCE(SUM(foi.freight_value), 0)         AS total_freight_revenue,
    COALESCE(SUM(foi.total_amount), 0)          AS total_revenue
FROM warehouse.fact_orders fo
JOIN warehouse.dim_date d ON fo.purchase_date_key = d.date_key
LEFT JOIN warehouse.fact_order_items foi ON fo.order_id = foi.order_id
GROUP BY d.full_date;