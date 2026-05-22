-- =============================================================================
-- 05_create_analytics_tables.sql (Chuyển đổi thành LOGICAL STAR SCHEMA VIEWS)
-- Tự động ánh xạ và tính toán logic từ schema warehouse sang schema analytics
-- =============================================================================

---------------------------------------------------------
-- 1. DIMENSION VIEWS (Bảng danh mục logic)
---------------------------------------------------------

-- Bảng Dim Products (Kết hợp từ Products và Translation của tầng warehouse)
CREATE OR REPLACE VIEW analytics.dim_products AS
SELECT
    p.product_id                                AS product_key, -- Dùng luôn UUID gốc làm Key
    p.product_category_name                     AS product_category_name_english,
    p.product_weight_g                          AS product_weight_g,
    CASE 
        WHEN (p.product_length_cm * p.product_height_cm * p.product_width_cm) < 10000 THEN 'Small'
        WHEN (p.product_length_cm * p.product_height_cm * p.product_width_cm) BETWEEN 10000 AND 50000 THEN 'Medium'
        ELSE 'Large'
    END                                         AS product_size_category
FROM warehouse.dim_products p;

-- Bảng Dim Customers (Phân khúc khách hàng logic từ warehouse)
CREATE OR REPLACE VIEW analytics.dim_customers AS
WITH customer_order_counts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS total_orders
    FROM warehouse.fact_orders
    GROUP BY customer_id
)
SELECT
    c.customer_id                               AS customer_key,
    c.customer_unique_id                        AS customer_unique_id,
    c.city                                      AS customer_city,
    c.state                                     AS customer_state,
    CASE 
        WHEN COALESCE(coc.total_orders, 0) = 0 THEN 'New'
        WHEN coc.total_orders BETWEEN 1 AND 2 THEN 'Regular'
        ELSE 'Loyal'
    END                                         AS customer_segment
FROM warehouse.dim_customers c
LEFT JOIN customer_order_counts coc ON c.customer_id = coc.customer_id;

-- Bảng Dim Sellers
CREATE OR REPLACE VIEW analytics.dim_sellers AS
SELECT
    s.seller_id                                 AS seller_key,
    s.seller_city                               AS seller_city,
    s.seller_state                              AS seller_state
FROM warehouse.dim_sellers s;

-- Bảng Dim Date (Ánh xạ trực tiếp từ bảng dim_date của warehouse)
CREATE OR REPLACE VIEW analytics.dim_date AS
SELECT
    TO_CHAR(d.date_actual, 'YYYYMMDD')::INTEGER  AS date_key,
    d.date_actual                               AS full_date,
    d.day_name                                  AS day_of_week,
    d.month_name                                AS month_name,
    d.year                                      AS year,
    d.quarter                                   AS quarter,
    CASE WHEN d.day_name IN ('Saturday', 'Sunday') THEN TRUE ELSE FALSE END AS is_weekend
FROM warehouse.dim_date d;

---------------------------------------------------------
-- 2. FACT VIEWS (Bảng sự kiện logic)
---------------------------------------------------------

-- Bảng Fact Sales (Tính toán trực tiếp các chỉ số doanh số và logistics)
CREATE OR REPLACE VIEW analytics.fact_sales AS
SELECT
    fo.order_id                                 AS order_id,
    fitem.order_item_id                         AS order_item_id,
    fitem.product_id                            AS product_key,
    fo.customer_id                              AS customer_key,
    fitem.seller_id                             AS seller_key,
    TO_CHAR(fo.order_purchase_timestamp, 'YYYYMMDD')::INTEGER AS date_key,
    
    -- Metrics
    fitem.price                                 AS sale_price,
    fitem.freight_value                         AS freight_value,
    (fitem.price + fitem.freight_value)         AS total_amount,
    
    -- Delivery Metrics
    fo.order_status                             AS delivery_status,
    CASE 
        WHEN fo.order_delivered_customer_date > fo.order_estimated_delivery_date THEN TRUE 
        ELSE FALSE 
    END                                         AS is_late
FROM warehouse.fact_orders fo
JOIN warehouse.fact_order_items fitem ON fo.order_id = fitem.order_id;

-- Bảng Fact Reviews
CREATE OR REPLACE VIEW analytics.fact_reviews AS
SELECT
    fr.review_id                                AS review_id,
    fr.order_id                                 AS order_id,
    fr.review_score                             AS review_score,
    fr.review_creation_date                     AS review_creation_date
FROM warehouse.fact_reviews fr;