

##############
# Creating a VM using the web console


Navigate to Compute Engine -> VM Instances -> Create 


Fill the form :

name : instance-01, change the first letter to uppercase and show the error

Region : Select different regions and show the changes in the price
Show that the types of machines available are also different across regions

Zone : show all the other option and finally select "us-central1-a"
		
Machine Configuration :

Machine family : change to all the option and show how the price differ 
				finally select : " General-purpose "

Series : E2
Machine type : e2-micro 


boot disk : click on the "Change" -> nothing to change but show all the possible options and click on cancel 

Access scopes : select " Allow full access to all cloud APi's"

FireWall : Allow HTTP traffic

Click on management, security, ..... show and click on else


Click on compute engine pricing  -> view entire page

Click on command line( to see the command line code) -> then click on create

Show the instance created on the main VM instances page

Now click on the instance which is created just now

Click on Details and scroll down

Click on Monitoring and scroll down


Click on Disks and show that one persistent disk has been created


##############
# Creating more instances and SSHing into those instances


In the toolbar at the top of the VM instance details page, click Create similar.

Click on create for instance-02

While the instance is being created

Once your VM has created -> click on SSH drop down menu -> open in  browser window 
(pop up need to unlblocked, incase if it is blocked)


Run (within the SSH window)


$ hostname -f

Click on the settings icon on the top-right and show what is possible

Check to see whether instance-02 has been created


Run

$ ping instance-02

$ ping <external IP of instance-2>

$ ping <internal IP of instance-2>



##############
# Creating instances using the gcloud command line tool

Switch over to the tab where the Cloud Shell terminal is open


$ gcloud help compute instances create

$ gcloud compute instances create instance-03

zone = asia-southeast1-b


Switch over to the VM instances page and show the instance creating (or created)

Show the details of the instance-3, default values for all fields that we did not specify

Back to cloud shell

$ gcloud compute instances list

$ gcloud compute instances list --format=json 


$ gcloud compute instances stop instance-03 --zone=asia-southeast1-b


Switch over to the VM instances page and show that instance-03 has been stopped


gcloud compute instances create instance-04 \
--project=plucky-respect-310804 \
--zone=us-central1-c \
--machine-type=f1-micro \
--image=debian-10-buster-v20210316 \
--image-project=debian-cloud \
--boot-disk-size=10GB


Go to the VM instances page and show that this has been created

Click on instance-04 and show the details of the instance

Note how the external IP address specified looks different (because we have not enabled this instance to receive HTTP/HTTP traffic)


##############
# Deploying a simple Flask application to a VM

# sudo apt install python3-pip will take time, in parallel can set up a static IP address

SSH to instance-01, copy over and SSH in a new tab

Create a python file 

$ nano server.py  

Paste the below code in it 

##--

from flask import Flask 

app = Flask(__name__)

@app.route("/")
def hello():
	return "<h3>Hello World from a GCP VM!!</h3>"

if __name__ == '__main__':
	app.run(host='0.0.0.0', port=80)

##--

$ ls -l

$ python3 --version

$ sudo apt-get update

$ sudo apt install python3-pip

$ sudo apt-get install python3-venv

$ python3 -m venv flask_env

$ source flask_env/bin/activate

$ pip3 install flask

$ export FLASK_APP=server.py

$ flask run --host=0.0.0.0 --port=8080


# Click on the IP address for the machine, change port and see app (8080)

# Show the firewall rules


# Now go back to the app and run on default port 5000


$ flask run --host=0.0.0.0


# Now we cannot see this unless we open up this port using the firewall rules


##############
# Assign a static IP address to the VM

Go to VPC Network from the nevigation menu from the dashboard

Click on "external ip address"

We already have some vm with ip just refresh if it not visible 

Now click on "reserve static address" -> 

name : instance-01-ipaddress
description : Static address for the VM hosting the internal website 
network : premium -> also click on question mark on both premium and standard
Ip address : IPv4
Type : Regional
Region : US-central1
Attached to : instance-1

Click on "reserve"

Switch over to VM instances and show that the static IP address of 


Go to the VM instances page

Copy over the external IP address of the instance-1

Open a new browser window and paste into the browser window

The prefix should be http://

Show that the app can be accessed



##############
# Firewalls allow traffic to reach our VM

Click on instance-1 and show that we have Allow HTTP and HTTPs traffic enabled

Click on the hamburger icon -> VPC Networks -> Firewall

Click on the default-allow-http rule and show the details


############
###  Configuring Startup scripts 

# Creating new instance.

name : instance-05
Region : us-central1 (Iowa)
Zone : us-central1-a

Accept the default values for all other settings

Firewall : Allow HTTP traffic

Click on Advanced Options -> Management 

Paste the below code on the Startup script textbox

----------------------------

#!/bin/bash

apt-get update
apt-get install nginx -y
cat <<EOF >/var/www/html/index.nginx-debian.html
<html><body><h1>WELCOME</h1>
<p>And this is how you use startup scripts on the GCP!</p>
</body></html>
EOF

----------------------------

Create the VM

Go to VM instances

Copy over the external IP address of the instance-5

Open a new browser window and paste into the browser window

The prefix should be http://

Show that the page can be accessed


#################################
# Creating snapshots of disks

Go to instance-05

Click "Snapshots" from the left menu

Click on Create a snapshot

name: instance-05-snapshot-01
description: Snapshot of instance-05 with nginx installed
source type: Disk
source disk: instance-05

Click on Create

# Go to VM instances

name : instance-06
Region : us-central1 (Iowa)
Zone : us-central1-a
Boot disk : Click on Change, and there go to Snapshot > Choose the "instance-05-snapshot-1"

Allow HTTP traffic

Click on Create

Now if you click on external ip address of instance-06 (http://)

Should be able to see the page!


































