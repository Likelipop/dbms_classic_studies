#!/bin/bash

set -e

source scripts/utils.sh

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p logs

log "PIPELINE START"

log "Step 1/3: Loading raw data..."
bash scripts/load_raw.sh \
    > logs/load_raw_$TIMESTAMP.log 2>&1
log "Step 1/3: Raw data loaded."

log "Step 2/3: Running staging..."
bash scripts/run_staging.sh \
    > logs/staging_$TIMESTAMP.log 2>&1
log "Step 2/3: Staging complete."

log "Step 3/3: Running warehouse..."
bash scripts/run_warehouse.sh \
    > logs/warehouse_$TIMESTAMP.log 2>&1
log "Step 3/3: Warehouse complete."

log "PIPELINE SUCCESS"