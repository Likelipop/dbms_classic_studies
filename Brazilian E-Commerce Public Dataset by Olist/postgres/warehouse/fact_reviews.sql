-- =============================================================================
-- fact_reviews.sql
-- Load: staging.stg_order_reviews → warehouse.fact_reviews
-- Grain: 1 row / review_id
-- Dependency: fact_orders phải load trước
-- =============================================================================

INSERT INTO warehouse.fact_reviews (
    review_id,
    order_id,
    review_date_key,
    review_score,
    review_comment_title,
    review_comment_message,
    answer_timestamp,
    response_time_hours
)
SELECT
    r.review_id,
    r.order_id,
    TO_CHAR(r.review_creation_date, 'YYYYMMDD')::INTEGER    AS review_date_key,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_answer_timestamp                               AS answer_timestamp,

    -- Response time: creation → answer (hours)
    CASE
        WHEN r.review_answer_timestamp IS NOT NULL
         AND r.review_creation_date    IS NOT NULL
        THEN ROUND(
            EXTRACT(EPOCH FROM (r.review_answer_timestamp - r.review_creation_date)) / 3600.0
        , 2)
        ELSE NULL
    END                                                     AS response_time_hours

FROM staging.stg_order_reviews r
WHERE EXISTS (
    SELECT 1 FROM warehouse.fact_orders fo WHERE fo.order_id = r.order_id
)
ON CONFLICT (review_id) DO UPDATE
    SET order_id                = EXCLUDED.order_id,
        review_date_key         = EXCLUDED.review_date_key,
        review_score            = EXCLUDED.review_score,
        review_comment_title    = EXCLUDED.review_comment_title,
        review_comment_message  = EXCLUDED.review_comment_message,
        answer_timestamp        = EXCLUDED.answer_timestamp,
        response_time_hours     = EXCLUDED.response_time_hours;
