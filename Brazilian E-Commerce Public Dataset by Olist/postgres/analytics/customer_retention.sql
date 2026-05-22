-- =============================================================================
-- product_performance.sql
-- Nguồn: warehouse.fact_order_items, warehouse.dim_products
-- =============================================================================

CREATE OR REPLACE VIEW analytics.vw_product_performance AS
SELECT
    dp.product_category_name_english            AS category_name,
    dp.size_category                            AS size_category,
    COUNT(DISTINCT foi.order_id)                AS total_orders,
    COUNT(foi.order_item_id)                    AS units_sold,
    COALESCE(SUM(foi.total_amount), 0)          AS total_sales,
    COALESCE(AVG(foi.price), 0)                 AS avg_unit_price
FROM warehouse.fact_order_items foi
JOIN warehouse.dim_products dp ON foi.product_key = dp.product_key
GROUP BY dp.product_category_name_english, dp.size_category;