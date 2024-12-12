from wand.image import Image
from google.cloud import storage

storage_client = storage.Client()
dest_bucket = 'loony-oreilly-olt-bucket-dest'

def transform_image(data, context):

    bucket = storage_client.get_bucket(data['bucket'])
    blob = bucket.get_blob(data['name'])

    image_source_file = blob.download_as_string()

    des_bucket = storage_client.get_bucket(dest_bucket)
    image_dest_blob = des_bucket.blob('negated_' + data['name'])

    with Image(blob=image_source_file) as image:
        with image.clone() as clone:
            clone.negate()
            image_dest_blob.upload_from_string(clone.make_blob())
