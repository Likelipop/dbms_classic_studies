#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

log "====== Raw Pipeline START ======"

SQL_DIR="$ROOT_DIR/postgres/raw"

# Define the list of raw data load scripts
FILES=(
    "load_customers.sql"
    "load_geolocation.sql"
    "load_order_items.sql"
    "load_order_payments.sql"
    "load_order_reviews.sql"
    "load_orders.sql"
    "load_products.sql"
    "load_sellers.sql"
    "load_product_category_translation.sql"
)

# Execute each file
for file in "${FILES[@]}"; do
    execute_sql_file "$SQL_DIR/$file"
done

log "====== Raw Pipeline DONE ======"