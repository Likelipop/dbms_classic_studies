TRUNCATE TABLE raw.olist_geolocation_dataset;

\copy raw.olist_geolocation_dataset FROM 'data/raw/olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');