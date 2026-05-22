TRUNCATE TABLE staging.stg_product_category_translation;

INSERT INTO staging.stg_product_category_translation(
    product_category_name,
    product_category_name_english
)
SELECT DISTINCT ON (rpcnt.product_category_name)
    CAST(NULLIF(BTRIM(rpcnt.product_category_name, ' ''"'), '') AS TEXT) AS product_category_name,
    CAST(NULLIF(BTRIM(rpcnt.product_category_name_english, ' ''"'), '') AS TEXT) AS product_category_name_english
FROM raw.product_category_name_translation rpcnt
WHERE NULLIF(BTRIM(rpcnt.product_category_name, ' ''"'), '') IS NOT NULL
ORDER BY rpcnt.product_category_name;