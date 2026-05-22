-- =============================================================================
-- validation_checks.sql
-- Mục đích: Đối soát số liệu (Reconciliation) giữa Warehouse và Analytics
-- =============================================================================

DO $$
DECLARE
    warehouse_total DECIMAL(15,2);
    analytics_total DECIMAL(15,2);
    warehouse_orders INT;
    analytics_orders INT;
BEGIN
    RAISE NOTICE '--- Bắt đầu chạy Business Validation Checks ---';

    -- 1. Đối soát Tổng Doanh Thu (Total Revenue)
    -- Lấy tổng doanh thu từ Fact
    SELECT COALESCE(SUM(total_amount), 0) INTO warehouse_total FROM warehouse.fact_order_items;
    -- Lấy tổng doanh thu từ View Analytics
    SELECT COALESCE(SUM(total_revenue), 0) INTO analytics_total FROM analytics.vw_sales_overview_daily;

    IF ABS(warehouse_total - analytics_total) > 1.00 THEN -- Chênh lệch cho phép do làm tròn (nếu có)
        RAISE EXCEPTION '[FAIL] Doanh thu không khớp! Warehouse: %, Analytics: %', warehouse_total, analytics_total;
    END IF;

    -- 2. Đối soát Tổng số đơn hàng (Total Orders)
    SELECT COUNT(DISTINCT order_id) INTO warehouse_orders FROM warehouse.fact_orders;
    
    -- Phải SUM lại từ bảng aggregated vì analytics.vw_sales_overview_daily gom theo ngày
    SELECT COALESCE(SUM(total_orders), 0) INTO analytics_orders FROM analytics.vw_sales_overview_daily;

    IF warehouse_orders != analytics_orders THEN
        RAISE EXCEPTION '[FAIL] Số lượng đơn hàng không khớp! Warehouse: %, Analytics: %', warehouse_orders, analytics_orders;
    END IF;

    SELECT COALESCE(SUM(total_amount), 0) INTO warehouse_total FROM warehouse.fact_order_items;
    SELECT COALESCE(SUM(total_spend), 0) INTO analytics_total FROM analytics.vw_customer_segmentation;

    IF ABS(warehouse_total - analytics_total) > 1.00 THEN
        RAISE EXCEPTION '[FAIL] Tổng chi tiêu theo phân khúc không khớp! Warehouse: %, View: %', warehouse_total, analytics_total;
    END IF;

    RAISE NOTICE '--- Business Validation Checks: PASSED ---';
END $$;