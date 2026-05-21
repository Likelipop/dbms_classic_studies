TRUNCATE TABLE raw.olist_products_dataset;

\copy raw.olist_products_dataset FROM 'data/raw/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');  
