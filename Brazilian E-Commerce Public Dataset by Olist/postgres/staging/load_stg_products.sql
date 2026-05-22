TRUNCATE TABLE staging.stg_products;

INSERT INTO staging.stg_products(
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT DISTINCT ON (ropd.product_id)
    CAST(NULLIF(BTRIM(ropd.product_id, ' ''"'), '') AS UUID) AS product_id,
    CAST(NULLIF(BTRIM(ropd.product_category_name, ' ''"'), '') AS TEXT) AS product_category_name,
    CAST(NULLIF(BTRIM(ropd.product_name_length, ' ''"'), '') AS INTEGER) AS product_name_length,
    CAST(NULLIF(BTRIM(ropd.product_description_length, ' ''"'), '') AS INTEGER) AS product_description_length,
    CAST(NULLIF(BTRIM(ropd.product_photos_qty, ' ''"'), '') AS INTEGER) AS product_photos_qty,
    CAST(NULLIF(BTRIM(ropd.product_weight_g, ' ''"'), '') AS INTEGER) AS product_weight_g,
    CAST(NULLIF(BTRIM(ropd.product_length_cm, ' ''"'), '') AS INTEGER) AS product_length_cm,
    CAST(NULLIF(BTRIM(ropd.product_height_cm, ' ''"'), '') AS INTEGER) AS product_height_cm,
    CAST(NULLIF(BTRIM(ropd.product_width_cm, ' ''"'), '') AS INTEGER) AS product_width_cm
FROM raw.olist_products_dataset ropd
WHERE NULLIF(BTRIM(ropd.product_id, ' ''"'), '') IS NOT NULL
ORDER BY ropd.product_id;