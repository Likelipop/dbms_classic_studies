-- =============================================================================
-- dim_date.sql
-- Populate warehouse.dim_date
-- Phủ toàn bộ dữ liệu Olist: 2016-01-01 → 2019-12-31
-- =============================================================================

INSERT INTO warehouse.dim_date (
    date_key,
    full_date,
    day_of_week,
    day_name,
    day_of_month,
    day_of_year,
    week_of_year,
    month_num,
    month_name,
    quarter,
    year,
    is_weekend
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER             AS date_key,
    d::DATE                                      AS full_date,
    EXTRACT(ISODOW FROM d)::SMALLINT             AS day_of_week,   -- 1=Mon, 7=Sun
    TO_CHAR(d, 'Day')                            AS day_name,
    EXTRACT(DAY   FROM d)::SMALLINT              AS day_of_month,
    EXTRACT(DOY   FROM d)::SMALLINT              AS day_of_year,
    EXTRACT(WEEK  FROM d)::SMALLINT              AS week_of_year,
    EXTRACT(MONTH FROM d)::SMALLINT              AS month_num,
    TO_CHAR(d, 'Month')                          AS month_name,
    EXTRACT(QUARTER FROM d)::SMALLINT            AS quarter,
    EXTRACT(YEAR  FROM d)::SMALLINT              AS year,
    EXTRACT(ISODOW FROM d) IN (6, 7)             AS is_weekend
FROM GENERATE_SERIES(
    '2016-01-01'::DATE,
    '2019-12-31'::DATE,
    '1 day'::INTERVAL
) AS gs(d)
ON CONFLICT (date_key) DO NOTHING;
