import os
import logging
from sqlalchemy import create_engine, text
from minio import Minio

def setup_logger(name):
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    
    if not logger.handlers:
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        
        os.makedirs('logs', exist_ok=True)
        fh = logging.FileHandler('logs/etl_pipeline.log')
        fh.setFormatter(formatter)
        logger.addHandler(fh)
        
        ch = logging.StreamHandler()
        ch.setFormatter(formatter)
        logger.addHandler(ch)
        
    return logger

def get_mysql_engine():
    user = os.getenv("MYSQL_USER", "loan_user")
    password = os.getenv("MYSQL_PASSWORD", "loan_pass")
    host = os.getenv("MYSQL_HOST", "localhost")
    port = os.getenv("MYSQL_PORT", "3306")
    database = os.getenv("MYSQL_DATABASE", "loan_db")
    return create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")

def get_postgres_engine():
    user = os.getenv("POSTGRES_USER", "postgres")
    password = os.getenv("POSTGRES_PASSWORD", "postgrespass")
    host = os.getenv("POSTGRES_HOST", "localhost")
    port = os.getenv("POSTGRES_PORT", "5432")
    database = os.getenv("POSTGRES_DB", "loan_gold_db")
    return create_engine(f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}")

def get_minio_client():
    user = os.getenv("MINIO_ROOT_USER", "admin")
    password = os.getenv("MINIO_ROOT_PASSWORD", "password123")
    host = os.getenv("MINIO_HOST", "localhost:9000")
    return Minio(host, access_key=user, secret_key=password, secure=False)

def execute_sql_file(engine, file_path, logger):
    logger.info(f"Executing SQL file: {file_path}")
    with open(file_path, 'r') as file:
        sql_script = file.read()
        
    # Simple split by statement for executing multiple commands
    statements = [stmt.strip() for stmt in sql_script.split(';') if stmt.strip()]
    
    with engine.connect() as conn:
        for statement in statements:
            try:
                conn.execute(text(statement))
            except Exception as e:
                logger.error(f"Error executing statement: {statement[:50]}... \n{e}")
                raise
        conn.commit()
    logger.info(f"Successfully executed {file_path}")
