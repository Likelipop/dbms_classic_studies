#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

log "====== Staging Pipeline START ======"

SQL_DIR="$ROOT_DIR/postgres/staging"

# Define the list of staging transformation scripts
FILES=(
    "load_stg_customers.sql"
    "load_stg_geolocation.sql"
    "load_stg_order_items.sql"
    "load_stg_order_payments.sql"
    "load_stg_order_reviews.sql"
    "load_stg_orders.sql"
    "load_stg_products.sql"
    "load_stg_sellers.sql"
    "load_stg_product_category_translation.sql"
)

for file in "${FILES[@]}"; do
    execute_sql_file "$SQL_DIR/$file"
done

log "====== Staging Pipeline DONE ======"