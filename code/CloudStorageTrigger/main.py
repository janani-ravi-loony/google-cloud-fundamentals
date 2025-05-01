import functions_framework
from google.cloud import storage
from PIL import Image, ImageOps
import io

storage_client = storage.Client()
dest_bucket_name = "loony-oreilly-olt-bucket-dest"

@functions_framework.cloud_event
def transform_image(cloud_event):
    data = cloud_event.data

    bucket_name = data["bucket"]
    file_name = data["name"]

    print(f"Bucket: {bucket_name}")
    print(f"File: {file_name}")

    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    file_contents = blob.download_as_bytes()
    print(f"Downloaded file: {file_name}")

    # Open the image using Pillow
    image = Image.open(io.BytesIO(file_contents)).convert("RGB")

    # Apply negation
    negated_image = ImageOps.invert(image)

    # Save to a buffer
    buffer = io.BytesIO()
    negated_image.save(buffer, format="PNG")
    buffer.seek(0)

    # Upload to destination bucket
    dest_bucket = storage_client.bucket(dest_bucket_name)
    new_file_name = "negated_" + file_name
    dest_blob = dest_bucket.blob(new_file_name)
    dest_blob.upload_from_file(buffer, content_type="image/png")
    print(f"Uploaded negated image as '{new_file_name}' to destination bucket: {dest_bucket_name}")
