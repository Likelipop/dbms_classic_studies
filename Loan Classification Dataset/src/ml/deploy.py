import argparse
from minio import Minio

def upload_model_to_minio(model_path: str, bucket_name: str = "ml-models"):
    """Uploads a trained model to MinIO Model Registry"""
    client = Minio(
        "localhost:9000",
        access_key="admin",
        secret_key="password123",
        secure=False
    )
    
    # Ensure bucket exists
    found = client.bucket_exists(bucket_name)
    if not found:
        client.make_bucket(bucket_name)
    
    model_name = model_path.split("/")[-1]
    client.fput_object(bucket_name, model_name, model_path)
    print(f"Successfully uploaded {model_name} to MinIO bucket '{bucket_name}'")

if __name__ == "__main__":
    # Example usage
    print("Deployment logic goes here.")
    # upload_model_to_minio("path/to/best_model.pkl")
