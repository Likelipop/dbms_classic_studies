TRUNCATE TABLE raw.olist_customers_dataset;

\copy raw.olist_customers_dataset FROM 'data/raw/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');