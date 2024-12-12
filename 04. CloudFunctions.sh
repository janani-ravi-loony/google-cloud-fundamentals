
####################################
### Deploy a simple Cloud Function using the UI


From the navigation menu go to "APIs & Services" -> Dashboard -> Enable API & Services

In search write "Cloud Function" and enable the Cloud Function API 

In search write "Cloud Build" and enable the Cloud Build API 


From the side navigation go to "Cloud Functions" and click on it

Click on "Create Function" 

Give the function name "hello-msg-func" 

Rest of the things will remain as it is so we will not change anything and click on "Save"

Expand the "Runtime, Build and Connection Settings" option and show the default things

Click on "Next"

Choose the Python 3.11 runtime and show the main.py but do not change anything

Deploy the function


Click on Testing tab

Test with the following:

{}

{"name" : "John"}

curl -m 70 -X POST https://us-central1-plucky-respect-310804.cloudfunctions.net/hello-msg-func \
-H "Content-Type: application/json" \
-d '{"name" : "everybody"}'

# Use the curl command that they have given

curl -m 70 -X POST https://us-central1-plucky-respect-310804.cloudfunctions.net/hello-msg-func \
-H "Authorization: bearer $(gcloud auth print-identity-token)" \
-H "Content-Type: application/json" \
-d '{
  "name": "Tina"
}'

###########

Next click on 'Triggers'

Click on the trigger URL will result in an error

Error: Forbidden
Your client does not have permission to get URL /hello-msg-func from this server.

=> Go to 'Permission' now

Run this on Cloud Shell

gcloud functions add-invoker-policy-binding hello-msg-func \
      --region="us-central1" \
      --member="allUsers"


Click on the trigger, it will print "Hello world!"

Add this extra parameter to the URL "?name=Doris"

The page will print "Hello Doris!"



####################################
### Deploy a simple Cloud Function using the console

Create a folder called hello_msg

mkdir hello_msg
cd hello_msg

nano main.py


def print_message(request):

	if request.method == 'GET':
		if request.args and 'name' in request.args:
			return 'Howdy ' + request.args.get('name') + '!\n'
		else:
			return f'Welcome to Cloud Functions!\n'

	if request.method == 'POST':
		data = request.get_json()
		return 'Hello ' + data['name'] + '!\n'


####################################


gcloud functions deploy print_message \
--gen2 \
--runtime=python311 \
--region=us-central1 \
--source=. \
--entry-point=print_message \
--trigger-http \
--allow-unauthenticated

curl -X GET https://us-central1-plucky-respect-310804.cloudfunctions.net/print_message


curl -X GET https://us-central1-plucky-respect-310804.cloudfunctions.net/print_message?name=loony 


curl -X POST https://us-central1-plucky-respect-310804.cloudfunctions.net/print_message \
-H "Content-Type:application/json"  -d '{"name":"Bob"}'






####################################
### Image operations, Cloud Functions triggered by Cloud Storage

Make sure that the loony-oreilly-olt-bucket-source folder only contains puppy.jpeg


Create a new cloud function

function name : process-images
Region : we will use the default one
Trigger : Change the trigger to Cloud storage
Event type : Finalize/Create
Bucket : loony-oreilly-olt-bucket-source


Runtime: Python 3.11

Entry point: transform_image


## main.py

from cloudevents.http import CloudEvent
import functions_framework

from wand.image import Image
from google.cloud import storage

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def transform_image(cloud_event: CloudEvent):
    """This function is triggered by a change in a storage bucket.

    Args:
        cloud_event: The CloudEvent that triggered this function.
    Returns:
        The event ID, event type, bucket, name, metageneration, and timeCreated.
    """
    data = cloud_event.data

    event_id = cloud_event["id"]
    event_type = cloud_event["type"]

    bucket = data["bucket"]
    name = data["name"]

    print(f"Event ID: {event_id}")
    print(f"Event type: {event_type}")
    print(f"Bucket: {bucket}")
    print(f"File: {name}")

    storage_client = storage.Client()

    bucket = storage_client.get_bucket(data['bucket'])
    blob = bucket.get_blob(data['name'])

    image_source_file = blob.download_as_string()

    des_bucket = storage_client.get_bucket('loony-oreilly-olt-bucket-dest')
    image_dest_blob = des_bucket.blob('negated_' + data['name'])

    with Image(blob=image_source_file) as image:
        with image.clone() as clone:
            clone.negate()
            image_dest_blob.upload_from_string(clone.make_blob())




## requirements.txt

functions-framework==3.*
cloudevents==1.*
wand
google-cloud-storage


#

Deploy the function

Show that the trigger is now bucket

Show images in the loony-oreilly-olt-bucket-source

Go to the "Testing" tab

{
	"bucket":"loony-oreilly-olt-bucket-source", 
	"name":"puppy.jpeg"
}

# Go to the destination bucket loony-oreilly-olt-bucket-dest

# Show the image

# Go to the "loony-oreilly-olt-bucket-source"

# Delete any existing images, and upload new ones

# Go to the destination bucket loony-oreilly-olt-bucket-dest

# Show the negated images

# Show the logs for the function as well


####################################
### Cloud Functions triggered by Pub/Sub




Go to Cloud Functions

Click on Trigger Cloud Function > Create Function   

Create a function named "store-pubsub-messages" in your project.

Select the trigger type "Cloud Pub/Sub".

Choose the Pub/Sub topic you just created.

Click on Python 3.12 runtime and change the main.py to the following:

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


entry point: save_msg_to_json_bucket    

---------------------------

Click on "Deploy"

Click on the topic and select "Message" > "Publish Message"

Enter a message such as "User 'John Doe' uploaded a new file to the system at 10:32 AM.", and click "Publish".

Visit the bucket and confirm that the messages.json file has been created.

Go back to Pub/Sub and publish another message such as:
"System alert: New user registration by 'Jane Doe' at 11:15 AM."

Return to the bucket and verify that the messages.json file has been updated








