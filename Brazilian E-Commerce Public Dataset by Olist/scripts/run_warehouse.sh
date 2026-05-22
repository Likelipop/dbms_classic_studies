#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

log "====== Warehouse Pipeline START ======"

SQL_DIR="$ROOT_DIR/postgres/warehouse"

# Ensure Dimensions are loaded BEFORE Facts due to Foreign Key constraints
FILES=(
    # -- Dimensions
    "dim_date.sql"
    "dim_customers.sql"
    "dim_sellers.sql"
    "dim_products.sql"
    
    # -- Facts
    "fact_orders.sql"
    "fact_order_items.sql"
    "fact_payments.sql"
    "fact_reviews.sql"
)

for file in "${FILES[@]}"; do
    execute_sql_file "$SQL_DIR/$file"
done

log "====== Warehouse Pipeline DONE ======"