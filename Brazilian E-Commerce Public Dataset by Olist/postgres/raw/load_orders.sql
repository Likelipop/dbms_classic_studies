TRUNCATE TABLE raw.olist_orders_dataset;

\copy raw.olist_orders_dataset FROM 'data/raw/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');  
