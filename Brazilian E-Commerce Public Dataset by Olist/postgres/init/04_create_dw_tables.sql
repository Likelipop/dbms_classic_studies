-- =============================================================================
-- 04_create_dw_tables.sql
-- Schema: warehouse (Star Schema)
-- Tầng Data Warehouse: Dimensions + Facts
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS warehouse;

-- Drop facts trước (vì có FK tới dims)
DROP TABLE IF EXISTS warehouse.fact_reviews      CASCADE;
DROP TABLE IF EXISTS warehouse.fact_payments     CASCADE;
DROP TABLE IF EXISTS warehouse.fact_order_items  CASCADE;
DROP TABLE IF EXISTS warehouse.fact_orders       CASCADE;

-- Drop dims
DROP TABLE IF EXISTS warehouse.dim_date          CASCADE;
DROP TABLE IF EXISTS warehouse.dim_products      CASCADE;
DROP TABLE IF EXISTS warehouse.dim_customers     CASCADE;
DROP TABLE IF EXISTS warehouse.dim_sellers       CASCADE;

-- =============================================================================
-- DIMENSION TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- dim_date
-- Grain: 1 row / ngày calendar (pre-populated)
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.dim_date (
    date_key            INTEGER         PRIMARY KEY,    -- YYYYMMDD
    full_date           DATE            NOT NULL,
    day_of_week         SMALLINT        NOT NULL,       -- 1=Mon ... 7=Sun
    day_name            VARCHAR(15)     NOT NULL,
    day_of_month        SMALLINT        NOT NULL,
    day_of_year         SMALLINT        NOT NULL,
    week_of_year        SMALLINT        NOT NULL,
    month_num           SMALLINT        NOT NULL,
    month_name          VARCHAR(15)     NOT NULL,
    quarter             SMALLINT        NOT NULL,
    year                SMALLINT        NOT NULL,
    is_weekend          BOOLEAN         NOT NULL DEFAULT FALSE
);

-- -----------------------------------------------------------------------------
-- dim_customers
-- Grain: 1 row / customer_id (bussiness key từ staging)
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.dim_customers (
    customer_key            UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id             UUID            NOT NULL UNIQUE,    -- NK
    customer_unique_id      UUID,
    zip_code_prefix         VARCHAR(10),
    city                    VARCHAR(100),
    state                   CHAR(2)
);

-- -----------------------------------------------------------------------------
-- dim_sellers
-- Grain: 1 row / seller_id
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.dim_sellers (
    seller_key          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id           UUID            NOT NULL UNIQUE,        -- NK
    zip_code_prefix     VARCHAR(10),
    city                VARCHAR(100),
    state               VARCHAR(20)
);

-- -----------------------------------------------------------------------------
-- dim_products
-- Grain: 1 row / product_id, kết hợp category translation
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.dim_products (
    product_key                     UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id                      UUID            NOT NULL UNIQUE,   -- NK
    product_category_name           TEXT,
    product_category_name_english   TEXT,
    product_name_length             INTEGER,
    product_description_length      INTEGER,
    product_photos_qty              INTEGER,
    product_weight_g                INTEGER,
    product_length_cm               INTEGER,
    product_height_cm               INTEGER,
    product_width_cm                INTEGER,
    -- Derived attribute
    size_category                   VARCHAR(10)     -- 'Small' | 'Medium' | 'Large'
);

-- =============================================================================
-- FACT TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- fact_orders
-- Grain: 1 row / order_id
-- Chứa lifecycle + delivery metrics của đơn hàng
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.fact_orders (
    order_id                        UUID            PRIMARY KEY,
    customer_key                    UUID            NOT NULL REFERENCES warehouse.dim_customers(customer_key),
    purchase_date_key               INTEGER         NOT NULL REFERENCES warehouse.dim_date(date_key),
    approved_date_key               INTEGER                  REFERENCES warehouse.dim_date(date_key),
    delivered_carrier_date_key      INTEGER                  REFERENCES warehouse.dim_date(date_key),
    delivered_customer_date_key     INTEGER                  REFERENCES warehouse.dim_date(date_key),
    estimated_delivery_date_key     INTEGER                  REFERENCES warehouse.dim_date(date_key),

    order_status                    VARCHAR(25),

    -- Delivery metrics (tính sẵn để query nhanh)
    approval_time_hours             NUMERIC(10,2),  -- purchase → approved
    carrier_time_days               NUMERIC(10,2),  -- approved → carrier
    delivery_time_days              NUMERIC(10,2),  -- carrier → customer
    estimated_delivery_days         NUMERIC(10,2),  -- purchase → estimated
    is_late_delivery                BOOLEAN         -- actual > estimated
);

-- -----------------------------------------------------------------------------
-- fact_order_items
-- Grain: 1 row / (order_id, order_item_id)
-- Chứa revenue metrics ở cấp độ từng sản phẩm trong đơn
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.fact_order_items (
    order_id            UUID            NOT NULL REFERENCES warehouse.fact_orders(order_id),
    order_item_id       INTEGER         NOT NULL,
    product_key         UUID            NOT NULL REFERENCES warehouse.dim_products(product_key),
    seller_key          UUID            NOT NULL REFERENCES warehouse.dim_sellers(seller_key),
    shipping_date_key   INTEGER                  REFERENCES warehouse.dim_date(date_key),

    price               DECIMAL(10,2)   NOT NULL,
    freight_value       DECIMAL(10,2)   NOT NULL DEFAULT 0,
    total_amount        DECIMAL(10,2)   GENERATED ALWAYS AS (price + freight_value) STORED,

    PRIMARY KEY (order_id, order_item_id)
);

-- -----------------------------------------------------------------------------
-- fact_payments
-- Grain: 1 row / (order_id, payment_sequential)
-- Chứa thông tin thanh toán
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.fact_payments (
    order_id                UUID        NOT NULL REFERENCES warehouse.fact_orders(order_id),
    payment_sequential      INTEGER     NOT NULL,
    payment_type            VARCHAR(20),
    payment_installments    INTEGER,
    payment_value           DECIMAL(10,2),

    PRIMARY KEY (order_id, payment_sequential)
);

-- -----------------------------------------------------------------------------
-- fact_reviews
-- Grain: 1 row / review_id
-- Chứa customer satisfaction metrics
-- -----------------------------------------------------------------------------
CREATE TABLE warehouse.fact_reviews (
    review_id               UUID        PRIMARY KEY,
    order_id                UUID        NOT NULL REFERENCES warehouse.fact_orders(order_id),
    review_date_key         INTEGER              REFERENCES warehouse.dim_date(date_key),

    review_score            SMALLINT,           -- 1–5
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    answer_timestamp        TIMESTAMP,

    -- Derived
    has_comment             BOOLEAN GENERATED ALWAYS AS (
                                review_comment_message IS NOT NULL
                                AND TRIM(review_comment_message) <> ''
                            ) STORED,
    response_time_hours     NUMERIC(10,2)       -- creation → answer
);

-- =============================================================================
-- INDEXES (hỗ trợ join và filter phổ biến)
-- =============================================================================
CREATE INDEX idx_fact_orders_customer_key       ON warehouse.fact_orders(customer_key);
CREATE INDEX idx_fact_orders_purchase_date      ON warehouse.fact_orders(purchase_date_key);
CREATE INDEX idx_fact_order_items_product_key   ON warehouse.fact_order_items(product_key);
CREATE INDEX idx_fact_order_items_seller_key    ON warehouse.fact_order_items(seller_key);
CREATE INDEX idx_fact_payments_order_id         ON warehouse.fact_payments(order_id);
CREATE INDEX idx_fact_reviews_order_id          ON warehouse.fact_reviews(order_id);
CREATE INDEX idx_fact_reviews_date_key          ON warehouse.fact_reviews(review_date_key);
CREATE INDEX idx_dim_customers_unique_id        ON warehouse.dim_customers(customer_unique_id);
CREATE INDEX idx_dim_products_category          ON warehouse.dim_products(product_category_name_english);
