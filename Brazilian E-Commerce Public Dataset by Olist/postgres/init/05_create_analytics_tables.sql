---------------------------------------------------------
-- 1. DIMENSION TABLES (Bảng danh mục)
---------------------------------------------------------

-- Bảng Dim Products (Kết hợp từ Products và Translation)
CREATE TABLE analytics.dim_products (
    product_key UUID PRIMARY KEY,
    product_category_name_english VARCHAR(100),
    product_weight_g INTEGER,
    product_size_category VARCHAR(20) -- Ví dụ: 'Small', 'Medium', 'Large'
);

-- Bảng Dim Customers
CREATE TABLE analytics.dim_customers (
    customer_key UUID PRIMARY KEY,
    customer_unique_id UUID,
    customer_city VARCHAR(100),
    customer_state CHAR(2),
    customer_segment VARCHAR(20) -- Ví dụ: 'New', 'Loyal', 'Churned'
);

-- Bảng Dim Sellers
CREATE TABLE analytics.dim_sellers (
    seller_key UUID PRIMARY KEY,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- Bảng Dim Date (Rất quan trọng trong Analytics để lọc theo Năm/Tháng/Quý)
CREATE TABLE analytics.dim_date (
    date_key INTEGER PRIMARY KEY, -- Định dạng YYYYMMDD
    full_date DATE,
    day_of_week VARCHAR(15),
    month_name VARCHAR(15),
    year INTEGER,
    quarter INTEGER,
    is_weekend BOOLEAN
);

---------------------------------------------------------
-- 2. FACT TABLES (Bảng sự kiện chính)
---------------------------------------------------------

-- Bảng Fact Sales (Nơi chứa các con số để tính toán)
CREATE TABLE analytics.fact_sales (
    order_id UUID,
    order_item_id INTEGER,
    product_key UUID REFERENCES analytics.dim_products(product_key),
    customer_key UUID REFERENCES analytics.dim_customers(customer_key),
    seller_key UUID REFERENCES analytics.dim_sellers(seller_key),
    date_key INTEGER REFERENCES analytics.dim_date(date_key),
    
    -- Metrics (Các chỉ số đo lường)
    sale_price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    total_amount DECIMAL(10, 2), -- sale_price + freight_value
    
    -- Delivery Metrics
    delivery_status VARCHAR(25),
    is_late BOOLEAN, -- So sánh giữa ngày giao thực tế và ngày dự kiến
    PRIMARY KEY (order_id, order_item_id)
);

-- Bảng Fact Reviews (Phân tích sự hài lòng của khách hàng)
CREATE TABLE analytics.fact_reviews (
    review_id UUID PRIMARY KEY,
    order_id UUID,
    review_score INTEGER,
    review_creation_date DATE
);