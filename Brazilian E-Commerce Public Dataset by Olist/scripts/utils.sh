#!/bin/bash
set -e

# ==============================================================================
# utils.sh
# Core utility functions and environment setup for the data pipeline
# ==============================================================================

# 1. Resolve the absolute path of the project root directory
export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 2. Load environment variables
if [ -f "$ROOT_DIR/.env" ]; then
    source "$ROOT_DIR/.env"
else
    echo "[ERROR] .env file not found in $ROOT_DIR"
    exit 1
fi

# 3. Export PostgreSQL password for non-interactive psql login
export PGPASSWORD=$POSTGRES_PASSWORD

# Function: Print formatted log messages with timestamps
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function: Execute a specific SQL file using psql
execute_sql_file() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    
    if [ ! -f "$file_path" ]; then
        log "[ERROR] SQL file not found: $file_path"
        exit 1
    fi

    log "  -> Executing: $file_name"
    
    psql -h localhost \
        -p "$POSTGRES_PORT" \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        -v ON_ERROR_STOP=1 \
        -f "$file_path"
}