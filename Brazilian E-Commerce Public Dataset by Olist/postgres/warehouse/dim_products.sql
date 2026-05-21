-- =============================================================================
-- dim_products.sql
-- Load: staging.stg_products + stg_product_category_translation
--       → warehouse.dim_products
-- =============================================================================

INSERT INTO warehouse.dim_products (
    product_id,
    product_category_name,
    product_category_name_english,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    size_category
)
SELECT
    p.product_id,
    p.product_category_name,
    COALESCE(t.product_category_name_english, p.product_category_name) AS product_category_name_english,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    -- Size category dựa trên volume (L x W x H cm³)
    CASE
        WHEN (p.product_length_cm * p.product_width_cm * p.product_height_cm) <= 1000  THEN 'Small'
        WHEN (p.product_length_cm * p.product_width_cm * p.product_height_cm) <= 10000 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM staging.stg_products p
LEFT JOIN staging.stg_product_category_translation t
    ON p.product_category_name = t.product_category_name
ON CONFLICT (product_id) DO UPDATE
    SET product_category_name           = EXCLUDED.product_category_name,
        product_category_name_english   = EXCLUDED.product_category_name_english,
        product_name_length             = EXCLUDED.product_name_length,
        product_description_length      = EXCLUDED.product_description_length,
        product_photos_qty              = EXCLUDED.product_photos_qty,
        product_weight_g                = EXCLUDED.product_weight_g,
        product_length_cm               = EXCLUDED.product_length_cm,
        product_height_cm               = EXCLUDED.product_height_cm,
        product_width_cm                = EXCLUDED.product_width_cm,
        size_category                   = EXCLUDED.size_category;
