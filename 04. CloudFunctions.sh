
####################################
### Deploy a simple Cloud Function using the UI


From the navigation menu go to "APIs & Services" -> Dashboard -> Enable API & Services

In search write "Cloud Function" and enable the Cloud Function API 

In search write "Cloud Build" and enable the Cloud Build API 


From the side navigation go to "Cloud Run Functions" and click on it

Click on "Write a function" 

Give the service name "hello-msg-func" 

Change runtime "Python 3.11"

DO NOT specify any trigger (this will default to HTTP trigger)

Use "Cloud IAM to authenticate incoming requests"

-- Require authentication

Click on "Create"

----------------------


Now you will see the Source

main.py
requirements.txt


Click on "Save and redeploy"

Click on the URL for the function

https://<some_endpoint>.us-central1.run.app

You should see an authentication error

Go to the "Test" option at the top

Run the curl command on Cloud Shell

This will work

---------------------

Go to the security tab of the function

"Allow unauthenticated invocations"

Click on "Save"

Click on the URL for the function again

Now this works

Pass a parameter

https://<some_endpoint>.us-central1.run.app?name=Bob


###########




####################################
### Image operations, Cloud Functions triggered by Cloud Storage

Make sure that the loony-oreilly-olt-bucket-source folder only contains puppy.jpeg


Create a new cloud function

# This will be Cloud Run - create a function with inline editor

Trigger : Change the trigger to Cloud storage


service name : negate-images
Region : we will use the default one
Event type : Finalize
Bucket : loony-oreilly-olt-bucket-source


Runtime: Python 3.11

Entry point: transform_image

# Click on "Create"


## main.py

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




## requirements.txt
functions-framework==3.*
google-cloud-storage
Pillow



#

Deploy the function

Show that the trigger is now bucket

Show images in the loony-oreilly-olt-bucket-source


# Go to the "loony-oreilly-olt-bucket-source"

# Delete any existing images, and upload new ones

# Go to the destination bucket loony-oreilly-olt-bucket-dest

# Show the negated images


####################################
### Cloud Functions triggered by Pub/Sub



--------------------

Go to Cloud Functions

Click on Trigger Cloud Function > Create Function   

Create a function named "store-pubsub-messages" in your project.

Select the trigger type "Cloud Pub/Sub".

Choose the Pub/Sub topic you just created.

Click on Python 3.12 runtime and change the main.py to the following:

entry point: save_msg_to_json_bucket    

# main.py
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

# requirements.txt
functions-framework==3.*
google-cloud-storage


Click on "Save and deploy"

---------------------------



Click on the topic and select "Messages" > "Publish Message"

Enter a message such as "User 'John Doe' uploaded a new file to the system at 10:32 AM.", and click "Publish".

Visit the bucket and confirm that the messages.json file has been created.

Go back to Pub/Sub and publish another message such as:
"System alert: New user registration by 'Jane Doe' at 11:15 AM."

Return to the bucket and verify that the messages.json file has been updated








