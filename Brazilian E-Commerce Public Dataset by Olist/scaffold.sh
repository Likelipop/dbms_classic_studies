#!/bin/bash

set -e

PROJECT_NAME="olist-data-engineering"

mkdir -p $PROJECT_NAME

cd $PROJECT_NAME

mkdir -p \
    data/raw \
    data/processed \
    logs \
    postgres/init \
    postgres/raw \
    postgres/staging \
    postgres/warehouse \
    postgres/analytics \
    postgres/views \
    scripts \
    metabase/dashboards \
    docs \
    tests \
    postgres_data \
    metabase_data

touch \
    docker-compose.yml \
    .env \
    .gitignore \
    README.md

touch \
    logs/pipeline.log \
    logs/load_raw.log \
    logs/staging.log \
    logs/warehouse.log \
    logs/analytics.log

touch \
    postgres/init/01_create_schemas.sql \
    postgres/init/02_create_raw_tables.sql \
    postgres/init/03_create_staging_tables.sql \
    postgres/init/04_create_dw_tables.sql \
    postgres/init/05_create_analytics_tables.sql

touch \
    postgres/raw/load_customers.sql \
    postgres/raw/load_geolocation.sql \
    postgres/raw/load_order_items.sql \
    postgres/raw/load_order_payments.sql \
    postgres/raw/load_order_reviews.sql \
    postgres/raw/load_orders.sql \
    postgres/raw/load_products.sql \
    postgres/raw/load_sellers.sql \
    postgres/raw/load_product_category_translation.sql

touch \
    postgres/staging/load_stg_customers.sql \
    postgres/staging/load_stg_geolocation.sql \
    postgres/staging/load_stg_order_items.sql \
    postgres/staging/load_stg_order_payments.sql \
    postgres/staging/load_stg_order_reviews.sql \
    postgres/staging/load_stg_orders.sql \
    postgres/staging/load_stg_products.sql \
    postgres/staging/load_stg_sellers.sql \
    postgres/staging/load_stg_product_category_translation.sql

touch \
    postgres/warehouse/dim_customers.sql \
    postgres/warehouse/dim_products.sql \
    postgres/warehouse/dim_sellers.sql \
    postgres/warehouse/dim_date.sql \
    postgres/warehouse/fact_orders.sql \
    postgres/warehouse/fact_order_items.sql \
    postgres/warehouse/fact_payments.sql \
    postgres/warehouse/fact_reviews.sql

touch \
    postgres/analytics/sales_overview.sql \
    postgres/analytics/customer_retention.sql \
    postgres/analytics/product_performance.sql \
    postgres/analytics/seller_performance.sql \
    postgres/analytics/delivery_performance.sql \
    postgres/analytics/payment_analysis.sql

touch \
    postgres/views/metabase_views.sql

touch \
    scripts/run_pipeline.sh \
    scripts/load_raw.sh \
    scripts/run_staging.sh \
    scripts/run_warehouse.sh \
    scripts/run_analytics.sh \
    scripts/reset_db.sh \
    scripts/utils.sh

touch \
    docs/architecture.md \
    docs/lineage.md \
    docs/business_rules.md

touch \
    tests/data_quality.sql \
    tests/validation_checks.sql

chmod +x scripts/*.sh

echo "Project scaffold created successfully."