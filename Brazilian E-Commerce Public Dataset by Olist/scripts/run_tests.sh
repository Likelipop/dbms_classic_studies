#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

log "====== Data Testing Pipeline START ======"

TEST_DIR="$ROOT_DIR/tests"

# Định nghĩa các file test
FILES=(
    "data_quality.sql"
    "validation_checks.sql"
)

# Chạy lần lượt từng file test
for file in "${FILES[@]}"; do
    log "  -> Running test: $file"
    
    # Nếu file SQL có lỗi (RAISE EXCEPTION), psql sẽ trả về mã lỗi nhờ cờ ON_ERROR_STOP=1
    psql -h localhost \
        -p "$POSTGRES_PORT" \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        -v ON_ERROR_STOP=1 \
        -f "$TEST_DIR/$file"
done

log "====== Data Testing Pipeline PASSED ======"