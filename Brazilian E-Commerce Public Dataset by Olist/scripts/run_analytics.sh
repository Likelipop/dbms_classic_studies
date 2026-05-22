#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

log "====== Analytics Pipeline START ======"

SQL_DIR="$ROOT_DIR/postgres/analytics"

# Define the list of analytical view generation scripts
FILES=(
    "sales_overview.sql"
    "product_performance.sql"
    "customer_retention.sql"
    "seller_performance.sql"
    "delivery_performance.sql"
    "payment_analysis.sql"
)

for file in "${FILES[@]}"; do
    execute_sql_file "$SQL_DIR/$file"
done

log "====== Analytics Pipeline DONE ======"