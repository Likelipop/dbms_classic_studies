TRUNCATE TABLE raw.olist_sellers_dataset;

\copy raw.olist_sellers_dataset FROM 'data/raw/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');    
