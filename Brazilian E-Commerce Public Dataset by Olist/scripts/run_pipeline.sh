#!/bin/bash

set -e

source scripts/utils.sh

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p logs

log "PIPELINE START"

bash scripts/load_raw.sh \
    > logs/load_raw_$TIMESTAMP.log 2>&1

bash scripts/run_staging.sh \
    > logs/staging_$TIMESTAMP.log 2>&1

log "PIPELINE SUCCESS"