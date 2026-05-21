#!/bin/bash
# =============================================================================
# run_warehouse.sh
# Chạy toàn bộ warehouse layer theo đúng thứ tự dependency
# Usage: ./scripts/run_warehouse.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

DB_CONN="${DB_CONN:-postgresql://postgres:postgres@localhost:5432/olist}"
SQL_DIR="$SCRIPT_DIR/../postgres/warehouse"
LOG_FILE="$SCRIPT_DIR/../logs/warehouse.log"

log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }
fail() { log "ERROR: $1"; exit 1; }

run_sql() {
    local file="$SQL_DIR/$1"
    log "Running: $1"
    psql "$DB_CONN" -v ON_ERROR_STOP=1 -f "$file" >> "$LOG_FILE" 2>&1 \
        || fail "Failed at $1"
    log "Done:    $1"
}

log "====== Warehouse pipeline START ======"

# ── Dimensions (order matters: dim_date first, dims independent of each other)
run_sql "dim_date.sql"
run_sql "dim_customers.sql"
run_sql "dim_sellers.sql"
run_sql "dim_products.sql"

# ── Facts (must follow dims; fact_orders before item/payment/review)
run_sql "fact_orders.sql"
run_sql "fact_order_items.sql"
run_sql "fact_payments.sql"
run_sql "fact_reviews.sql"

log "====== Warehouse pipeline DONE  ======"
