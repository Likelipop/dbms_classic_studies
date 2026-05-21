TRUNCATE TABLE raw.product_category_name_translation;

\copy raw.product_category_name_translation FROM 'data/raw/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');    
