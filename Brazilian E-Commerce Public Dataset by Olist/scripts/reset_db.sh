#!/bin/bash
set -e

# Source the core utility file
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

log "====== Database Reset START ======"

SQL_DIR="$ROOT_DIR/postgres/init"

# Define the sequence of initialization files
FILES=(
    "01_create_schemas.sql"
    "02_create_raw_tables.sql"
    "03_create_staging_tables.sql"
    "04_create_dw_tables.sql"
)

# Execute each file in order
for file in "${FILES[@]}"; do
    execute_sql_file "$SQL_DIR/$file"
done

log "====== Database Reset DONE ======"