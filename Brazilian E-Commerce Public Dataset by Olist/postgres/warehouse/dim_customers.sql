-- =============================================================================
-- dim_customers.sql
-- Load: staging.stg_customers → warehouse.dim_customers
-- =============================================================================

INSERT INTO warehouse.dim_customers (
    customer_id,
    customer_unique_id,
    zip_code_prefix,
    city,
    state
)
SELECT
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    INITCAP(TRIM(c.customer_city))      AS city,
    UPPER(TRIM(c.customer_state))       AS state
FROM staging.stg_customers c
ON CONFLICT (customer_id) DO UPDATE
    SET customer_unique_id  = EXCLUDED.customer_unique_id,
        zip_code_prefix     = EXCLUDED.zip_code_prefix,
        city                = EXCLUDED.city,
        state               = EXCLUDED.state;
