import os
from src.etl.utils import setup_logger, get_mysql_engine, execute_sql_file

logger = setup_logger("etl_silver")

def run():
    logger.info("Starting Silver ETL phase (SQL execution)...")
    engine = get_mysql_engine()
    
    sql_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), "sql", "silver", "normalize.sql")
    
    try:
        execute_sql_file(engine, sql_file, logger)
        logger.info("Silver ETL phase completed successfully.")
    except Exception as e:
        logger.error(f"Silver ETL phase failed: {e}")
        raise

if __name__ == "__main__":
    run()
