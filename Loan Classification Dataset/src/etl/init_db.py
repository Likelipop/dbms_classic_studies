import os
import glob
from sqlalchemy import text
from src.etl.utils import setup_logger, get_mysql_engine, get_postgres_engine, get_minio_client, execute_sql_file

logger = setup_logger("init_db")

def init_minio():
    client = get_minio_client()
    buckets = ["data-sources", "ml-models"]
    for bucket in buckets:
        if not client.bucket_exists(bucket):
            client.make_bucket(bucket)
            logger.info(f"Created MinIO bucket: {bucket}")
        else:
            logger.info(f"MinIO bucket already exists: {bucket}")
            
    # Create "folder" structures for ML models by putting an empty object
    from io import BytesIO
    folders = ["trained/", "evaluated/", "deployed/"]
    for folder in folders:
        client.put_object("ml-models", folder, BytesIO(b""), 0)
    logger.info("Initialized ML models folder structure in MinIO")

    # Upload local xlsx files from data folder to simulate data source
    data_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "data")
    xlsx_files = glob.glob(os.path.join(data_dir, "*.xlsx"))
    for file_path in xlsx_files:
        if "~lock" in file_path:
            continue
        file_name = os.path.basename(file_path)
        client.fput_object("data-sources", file_name, file_path)
        logger.info(f"Uploaded {file_name} to MinIO data-sources bucket")

def init_mysql():
    engine = get_mysql_engine()
    sql_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "init-scripts", "mysql-init.sql")
    execute_sql_file(engine, sql_file, logger)
    logger.info("Initialized MySQL schemas (Bronze & Silver) from SQL script")

def init_postgres():
    engine = get_postgres_engine()
    sql_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "init-scripts", "postgres-init.sql")
    execute_sql_file(engine, sql_file, logger)
    logger.info("Initialized PostgreSQL schemas (Gold) from SQL script")

if __name__ == "__main__":
    logger.info("Starting Database and Data Lake Initialization...")
    init_minio()
    init_mysql()
    init_postgres()
    logger.info("Initialization completed.")
