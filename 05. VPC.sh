#################################
VPC, Subnet and Firewall
#################################
# https://app.pluralsight.com/library/courses/gcp-vcp-networks-architecting-global-private-clouds
# https://app.pluralsight.com/library/courses/gcp-leveraging-network-interconnection-options

Click on the hamburger menu -> View All Products -> Select and Pin VPC.

Observe there is a default VPC created for you. Click on the default VPC.

Click on all the tabs and observe the details.

Observe there are 42 subnets created for you.

Observe there are 4 default firewall rules created for you.


Click on Firewall from the left pane.

Click and observe each of the firewall rules.


---------------


Click on VPC networks from the left pane.

Click Create VPC network.

Click on ? icon next to all the fields and observe the details.

name: loony-auto-vpc

In subnet click "Automatic" and observe the details.

Scroll down to Firewall rules
# Observe loony-auto-vpc-deny-all-ingress and loony-auto-vpc-allow-all-egress are selected and cannot be deselected.

Click on each of the ? icons and observe the details.

Select all the firewall rules


Click Create.

Click on "loon-auto-vpc" > subnet 

Take a note of the primary IP range of us-central1 subnet.
# 10.128.0.0/20

##############################
### Communication between VMs in same network

On a new tab -> Compute Engine

Create a VM instance with the following details:

name: loony-vm-us-central1
region: us-central1
zone: any
machine type: e2-micro

Click Advanced options -> Networking

network: loony-auto-vpc
network service tier: Standard

Click Create.

#########################################
# Notes
# In typical network setups, including those in cloud environments like Google Cloud Platform (GCP), specific IP addresses within any subnet are reserved for special purposes:

# Network Address (10.128.0.0): The first address of any subnet, in your case 10.128.0.0, is the network address. It is used to identify the subnet itself and is not assignable to individual devices. This address is crucial for network routing purposes as it represents the entire network segment.

# Gateway Address (10.128.0.1): Often, the first usable address in the subnet, following the network address, is assigned as the default gateway. In GCP, and many other networks, this address is used for the router or gateway that manages traffic between this subnet and other networks. This gateway is essential for enabling communication between the VMs in the subnet and the internet or other virtual networks within GCP.

# The IP address 10.128.0.1 would typically be the default gateway through which your VM at 10.128.0.2 would communicate with other networks outside its local subnet.

#########################################



Create a VM instance with the following details:

name: loony-vm-asia-south2
region: asia-south2
zone: any
machine type: e2-micro

Click Advanced options

network: default
network service tier: Standard

Click Create.

# Observe the internal IP its 10.190.0.2, 0 is reserved for subnet and 1 is reserved for gateway.

SSH into the loony-vm-us-central1 instance.

ping -c 4 loony-vm-asia-south2

ping -c 4 <internal-ip-of-loony-vm-asia-south2>

ping -c 4 <external-ip-of-loony-vm-asia-south2>

#################################
### Custom VPC

Click on the hamburger menu on the top left corner of the console and select VPC.

Create a custom VPC with the following details:

# https://www.ipaddressguide.com/cidr
name: loony-custom-vpc
subnet creation mode: custom

New subnet:

name: loony-custom-asia-east1-subnet
region: asia-east1
IP stack type: IPv4 (single-stack)
ipv4 range: 10.130.0.0/20


# Network Address: 10.130.0.0
# Subnet Mask: /20, which corresponds to 255.255.240.0 in dotted decimal notation.
# This subnet mask indicates that the first 20 bits of the IP address are fixed for network identification, and the remaining 12 bits are used for host addresses.

# IP Range: The range of IP addresses in this subnet goes from 10.130.0.0 to 10.130.15.255.


Click Secondary IP ranges and delete

Click Done

Click Create.
# Observe we havent given any firewall rules that is ok if we want we can add later.

Click on the newly created network

Show that we have only one subnet

##############################
### Provisioning a VM instance on custom mode VPC

# Go back to compute engine

Create a VM instance with the following details:

name: loony-vm-asia-east1
region: us-central1 (no subnet in this region)
zone: any
machine type: e2-micro

Click Advanced options -> Networking

network: loony-custom-vpc
subnet: 
# No subnets at this region
network service tier: Standard

Scroll up and set region as asia-east1
Scroll down and now check the subnet

Click Create.

--------------------

Click on SSH and observe the error.
# VM has a firewall rule that allows TCP ingress traffic from the IP range 35.235.240.0/20, port: 22

Open a new tab with VPC > loony-custom-vpc > Firewall

Click Add Firewall rule

name: loony-custom-allow-ssh
network: loony-custom-vpc
direction of traffic: Ingress
action on match: Allow
target: All instances in the network
source filter: IPv4 ranges
source IP ranges: 0.0.0.0/0
[TICK] specified protocols and ports > tcp: 22

Click Create.

Go back to the VM instance(loony-vm-asia-east1) and click on SSH.
# Observe you are able to SSH into the VM.

--------------------
# From your local machine

ping -c 4 <external-ip-of-loony-vm-us-central1>
# It works

ping -c 4 <external-ip-of-loony-vm-asia-east1>
# It fails


Go back to the VPC > loony-custom-vpc > Firewall

Delete the loony-custom-allow-ssh rule.

Create a new rule with the following details:
name: loony-custom-allow-ssh-icmp
network: loony-custom-vpc
direction of traffic: Ingress
action on match: Allow
target: All instances in the network
source filter: IPv4 ranges
source IP ranges: 0.0.0.0/0
[TICK] specified protocols and ports > tcp: 22
[TICK] specified protocols and ports > other > icmp

Click Create.


# Go to your local machine

ping -c 4 <external-ip-of-loony-vm-us-central1>
# It works

ping -c 4 <external-ip-of-loony-vm-asia-east1>
# It works

-------------------------------------------------

Go back to the VM instance(loony-vm-asia-east1) and click on SSH.

ping -c 4 <internal-ip-of-loony-vm-us-central1>
# It wont works as they are in different VPCs

SSH into the loony-vm-us-central1 instance.

ping -c 4 <internal-ip-of-loony-vm-asia-east1>
# It wont work as they are in different VPCs


