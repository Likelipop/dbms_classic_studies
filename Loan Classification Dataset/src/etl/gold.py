import os
import pandas as pd
from src.etl.utils import setup_logger, get_mysql_engine, get_postgres_engine, execute_sql_file

logger = setup_logger("etl_gold")

def migrate_to_staging(mysql_engine, pg_engine):
    logger.info("Migrating Silver tables from MySQL to PostgreSQL Staging...")
    
    tables_to_migrate = [
        "dim_borrower",
        "dim_loan_info",
        "dim_credit_profile",
        "fact_loan_performance"
    ]
    
    for table in tables_to_migrate:
        logger.info(f"Extracting {table} from MySQL...")
        df = pd.read_sql(f"SELECT * FROM {table}", mysql_engine)
        
        stg_table = f"stg_{table}"
        logger.info(f"Loading {len(df)} rows into {stg_table} in PostgreSQL...")
        df.to_sql(stg_table, con=pg_engine, if_exists='replace', index=False)

def run():
    logger.info("Starting Gold ETL phase (Cross-DB Migration + SQL execution)...")
    mysql_engine = get_mysql_engine()
    pg_engine = get_postgres_engine()
    
    sql_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), "sql", "gold", "aggregate.sql")
    
    try:
        # Step 1: Bridge data from MySQL (Silver) to PostgreSQL (Staging)
        migrate_to_staging(mysql_engine, pg_engine)
        
        # Step 2: Execute pure SQL transformation inside PostgreSQL
        execute_sql_file(pg_engine, sql_file, logger)
        
        logger.info("Gold ETL phase completed successfully.")
    except Exception as e:
        logger.error(f"Gold ETL phase failed: {e}")
        raise

if __name__ == "__main__":
    run()
