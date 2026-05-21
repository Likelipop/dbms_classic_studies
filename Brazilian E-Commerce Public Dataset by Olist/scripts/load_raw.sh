#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/.env"
source "$ROOT_DIR/scripts/utils.sh"

export PGPASSWORD=$POSTGRES_PASSWORD

log "START loading raw tables"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_customers.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_geolocation.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_order_items.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_order_payments.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_order_reviews.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_orders.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_products.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_sellers.sql"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f "$ROOT_DIR/postgres/raw/load_product_category_translation.sql"

log "FINISH loading raw tables"