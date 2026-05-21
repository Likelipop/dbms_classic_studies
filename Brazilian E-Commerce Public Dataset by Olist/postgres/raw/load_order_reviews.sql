TRUNCATE TABLE raw.olist_order_reviews_dataset;

\copy raw.olist_order_reviews_dataset FROM 'data/raw/olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');