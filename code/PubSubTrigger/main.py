import json
import base64
from google.cloud import storage
import functions_framework

@functions_framework.cloud_event
def save_msg_to_json_bucket(cloud_event):
    pubsub_message = base64.b64decode(cloud_event.data["message"]["data"]).decode("utf-8")

    event_id = cloud_event.get("id")
    timestamp = cloud_event.get("time") or cloud_event.get("timestamp")

    message_dict = {
        "message": pubsub_message,
        "event_id": event_id,
        "timestamp": timestamp
    }

    storage_client = storage.Client()
    bucket = storage_client.get_bucket('loony-oreilly-olt-bucket-dest')

    blob = bucket.blob('messages.json')
    messages = []

    if blob.exists():
        blob_content = blob.download_as_string()
        messages = json.loads(blob_content)
    
    messages.append(message_dict)

    new_blob = bucket.blob('messages.json')
    new_blob.upload_from_string(json.dumps(messages))

    return 'Message successfully stored in JSON format.'