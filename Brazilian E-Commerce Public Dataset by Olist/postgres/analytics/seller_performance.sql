-- =============================================================================
-- seller_performance.sql
-- Nguồn: warehouse.fact_order_items, warehouse.dim_sellers
-- =============================================================================

CREATE OR REPLACE VIEW analytics.vw_seller_performance AS
SELECT
    ds.seller_id                                AS seller_id,
    ds.state                                    AS seller_state,
    ds.city                                     AS seller_city,
    COUNT(DISTINCT foi.order_id)                AS orders_handled,
    COUNT(foi.order_item_id)                    AS items_sold,
    COALESCE(SUM(foi.price), 0)                 AS gross_revenue,
    COALESCE(SUM(foi.freight_value), 0)         AS total_freight_charged
FROM warehouse.fact_order_items foi
JOIN warehouse.dim_sellers ds ON foi.seller_key = ds.seller_key
GROUP BY ds.seller_id, ds.state, ds.city;