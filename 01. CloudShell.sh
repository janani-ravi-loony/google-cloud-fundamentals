#####

Enabling billing:
https://drive.google.com/drive/folders/130rcJUmsy4LANX-7iWasu7KmuvFULkSf?usp=sharing

################ Creating and working with Projects

https://console.cloud.google.com/


Provide valid username and password 

	Username : cloud.user@loonycorn.com


Click on the drop down menu at the top and you can see all the available projects 

Go through RECENT, STARRED and ALL projects 

Click on NEW PROJECT, create a project named oreilly-olt-gcp

Click on the question mark next to the bell button, you will see the hierarchy of this project

=> Note that if they are using a gmail account, there will be no hierarchy

Click on Edit for Project Id, click on refresh option on the right side, we see the id changes

Choose any random ID (this project ID is unique across all GCP projects so each of us have to have our own unique ID)

Show the dashboard for this new project

=> Show that I have billing enabled for this project



###########
# Exploring Products

Click on hamburger icon on the top-left

Show the left-hand navigation pane

Scroll down and show that all the products and services are available from here

Hover over "Compute Engine" and pin that

Hover over "Cloud Storage" and pin that as well

Scroll through products and click on API and services > Dashboard

Click on + ENABLE APIS AND SERVICES

Search for Compute Engine API and enable it. 

Also click on Try this API and it redirects to google documentation



###########
# Sharing the project

Click on "Add people to project"

Add bob@loonycorn.com as a member and select the role as Project > Owner, press save 


###########
# Exploring Cloud Shell

To launch a Cloud Shell session from the Cloud Console, use the "Activate Cloud Shell" button in your Console.

Hit Command + Shift + + to increase the font of the Cloud Shell

Run 

$ pwd

$ gcloud config set project plucky-respect-310804

Click on the full screen icon and show that it opens up on shell.cloud.google.com 

$ cloudshell help

$ cloudshell download-files -h

$ nano some_file.txt

$ ls -l

$ cloudshell download-files some_file.txt
$ gcloud --help

$ gcloud components list

$ bq

$ gsutil


Click on three-dotted More menu -> select Upload file ->

Select the puppy.jpg file from the file_code/resource folder

$ ls -l

Show that the file has been uploaded

Click on the top-right icon for "Session Information" and show that Cloud Shell has a usage quota


###########
# Using the Cloud Shell editor


Go to full screen on the terminal of the Cloud Shell by clicking on the icon on the top-right

Command + Shift + + to increase the font on the cloud shell window

=> You should now have a terminal window opened on a new tab

Create a new folder using the command line

$ mkdir SampleProject


Go back to the first tab

Click on pencil button to open an editor from the cloud shell 

Open the Cloud Shell editor in a new window

Go to File -> Open Workspace if nothing shows up

Show that the SampleProject folder in under here


###########
# Running Java


Select the SampleProject folder

Click on File -> New file

Create a file HelloWorld.java

--

public class HelloWorld {
    
    public static void main(String[] args) {
        
        System.out.println("Hello World from Cloud Shell Editor!");

    }

}

--

Switch over to the terminal tab

$ cd SampleProject

$ ls 

$ java --version

$ javac HelloWorld.java

$ ls

$ java HelloWorld


###########
# Running Python


Click on File -> New file

Create a file hello_world.py

Paste the code in

--

num1 = 1.5
num2 = 6.3

sum = num1 + num2

print('The sum of {0} and {1} is {2}'.format(num1, num2, sum))

print('Hello and welcome to Python!')

--

$ python --version

$ python3 --version

$ python3 hello_world.py


Finally show that Maven is also installed on Cloud Shell

mvn --version


###########

# Configuring Cloud Shell

# To check the current project

$ echo $GOOGLE_CLOUD_PROJECT 

#going to a different project using the project ID

$ gcloud config list

# Seting up the region to the project 

$ gcloud config set compute/region us-east1

$ gcloud config list







































































