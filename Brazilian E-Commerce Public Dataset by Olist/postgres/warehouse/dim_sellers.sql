-- =============================================================================
-- dim_sellers.sql
-- Load: staging.stg_sellers → warehouse.dim_sellers
-- =============================================================================

INSERT INTO warehouse.dim_sellers (
    seller_id,
    zip_code_prefix,
    city,
    state
)
SELECT
    s.seller_id,
    s.seller_zip_code_prefix,
    INITCAP(TRIM(s.seller_city))    AS city,
    UPPER(TRIM(s.seller_state))     AS state
FROM staging.stg_sellers s
ON CONFLICT (seller_id) DO UPDATE
    SET zip_code_prefix = EXCLUDED.zip_code_prefix,
        city            = EXCLUDED.city,
        state           = EXCLUDED.state;
