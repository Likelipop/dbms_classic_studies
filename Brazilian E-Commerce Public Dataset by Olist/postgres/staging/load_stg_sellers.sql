--TrT
TRUNCATE TABLE staging.stg_sellers;

--Clean data

--II + SDOOr + OCDUS
INSERT INTO staging.stg_sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT DISTINCT ON (osd.seller_id)
    CAST(
        NULLIF(  BTRIM(osd.seller_id, ' ''"'), '') 
    AS UUID) AS seller_id,

    CAST(
        NULLIF(
            BTRIM(osd.seller_zip_code_prefix, ' ''"'), 
        '') 
    AS INTEGER) AS seller_zip_code_prefix,

    NULLIF(
        BTRIM(osd.seller_city, ' ''"'), 
    '') AS seller_city,

    NULLIF(
        BTRIM(osd.seller_state, ' ''" '), 
    '') AS seller_state
FROM raw.olist_sellers_dataset osd 
WHERE 
    osd.seller_id IS NOT NULL
    AND NULLIF(BTRIM(osd.seller_id, ' ''"'), '') IS NOT NULL
ORDER BY
    osd.seller_id, 
    osd.seller_zip_code_prefix DESC 
ON CONFLICT (seller_id) DO UPDATE SET
    seller_state = EXCLUDED.seller_state,
    seller_city = EXCLUDED.seller_city,
    seller_zip_code_prefix = EXCLUDED.seller_zip_code_prefix;
