TRUNCATE TABLE raw.olist_order_payments_dataset;

\copy raw.olist_order_payments_dataset FROM 'data/raw/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');