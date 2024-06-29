######################
## Creating buckets using the UI


Click on the new bucket with below args:

	name - loony-oreilly-olt-bucket
	locate-type - multi-regional
	storage class - standard
	access-control - uniform
	encryption - as it is

Show the monthly cost estimator on the right

Show data retrieval is free

Open up each of the options while creation and explain

# Make sure this is unticked

[UNTICK]  Enforce public access prevention on this bucket


Then click on "Create"

# Now you can see the bucket has created, 
# Click on the bucket and go inside the project

Click on the configuration and see the details of the bucket
	Copy the url and paste it in a new tab and see it is redirecting to bucket

Click on permissions and see the details
Click on retention and see the details
Click on the lifecycle and see the details


######################
## Creating buckets using gsutil


=> Click on the cloudshell which is there in the top right on the gcp dashboard

=> Run gcloud auth login

=> Click on the url and login as cloud.user@loonycorn.com and code the code
=> Paste the code in cloud shell and here we go, our gsutil is configured.

gsutil mb gs://loony-oreilly-olt-bucket

# Once we run the code, it will throw an error
ServiceException: 409 A Cloud Storage bucket named 'simple' already exists. 
Try another name. 
Bucket names must be globally unique across all Google Cloud projects, 
including those outside of your organization.


gsutil mb gs://loony-oreilly-olt-bucket-source

gsutil ls

gsutil mb -c regional -l us-central1 gs://loony-oreilly-olt-bucket-dest

gsutil help mb


##################################
### Upload and configure file settings to be public


Select the loony-oreilly-olt-bucket

Click on create folder and enter the folder name - 'images'
'Betsy.jpg', 'Boomer.jpg', 'puppy.jpg'

Click on the name of the dog and see the details about the dog

Also copy the authenticted url and paste seperately in the browser, 

Then we can see the image completely in the browser

Click on the 3 dots -> Edit permissions


Cannot get legacy ACL for an object when uniform bucket-level access is enabled. 
Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access

Click on the bucket -> Configuration -> Permissions -> Access control

Change to fine-grained


Go back to the images/ folder

3 dots -> Click on the edit permissions , then click on add Entry.
Click on entity and from dropdown choose "Public"

Click on save.

# Now you can see under public access, it is public access to internet.
Click on copy the url and add the url in a new tab and see the image


##################################
### Change the retention policy of the bucket


# Now lets do the retention policy, so we cannot do any modification until the period ends
Click on Retention and click on set retention policy.
And here I am going to give 600 seconds

Now you an see in Retention policy new time period gets added
Come back the objects and see the retention expiration date 

Try and delete the objects, you should not be allowed to, you will get an error

We can come back to this after 10 minutes and see that we can now delete objects


######################
# Temporary hold

Go to another bucket loony-oreilly-olt-bucket-source

Upload the same set of images to the bucket 
'Betsy.jpg', 'Boomer.jpg', 'puppy.jpg'

=> Tick "puppy.jpg"

=> Click on "Manage holds"

=> Tick temporary hold

=> Save the changes


=> Click on "puppy.jpg" and see the details

=> Try to delete the file
(We get an error, click and see the error message)
(We cannot delete this file untile we manually remove the hold)


=> Click on "Manage holds" of "puppy.jpg"

=> Untick temporary hold

=> Save the changes

=> Try to delete the file
(We can delete the file now)


##################################
### Data versioning and object lifecycle

Go to another bucket loony-oreilly-olt-bucket-source

Upload the same set of images to the bucket 
'Betsy.jpg', 'Boomer.jpg', 'puppy.jpg', 'Life Expectancy Data.csv'


In Cloud Shell run the following

$ gsutil versioning get gs://loony-oreilly-olt-bucket

$ gsutil versioning set on gs://loony-oreilly-olt-bucket

Cannot set versioning on a bucket with a retention policy


$ gsutil versioning set on gs://loony-oreilly-olt-bucket-source

$ gsutil versioning get gs://loony-oreilly-olt-bucket-source


$ gsutil ls -L gs://loony-oreilly-olt-bucket-source/Boomer.jpeg

Note the generation number, and the metageneration number (should be 1)

On the web console go to the image

3 dot -> edit permissions
Give the key - age and value - 3 months


Back to Cloud Shell


$ gsutil ls -L gs://loony-oreilly-olt-bucket-source/Boomer.jpg

Note that the generation number is the same, metageneration has now changed to 2


Back to the web console

Upload the same Boomer.jpg again

$ gsutil ls -L gs://loony-oreilly-olt-bucket-source/Boomer.jpg

Generation number has changed, metageneration should have gone back to 1


Go to the web console for the bucket gs://loony-oreilly-olt-bucket-source

Go to the "lifecycle" tab

Click on "Add a rule"

Choose "Delete object"

Object condition should be "Number of newer versions"

Choose 3

This will ensure that your storage costs will not balloon because of versioning

Create the rule and show the rule now applies

Rules can take 24 hours to take effect


##################################
#### Soft delete and object versioning

=> Open the "loony-oreilly-olt-bucket-source" bucket

=> Click on "Version history" and see the versions

=> Go back to the bucket loony-cloud-leader-bucket-source

=> Click "Protection", show the "Soft Delete" policy enabled by default

=> Turn off "Object versioning" (so we only have soft delete)


=> Go back and delete the file "Betsy.jpg"

=> On the top right click on the drop down next to "Show" (by default it is "Live objects only")

=> Switch to "Soft deleted objects only" -> see the "Betsy.jpg" file

=> Switch to "Live and noncurrent objects" -> see the other objects no "Betsy.jpg"

=> Go back to the bucket loony-cloud-leader-bucket-source -> "Protection" -> "Object versioning" 
(Turn on)


=> Now delete the file "Life Expectancy Data.csv"

=> Switch to "Soft deleted objects only"
(We have the original "Life Expectancy Data.csv" that we deleted)

=> Switch to "Live and noncurrent objects" -> see "Life Expectancy Data.csv (Noncurrent)"


=> Click on "Life Expectancy Data.csv (Noncurrent)"

=> Click on "Restore"
(Observe now we have a live version of the file and a noncurrent version of the file)

##################################
### Authenticating using time-limited signed URL

Go to IAM page

Copy the service account of the app engine plucky-respect-310804@appspot.gserviceaccount.com

On Cloud Shell


$ gcloud iam service-accounts keys create key.json \
    --iam-account=plucky-respect-310804@appspot.gserviceaccount.com


$ ls

Show the key.json file


pip3 install --upgrade pip

pip3 install --upgrade pyopenssl

gsutil signurl -d 10m key.json gs://loony-oreilly-olt-bucket-source/cat.jpeg


Click on the signed URL and show that the link can be accessed

Send the signed URL on chat and show others they can access










































