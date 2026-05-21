TRUNCATE TABLE raw.olist_order_items_dataset;

\copy raw.olist_order_items_dataset FROM 'data/raw/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');