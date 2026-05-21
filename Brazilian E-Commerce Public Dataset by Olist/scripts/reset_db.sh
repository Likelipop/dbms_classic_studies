#!/bin/bash

set -e

source .env
source scripts/utils.sh

export PGPASSWORD=$POSTGRES_PASSWORD

log "RESET database schemas"

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f postgres/init/01_create_schemas.sql

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f postgres/init/02_create_raw_tables.sql

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f postgres/init/03_create_staging_tables.sql

psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB \
    -f postgres/init/04_create_dw_tables.sql

log "RESET completed"