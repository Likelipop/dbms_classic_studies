--TrT
TRUNCATE TABLE staging.stg_order_reviews;

--II + SDOOr
INSERT INTO staging.stg_order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT DISTINCT ON (oord.review_id)
    CAST(oord.review_id AS UUID),
    CAST(oord.order_id AS UUID),
    CAST(oord.review_score AS INTEGER),
    oord.review_comment_title,
    oord.review_comment_message,
    CAST(oord.review_creation_date AS TIMESTAMP),
    CAST(oord.review_answer_timestamp AS TIMESTAMP)
FROM raw.olist_order_reviews_dataset oord 
WHERE 
    oord.review_id IS NOT NULL AND
    oord.order_id IS NOT NULL AND 
    oord.review_score::INTEGER BETWEEN 0 AND 10
ORDER BY
    oord.review_id, 
    oord.review_answer_timestamp DESC;