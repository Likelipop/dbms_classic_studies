#!/bin/bash

set -e

source scripts/utils.sh

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p logs

log "PIPELINE START"

log "Step 1/4: Loading raw data..."
bash scripts/load_raw.sh > logs/load_raw_$TIMESTAMP.log 2>&1
log "Step 1/4: Raw data loaded."

log "Step 2/4: Running staging..."
bash scripts/run_staging.sh > logs/staging_$TIMESTAMP.log 2>&1
log "Step 2/4: Staging complete."

log "Step 3/4: Running warehouse..."
bash scripts/run_warehouse.sh > logs/warehouse_$TIMESTAMP.log 2>&1
log "Step 3/4: Warehouse complete."

# ── BƯỚC CẬP NHẬT MỚI: Chạy tầng Analytics
log "Step 4/4: Running analytics..."
bash scripts/run_analytics.sh > logs/analytics_$TIMESTAMP.log 2>&1
log "Step 4/4: Analytics complete."

log "PIPELINE SUCCESS"