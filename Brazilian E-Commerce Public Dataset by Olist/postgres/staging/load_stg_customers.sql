TRUNCATE TABLE staging.stg_customers;

INSERT INTO staging.stg_customers(
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT DISTINCT ON (rocd.customer_id)
    CAST(NULLIF(BTRIM(rocd.customer_id, ' ''"'), '') AS UUID) AS customer_id,
    CAST(NULLIF(BTRIM(rocd.customer_unique_id, ' ''"'), '') AS UUID) AS customer_unique_id,
    CAST(NULLIF(BTRIM(rocd.customer_zip_code_prefix, ' ''"'), '') AS INTEGER) AS customer_zip_code_prefix,
    CAST(NULLIF(BTRIM(rocd.customer_city, ' ''"'), '') AS TEXT) AS customer_city,
    CAST(NULLIF(BTRIM(rocd.customer_state, ' ''"'), '') AS TEXT) AS customer_state
FROM raw.olist_customers_dataset rocd
ORDER BY rocd.customer_id;