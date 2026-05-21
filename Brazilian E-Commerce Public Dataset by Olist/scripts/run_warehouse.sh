#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/.env"
source "$ROOT_DIR/scripts/utils.sh"

export PGPASSWORD=$POSTGRES_PASSWORD

SQL_DIR="$ROOT_DIR/postgres/warehouse"

log "====== Warehouse pipeline START ======"

run_sql() {
    local file="$1"

    log "Running: $file"

    psql -h localhost \
        -p $POSTGRES_PORT \
        -U $POSTGRES_USER \
        -d $POSTGRES_DB \
        -v ON_ERROR_STOP=1 \
        -f "$SQL_DIR/$file"

    log "Done: $file"
}

# ── Dimensions
run_sql "dim_date.sql"
run_sql "dim_customers.sql"
run_sql "dim_sellers.sql"
run_sql "dim_products.sql"

# ── Facts
run_sql "fact_orders.sql"
run_sql "fact_order_items.sql"
run_sql "fact_payments.sql"
run_sql "fact_reviews.sql"

log "====== Warehouse pipeline DONE ======"