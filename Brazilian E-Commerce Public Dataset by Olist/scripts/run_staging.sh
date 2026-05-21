#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/.env"
source "$ROOT_DIR/scripts/utils.sh"

export PGPASSWORD=$POSTGRES_PASSWORD

log "START loading staging tables"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_customers.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_geolocation.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_order_items.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_order_payments.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_order_reviews.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_orders.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_products.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_sellers.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/staging/load_stg_product_category_translation.sql"

log "FINISH loading staging tables"