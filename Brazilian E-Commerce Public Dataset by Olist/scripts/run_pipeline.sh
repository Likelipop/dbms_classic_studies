#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_DIR="$ROOT_DIR/logs"

# Ensure the logs directory exists
mkdir -p "$LOG_DIR"

log "====== FULL PIPELINE START ======"

log "Step 1/5: Loading Raw Data..."
bash "$ROOT_DIR/scripts/load_raw.sh" > "$LOG_DIR/load_raw_$TIMESTAMP.log" 2>&1
log "Step 1/5: Raw Data Loaded Successfully."

log "Step 2/5: Running Staging..."
bash "$ROOT_DIR/scripts/run_staging.sh" > "$LOG_DIR/staging_$TIMESTAMP.log" 2>&1
log "Step 2/5: Staging Completed Successfully."

log "Step 3/5: Running Warehouse..."
bash "$ROOT_DIR/scripts/run_warehouse.sh" > "$LOG_DIR/warehouse_$TIMESTAMP.log" 2>&1
log "Step 3/5: Warehouse Completed Successfully."

log "Step 4/5: Running Analytics..."
bash "$ROOT_DIR/scripts/run_analytics.sh" > "$LOG_DIR/analytics_$TIMESTAMP.log" 2>&1
log "Step 4/5: Analytics Completed Successfully."


log "Step 5/5: Running Data Tests..."
bash "$ROOT_DIR/scripts/run_tests.sh" > "$LOG_DIR/tests_$TIMESTAMP.log" 2>&1
log "Step 5/5: Data Tests Passed Successfully."

log "====== FULL PIPELINE SUCCESS ======"