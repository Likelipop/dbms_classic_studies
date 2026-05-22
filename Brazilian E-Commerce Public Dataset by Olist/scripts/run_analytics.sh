#!/bin/bash

set -e

# Xác định thư mục gốc của dự án
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load biến môi trường và các hàm tiện ích (log)
source "$ROOT_DIR/.env"
source "$ROOT_DIR/scripts/utils.sh"

# Export mật khẩu để psql không yêu cầu nhập thủ công
export PGPASSWORD=$POSTGRES_PASSWORD

# Đường dẫn tới thư mục chứa các file SQL analytics
SQL_DIR="$ROOT_DIR/postgres/analytics"

log "====== Analytics pipeline START ======"

# Hàm helper để thực thi file SQL
run_sql() {
    local file="$1"

    log "Running Analytics View: $file"

    psql -h localhost \
        -p $POSTGRES_PORT \
        -U $POSTGRES_USER \
        -d $POSTGRES_DB \
        -v ON_ERROR_STOP=1 \
        -f "$SQL_DIR/$file"

    log "Done: $file"
}

# ── Thực thi các file SQL tạo View Phân Tích (Data Marts)
run_sql "sales_overview.sql"
run_sql "product_performance.sql"
run_sql "customer_retention.sql"
run_sql "seller_performance.sql"
run_sql "delivery_performance.sql"
run_sql "payment_analysis.sql"

log "====== Analytics pipeline DONE ======"