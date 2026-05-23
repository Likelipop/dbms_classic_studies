import sys
from src.etl.utils import setup_logger
from src.etl import bronze, silver, gold

logger = setup_logger("run_etl")

def run_all():
    logger.info("="*50)
    logger.info("STARTING FULL ETL PIPELINE")
    logger.info("="*50)
    
    try:
        bronze.run()
        silver.run()
        gold.run()
        
        logger.info("="*50)
        logger.info("ETL PIPELINE COMPLETED SUCCESSFULLY")
        logger.info("="*50)
    except Exception as e:
        logger.error(f"ETL PIPELINE FAILED: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    run_all()
