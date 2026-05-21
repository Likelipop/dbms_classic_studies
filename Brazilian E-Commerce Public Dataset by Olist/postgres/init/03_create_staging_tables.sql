DROP TABLE IF EXISTS staging.stg_customers;
DROP TABLE IF EXISTS staging.stg_geolocation;
DROP TABLE IF EXISTS staging.stg_order_items;
DROP TABLE IF EXISTS staging.stg_order_payments;
DROP TABLE IF EXISTS staging.stg_order_reviews;
DROP TABLE IF EXISTS staging.stg_orders;
DROP TABLE IF EXISTS staging.stg_products;
DROP TABLE IF EXISTS staging.stg_sellers;
DROP TABLE IF EXISTS staging.stg_product_category_translation;

CREATE TABLE staging.stg_customers (
    customer_id UUID PRIMARY KEY,
    customer_unique_id UUID,
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

CREATE TABLE staging.stg_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

CREATE TABLE staging.stg_order_items (
    order_id UUID,
    order_item_id INTEGER,
    product_id UUID,
    seller_id UUID,
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE staging.stg_order_payments (
    order_id UUID,
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE staging.stg_order_reviews (
    review_id UUID PRIMARY KEY,
    order_id UUID,
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE staging.stg_orders (
    order_id UUID PRIMARY KEY,
    customer_id UUID,
    order_status VARCHAR(25),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE staging.stg_products (
    product_id UUID PRIMARY KEY,
    product_category_name TEXT,
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

CREATE TABLE staging.stg_sellers (
    seller_id UUID PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state CHAR(20)
);

CREATE TABLE staging.stg_product_category_translation (
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT
);