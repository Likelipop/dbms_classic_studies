-- =============================================================================
-- data_quality.sql
-- Mục đích: Kiểm tra tính toàn vẹn (Nulls, Duplicates, Ranges) ở tầng Warehouse
-- =============================================================================

DO $$
DECLARE
    error_count INT;
BEGIN
    RAISE NOTICE '--- Bắt đầu chạy Data Quality Checks ---';

    -- 1. Kiểm tra NULL ở khóa chính của bảng fact_orders
    SELECT COUNT(*) INTO error_count FROM warehouse.fact_orders WHERE order_id IS NULL;
    IF error_count > 0 THEN
        RAISE EXCEPTION '[FAIL] fact_orders có % dòng bị NULL order_id', error_count;
    END IF;

    -- 2. Kiểm tra dữ liệu trùng lặp (Duplicates) trong dim_customers
    SELECT COUNT(*) INTO error_count 
    FROM (
        SELECT customer_id, COUNT(*) 
        FROM warehouse.dim_customers 
        GROUP BY customer_id 
        HAVING COUNT(*) > 1
    ) dupes;
    
    IF error_count > 0 THEN
        RAISE EXCEPTION '[FAIL] dim_customers có % khách hàng bị trùng lặp customer_id', error_count;
    END IF;

    -- 3. Kiểm tra tính hợp lệ của điểm đánh giá (Từ 1 đến 5 sao)
    SELECT COUNT(*) INTO error_count 
    FROM warehouse.fact_reviews 
    WHERE review_score < 1 OR review_score > 5;
    
    IF error_count > 0 THEN
        RAISE EXCEPTION '[FAIL] fact_reviews có % đánh giá nằm ngoài khoảng 1-5 sao', error_count;
    END IF;

    -- 4. Kiểm tra logic ngày tháng: Ngày giao hàng không thể diễn ra trước ngày mua hàng
    SELECT COUNT(*) INTO error_count 
    FROM warehouse.fact_orders fo
    JOIN warehouse.dim_date purchase_dt ON fo.purchase_date_key = purchase_dt.date_key
    JOIN warehouse.dim_date delivery_dt ON fo.delivered_customer_date_key = delivery_dt.date_key
    WHERE delivery_dt.full_date < purchase_dt.full_date;

    IF error_count > 0 THEN
        RAISE EXCEPTION '[FAIL] fact_orders có % đơn hàng có ngày giao nhỏ hơn ngày mua', error_count;
    END IF;

    RAISE NOTICE '--- Data Quality Checks: PASSED ---';
END $$;