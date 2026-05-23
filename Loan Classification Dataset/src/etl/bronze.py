import os
import pandas as pd
from io import BytesIO
from sqlalchemy import text
from src.etl.utils import setup_logger, get_mysql_engine, get_minio_client

logger = setup_logger("etl_bronze")

def extract_from_minio(client, bucket_name="data-sources"):
    objects = client.list_objects(bucket_name)
    dfs = []
    for obj in objects:
        if obj.object_name.endswith('.xlsx'):
            logger.info(f"Downloading {obj.object_name} from MinIO...")
            response = client.get_object(bucket_name, obj.object_name)
            excel_data = BytesIO(response.read())
            df = pd.read_excel(excel_data)
            dfs.append(df)
            response.close()
            response.release_conn()
            
    if dfs:
        return pd.concat(dfs, ignore_index=True)
    return pd.DataFrame()

def load_to_mysql(df, engine):
    logger.info(f"Loading {len(df)} rows to MySQL bronze_loans_raw...")
    # Convert dataframe to JSON string per row
    json_data = df.apply(lambda x: x.to_json(), axis=1).to_frame('raw_data')
    
    # We append the data to the raw table
    json_data.to_sql('bronze_loans_raw', con=engine, if_exists='append', index=False)
    logger.info("Successfully loaded data to bronze.")

def run():
    logger.info("Starting Bronze ETL phase...")
    client = get_minio_client()
    engine = get_mysql_engine()
    
    df = extract_from_minio(client)
    if not df.empty:
        load_to_mysql(df, engine)
    else:
        logger.warning("No data extracted from MinIO.")
    logger.info("Bronze ETL phase completed.")

if __name__ == "__main__":
    run()
