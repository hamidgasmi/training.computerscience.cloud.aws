# AWS:
## Infrastructure:

- [AWS Global Infrastructure](https://infrastructure.aws/)

<details>
<summary>Region</summary>

- It's a collection of data centers (AZs)
- It has 2 or more data centers (AZs)
- Regions AZs are independ from each other (to decrease failure likeliness)
- Regions AZs are close enough to each other so that latency is low between them
- Some regions are linked by a direct high speed network (see link above)
	- It isn't a public network 
	- E.g., Paris and Virginia regions are linked by a high speed network 
- Data created is a specific region wont leave the region 
	- Unless we decide otherwise (data replication to another region)
	- Regions allow to operate in a specific country where laws are known
	- We make sure that data will only operate under the jurisdiction of those laws 

</details>

<details>
<summary>Availability Zone (AZ)</summary>

- It's a logical data center within a region
- There could be more physical data centers within an AZ 
- Its name could be different from 1 aws account to another 

</details>

<details>
<summary>Edge Locations</summary>

- They're also called "Points of Presence" (Pops)
- They host CDN (Content Delivery Network)
- There're many more than regions

</details>
 
<details>
<summary>Regional Edge Caches</summary>

- It's a Larger version of Pops
- It has more capacity
- It can serve larger areas
- There're less of them

</details>

---

## Security: Identity and Access Control (IAM):

<details>
<summary>Description</summary>
</details>

---

## Compute - EC2 (Elastic Cloud Computing):

<details>
<summary>Description</summary>

- It provides sizable compute capacity in the cloud 
- It's a IaaS (Infrastructure as a Service) AWS Service 
- It takes 2mn to obtain and boot new server instances 
- It allows to quickly scale capacity both up and down as your computing requirement changes
- ARN:  
	- Format: arn:${Partition}:ec2:${Region}:${Account}:instance/${InstanceId}
    - E.g., arn:aws:ec2::191449997525:instance/1234j8r3kdj
- Use cases:
	- Monolothic application that require a traditional OS to work

</details>

<details>
<summary>Families, Types and, Sizes</summary>

- EC2 instances are grouped into families
- Each family is designed for a specific broad type workload
- A type determines a certain set of features
- A Size decides the level of workload a machine can cope with
- Families:
	- General Purpose:
		- A1: Arm-based machine
		- T2, T3: Low-cost instance types; occasional traffic bursts (Credits)
		- M4: 
		- M5, M5a, M5n: general workloads; 100% of resources at all times (24/7)
	- Compute Optimized:
		- C5, C5n, C4: Provides more capable CPU
	- Memory Optimized:
		- R5, R5a, R5n, R4: Optimize large amounts of fast memory 
		- X1e, X1: Optimize large amounts of fast memory 
		- High Memory, z1d
	- Storage Optimized: 
		- I3, I3en: Deliver fast I/O
		- D2, H1
	- Accelerated Computing:  
		- P3, P2: Deliver GPU
		- G4, G3: Deliver GPU
		- F1: delivers FPGA
- Instance name: Type + Generation # + [a] + [d] + [n] + ".Size"
	- Type letter + Generation #: see item above (families)
    - "a" if uses  AMD CPUs 
    - "d" if it is NVMe storage + 
    - "n" if it is Higher speed networking +
    - ".Size": "nano", "micro", "small", "medium", "large", "xlarge", "nxlarge" (n > 2) and, "large"
    - E.g.,: t2.micro, t2.2xlarge, t3a.nano, m5ad.4xlarhe 
- [For more details](https://aws.amazon.com/ec2/instance-types/) 

</details>
<details>
<summary>Instance Metadata</summary>

- It's available at: http://169.254.169.254/latest/meta-data/metadataName from within the EC2 instance itself 
- To get the list of all available metadata: #curl http://169.254.169.254/latest/meta-data/ 
- E.g., ami-id, instance-id, instance-type, local-ipv4, mac, public-ipv4, security-groups 
- [For more details](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) 

 

    
</details>
<details>
<summary>User Data</summary>

- It's available at: http://169.254.169.254/latest/user-data/ from within the EC2 instance 
- To get the list of all available metadata: #curl http://169.254.169.254/latest/user-data/ 
- [For more details](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) 


</details>
<details>
<summary>Bootstrap</summary>

- It is the process of providing "build" directives to an EC2 instance
- It uses user data and can take in 
	- Shell script-style commands: Power Shell for Windows or Bash for Linux  
	- [Cloud-init directives](https://cloudinit.readthedocs.io/en/latest/) 
- These commands or directives are executed during the instance launch process 
- User data can be used to run these commands or directives
- Actions could be involved: 
	- Configuring an existing application on an EC2 
	- Performing software installation on an EC2 
	- Configuring an EC2 instance 
	- Action that can't be involved: 
	- Configuring resource policies 
	- Creating an IAM User

</details>
<details>
<summary>Security: Instance Role</summary>

- It is a type of IAM Role that could be assumed by EC2 instance or application
- An application that is running within EC2, 
	- It isn't a valid AWS identity 
	- It can't therefore assume AWS Role directly
- They need to use an intermediary called  instance profile:  
	- It is a container for the role that is associated with an EC2 instance
	- It allows applications running on EC2 to assume a role and  
    - It allows application to access to temporary security credentials available in the instance metadata 
    - It is attached to an EC2 instance at launch process or after 
    - Its name is similar to the IAM role's one it is associated to 
    - It is created automatically when using the AWS console UI
    - Or it is created manually when using the CLI or Cloud Formation
- EC2 AWS CLI Credential Order:
	- (1) Command Line Options:
		- aws [command] —profile [profile name] 
		- This approach uses longer term credentials stored locally on the instance
		- It's NOT RECOMMENDED for production environments 
	- (2) Environment Variables: 
		- You can store values in the environment variables: AWS_ACCESS_KEY_ID, AWS_ACCESS_KEY, AWS_SESSION_TOKEN
		- It's recommended for temporary use in non-production environments 
	- (3) AWS CLI credentials file:
		- aws configure 
		- This command creates a credentials file 
		- Linux, macOS, Unix: it's stored at ~/.aws/credentials
		- Windows, it's store at: C:\Users\USERNAME\.aws\credentials
		- It can contain the credentials for the default profile and any named profiles 
		- This approach uses longer term credentials stored locally on the instance
		- It's NOT RECOMMENDED for producuon environments. 
	- (4) Container Credentials: 
		- IAM Roles associated with AWS Elastic Container Service (ECS) Task Definitions 
		- Temporary credentials are available to the Task's containers 
		- This is recommended for ECS environments 
	- (5) Instance Profile Credentials 
		- IAM Roles associated with Amazon Elastic Compute Cloud (EC2) instances via Instance Profiles 
		- Temporary credentials are available to the Instance
		- This is recommended for EC2 environments
- For more details:  
    - [User Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)
    - [...](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html)
	- [CLI Order of things](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

</details>
<details>
<summary>Encryption</summary>

- Volume encryption uses EC2 host hardware to encrypt data at rest and in transit between EBS and EC2 instance
- Encryption generates a Data Encryption Key (DEK) from a Customer Master Key (CMK) in each region
- When a volume is encrypted (or an instance is created), each volume is encrypted by a unique DEK 
- Snapshot, AMI and volumes created from these AMI or snapshots will use the same DEK
- AWS KMS encryption is supported by most instance types (any of the current modern instance generation, especially those that use the nitro platform)
- There are some older generation instances which don't support it, though!
- EC2 instance and OS see plaintext data as normal (no any encryption): 
    - Therefore, there is no performance impact
    - Encrypted DEKs stored with EBS volume are decrypted by KMS using a CMK
    - These decrypted DEKs (plaintext DEKs):
        - They're given to EC2 Host which stores them in its memory 
        - It uses them to decrypt data into EC2 instance or encrypt data from EC2 instance to EBS 
    	- When the instance is stopped/rebooted, the Host erases these plaintext DEKs
    - So, AWS KMS isn't encrypting neither it is decrypting data 
- When an encrypted EBS snapshot is copied into another region: 
    - A new CMK should be created in the destination region
    - The new snapshot will be encrypted
- Encryption from an OS perspective:
	- AWS KMS isn't enough for that
    - We need to use an OS level encryption available on most OS (Microsoft Windows, Linux) 
    - Only OS encryption will ensure that from an operating system perspective, the file's encrypted 
    - We're able to use both, though

</details>
<details>
<summary>Performance</summary>

EBS Optimization

- Performance of restoring a volume from a Snapshot: 
	- When we restore a volume from a snapshot, it doesn't immediately copy all that data to EBS 
	- Data is copied as it is requested 
    - So, we get the max performance of a the EBS volume, only when all that data has been copied across in the background 
    - Solution: to perform a read of every part of that volume in advance before it is moved into production  
    - To ensure that our restored volume always functions at peak capacity in production, we can force the immediate initialization of the entire volume using dd or fio 
    - For more details:
		- [EBS restoring volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-restoring-volume.html) 
    	- [EBS initialize](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-initialize.html)
- Enhanced Networking - SR-IOV: 
	- It stands for Single Root I/O volume 
    - Opposite to the traditional network virtualization that is using Multi-Root I/O Volume (MR-IOV) where a software-based hypervisor is managing virtual controllers of virtual machines to access one physical network card (slow) 
    - SR-IOV allows virtual devices (controllers) to be implemented in hardware (virtual functions) 
	- In other words, it allows a single physical network card to appear as multiple physical devices 
	- Each instance be given one of these (fake) physical devices 
    - This results in faster transfer rates, lower CPU usage, and lower consistent latency 
    - EC2 delivers this via the Elastic Network Adapter (ENA) or Intel 82599 Virtual Function (VF) interface 
    - [Fore more details](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking.html) 
- Enhanced Networking - Placement Groups: Good to increase Performance or Reliability 
	- Clustered Placement Group:  
		- Instances grouped within a single AZ 
        - It is good to increase performance 
		- It is recommended for application that need low network latency, high network throughput (or both) 
		- Only certain instances can be launched in to a clustered group 
		- Best practices:  
			- We should always try to launch all of the instances that go inside a placement group at the same time  
			- AWS recommends homogenous instances within cluster placement groups 
			- We might get a capacity issue when we ask to launch additional instances in an existing placement group
	- Spread Placement Group: 
		- It is good to increase availability
		- Instances are each individual placed on distinct underlying hardware (separate racks)
		- It is possible to have spread placement groups inside different AZ within one region
		- We can launch up to 7 instances into this placement group
		- So if a rack does go through and fail, it is only going to affect 1 instance
		- It is recommended for applications that have a small # of critical instances that should be kept separate from each other: email servers, Domain controllers, file servers
	- Partition Placement Group: 
        - It is good to increase availability for large infrastructure platforms where we want to have some visibility of where those instances are from a partition perspective 
        - Similar to spread placement group except there are multiple EC2 instances within a partition 
        - Each partition within a placement group has its own hardware (own set of racks) 
        - Each rack has its own network and power source 
        - A partition PL supports a maximum of 7 partitions per Availability Zone 
        - It allows to isolate the impact of hardware failure within our application 
        - We can use this to split those instances across all of those 7 partitions (we get visibility of that)  
        - If needed, we can even make it automated, if we give that information to our applications itself, it can have visibility over its infrastructure placement 
        - Multiple EC2 instances HDFS, HBase, and Cassandra 

</details>
<details>
<summary>Pricing Models</summary>

- On Demand: 
	- It allows to pay a fixed rate by second with a minimum of 60 seconds
    - No commitment and it is the default 
    - Use cases: 
        - Application with short term, spiky, or unpredictable workloads that can't be interrupted 
        - Application being developed or tested on Amazon EC2 for the 1st time 
- Spot: 
    - It enables to bid whatever price we want for instance capacity  
	- It is exactly like the stock market: it goes up and down (The price moves around) 
	- When Amazon have excess capacity (there're available EC2 servers capacity. Not used) 
	- Amazon drops then the price of their EC2 instances to try and get people to use that spare capacity 
	- The maximum price indicate the highest amount the customer is willing to pay for an EC2 instance 
	- We get the price that we want to bid at, 
    	- if it hits that price we have our instances  
    	- If it goes above that price then we're going to lose our instances within 2 minutes window 
    	- The default behavior is to automatically bid the current spot instance price  
    	- The price fluctuates, but will never exceed the normal on-demand rates for EC2 instances 
    	- Real examples: https://aws.amazon.com/ec2/spot/testimonials/ 
	- Use Cases: 
    	- Good for stateless parts of application (servers) 
    	- Good for workloads that can tolerate failures 
    	- Applications that have flexible start and end times 
    	- Applications that are only feasible at very low compute prices 
    	- Users with urgent computing needs for large amounts of additional capacity 
    	- Spot instances tend to be useful for dev/test workloads, or perhaps for adding extra computing power to large-scale data analytics projects 
		- Antipattern: spot isn't suitable for long-running workloads and require stability and can't tolerate interruptions 
    - Spot Fleet: 
        - It is a container for "capacity needs" 
    	- We can specify pools of instances of certain types/sizes aiming for a given "capacity" 
    	- A minimum percentage of on-demand can be set to ensure the fleet is always active 
- Reserved: 
	- Contract terms: 1 or 3 Year Terms 
    - Payment Option: No Upfront, Partial Upfront, All Upfront (max cost saving) 
    - It could be Zonal: The capacity is then reserved in the specific zone (capacity reservation). So if there capacity constraint on a zone, those with zonal reserved instances are prioritized 
    - It could be also on regional: The capacity isn't reserved in a particular region's zone? (more flexibility) 
    - It offers a significant discount on the hourly charge for an instance 
    - Use cases: 
    	- Long-running, understood, and consistent workloads 
        - Applications that require reserved capacity 
        - Users able to make upfront payments to reduce their total computing 
    - Standard Reserved Instance: 
        - Up to 75% off on demand instances 
        - The more we pay up front and the longer the contract, the greater the discount 
    - Convertible Reserved Instances: 
        - Up to 54% off on demand capacity to change the attributes of the RI as long as the exchange results in the creation of reserved instances of equal or greater value 
        - So it allows you to change between your different instance families 
        - E.g.: We have an EC2 R5 instance that is very high ram with Ram utilization; we would like to convert it to EC2 C5 instance that has very very good CPE use 
    - Scheduled Reserved Instances: 
    	- They're available to launch within the time windows we reserve (predictable: fraction of a day/week/month) 
        - E.g. 1: We run a school 
        - E.g. 2: We need to scale when everyone comes in at 9:00 on logs 
    - Capacity Priority: how AWS resolves capacity constraint: 
    	- Zonal Reserved instance are guaranteed to get the reserved instances on the zone 
    	- On Demand instances 
    	- Spot instances 

</details>
<details>
<summary>Dedicated Hosts</summary>

- Physical server dedicated for our use for a given type and size (Type and Size are inputs)  
- The number of instances that run on the host is fixed - depending on the type and size (see print screen below) 
- It can help reduce cost by allowing us to use our existing server-bound software licenses 
- It can be purchased On-Demand (hourly) 
- Could be purchased as a reservation for up to 70% off On-Demand price 
- Use Cases: 
	- Regulatory requirements that may not support multi-tenant virtualization 
	- Licensing which doesn't support multi-tenancy or cloud deployments 
	- We can control instance placement 

</details>
<details>
<summary>Virtualization</summary>

- Xen-based hypervisor: The Xen Project is a Linux Foundation Collaborative Project 
- The Nitro Hypervisor that is based on core KVM technology 
- Bare metal instances: With virtualization (High Memory Instance) 
- [For more details](http://www.brendangregg.com/blog/2017-11-29/aws-ec2-virtualization-2017.html) 

</details>

---

## Networking - VPC (Virtual Private Cloud):

<details>
<summary>Description</summary>
 
- It is a virtual network within AWS: it is our private data center inside AWS platform
- It can be configured to be public/private or a mixture
- It is isolated from other VPCs by default
	- It can't talk to anything outside itself unless we configure it otherwise
	- It's isolated from network blast radius
- It is Regional: it can't span regions
- It is highly available: it is on multiple AZs which allows a HA (Highly Available) architecture
- It can be connected to our data center and corporate networks: Hardware Virtual Private Network (VPN)
- It supports different Tenancy types: it could be:
	- Dedicated tenant: it can't be changed (Locked). It is expensive
	- multi-tenant (default): it still could be switched to a dedicated tenant

</details>

<details>
<summary>Architecture (UML notations)</summary>

![VPC Architecture with UML notations](https://awscertifiedsolutionsarchitectassociatedocs.s3.amazonaws.com/VPC_ArchitectureUML.PNG)

</details>

<details>
<summary>IPv4 CIDR</summary>

- It is from /28 (16 IPs) to /16 (65,536 IPs) 
- We need to plan in advance CIDR to support whatever service we will deploy in the VPC:
	- We need to make sure our CIDR will support enough subnets
	- We need to make sure our CIDR will let our subnets have enough IP addresses
	- Some AWS services require a minimum number of IP addresses before they can deploy
- We need to plan a CIDR that allows HA architecture:
	- We need to break our CIDR down based on the number of AZs we will be using and then 
	- We need to break down our CIDR based on the number of tiers (subnets) our VPC will have. E.g., public/private/db tiers
- We need to plan for future evolutions: additional AZs, additional tiers (subnets)
- Best Practice: ensure that VPCs we work with don't overlap CIDR blocks, whatever this is possible:
	- Lots of networking features don't like the same CIDR block
	- This will just make things a lot easier further down
	- Our corporate network VPCs, any other VPC we work with, 
	- VPCs of any partners and vendors that we interact with
- Best Practice: It is recommended to plan for our VPC in advance even though, we can now update VPC CIDR

</details>

<details>
<summary>Types</summary>

- Default VPC:
	- It is created by default in every region for each new AWS account (to make easy the onboarding process)
	- It is required for some services:
	 	- Historically some services failed if the default VPC didn't exist
	 	- It was initially not something we could create, but we could delete it
	 	- So if we delete, we could run into problems where certain services wouldn't launch,
	 	- We needed to create a ticket to get it recreated on our behalf
	 	- It is used as a default for most
	- Its initial state is as follow:
	 	- CIDR: default 172.31.0.0/16 (65,000 IP addresses)
	 	- Subnet: 1 "/20" public subnet by AZ
	 	- DHCP: Default AWS Account DHCP option set is attached
	 	- DNS Names: Enabled
	 	- DNS Resolution: Enabled
	 	- Internet Gateway: Included
	 	- Route table: Main route table routes traffic to local and Internet Gateway (see below)
	 	- NACL: Default NACL allows all inbound and outbound traffic (see below)
	 	- Security Group: Default SG allows all inbound traffic (see below)
	 	- ENI: Same ENI is used by all subnets and all security group
- Custom VPC (or "Bespoke"): 
	- it can be designed and configured in any valid way
	- Its initial state is as follow:
	 	- CIDR: initial configuration
	 	- Subnet: none
	 	- DHCP: Default AWS Account DHCP option set is attached
	 	- DNS Names: Disabled
	 	- DNS Resolution: Enabled
	 	- Internet Gateway: none
	 	- Route table: Main route table routes traffic to local (see below)
	 	- NACL: Default NACL allows all inbound and outbound traffic (see below)
	 	- Security Group: Default SG allows all inbound traffic from itself; allows all outbound traffic (see below)
	 	- ENI: none

</details>

<details>
<summary>DHCP Options Sets</summary>

- It stands for: Dynamic Host Configuration Protocol
- It's a configuration that sets various things that have provided to resources inside a VPC when they use DHCP
- It's a protocol that allows resources inside a network to auto configure their network card such as IP address
- It allows any instance in a VPC to point to the specified domain and DNS servers to resolve their domain names
- The default EC2 instance private DNS name is: ip-X-X-X-X.ec2.internal (Xs correspond to EC2 instance private IP digits)
- [More details](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html)

</details>

<details>
<summary>DNS</summary>

- It stands for: Domain Name System
- There're 2 features related to DNS: VPC DNS hostnames and DNS Resolution
- It allows to associate a public DNS name to a VPC public instance
- The default EC2 instance public DNS name is: ec2-X-X-X-X.compute-1.amazonaws.com (Xs correspond to EC2 instance public IP digits)
- Public DNS name resolution:
	- From outside EC2 instance VPC, it's resolved to the EC2 instance Public IP
	- From inside EC2 instance VPC, it's resolved to the EC2 instance Private IP
- Best Practice: Always enable VPC DNS hostnames and, VPC DNS resolution

</details>

<details>
<summary>Subnet</summary>

- Analogy: it is like a floor (or a component of it) in our data center
- Description: it is a part of a VPC
- Location: It is inside an AZ: subnets can't span AZs

- CIDR blocks:
	- It can't be bigger than CIDR blocks of the VPC it is attached to
	- It can't overlap with any CIDR blocks inside the VPC it is attached to
	- It can't be created outside of the CIDR of the VPC it is attached to
- 5 Reserved IPs:
	- Subnet's Network IP address: e.g., 10.0.0.0
	- Subnet's Router IP address ("+1"): Example: 10.0.0.1.
	- Subnet's DNS IP address ("+2"): E.g., 10.0.0.2
	 	- For VPCs with multiple CIDR blocks, the IP address of the DNS server is located in the primary CIDR
	 	- [For more details](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html#AmazonDNS)
	- Subnet's Future IP address ("+3"): e.g., 10.0.0.3
	- Subnet's Network Broadcast IP address ("Last"): E.g., 10.0.0.255
	- [For more details](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)

- Security and Sharing:
	- Share a subnet with Organizations or AWS accounts
	 	- Resources deployed to the subnet are owned by the account that deployed them: so we can't update them
	 	- The account we shared the subnet with can't update our subnet (what if there is a role that allow them so?)
	- A subnet is private by default
	- A subnet is Public if:
	 	- If it is configured to allocate public IP
	 	- If the VPC has an associated Internet Gateway
	 	- If it is attached to a route table with a default route to the Internet Gateway

- Type:
	- Default Subnet:
	 	- It is a subnet that is created automatically by AWS at the same time as a default VPC
	 	- It is public
	 	- There is as many default subnets as AZs of the region where the default VPC is created in
	- Custom Subnet: it is a subnet created by a customer in a costum VPC

- Limits:
	- Subnet max/min netmask: /16 ... /28 (same as VPC netmask limit)

- Associations:	
	- Subnet & VPC:
	 	- A subnet is attached to 1 VPC
	 	- A VPC can have 1 or more subnets: The number of subnets depends on VPC CIDR range and Subnets CIDR ranges 
	 	- If all subnets have the same CIDR prefix, the formula would be: 2^(Subnet CIDR Prefix - VPC CIDR Prefix)
	 	- For a VPC of /16, we could create: 1 single subnet of a /16 netmask; 2 subnets of /17; 4 subnets of /18; ... 256 subnets of /24
	- Subnet & Route Table:
	 	- A subnet must be associated with 1 and only 1 route table (main or custom)
	 	- When a subnet is created, it is associated by default to the VPC main route table
	- Subnet & NACL:
	 	- A subnet must be associated with 1 and only 1 NACL (default or custom)
	 	- When a subnet is created, it is associated by default to the VPC default NACL

</details>

<details>
<summary>Router</summary>

- It's a virtual routing device that is in each VPC
- It controls traffic entering the VPC (Internet Gateway, Peer Connection, Virtual Private Gateway, ...)
- It control traffic leaving the subnets 
- It has an interface in every subnet known as the "Subnet+1" address (is it the ENI?)
- It's fully managed by AWS
- It is highly available and scalable

</details>

<details>
<summary>Route table (RT)</summary>

- Description:
	- It controls what the VPC router does with subnet Outbound traffic	
	- It is a collection of Routes:
	 	- They're used when traffic from a subnet arrives at the VPC router
	 	- They contain a destination and a target 
		- Traffic is forwarded to the target if its destination matches the route's destination
	 	- Default Routes (0.0.0.0/0 IPv4 and ::/0 IPv6) could be added
	- Most Specific Route is always chosen:
	 	- It's when multiple routes' destination maches with traffic destination
	 	- A matched /32 destination route (a single IP address) will be always chosen first...
		- A matched /24 destination route will be chosen before a matched /16 destination route... 
		- The default route matches with all traffic destination but will be chosen last
	- A route Target can be: 
	 	- An IP @ or 
	 	- An AWS networking object: Egress-Only G., IGW, NAT G., Network Interface, Peering Connection, Transit G., Virtual Private G.,...

- Location: -

- Types:
	- Local Route:
		- Its (Destination, Target) = (VPC CIDR, Local)
		- It lets traffic be routed between subnets
		- It doesn't forward traffic to any target because the VPC router can handle it
		- It allows all subnets in a VPC to be able to talk to one another even if they're in different AZs
		- It's included in all route tables
		- It can't be deleted from its route table

	- Static Route: It's added manually to a route table
	- Propagated Route:
		- It's added dynamically to a route table by attaching a Virtual Private Gateway (VPG) to the VPC
		- We could then elect to propagate any route that it learned onto a particular route table 
		- It's a way that we can dynamically populate new routes that are learned by the VPG
		- Certain types of AWS networking products (VPN, Direct Connect) can dynamically learn routes using BGP (Border Gateway Protocol)
		- External networking products (a VPN or direct connect) that support BGP could be integrated with AWS VPC, they can dynamically generate Routes and insert them to a route table
		- We don't need then to do it manually by a static route table

	- Main Route table:
		- It's created by default at the same time as a VPC it is attached to
		- It's associated "implicitly" by default to all subnets in the VPC until they're explicitly associated to a custom one
		- In a default VPC: it routes outbound traffic to local and to outside (Internet Gateway)
		- In a custom VPC: It routes outbound traffic to local	
	- "Custom" route table: 
		- It could be created and customized to subnets' requirements
		- It is explicitly associated with subnets

- Limits: -

- Best Practice: 
	- It is recommended not to update the main route table
	- It is particularly recommended not to add the route to the Internet Gateway in the main route table: 
	- Since by default, all VPC's Subnets are associated "implicitly" to the main route table
	- All existing and future subnets could be public by default (if Public IP is enabled)		

- Associations:
	- A RT could be associated with multiple subnets
	- A subnet must be associated with 1 and only 1 route table (main or custom)

</details>

<details>
<summary>Internet Gateway</summary>

- It can route traffic for public IPs to and from the internet
- It is created and attached to a VPC
- A VPC could be attached to 1 and only 1 Internet Gateway
- It doesn't applies public IPv4 addresses to a resource's ENI
- It provides Static NAT (Network Address Translation):
	- It is the process of 1:1 translation where an internet gateway converts a private address to a public IP address
	- It make the instance a true public machine
	- When an Internet Gateway receives any traffic from an EC2 instance, if the EC2 has an allocated public IP: 
		- Then the Internet Gateway adjusts those traffic's packets (Layer 3 in OSI model)
		- It replaces the EC2 private IP in the packet source IP with the EC2 associated Public IP address
		- It sends then the packets through to the public Internet
	- When an Internet Gateway receives any traffic from the public internet,
		- It adjusts those packets as well,
		- It replaces the Public IP @ in the packet source IP with the associate EC2 private IP address
		- It sends then the packets to the EC2 instance through the VPC Router

</details>

<details>
<summary>NACL - Network Access Control Lists</summary>

- Description
	- It is a security feature that operates at Layer 4 of the OSI model (Transport Layer: TCP/UDP and below)
	- It impacts traffic crossing the boundary of a subnet
	- It doesn't impact traffic local to a subnet: Communications between 2 instances inside a subnet aren't impacted
	- It acts FIRST before Security Groups: if an IP is denied, it won't reach security group
	- It is stateless
	- It includes Rules:
		- There're 2 sets of rules: Inbound and Outbound rules
		- They're explicitly allow or deny traffic based on: traffic Type (protocol), Ports (or range), Source (or Destination)
		- Their Source (or Destination) could only be IP/CIDR
		- Their Source (or Destination) can't be an AWS objects (NACL is Layer 4 feature)
		- Each rule has a Rule #
		- They're processed in number of order, "Rule #": Lowest first
		- When a match is found, that action is taken and processing stops
		- The "*" rule is an implicit deny: It is processed last
	- Its rules include Ephemeral Ports:
		- When a client initiates communications with a server, it uses a well-known port # on that server: e.g., TCP/443
		- The response is from that well-known port to an ephemeral port on the client
		- The client decides the ephemeral port (e.g., TCP/22000): they're be thousands!
		- Because NACL are stateless and ephemeral ports are thousands, to manage the overhead of NACL rules is very high 
		- A single Communication involves 4 individual sets of rules:
		- We should think to "allow" traffic for every "ephemeral" ports on Client Inbound and Outbound rules and, 
		- We should think to "allow" traffic for every "ephemeral" ports on Destination Inbound and Outbound rules as well
	 
- Location: It isn't specific to any AZ

- Type:
	- Default NACL:
		- It is created by default at the same as the VPC it is attached to
		- It is associated "implicitly" to all subnets as long as they're not associated explicitly to a custom NACL 
		- It Allows ALL traffic: Rule 100: Allow everything
	- Custom NACL:
		- It is created by users
		- It should be associated "explicitly" to a subnet
		- It blocks ALL traffic, by default: it only includes "*" rule only

- Best Practice: 
	- Inbound and Outbound Rules # should use an increment of 100: 
		- 100 for the 1st IPv4 rule, 101 for the 1st IPv6 rule
		- 200 for the 2nd IPv4 rule, 201 for the 2nd IPv6 rule
	- Ensure that you place the DENY rules earlier in the table than the ALLOW rules that open the wide range of ephemeral ports

- Use cases:
	- Because of NACL management overhead (4 sets of rules for each communication), 
	- They tend not to be used all that much generally in production usage (Security Groups are preferred)
	- They're used when we have an explicit deny that we would like to add (E.g., an IP @ we were attacked from)
	
- Associations:	
	- It could be associated with multiples subnets
	- A subnet has to be associated with 1 NACL

</details>

<details>
<summary>SG - Security Group</summary>

- Description
	- It's a Software firewall that surrounds AWS products
	- It a Layer 5 firewall (session layer) in OSI model
	- It acts at the instance level, not the subnet level
	- It could be attached/detached from an EC2 instance at anytime
	- It is Stateful:
		- The response to an allowed inbound (or outbound) request, will be allowed to flow out (or in), regardless of outbound (or inbound) rules
		- If we send a request from our instance and it is allowed by the corresponding SG rule, its response is then allowed to flow in regardless of inbound rules
		- [More details (see Tracking)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#security-group-connection-tracking])
		- [Comparison between Security Group and ACL (stateless)](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Security.html#VPC_Security_Comparison])
	- SG Rules include: Inbound and Outbound rule sets:
		- Type: TCP
		- Protocol: e.g., HTTP, SSH
		- Port Ranges: e.g., Port 22 (SSH), Port 53 (UDP), Port 3060 (MySQL), Port 80 (http), Port 443 (https)... 
		- Source/Destination: Since it is a Layer 5 Firewall, it supports:
		- IP addresses, CIDRs (Layer 4 info)
		- a Security Group (Layer 5 info)
		- It can auto-reference itself in an Inbound rules' Source: 
		- It allows traffic from itself
		- All resources in the same SG are allowed to communicate to each other
	- Implicit Deny: Explicit Allow > Implicit Deny
		- There is no explicit denies
		- All rules are analyzed
		- If a rule matches, the request is allowed
		- If there is no match, the request is implicitly denied

- Types:
	- Default SG in a default VPC: 
		- It is created at the same time as a VPC
		- It allows all inbound and outbound traffic (open to the word)
	- Default SG in a custom VPC:	
		- It is created at the same time as a VPC 
		- It allows all inbound traffic from the same SG 
		- It allows all outbound traffic
	- Custom SG:
		- It is created by users in a default or custom VPC
		- It implicitly denies all inbound traffic: there isn't any inbound rule
		- It allows all outbound traffic

- Associations:
	- SG : VPC - * : 1 
		- It's associated with a single VPC: it doesn't span VPC's
		- A VPC could contain multiple SGs
	- SG : ENI - * : 1		
		- It is attached to 1 ENI
		- An ENI could be attached to multiple SGs		 
	- SG : EC2 Instance : * : *	
		- It could be assigned to multiple instances
		- It could be assigned to multiple instances in another AWS account within the same region (Peering Connection?) 
		- An EC2 instance could be attached to Multiple SGs

</details>

<details>
<summary>Bastion Host - JumpBox</summary>

- It is a host (EC2 instance) that sits at the perimeter of a VPC
- It is in a public Subnet 
- it usually involves access from untrusted networks or computers
- It functions as an entry point to the VPC for trusted admins
- It allows for updates or configuration tweaks remotely while allowing the VPC to stay private and protected (private subnets)
- It is generally connected to via SSH (Linux) or RDP (Windows)
- Its goal is to reduce the surface area in which we need to harden:
	- Instead to harden all private instances (we could have many of them),
	- We just need to harden 1 Bastion Host
	- Multifactor authentication, ID federation, and/or IP blocks
- How it works:
	- Traffic is going through the Internet gateway > route tables > NACL > Security Groups > Bastion host
	- Then the bastion host basically just forwards the connection through SSH/ADP to private instances
	- All what we need to do is harden our bastion host as strongly as possible because it is exposed to the public
	- Then, we don't have to worry about hardening our private instances in our private subnet
- Best Practice: 
	- Bastion hosts must be kept updated, and security hardened and, audited regularly
	- Multifactor authentication, ID federation, and/or IP blocks
	- It is recommended to add tags to be able to differentiate from other regular EC2 instances
	- Create a specific SG for bastion hosts:
		- Since bastion hosts require specific rules, we could make them in a unique SG
		- The SG could then be shared with bastion hosts only
		- It will allow to reduce bastion hosts creation overhead
	- SSH forwarding: it allows to connect to the private instance through the bastion host without leaving SSH keys within the bastion host
- For more details:
	- [SSH forwarding](https://aws.amazon.com/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/)
	- [A new way to securely connect to instances without having to use a bastion or open SSH ports](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)

</details>

<details>
<summary>NAT Instances & NAT Gateway</summary>

- It provides Dynamic NAT (Network Address Translation):
	- It is a variation of Static NAT (see Internet Gateway, above)
	- It allows many private IP addresses to get outgoing internet access using a smaller number of public IPs (generally one)
	- 1 public IP <-> many private IPs.
- Its purpose is to let EC2 instances in private subnets to go out and download software.
- Its benefits:
	- Security reasons: the concept of least privilege (if a resource doesn't need internet access, than we shouldn't give them access)
	- We're running out IP addresses: so we can't allocate a specific IP address for each instance
- How it works: let's have an example: 
	- A private EC2 instance which private IP is: 10.0.0.10
	- The EC2 instance requires to update its software for a public IP: 1.3.3.7
	- A NAT Gateway/Instance which Elastic IP is: 172.162.0.10
	- An Internet Gateway with a Public IP is: 53.12.23.11
	- Outgoing Traffic:
		- The EC2 L3 layer will create a packet (Src IP, Dest IP) = (10.0.0.10, 1.3.3.7)
		- The EC2 instance will send the packet to the NAT Gateway
		- The NAT Gateway will update the packet Src IP by its EIP: (Src IP, Dest IP) = (172.162.0.10, 1.3.3.7)
		- The NAT Gateway will then send the packet to the Internet Gateway
		- The Internet Gateway will also update the packet Src IP by its Public IP: (Src IP, Dest IP) = (53.12.23.11, 1.3.3.7)
		- The Internet Gateway will then send the packet to the Internet
	- Ingoing Traffic:
		- it is similar to the outgoing process above
		- In this case, the packet Destination IP is updated
		- It is updated 1st by the Internet Gateway with the NAT Gateway EIP
		- Then, it is updated by the NAT Gateway with the EC2 Private IP
- NAT Gateway: 
	- 1 NAT Gateway inside an AZ
	- It requires a Public Subnet and a Public Elastic IP
	- It understands and allow session traffic (layer 5)
	- It's scalable but isn't highly available by design (Redundant): if an AZ fails, all underlying NAT Gateway will fail
	- Best Practice: 
		- We need 1 NAT Gateway by AZ
		- We need a Single Route table for each AZ (each NAT Gateway)
		- Each NAT Gateway should be then associates with all private subnets of the related AZ
	- Performance: 
		- Initially 5GB of bandwidth 
		- It can scale to 45GB
		- For more bandwidth, we can distribute the workload by splitting our resources into multiple subnets inside an AZ
		- Then specify for each subnet to go to a separate gateway
- NAT Instance:
	- It is a single EC2 instance
	- It could be created from a specific AMI
	- it requires to Disable EC2 Source/Destination Checks:
		- Each EC2 instance performs source/destination checks by default
		- This means that the instance must be the source or destination of any traffic it sends or receives
		- However, a NAT instance must be able to send and receive traffic when the source or destination is not itself
		- Therefore, it is required tp disable source/destination checks on the NAT instance
	- Disadvantage: 
		- It is a single point of failure
		- If the instance is terminated, the route status: blackhole
	- Use cases: there is only one use case
		- When cost saving is absolutely required and, a NAT and bastion hosts are needed
		- We could then combine bastion host and NAT in the same machine
	- For more details: 
		- [NAT Instance](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html)
		- [NAT Gateway vs. NAT Instance](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html)

</details>

<details>
<summary>VPC Peering</summary>

- It allows communication between 2 VPCs via a direct network route using private IP addresses
- It can span AWS accounts and even regions (see limits below)
- It's involved at layer 3 of OSI model (network)
- It uses peering connection object: 
	- it's a network gateway
	- It's similar to Internet Gateway but used to link VPCs
	- Traffic goes through RTs, NACLs and, SGs. Therefore: 	
		- Routes are required at both sides
		- NACLs and SGs can be used to control access
		- SG reference is cross-account but it's not cross-region (see limits below)
	- DNS resolution to private IPs can be enabled, 
		- It is needed in both sides
		- Public DNSes will therefore be resolved to their private IP and,
		- It won't be traveling over the public Internet
- Data transit:
	- It is encrypted
	- It uses AWS global-backbone for VPC peering cross-region: low latency and higher performance than public internet
- Limits:
	- VPC CIDR blocks can't overlap
	- Transitive Peering is NOT Possible: 
		- A VPC can't talk to another VPC through a 3rd VPC
		- A Direct peering is required between 2 VPCs so that they can talk to each other
	- Cross-Region:
		- An SG can't be referenced from another region
		- IPv6 support isn't available cross-region
- Use cases:
	- To make a service that is running in a single VPC accessible to other VPCs
	- To connect our VPC to a vendor VPC or a partner VPC to access an application
	- To give access to our VPCs for security audit
	- We have a requirement to split an application up into multiple isolated network to limit the blast raduis in the event of network based attacks

</details>

<details>
<summary>VPC EndPoint</summary>

- It is a virtual gateway object created in a VPC
- It provides a method of connecting to public AWS services: 
	- Its related traffic doesn't leave AWS network
	- It doesn't require a public IP address, 
	- It doesn't require an Internet gateway, 
	- It doesn't require any other resource: a NAT device, a VPN connection nor, an AWS Direct Connect connection instances
- It is horizontally scaled (bandwidth)
- There're 2 types of VPC endpoints:
	- Gateway endpoint: 
		- It is used for S3 buckets and DynamoDB
		- It is similar to Internet Gateway
		- Its related traffic goes through RT: (Destination, Target) = (AWS Service Prefix Lists, Gateway Endpoint ID)
		- Prefix Lists are more specific than general public internet (0.0.0.0/0)
		- Therefore, Prefix Lists will override the use of the IG when they're in the same RT
		- It can be restricted via policies: full access is selected by default
		- It is HA (Highly available) across AZs in a region: 1 Gateway endpoint by VPC
	- Interface endpoint:
		- It is used for most other AWS services such as SNS, SQS
		- It is an ENI with a private IP address
		- It provides another unique endpoint for the selected service (different from the service public endpoint)
		- It is attached to a subnet
		- For HA, it should be associated with multiple AZs
		- Its related traffic goes through SGs and NACLs
		- It doesn't require a RT: it adds or replaces the DNS for the service
		- It provides multiple DNS names: 1 per selected subnet + 1 general DNS name (not specific for an AZ)
		- It replaces the default service public DNS when "Private DNS Names" feature is enabled
		- [For more details about AWS Services endpoint](https://docs.aws.amazon.com/general/latest/gr/rande.html)

- Limits:
	- Gateway endpoints are used via route
- Use cases:
	- An entire VPC is private without an Internet Gateway
	- A specific private instance needs to access public services
	- To access resources restricted to specific VPCs or endpoints (private S3 buckets)
- [For more details about Interface endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html)

</details>

<details>
<summary>IPv6</summary>

- VPC IPv6:
	- It is currently opt-in (disabled by default)
	- It is enabled from VPC -> Edit CIDR feature
	- It's a /56 CIDR allocated from AWS pool
	- It can't be adjusted
- Subnet IPv6:
	- It is a /64 CIDR
	- It can be chosen from the VPC /56 range
	- It is enabled from subnet -> Edit CIDR feature
- It is publicly routable: 
	- There is no concept of Private IPv6 address
	- There is no concept of Elastic IPs with IPv6
	- IG doesn't do static NATs for IPv6
	- IG is routing from VPC to the public Internet
	- RT can contain IPv6 routes
	- IPv6 default route is: "::/0"
- It should also be configured in NACL and SG
- To use it:
	- Enable it for VPC
	- Enable it for a subnet
	- Add IPv6 routes in subnet's RT (particularly ::/0)
	- Make sure corresponding NACL allows traffic with IPv6
	- Make sure corresponding SGs allow traffic with IPv6
- DHCP6:
	- It let resources of subnets with IPv6 range configure a public IPv6 address
	- The OS is configured with the public IPv6
- DNS Name:
	- It isn't allocated to IPv6 addresses
- Limits:
	- It isn't currently supported across every AWS product 
	- It isn't currently supported with every feature
	- It isn't currently supported by VPNs, customer gateways, and VPC endpoints
	- [For more details]()

</details>

<details>
<summary>Egress-Only Gateway</summary>

- It provides instances with outgoing access to the public internet using IPv6 and,
- It prevents them from being accessed from the internet (or outside VPC?)
- It allows outbound and inbound response traffic
- Analogy: 
	- it is similar to NAT Gateway but
	- it doesn't provide Dynamic NAT since it isn't relevent with IPv6
	- NAT Gateway doesn't support IPv6

</details>

<details>
<summary>Flow Logs</summary>

</details>

<details>
<summary>Load Balancers</summary>

</details>

<details>
<summary>Limits</summary>


</details>

<details>
<summary>Conventions</summary>

- Subnet Name: sn-[public/private]-[AZ]: sn-public-a; sn-private-a
- Subnet range: 
	- In some cases, humans do need to understand the networking structure that we use inside a VPC
	- So, we could match a subnet's CIDR to its AZ and its application tear:
	- E.g., for a VPC 10.0.0.0/16 with Subnets: /24 + 2 AZs + 3 tiers:
		- For AZ1: (Tier 1, 10.0.11.0); (Tier 2: 10.0.21.0); (Tier 3: 10.0.31.0)
		- For AZ2: (Tier 1, 10.0.12.0); (Tier 2: 10.0.22.0); (Tier 3: 10.0.32.0)
- Peering Connection name: pc-[Requester VPC name]-[Accepter VPC name]. E.g., pc-VPC1-VPC2

</details>

---

## Networking - Route 53:

<details>
<summary>Description</summary>
 
- It is AWS Domain Registrar and DNS service

</details>

<details>
<summary>Domain Registrar</summary>

- It checks a domain is available: it is done against the database of the TLD or the subdomain operator
- It allows to register a domain: 
	- It contacts then the TLD to add a record into the corresponding zone (the registration is "Pending")
	- It publishes All or Some Registrant Contact details in the public WHOIS database
	- It stores Registrant Contact, Administrative Contact and, Technical Contact details in the domain record
	- It allow to renew the domain automatically 
- It allows to host a domain: It gives the rights to specify name servers (NS) to be authoritative for our domains
- It allows to register and host a domain, register only or host only a domain
- It allows to add records (www, ftp, mail…) into the name servers (NS) zone files

</details>

<details>
<summary>DNS Service</summary>

- Hosted Zone:
	- It corresponds to a domain name
	- It is a collection of records (see below)
	- It supports public and private hosted zones:
- Public Zone:
	- It is created by default when a domain is registered/transfered with Route 53
	- It is also created when we create a domain manually (how could it be done?) 
	- It has the same name as the domain it relates to: It is FQDN (Fully Qualified Domain Name)
	- It is accessible globally since the TLD zone delegates to its name servers
	- It is accessible either from internet-based DNS clients or from within any AWS VPC 
	- It has an NS record that is given to the corresponding domain operator (Route 53 becomes then "Authoritative") 
- Private Zone:
	- It is created manually and associated with one or more VPCs
	- It is accessible from VPCs it is associated with 
	- It needs "enableDnsHostname" and "enbaleDnsSupport" enabled on a VPC 
	- Not all Route 53 features supported (limits on health checks)
- Split-view: 
	- It allows to have 2 different websites with the same domain name:
		- One website is available on the public Internet and 
		- a different website available on a private network
	- How it works:
		- Create a public zone for a domain name 
		- Create a private zone with the same zone name and with specific VPCs
		- The private zone will then override the public zone within the specificied VPCs
		- It the private zone doesn't have any record, the private zone doesn't then override the public zone
	- Use cases:
		- We have 2 versions of an application. The internal version may contain additional information or features for administration
		- We have a new version of an applicaiton. We would like to test it without distrupting the public version
- Zone's Records:
	- NS Record has the server names that are authoritative for a subdomain
	- SOA Record (Start of Authority Records)
	- A Record provodes an IPv4 address for a given host (www)
	- AAAA record provodes an IPv6 address for a given host (www)
	- CNAME record (Canonical Name):
		- It allows to resolve one domain name to another
		- It cannot be used at the APEX (top) of a domain
		- E.g. 1, add Cnames for mobile.example.com that is pointing m.example.com server
		- It could reference an original record (A or AAAA) instead of an explicit IP address 
		- E.g. 2, add a CNames (www, ftp, vpn) for example.com:
		- www.example.com; ftp.example.com; vpn.example.com
		- All CNames could reference the original A record (example.com)
		- If the original record IP address changes, there's no impact on CName records
		- We can reference names that are outside our domain with FQDN (the last . is required "anotherexample.com.")
	- Alias record type:
		- It is a Route 53 specific feature
		- It is an extension of CNames
		- It can be used at the APEX of a domain (for naked domain names)
		- It can refer to AWS logical services (LBs, S3 buckets)
		- It allows to specify a hostname in our DNS records which then resolve to the correct A/AAAA records at the time of a request
		- AWS doesn't charge for alias records against AWS resources
		- It is recommended by AWS
	- MX record:
		- It is quired whenever a server is attempting to send an email to a given domain
		- It provides the email servers for a given domain
		- Eeach server within MX record has a priority value
		- The lower priority value is preferred
	- TXT record:
		- It's used to store plain text inside a domain
		- It's often used to verify domain ownership:
		- If we are adding a domain to Gmail or Office 365, 
		- They'll probably ask to add a text record to the domain with some random text that they're aware of
		- They can then perform a resolution on that text record against the text of that "TXT record"
		- If it matches, it guarantees that we own that domain.
		- It can be used in spam filtering
	- VPC DNS Resolver ?

</details>

<details>
<summary>Health Check</summary>

- It can be created within Route 53
- It's used to influence Route 53 routing decisions:
	- Records can be linked to health checks
	- If the check is unhealthy, the record isn't used
	- It can be used to do failover and other routing architecture (see Routing policies, below)
- Its status are: Unknown (1st status), Health, Unhealthy
- Endpoint Check:
	- It checks the physical health of an endpoint
	- It species an endpoint by IP address or a domain name (usefull when we have a domain name which IP address changes often)
	- It is impacted by resources security features (SG, NACL)
	- It occurs every 30 seconds (default) or every 10s
	- It has a failure threshold: if x checks are unhealthy, then the healthcheck is unhealthy
	- E.g., If the check occurs every 30s and the failure threshold is 3, then Route 53 will be able react for a fealure only after 90s (long time) 
	- Each endpoint check corresponds actually to multiple healthchecks that are done by Health Checkers (a global health check system)
	- Endpoint Check aggregates the data from the health checkers and determines whether the endpoint is healthy:
		- If more than 18% of health checkers report that an endpoint is healthy, Route 53 considers it healthy
		- If 18% of health checkers or fewer report that an endpoint is healthy, Route 53 considers it unhealthy.
	- Health Checkers evaluation is based on the Response time which depends on the type of health check:
		- For HTTP/S healthchecks: 4s to establish a TCP connection with the endpoint + an HTTP status code of 2xx or 3xx within 2 seconds after connecting
		- For a TCP healthchecks: 10s to establish a TCP connection with the endpoint
		- For HTTP/S with string matching: All the checks as with HTTP/S but the body is checked for a string match
	- Endpoint Check other Options are:
		- TCP options includes
		- IP @ (for TCP and HTTP/S)
		- Hostname (for HTTP/S): it's useful if we have multiple websites under the same IP (the same server); we could create then 1 healthcheck/website
		- Port (for TCP and HTTP/S):
		- Path (for HTTP/S)
		- Latency graphs: ?
		- Invert health check status: 
		- Health checker regions:
	- [More details](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-determining-health-of-endpoints.html#dns-failover-determining-health-of-endpoints-monitor-endpoint) 
- Calculated healthcheck:
	- It monitors the health of multiple healthchecks
	- We could select how many sub-healthcheck should be healthy to make the calculated health check healthy
	- Usefull particularly when we have got lots of different services/components of our system 
	- We created an individual healthcheck for each of them
	- It summarizes the health of all these individual components 
	- E.g., We have a front-end tier, a logic tier and, a database tier, 
	- Each tier has a healthcheck
	- Whe can then create a calculated healthcheck that will check the status of these individual checks to report the whole system healthy. 
- CloudWatch alrams health checks:
	- They monitor CloudWatch alarms
	- e.g., we may want to consider something unhealthy if a DynamoDB table is experiencing performance issues
- Best Practice:
</details>

<details>
<summary>Routing Policies</summary> 
- Simple Routing policy:
	- It's a single record with multiple values a hosted zone (Error for a new 2nd record with the same type and domain name)
	- It can contain multiple values (IP addresses) or
	- It can also contain a single AWS resource as an alias type record (1 LB, 1 S3 Bucket Endpoint, 1 VPC Endpoint...)
	- It returns to a DNS query all the values in a random order (the client can select the appropriate one)
	- It doesn't support Health check isn't possible
	- Pros:
		- Simple as a starting point for our DNS architecture: Good when we're not aware of how our traffic patterns are
		- Simple with a somewhat even spread of requests (TTL is very important here to avoid the issue below)
	- Cons:
		- No performance control (It isn't a LB architecture): if a big organization caches an IP @, all its users will query a single IP
		- No healthcheck: if a resource behind an IP @ fail, it will continue sending requests to it
- Failover Routing policy: 
	- It enhances "Simple Routing" policy
	- It's a single Primary record + a single Secondary record with the same name
	- It (primary and second records) can contain multiple values (IP addresses) or a single AWS resource as an alias type record
	- They support healthcheck (calculated healthchecks if primary record contains multiple values?)
	- Queries will resolve to the primary unless it is unhealthy:
	- Queries will resolve to the secondary if the primary is unhealthy
	- The secondary records cold provide emergency resources during failures:
		- E.g., an S3 static website that presents a maintenance page 
		- with usefull information: Failure status, contact details
	- It can be conbined with other routing policies to allow multiple primary and secondary reconrds

- Multivalue Answer Routing policy: 
	- It's multiple records with the same name
	- Its records can contain 1 value only (IP address or AWS product)
	- it supports healthcheck
	- It responds to DNS queries with up to 8 random healthy records
- Weighted Routing: 
	- It's multiple records with the same name
	- Its records have a weight and a unique Set ID
	- It allows to split traffic based on different weights assigned
	- It can be used to control the amount of traffic that reaches specific resources:
		- To test new software/products/ AB Testing?
		- When resources are being added or removed from a configuration that doesn't use a LB
		- No performance or loading control (It isn't a LB architecture)
	- We can attach a health check to a record so that Route 53 can omit the record as long as the associated EC2 instance isn't healthy 
	- E.g., we can set 10% of our traffic to go to US-EAST-1 and 90% to go to EU-WEST-1 
	- The weight is a value. It isn't a % 
	- So, if we add to address with the following weights: 20 and 30 => the corresponding % will be: 40% and 60% 
- Latency-based Routing policy: 
	- It's multiple records with the same name: they're considered part of the same latency-based set (if the name is different, they're not)
	- Its records are allocated to a unique region and have a unique Set ID
	- It consults a latency database (DNS Resolver location - Policy Region - Latency) when a request occurs from a resolver server
	- It returns the record set with the lowest network latency to the resolver server (end-user)
	- The latency calculation is NOT made between customer's resolver server location and our resource location!
	- It isn't related to geography but to network condition instead 
	- We can attach a health check to a record
- Geolocation Routing policy:
	- It's multiple records with the same name
	- It lets to choose the resources that server traffic based on the geographic region from which queries originate 
	- Its records are configured for:
		- a Country: the lowest abstration level 
		- a Continent:
		- Default: the highest abstration level (while planete)
	- Its IP matching process is:
		- A record set is used for queries originated from its region
		- When multiple regions match a query region, the record set with the lowest abstraction level is returned
	  	- If this process fails, the default record set is returned (if it exists) 
		- If no record set is configured for the originating query region, the default record set is returned (if it exists)
		- If matching record set health check fails, it is then excluded in this process
		- If there is no record matching and there is no default record, then "No answer" is returned 
	- E.g. 1, a website like Netflix: its content is based on their customer' country
	- E.g. 2, we might want all queries from Europe (/US) to be routed to a fleet of EC2 instances:
		- They're specifically configured for our European (US) customers 
		- They may have the local language (English, Spanish, Chinese) of our European (US) customers
		- They may display all prices in Euros ($)
		- We could set US record set as a default, canadien customers will be then redirected to the US EC2 fleet
- Geoproximity Routing (Traffic Flow Only): 
	- To use Geoproximity routing, it is required to use Route 53 traffic flow 
	- Traffic flow is: ?
	- Geoproximity Routing lets Route 53 routes traffic to our resources based on the geographic location of our users and our resources 
	- We can also optionally choose to route more or less traffic to a given resource by specifying a value, known as a bias 
	- A bias expands or shrinks the size of the geographic region from which traffic is routed to a resource 

</details>

<details>
<summary>Limits</summary>
</details>

<details>
<summary>Conventions</summary>

- Healthcheck name: same as the corresponding domain name
- Failover Routing recommendation: TTL <= 60 to let client respond quickly to changes in health status

</details>

---

## Storage - S3 (Simple Storage Service):

<details>
<summary>Description</summary>

- It's a secure, durable, highly scalable objects storage
- Objects are organized into Buckets
- An object is: 
	- Object key: object name 
	- Value: object data 
	- Version ID: it is possible to do version control
	- Object Metadata: expires, content-type, cache
	- Subresources:
		- ACLs: see permission below 
		- Torrents:
- A folder could be created within a bucket:
	- It's not an actual object
	- It's added as a prefix into the underlying objects' key
- It's a universal namespace:  
	- A bucket name must be unique globally
	- Its URL format is: https://region.amazonaws.com/bucketname
	- E.g., https://selfservedweb.s3.amazonaws.com/Web_Scalability_for_StartupEngineers.pdf
- ARN:  
	- Format: arn:partition:service:region:account: 
    - E.g., arn:aws:cloudfront::191449997525:?

</details>
 
<details>
<summary>Uploads</summary>

- It's done using the S3 console, the CLI, or APIs
- It uses a single operation (Single PUT upload) or multipart upload
- A successfull upload will return an HTTP 200 code
- Single PUT Upload:
	- An object is uploaded in a single stream of data
	- Limit of 5 GB/PUT 
	- It can cause performance issues 
	- If the upload falls the whole upload falls 
- Multipart Upload:
	- An object is broken up into parts (up to 10,000)
	- All parts are upluded in parallel
	- All parts are merged once they're all uploaded
	- Each part is 5MB to 5GB, except the last part which can be less
	- It's faster
	- If an individual part upload falls, 
		- It won't impact the whole upload 
		- It will be retried individually
	- It's recommended for anything over 100 MB
	- It's required for anything beyond 5 GB
	- It's not possible via the console:
		- CLI: aws s3 cp myFile S3://MyBucket/
		- API?

</details>

<details>
<summary>Static Websites</summary>

- A bucket can be configured to host a website:
	- Content should be uploaded to the bucket:
	- "Static web hosting" feature should be enabled
- It can host many types of content: HTML, CSS, JavaScript, Media (audio, movies and, images)
- It can host front-end code for serverless application or 
- It can be an offload location for static content: 
	- Instead storing media on a web server, 
	- We could store it on S3 and 
	- Direct the Web server to point S3
- It can host custom domains:
	- Create a bucket with an acual DNS name
	- Create a record in Route 53 that points at the bucket (Alias)
- It can redirect requests:
	- We can specify a full set of redirection rules 
	- It can redirect requests for an object to another object in the same bucket or to an external URL
- CloudFront can also be added as a CDN for global users
- SSL can be added for custom domains
- CORS:
	- Cross-Origin Resource Sharing
	- It's a way a web server can relax the [same-origin policy](https://en.wikipedia.org/wiki/Same-origin_policy)
	- It allows a web server running in one domain to reference resources in another
	- This particularly helpful: each S3 bucket (and even AWS product) has its own domain name
	- [For more details](https://docs.aws.amazon.com/AmazonS3/latest/dev/cors.html)

</details>

<details>
<summary>Versioning</summary>

- It allows multiple versions of an object to exist in an S3 bucket
- It's disabled by default
- It requires to be enabled at a bucket level
- Once it's enabled, 
	- It can never switched off (only suspended)
	- It add a new feature on the console to Hide or Show the older versions
	- Any modification operation on an object,
		- It generates a new version of the object with a new Version-ID
		- It hides the older version  
	- A delete operation on an object doesn't delete it:
		- It generates a new version of the object marked as deleted ("Delete" marker)
		- It can be undone: if the "Delete" marked version is deleted
	- Older versions of an object are still accessible by using the object name and a version ID
	- To delete physically an object, all versions must be selected and deleted
- AWS accounts are billed for all versions:
	- Be careful, the bucked size could get very big 
	- Previous versions aren't deleted!
- MFA Delete: 
	- It's a feature designed to prevent accidental deletion of objects
	- Once enabled, a one-time password is required:
		- To delete an object version or 
		- To change the versioning state of a bucket
	- Versioning is required
- For more details:
	- [Deleting Object Versions](https://docs.aws.amazon.com/AmazonS3/latest/dev/DeletingObjectVersions.html)
    - [Using MFA Delete](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMFADelete.html)

</details>

<details>
<summary>Presigned URL</summary>

- It's created by an identity to let someone else (a bearer) access to a private object on a temporary basis
- Its creator is an IAM Identity: User, Group, Role
- The bearer of the URL gets the same level of authorization as the creator
- It's encoded with authentication built in
- It has an expiry time: 7 days maximum
- When It's used, 
	- AWS verifies the creator's access to the object
	- AWS doesn't verifies the bearer access to the object
- It can be created even on objects the creator doesn't have access to
- The bearer lose access when:
	- The presigned URL has expired (7 days max)
	- The creator permissions have changed
	- The URL was created using a role and its temporary credentials have expired (36-hour max)
- Use cases:
	- Stock images website:
		- Media stored privately on S3
		- Presigned URL generated when an image is purchased
	- Client access to upload an image for process to an S3 bucket
- Best Practices:
	- Create presigned URLs with an identity with long term credentials 
	- Avoid creating presigned URLs with roles

</details>

<details>
<summary>Storage Tier/Class</summary>

- It influences for objects in S3:
	- The durability (Fault Tolerance?):
		- It refers to long-term objects protection 
		- How it can operate through a failure with no user impact
		- How well objects are protected from loss or any compromises
		- It's concerned with object redundancy
	- The availability: 
		- It refers to system uptime
		- How quick a system can recover in the event of a failure
		- The storage system is operational and can deliver data upon request
	- The "1st byte latency" 
		- It's the amount of time that passes between: 
		- The time a request to get an object is made and 
		- The time its 1st byte is received
	- The cost:
		- Storage Size fee: per GB used with a Minimum Capacity charge
		- Storage Duration fee: with a Minumum Storage duration charge
		- Data Transfer fee (Retrieval Fee) per GB
		- Requests type: PUT, COPY, POST, or LIST Requests / GET, SELECT
		- Requests type #: nbr of requests by type
		- Minimu capacity doesn't mean that we can't upload a file less than the minimum size
		- Minimum duration doesn't mean neither that we can't delete an object before the minimum duration 
		- They only mean that we'll be billed for a minimum size and a minimum period of time
- It is setup at object level
	- Initially: during the upload process or
	- Once the object is loaded, it can be Changed manually or by Lifecycle policies
- ![S3 Tiers/Classes](https://awscertifiedsolutionsarchitectassociatedocs.s3.amazonaws.com/S3_StorageClasses.png)
- S3 Standard:
	- It's the default class
	- Use cases:
		- All purpose storage
		- We don't have any specific requirements or 
		- We don't know the usage of the object
- S3 IA (Infrequently Access): 
	- Same as S3 Standard (Designed for durability, Designed for availability, +3 AZ Replication and, 1st byte latency - rapid access)
	- but it's for data that is accessed infrequently
    - Storage Size fee: Lower than S3 standard
    - But we're charged:
		- A retrieval fee
		- Minimum capacity charge per object: billet at least for 128K / object
		- Minimum duration charge per object: billed at least for 30 days / object
- S3 One-Zone - IA (Infrequently Access):
    - Lower-cost option accessed data
	- Use cases:
		- For Cross Region Replications: 
			- The data is stored somewhere else 
			- A replication isn't the main location, 
			- So the "standard" durability isn't needed here
		- Output of data processes:
			- If the data is lost, the process can be run again and the output can be reproduced
			- This's particularly true, when the process is quick
			- What if the process to get the output data is long?
		- Non important data (non mission critical data) 
	- Use cases: ?
- S3 RRS - Reduced Redundancy Storage 
	- It is obsolete (not recommended)
	- Durability Design: 4 nines (99.99%)
	- Durability SLA: ?
	- Availability Design: 4 nines (99.99%)
	- Availability SLA: N/A
	- AZ: >= 3
	- Concurrent facility fault tolerance: 1
    - "1st byte latency" SLA: milliseconds
	- Use cases: ?
- S3 - Glacier: 
	- It's a storage class for data archiving
	- It's an archival storage on a file system or disk back ups in a traditional backup system
	- We're charged:
		- A retrieval fee
		- Bigger Minimum capacity charge per object
		- longer Minimum duration charge per object
	- Use cases: file system or disk back ups
- S3 - Glacier Deep Archive: 
    - It's for long-term archival
	- It is like tape storage
	- It's S3 lowest-cost storage class
	- We're charged: 
		- A retrieval fee
		- Biggest Minimum capacity charge per object
		- longest Minimum duration charge per object
	- Use cases: Cold backups
- S3 - Intelligent Tiering: 
	- It moves objects automatically between 2 tiers:
		- An Object that isn't accessed for 30 days is moved to IA tier
		- If it's accessed, it's then moved back to frequent access tier
	- Cost:
		- No cost when data is moved from a tier to another one
		- Automation and Monitoring fee: monthly
	- Use cases:
		- We don't known access patterns or it's unpredictable
		- We don't want admin overhead
- For more details: 
	- [Data Availability vs. Durability](https://blog.westerndigital.com/data-availability-vs-durability/)
	- [Classes]
		- [Blog post](https://medium.com/@davidoh0905/aws-s3-solutions-architect-exam-s3-availability-and-durability-96700c1c6d8c)
		- [AWS documentation](https://aws.amazon.com/s3/storage-classes/)
	- In AWS Certification exams: 
		- It seems like answers should be based on ‘designed for’ durability/availability (unless the question specifies otherwise)

</details>

<details>
<summary>Lifecycle Management</summary>

- It's done at Bucket level
- It's done by creating Life Cycle rules
- Rules could be applied on objects with specific tags
- Transition rules:
	- They're to automate moving objects from one tier to another
	- They could be applied on current version and/or older ones
- Expiration rules: 
	- They're to automate expiring of objects that are no longer required
	- They could be applied on current version and/or older ones
	- Current versions could be expired
	- Previous versions could be permanently deleted (physically)
	- Clean up expired object delete markers (You cannot enable clean up expired object delete markers if you enable Expiration)
	- Clean up incomplete multipart uploads
- Possible transitions:
	- From Standard Tier to:
		- Standard IA
		- Intelligent Tiering
		- One-Zone IA
		- Glacier
	- From Standard IA Tier to:
		- Intelligent Tiering
		- One-Zone IA
		- Glacier
	- From Intelligent Tiering to
		- One-Zone IA
		- Glacier
	- From One-Zone IA Tier to Glacier 
- Cost:
	- Data transfer fee when data is moved from a tier to another one
	- Automation and Monitoring fee?
- Use cases: Reduce admin overhead

</details>

<details>
<summary>Cross-Region Replication (CRR)</summary>

- It's an S3 feature that can be enabled on S3 buckets
- It allows a one-way replication of data from a source bucket to a destination bucket in another region
- It is a set of rules:
	- They could be applied on the entire source bucket objects
	- They could also be applied on a part of source bucket objects (based on prefixes and/or tags)
	- They could be overlapping
	- They've a priority value to resolve conflicts that occur when an object is eligible for replication under multiple rules 
	- A higher value indicates a higher priority
- It requires:
	- Versionning feature to be enabled on both buckets (src. and dest.)
	- to allocate an IAM role with permissions to let S3 replicates objects
- By default, replicated objects keep their:
	- Storage class
	- Object name (key)
	- Owner
	- Object permission
- Override is possible for:
	- Storage class,
	- Storage ownership (select a different aws account)
	- Object permission at the destination bucket
- Exclusion, the following are excluded from Replication:
	- System actions (lifecycle events aren't replicated)
	- SSE-C encrypted objects - only SSE-S3 an KMS (if enabled) encrypted objects are supported
	- Any existing objects from before replication is enabled (replication isn't retroactive)
	- "Mark Delete" objects: it doesn't replicat deletions
- The replication is using SSL protocol?
- Use cases:
    - Compliancy of data and making sure data is kept in a dedicated region (for example for GDPR compliance)
	- See Scalability, Resilience and DR sections

</details>

<details>
<summary>Scalability</summary>

- CRR minimizes latency for global applications by creating Performance Replicas

</details>

<details>
<summary>Consistency</summary>

- Read after write consistency for PUTS of new objects: a new object is ready to read as soon as it is uploaded
- Eventual Consistency for overwrite PUTS and DELETE: update and deletes may need some time to propagate

</details>

<details>
<summary>Resilience</summary>

- CRR cloud be used to create Resilience Replicas

</details>


<details>
<summary>Disaster Recovery</summary>

- CRR could be used as Disaster Recovery solution that provides a low [RPO (Recovery Point Objective)](https://en.wikipedia.org/wiki/Disaster_recovery)
- S3 RTC (Replication Time Control) could be combined with CRR: 99.99% of replications happens <= 15 minutes

</details>

<details>
<summary>Security(Permission)</summary>

- The only entity that initially has access to a booket is the account that creates it (the root account)
- The bucket by default isn't public (it doesn't trust any other aws account; it doesn allow public access)
- Bucket authorization is controlled using:
	- IAM Identity policies for known principals
		- It's added to IAM Identities (Users, Groups, Roles)
		- It can include S3 elements
		- It only works for identities in the same account as the bucket
	- Bucket policies (resource policies)
		- It's added a bucket level but 
		- It's applied to all bucket objects
		- It can apply to anonymous accesses (public access) 
	- Bucket or Object Access Control Lists (ACLs): 
		- It's for also all principals
		- It's not recommended anymore
	- Block Public Access Bucket Setting:
		- It's a setting applied on top of any existing settings as a protection
		- It OVERRULES any other public grant
		- It can disallow ALL public access granted to a bucket and its objects
		- It can also block new public access grants to a bucket and its objects
		- It uses ACLs, bucket policies, access point policies, or all
		- It's turned on by default
- If more than 1 policy apply for a principal:
	- All policies are combined
	- least-privilege principle is applied: 
		- 1- Explicit Denies are the top priority
		- 2- Explicit Allows are the second priority
		- 3- Implicit Denies are the default
- For more details: [Controlling Access to S3 Resources](https://aws.amazon.com/blogs/security/iam-policies-and-bucket-policies-and-acls-oh-my-controlling-access-to-s3-resources/)

</details>

<details>
<summary>Encryption</summary>

- Client-side Encryption: 
	- It's the responsibility of the client/application:
		- Encryption/decryption process (CPU intensive process)
		- Encryption keys
	- Objects are encrypted before they're uploaded in S3
	- It's used when strict security compliance is required
	- It has a significant admin and processing overhead:
		- To Keep track of keys
		- To manage which ones are used for which files
		- To store them securely
		- To back them up
		- To manage rotation
	- It requires a powerful machine
- Encryption In Transit:
	- It's achieved by SSL/TLS
- Encryption At Rest:
	- Objects aren't encrypted by default
	- It can be configured on a per-object basis
	- Sever-Side Encryption with Customer-Managed Keys (SSE-C):
		- S3 handles the encryption/decryption process (a CPU intensive process)
		- The customer is responsible for keys management
		- Keys must be supplied with each PUT/GET request
		- It also has a significant admin and processing overhead (see Client-Side Encryption)
	- Sever-Side Encryption with S3-Managed Keys (SSE-S3 or Amazon S3 master-key):
		- Keys are generated by S3 using AWS KMS 
		- KMS provides 2 versions of the key: 1 encrypted version and 1 decrypted version
		- S3 encrypts object by using AES-256 and the key decrypted version
		- S3 takes the key encrypted version and stores it with object
		- We always know which key is used to encrypt which object
		- Pros:
			- No admin and processing overhead
			- No CPU machine is necessary
		- Cons:
			- Less security: Role separation isn't possible
			- If an IAM Entity has permission to manage an S3 bucket (read/write), they could then also encrypt/decrypt data
	- Sever-Side Encryption with AWS KMS-Managed Keys (SSE-KMS):
		- Objects are encrypted using individual keys generated by KMS
		- Encrypted keys are stored with the encrypted objects
		- Decryption of an object needs both S3 and KMS key permission
			- E.g., We could have an S3 administrator with full control on S3 objects but without the ability to read S3 data
		- Pros:
			- No admin and processing overhead
			- No CPU machine is necessary
			- [Role separation](https://en.wikipedia.org/wiki/Separation_of_duties): allow an identity to be given S3 administrator rights, but not allow them to interact with objects
- Bucket Default Encryption Propriety:
	- Objects are encrypted in S3 (not buckets)
	- Each PUT operation needs to specify encryption (and type) or not
	- A bucket captures any PUT operations where no encryption method/directive is specified
	- It doesn't enforce what type can and can't be used
	- Bucket policies can enfore what type can be used
- [For more details](https://aws.amazon.com/blogs/security/how-to-prevent-uploads-of-unencrypted-objects-to-amazon-s3/)

</details>

<details>
<summary>Limits</summary>

- Unlimited storage
- Unlimited object #
- Default limit of 100 buckets / AWS account
- Hard limit of 5 GB / PUT
- Hard limit of 3500 PUTs / second
- Hard limit of 7 days for presigned URL (expiration)

</details>

<details>
<summary>S3 Log requests</summary>

- All requests to S3 bucket could be logged 
- They could be stored in another S3 bucket in the same AWS account or in a completely different AWS account 

</details>

- [S3 FAQ](https://aws.amazon.com/s3/faqs/)

---

## Networking - CloudFront:

<details>
<summary>Description</summary>

- It's a Content Delivery Network (CDN)
- It's a global service (Network and Content Delivery)
- It's a global cache for data on edge caches:
	- It allows lower latency, higher throughput
	- It reduces load on the content servers
	- It caches objects for a TTL (Time To Live)
- It's for static, dynamic files, streaming (RTMP) and, interactive content 
- It distributes Media using HTTP or HTTPS
- It's not included in free tier subscription
- It comes with a default domain names: 
	- [randomCodes].cloudfront.net
	- It work with http and https
	- E.g. 1, http://d1234.cloudfront.net 
	- E.g. 2, https://d1234.cloudfront.net
- ARN:  
	- Format: arn:partition:service:region:account:distribution/distributionName 
    - E.g., arn:aws:cloudfront::191449997525:distribution/EWA2YC90MZY8E 

</details>

<details>
<summary>Origin</summary>

- The server/service that hosts our content
- It needs to be accessible on the internet
- It can be an S3 Bucket: 
	- S3 AWS public endpoints will be used
- It can be an web server (an ELB, or a Route 53):
	- An EC2 instance: 
	- A Corporate Data Center Server: a public IP address will be used
- It can be an Amazon MediaStore: 
- It can be a corporate Data

</details>

<details>
<summary>Distribution</summary>

- It's the "configuration" entity within CloudFront
- It's where we configure all aspects of a specific "implementation" of CloudFront from
- It has a DNS address
- It can include 1 or more origins
- It has 2 Delivery Methods:
	- Web Distribution: 
		- To speed up distribution of static and dynamic content, for example, .html, .css, .php, and graphics files
    	- Distribute media files using HTTP or HTTPS
    	- Add, update, or delete objects, and submit data from web forms
    	- Use live streaming to stream an event in real time
	- RTMP Distribution (Real-Time Messaging Protocol):
		- To speed up distribution of streaming media files using Adobe Flash Media Server's RTMP protocol. 
		- It allows an end user to begin playing a media file before the file has finished downloading from a CloudFront edge location 
		- It requires to store the media files in an Amazon S3 bucket
- Origin Settings:
	- Origin Domain Name: the service/server that hosts the origin
	- Origin Path to set a specific part of a service/server (E.g., S3 folder)
	- Restrict Bucket Access:
- Default Cache Behavior Settings:
	- Viewer Protocol Policy:
- Distribution Settings:
	- Price Class:
		- Only US, Canada, Europe; 
		- US, Canada, Europe, Asia, Middle-East, Africa or; 
		- All Pops (Recommended choice but most expensive)
	- WAF ACL (Web Application Firewall Access Control List): 
		- To allow or block requests based on criteria that we specify, 
		- Choose the web ACL to associate with this distribution.
	- Default Root Object: 
		- The object that we want CloudFront to return (E.g. index.html) 
		- When a viewer request points to our root URL (www.example.com
		- instead of to a specific object in our distribution (www.example.com/index.html)
	- TTL (Time To Live):
		- It's set at objects level: it dictates to CloudFront how long they should be cached for
		- It could be set at CloudFront level as a distribution default TTL
	- Alternate Domain Names (CNAMEs):
		- We could add up to multiple CNAMEs
		- We must create their record with our DNS service to route queries for www.example.com to d1234.cloudfront.net
		- SSL certificate is required within ACM (AWS Certificate Manager) to proves our ownership of that domain
	- Restrict Viewer Access:
		- By default, CloudFront is a publicly accessible CDN
		- We can make it private (private CloudFront Distribution):
			- It will then require users to access our content to use a Signed URL or a Signed cookie 
			- Trusted Signers: we could choose the current AWS account and/or other ones to create signed URLs or signed cookies

</details>

<details>
<summary>Edge Location/Regional Edge Caches</summary>

- see infrastructure
- It's not just read only?

</details>
          
<details>
<summary>Caching Process</summary>

- Create a distribution and point at one or more origins
- Distribution DNS address directs clients at the closest available Edge Location
- If the requested data is cached in the Edge Location, it's delivered locally from it (cache hit)
- If the requested data isn't cached:
	- The edge location attempts to download it from a regional cache
		- An aged (expired) content in edge location may still exist here 
		- It's bigger (more storage) and 
		- It servers more people (attached to multiple Pops)
	- If the data isn't in regional cache, 
		- The edge location and regionl cache perform an origin fetch
		- They download the data from the origin
		- The regional cache will be able then to serve requests from other pops
	- As the edge location receives the data, 
		- It immediately begins forwarding to the custmer
		- It immediately begins
		- It immediately caches it for the next visitor
- Content validity:
	- It could expire (valid for a TTL): It could be discarded and be recached
	- It could be explicitly invalidated and removed

</details> 

<details>
<summary>Origin Access Identity (OAI)</summary>
 
- It's also called Origin Access Identifier
- It's a virtual identity that can be associated with a distribution 
- It allows restriction of an S3 bucket to accept connections only from a specific CloudFront OAI
- It works only with S3 buckets (it doesn't support any other service such as EC2 server or on premise web server)
- How it works:
	- Private S3 bucket (bucket policy denies public access)
		- Create it private
		- Edit bucket policy of an existing S3 bucket and remove its public access statement (if it applies)
	- Create an OAI in CloudFront
	- Private distribution in CloudFront with the OAI above:
		- Create a new Private distribution
		- or Edit an existing public distribution (Distribution Setting > Origin and Origin Settings > Edit the origins)
		- This will grant the AOI above Read Permission on the S3 bucket above (It'll add an allow statement in the bucket policy)
- Use cases:
	- For better User experience: to avoid a lower level of performance by going direct to S3
	- To avoid bypassing an application, 
		- It generates signed URLs to access restricted content using CloudFront
		- We don't want our customers having the abily to bypass it and go directly to the underlying S3 bucket 

</details>

- [For more details](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)

---

## Storage - Elastic File System (EFS):

<details>
<summary>Description</summary>

- It's an implementation of the Network File System ([NFSv4](https://en.wikipedia.org/wiki/Network_File_System#NFSv4)) within AWS
- It's delivered as a service
- It can be mounted on multiple Linux instances at the same time
	- It's accessed via "mount targets"
	- It's currently only supported in Linux
	- It's elastic:
		- An initial size isn't required
		- It grows and shrinks automatically, as files are added and removed
- It has a DNS name:
	- Format: fs-[randomCode].efs.ap-[regionName].amazonaws.com
	- E.g., fs-963f75af.efs.ap-useast-1.amazonaws.com
- It's region resilient: 
	- Its availability isn't impacted by an AZ failure
	- It's recommnended though to have 1 mount target by AZ
- It integrate with multiple AWS services:
	- AWS backup service to get data backed up
	- AWS Data Sync that can act as a synchronization product and get data in EFS
      
</details>

<details>
<summary>Mount Targets</summary>

- They're placed in subnets inside a VPC (1 mount target/AZ)
- They have an IP address
- Security Groups are used to control access to them
	- The related EC2 instances' SGs could be best fit here 
	- By simply allowing all inbound traffic from source with the same SG
- It's accessed:
	- By local EC2 instances from a local VPC
	- By other EC2 instances from other VPCs across VPC peering connection
	- By on-premises locatons via a VPN or Direct Connect
- CLI EFS Utilities:
	- It's not required since EFS is standard inside Linux OS
	- It's recommended though since it allows the machine a tighter integration with EFS 

</details>

<details>
<summary>Performance modes</summary>

- General Purpose:
	- It's the default mode
	- It's suitable for 99% of needs
- Max I/O: 
	- It's designed for when a large number of instances (hundereds) need to access the file system

</details>

<details>
<summary>Throughput modes</summary>

- Bursting Throughput mode:
	- It's the default
	- The size of the file system is linked to its performance:
	- 100 MiB/s base burst
	- 100 MiB/s per 1 TB size
	- Earning 50 MiB/s per Tib of storage		
- Provisioned mode (or the Throughput mode):
	- It allows control over throughput independently of file system size

</details>

<details>
<summary>Encryption</summary>

- Encryption at rest:
	- It's configured when creating a file system 
	- It's disabled by default
	- It works with a AWS KMS of the same or another AWS account
- Encryption in transit:
	- It's configured when mouting a file system

</details>

<details>
<summary>Storage Classes</summary>

- Standard:
- Infrequent Access (IA)

</details>

<details>
<summary>Lifecycle management</summary>

- It's used to move files between classes based on access patterns

</details>

<details>
<summary>Use cases</summary>

- Parralel and Elastic workloads:
	- It's designed for large scale parallel access of data
	- It supports thousands of NFS clients and access the data concurrently
	- E.g. 1, Shared data/media for WordPress instances, content management and web serving using a shared set of data
	- E.g. 2, Shared bespoke logging information:
		- Scenarios where CloduWatch isn't used
		- Because of tight security requirements
	- E.g. 3, Big Data and analytics where concurrent access is needed from multiple locations (why not S3?)
	- E.g. 4, Certain media processing workflows like video editing, studio production, broadcast processing
	- E.g. 5, A shared home directory platform for multiple Linux OS instances: rather than having a home directory on each of them
- Antipatterns:
	- It's not for is single machine situations, so it's probably overkill to use EFS if you've only got a single EC2
	- It's not an object storage (it's not supported by Cloudfront)
	- It's not used for temporary storage (it's not efficient)

</details>

<details>
<summary>Limits</summary>

- 1 Mount Target / AZ

</details>

<details>
<summary>Best practices</summary>

- For High availability:
	- Create 1 mount target by AZ
	- Use the mount target of the EC2 instance AZ to mount to EFS
	- If an AZ fails, all instances in others AZs will still have access to the EFS storage
- For less admin overhead,
	- Associate the Mount Targets to the SG of the EC2 instances they're mounted on
	- Allow all inbound traffic from the same SG

</details>

---

## Database - SQL - Relational Database Service (RDS):

<details>
<summary>Description</summary>

- It's a database as a service (DBaaS) product:
	- It can be used to provision a fully functional database without the admin overhead
	- We can't log in to its OS
	- Patching of the RDS OS and DB is Amazon's responsibility
- It can perform at scale
- It can be made publicly accessible
- It can be configured for demanding availability and durability scenarios
	- It can be deployed in a single AZ or Multi-AZ mode
- It isn't Serverless
- It supports different database engines: 
    - MySQL:
    - MariaDB:  
    - PostgreSQL:
    - Oracle:
    - Microsoft SQL Server:
	- Amazon Aurora:
		- It's AWS own relational database engine
    	- It could be created from MySQL db (good way to migrate to Aurora)
		- It could be created from a PostgreSQL db (a good way to migrate to Aurora)
		- Aurora Serverless is Serveless
- It's deployed in EC2 instances, it supports: 
	- EC2 General Purpose Family (DB.M4, DB.M5)
	- Memory Optimized family:
		- DB.R4 and DB.R5
		- DB.X1e and DB.X1 for Oracle
	- Burstable (DB.T2 and DB.T3)
- It uses a storage similar to EBS, it supports:
	- General Purpose SSD (gp2): 
		- IOPS per GiB, 
		- burst to 3,000 IOPS (pool architecture like EBS)
	- Provisioned IOPS SSD (io1): 
		- 1,000 to 80,000 IOPS (engine dependent) 
		- Size and IOPS can be configured independently
	- Autoscalling feature (disabled by default)
- It has an endpoint, a CNAME:
	- It points to the current primary instance
	- We can connect into it with the CNAME + Port #
- Every modification of the instance could be:
	- run immediately
	- or run at maintenance time that is created when the instance is created
- It requires a minimum of 2 subnets in a Subnet Group
- Troubleshooting: 
	- We want our application to check whether a request generated an error before we spend any time processing results.  
	- The easiest way to find out if an error occurred is to look for an Error node in the response from the Amazon RDS API.  

</details>

<details>
<summary>Architecture</summary>
</details>

<details>
<summary>Read Replica</summary>

- It's a read-only copy of an RDS instance
- It's created from a primary instance
	- The source primary instance is called the Master Instance
	- The copy instance is called the Read-Replica Instance
- It's achieved by using asynchronous replication from the Master Primary instance to the read replica instance
- Reads from a Read-Replica are eventually consistent - normally seconds
- It can be created in the same region or in a different region
	- For different region, AWS handles the secure communications between those regions (Encryption in Transit)
	- Without a need to any networking configurations
- It requires Automatic backups to be turned on Master Instance
- It can be addressed indepently from its primary instance (each read-replica has its own DNS name)
- It's used for scaling reads:
- It's possible to have up to 5 read-replica (5x increase in reads)
	- It's not possible to have a single DNS name to address all of those read replicas
	- Our application need to be aware of our database topology in order to take advantage of these read replicas
- It's possible to have read-replicas of read replicas (latency)
- It can be promoted to be a primary instance
	- The read-replica db becomes then its own database (master)
	- It breaks the asynchnous replication
	- It can be used for read and write operations
- It can be multi-AZ 
- It's available for all database types (MySQL, PostgreSQL, MariaDB, Oracle, Aurora) except SQL-Server
- Database engine version upgrade is independent from master instance (it must be handled manually)
- [Multi-AZ vs. Read-Replicas](https://aws.amazon.com/rds/details/multi-az/)

</details>

<details>
<summary>Option Group</summary>

- It allows to configure (enable, disable, ...) some of the RDS database engines specific features
	- E.g. 1, MySQL Memcached support (MEMCACHED)
	- E.g. 2, Oracle Native Network Encrytion (NATIVE_NETWORK_ENCRYPTION)
- It's currently available for MariaDB, MySQL, Oracle and, Microsoft SQL Server 
- It's not currently available for PostgreSQL and Aurora

- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html)

</details>

<details>
<summary>DB Parameter Group</summary>

- It acts as a container for engine configuration parameters that are applied to one or more DB instances
	- E.g. 1, autocommit DB parameter for MySQL 5.6 RDS instance
	- E.g. 2, auto_increment_increment DB parameter for MySQL 5.6 RDS instance
- A default one is created 
	- When a db instance is created without specifying a custom DB parameter group
	- It contains db engine defaults and Amazon RDS system defaults based on the engine, compute class and, allocated storage of the instance
	- It's not possible to modify it
	- To modify the DB Parameter Group of an RDS instance associated with a default Parameter Group:
		- Create a new DB Parameter Group
		- Modify the RDS Instance to use the new parameter group
- If a non-default DB parameter group is updated, 
	- The changes is applied to all DB instances that are associated with it
	- When the change is applied depends on the "Apply Type" of the changed parameter:
		- If it's a dynamic parameter, the change is applied immediately regardless of the Apply Immediately setting 
		- If it's a static parameter, the parameter change takes effect after the DB instance is manually reboot
- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html)

</details>

<details>
<summary>Scalability</summary>
</details>

<details>
<summary>Consistency</summary>
 
</details>

<details>
<summary>Resilience</summary>

- Multi-AZ mode:
	- RDS creates 2 db instances in the same region:
		- The primary database (production)
		- The Standby database is created in a different AZ 
	- It is for resilience Only
		- Disaster Recovery: Database failure, AZ failure
		- DB maintenance 
		- It isn't for performance (see read replicas)
	- Primary instance:
		- It's the only one that is accessed with the instance CNAME
		- It has its own storage
	- The Standby instance: 
		- It's the exact copy of the primary database
		- It has also its own storage
		- The data replication from the primary db is synchronous: data is copied in real time  
		- It's the source of backups (no performance impact)
	- Failover Process:
		- In case of a db maintenance or a failure (DB instance or AZ),
		- RDS will try to minimize the outages
		- It will automatically failover to the standby db
		- Its CNAME @ won't change 
		- Its CNAME @ will point to the standby db
		- It may be a brief outage: 
		- It can have some level of lag or caching that can slow down it: 2 digits seconds or ~1 or 2 minute(s)
	- DB maintenance Process:
		- In case of a planned db maintenance (change the db size),
		- RDS will try to minimize the outages
		- It will apply the change on the standby database 1st
		- It will then "failover" to the standby db that will become the new primary db (See failover process)
		- It will finally apply the change on the new primary db
	- Fault Tolerant System?
		- Except Aurora, RDS is not a truly fault tolerant system
		- This is because of the brief outage that could happen during the failover process
	- It provides us with better [RTO](https://en.wikipedia.org/wiki/Disaster_recovery#Recovery_Time_Objective)
	- It allows to force AZ changing: actions > reboot  
		- We can actually reboot with failover  
		- This is a way of forcing our AZ to change
		- So we can change from one AZ to another by just rebooting with failover 
		- It's possible for MySQL, MariaDB, PostgreSQL, Oracle, SQL Server
- Single AZ Mode:
	- The RDS instance is in a single AZ
	- The Standby instance isn't created

</details>

</details>
<details>
<summary>Disaster Recovery</summary>

- Snapshot:
	- It's a manual backup: 
		- It's user initiated
		- E.g., Console, CLI, Lambda function
	- It's created automatically when a new RDS instance is created/restored
	- It's stored in S3
    - It's kept even after the original RDS instance is deleted
	- It can be copied to the same region or to a different one
- Backups:
	- It's an automated backup: 
		- It occurs once a day during a backup window: it takes a full daily snapshot
		- Log backups occur every 5 minutes (Point in time)
	- It's taken from the Standby instance 
	- It's stored in S3
	- It's an incremental backup:
		- The 1st backup stores the entire used space
		- After, changed data only stored
	- It's automatically deleted when the original RDS instance is deleted
	- It allows to recover our db to any point in time within a retention period
		- Retention period is from 1 to 35 days
		- Retention period is 0 means it's disabled
		- Down to a second within this retention period
	- It's enabled by default
		- Default retention period is 7 days
	- It provides a low [RPO](https://en.wikipedia.org/wiki/Disaster_recovery#Recovery_Point_Objective)
- Snapshot/Backups operation impacts:
	- During the Snapshot/backup window, storage I/O may be suspended while data is being backed up 
	- We may experience elevated latency
- Restoring Backups/snapshots:
	- AWS chooses the most recent daily backup, then
	- It applies transaction logs relevant to that day 
	- It results a new RDS instance: 
		- With a new DNS endpoint
		- With a new SG
	- It requires to perform some level of reconfiguration:
		- At an application level, to change the DNS Name the application is pointing to
		- At AWS level, to associate the new instance to the previous SG 

</details>

<details>
<summary>Security</summary>

- Network Security:
	- It could be Public:
		- It will be in a public subnet 
		- It will be assigned a public IP @
		- It will be accessible by resources from outside the VPC it's attached to
	- It could be Private: 
		- It won't be assigned a public IP @
		- It will be accessible only by resources inside the VPC it's attached to
	- Its network access is controlled by Security Groups (SG)
	- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html)
- IAM DB authentication:
	- It allows to manage database users credentials through IAM
	- It's disabled by default
	- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAM.html)

</details>

<details>
<summary>Encryption</summary>

- Encryption At Rest:
	- It is supported for all database types
	- It can be configured only when creating a DB instance
	- It can be added by taking a snapshot, making an encrypted snapshot, and creating a new encrypted instance from that encrypted snapshot
	- It can't be removed
	- It is done using the AWS KMS
	- Once an RDS instance is encrypted, the data stored at rest in the underlying storage is encrypted too (
		- Its automated backups, read replicas, and snapshots are encrypted
	- Read Replicas need to be the same state as the primary instance (encypted or not)
	- An Encrypted snapshot requires a new destination region KMS CMK to be copied to a new region
	- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html)
- Encryption in Transit:
	- Data in transit is encrypted for asynchronous replication of read-replicas in different regions

</details>

<details>
<summary>Pricing</summary>

- It's based on:
	- Instance pricing model (Reserved, On Demand)
	- Instance size
	- Provisioned storage (allocated): it isn't Elastic
	- IOPS if using io1
	- Data transferred out
	- Extra storage (backups/snapshots) beyond the 100% of provisioned db:
		- We get a free storage space equal to the db size
		- For an 100GB allocated RDS DB, 100GB of snapshot/backups are included
- Reserved DB instance: 
	- It let optimize Amazon RDS costs based on expected usage 
    - We can reserve a DB instance for a 1- or 3-year term  
    - Reserved DB instances provide with a significant discount compared to on-demand DB instance pricing
	- Discounts for reserved DB instances are tied to instance type and AWS Region  
	- It is available in 3 varieties: No Upfront, Partial Upfront,  All Upfront
	- See EC2 Description
- [For more details](https://aws.amazon.com/rds/mysql/pricing/)

</details>

<details>
<summary>Use cases</summary>

- Scalability: It's used for read-heavy database workloads (It doesn't scale writes)
- Global resilience: 
	- Improve the ability to recover from a serious failure either within a region or internationally
	- It provides with a better [RTO](https://en.wikipedia.org/wiki/Disaster_recovery#Recovery_Time_Objective) better than snapshot's one

</details>

<details>
<summary>Limits</summary>

- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html)

</details>

---

## Database - SQL - RDS Aurora Provisioned:

<details>
<summary>Description</summary>

- It's a custom-designed relational database engine that forms part of RDS
- It has 2 editions:
	- 1st one with MySQL compatibility
	- 2nd one with Postgre compatibility
- It's available in regions that have at least 3 AZs (not all regions)
- It uses a base configuration of a "DB cluster" that consists of:
	- A single primary instance: 
		- It's also called the primary node
		- It supports read-write workloads
		- It performs all of the data modifications to the cluster volume 
	- A cluster volume:  
		- It's an all-SSD virtual database storage volume 
		- It's shared by the primary instance and all replica instances
		- It scales automatically
	- 0 to 15 Replica instances:
		- They're also called replica nodes
		- They support only read operations
		- There is less than 100 ms of replication lag (Latency)
- Adding a reader is quick:
	- It's more quicker than converting a mySQL based RDS from no to multi-AZ
	- It only needs to provision a new instance and point it at the shared storage
	- It's not adding a new storage; there's no copy involved
- Its location could be 
	- Regional
	- Gloabl
	- Not all MySQL versions support this feature

</details>

<details>
<summary>Architecture</summary>
</details>

<details>
<summary>Db Features</summary>

- One writer and multiple readers:
	- It supports multiple reader instances connected to the same storage volume as a single writer instance 
	- It's a good general-purpose option for most workloads
- Parallel query:
	- One writer and multiple readers
	- It parallelizes some of the I/O and computation involved in processing data-intensive queries
	- It allows queries to be executed across all nodes of a cluster at the same time
	- It's currently available only for Aurora MySQL edition
	- It improves the performance of analytic queries by pushing processing down to the Aurora storage layer 
	- Use cases: 
		- Hybrid transactional and analytic workloads
		- Queries with larger data sets
	- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-mysql-parallel-query.html)
- Multiple writers:
	- It supports multiple writer instances connected to the same storage volume
	- It's good for when continuous writer availability is required

- They need to be enabled when a database cluster is made

</details>

<details>
<summary>Global Database Location</summary>

- It's currently available only for Aurora MySQL edition and version MySQL 5.6.10a 
- It consists of 1 primary cluster in a primary AWS region and 1 read-only cluster in a secondary region
	- This implies that data is replicated 12 times (2 copies x 3 AZs x 2 Regions)
	- Writes are done in the primary cluster 
	- Writes are replicated to secondary AWS Regions with typical latency of less than 1 sec
- It requires large DB instances: a Memory Optimized DB instance class (includes r and x classes)
- It requires to be enabled when a database cluster is made
- When enabled, database features aren't available

</details>

<details>
<summary>Endpoints</summary>

- There are several different endpoints available
- Cluster Endpoint: 
	- It connects our app. to the current primary DB instance of the app's cluster
	- It's updated automatically so that it always points to the primary instance
	- It's for both reads and writes
- Reader Endpoint 
	- It load balances read operations across all available Read Replicas
	- It's for read only
	- It offloads read queries and reduces load on the primary DB instance
- Instance Endpoints: 
	- It connects to a specific instance in the cluster 
	- It allows to have fine-grained control over query allocation, rather than having Aurora handle connection distribution
- Custom Endpoints:
	- It connects explicitly to an individual database instances

</details>

<details>
<summary>Migrating a RDS MySQL to RDS Aurora</summary>

- Way 1: 
	- Create an Aurora read-replica for the primary MySQL database. 
	- Promote the read-replica to a primary database. 
- Way 2: 
	- Create an Aurora read-replica for the primary MySQL database. 
	- Create a snapshot a the Aurora read-replica. 
	- Create a new Aurora database from the snapshot. 
- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Migrating.RDSMySQL.Import.html)

</details>

<details>
<summary>Scalability</summary>

- Storage Autoscaling: 
	- It starts with 10 GB
	- It scales in 10 GB increments to 64TB
	- It scales Compute ressources up to 32vCPUs and 244GB of memory 
	- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Integrating.AutoScaling.html)

</details>

<details>
<summary>Consistency</summary>
</details>

<details>
<summary>Resilience</summary>

- Storage:
	- It's replicated (the cluster volume) 6 times across 3 AZs (2 cluster data copies in each AZ)
	- It's constantly backed up to S3
	- It can tolerate
		- The loss of up to 2 data copies or an AZ failure without losing write availability
		- The loss of up to 3 data copies without losing read availability
- Instance DB:
	- It automatically initiates a Failover when there is any issue on the current primary instance
	- It's also possible to initiate a Failover manually (action > Failover)
	- The replica with the highest priority is promoted to be the primary during failover
	- Tier 0 has the highest priority
- It's capable of self healing any data problems that exists in a shared storage
	- It scans continuously data blocks and disks for errors
	- It replaces them automatically 
	- It monitors disks and nodes for failures
	- It automatically replaces/repairs the disks/nodes without the need to interrupt read/write processing from the db node

</details>

</details>
<details>
<summary>Disaster Recovery (Backtrack)</summary>

- It lets quickly recover from a user error, without having to create another DB cluster
- It has a maximum window of 72 hours
- E.g., if we accidentally deleted an important record at 10am, we could use Backtrack to move the Aurora database back to its state at 9:59am
- Pros: 
	- It doesn't create a new database (with a new DNS Name)
	- It doesn't require to perform any reconfiguration (see the required reconfiguration for the other RDS based engines)
- Con: It does cause an outage because it's rolling back the entire shared storage
- [For more details](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Managing.Backtrack.html)

</details>

<details>
<summary>Security</summary>
</details>

<details>
<summary>Encryption</summary>
</details>

<details>
<summary>Pricing</summary>

- It's based on high watermark system:
	- It's based on the used storage
	- It start off with zero allocation
- "Auto scalling" feature:
	- It's to dynamicaly scale up/down of reader instances
	- When the database isn't used, it allows to scale down the database
	- But there is a minimum and the level of reader instances increase/decrease is limited
	- We're not going to get the linear alignment between the capacity that we need (the amount of resources actually used) and the capacity that is provided
- E.g.:
	- If we consume 10 TiB, we're billed for 10 TiB 
	- If we delete 5 TiB, we're still using 10 TiB and, billed for 10 TiB
- To reduce the high watermark, we should take a backup and make a new cluster with just that data
- [For more details](https://aws.amazon.com/rds/aurora/pricing/)

</details>

<details>
<summary>Use cases</summary>

- Eventual consistency is acceptable: 
	- To use the cluster endpoint for writes
	- To use the reader endpoint for all reads
	- To avoid using specific instance endpoints
- Immediate consistency use case:
	- To use the cluster endpoint for writes
	- To use the cluster endpoint for reads of data recently updated (less than 100 ms)
	- To use the reader endpoint for all other reads
- [More use cases](https://developer.rackspace.com/blog/Understanding-Amazon-Aurora-Endpoints/)

</details>

<details>
<summary>Limits</summary>

- Max cluster volume:  64 TiB
- Max cluster Replicas #: 15
- Max Compute ressources: 32vCPUs 
- Max Compute memory: 244GB
- Backtrack maximum window: 72 hours

</details>

---

## Database - SQL - RDS Aurora Serverless:

<details>
<summary>Description</summary>

- It handles certain resource allocation as a service
- It's based on the same db engine as Aurora Provisioned
- It has a shared storage accessible for all db instances
- It's a self-managed db product:
	- We access it just as we would do if we were accessing a provisioned database
	- But it removes the complexity of managing a database such as:
		- Provision a hardware or virtual machines (All RDS remove this complexity)
		- Install of the database software (All RDS remove this complexity)
		- Manage of backups, High Availability, performance (All RDS remove this complexity)
		- Manage the server instances themselves (Only RDS Serverless removes this complexity)
	- It does only require to specify a minimum and maximum amount of resources (see ACUs, below)
	- It handles the scaling without any distruption to its related application
- Data API
	- It's a web-based query editor tool
	- It allows you to access the database using traditional APIs
	- It requires to be enabled to work
	- Rather than having to open a traditional database connection and execute SQL queries, we can connect to it using standard API
	- It could be used by web services-based application including AWS Lambda, AWS AppSync and, AWS Cloud9
	- It's much easier if you're designing an application from scratch and code it to utilize Aurora Serverless

</details>

<details>
<summary>Architecture</summary>

![Aurora Serverless Architecture](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/images/aurora-serverless-arch.png)

</details>

<details>
<summary>ACUs (Aurora Capacity Units)</summary>

- It's an abstraction away from physical hardware specifications
- [Setting the Capacity of an Aurora Serverless DB Cluster](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.setting-capacity.html)

</details>

<details>
<summary>Private Link</summary>

- It's a service that allows to place endpoints inside a customer VPC to access remote services
- Since Aurora Serverless DB instances aren't hosted inside a customer VPC (there's no physical instance inside it)
- Aurora Serverless uses Private Link to access its db instances
- It's like a VPC endpoints
- Aurora Serverless cluster can't currently be accessed from across a VPN or an inter-region VPC peer

</details>

<details>
<summary>Scalability</summary>

- It's capable of rapid scaling
- Instance Pool:
	- It contains "hot" instances of various different sizes:
	- They're ready to use
	- They're stateless (they have not any storage attached)
	- They have the Aurora Serverless software installed on them
	- They can be quickly allocated for any AWS customer as soon as they're needed
- Proxy Fleet:
	- It's a transparent set of proxying instances
	- It sits between an application and its Aurora Serverless instances
	- It abstracts db instances layer from their application
	- It grows and shrinks based on demand
	- It routes transparently connections from an application to Aurora Serverless instances without this application knowing any different	
	- It's used to route the workload to "warm" resources that are always ready to service requests (see instance pool)
- Automatic Pause and Resume:
	- It's an additional scaling configuration
	- It allows to pause (0 ACU) automatically a db instance after consecutive minutes of inactivity
	- It reallocates quickly a new db instances when an activity is detected
- E.g., When a current capacity is exceeded,
	- It transparently uses the instance pool to provision a new larger database instance or multiple smaller database instances 
	- It transparently attachs them to the database shared storage
	- It transparently redirects connection to the new instances
	- It then transparently removes the small instances which are no longer needed	

</details>

<details>
<summary>Consistency</summary>
 
</details>

<details>
<summary>Resilience</summary>

- Aurora separates computation capacity and storage
- Storage volume (Replicas):
	- It spreads replicas across multiple AZs 
	- The data remains available even if outages affect the DB instance or the associated AZ

- DB Instance Automatic multi-AZ failover:
	- The DB instance of an Aurora Serverless DB cluster is created in a single AZ
	- If the DB instance or the AZ fails, Aurora recreates the DB instance in a different AZ 
	- In case of a failure, the Automatic multi-AZ failover takes longer than an Aurora Provisioned cluster
	- Its time is currently undefined: it depends on demand and capacity availability in other AZs within the given AWS Region

</details>

<details>
<summary>Disaster Recovery</summary>

- Snapshot:
	- It's possible to restore an Aurora Serverless db from a snapshot
	- It's possible to do it from an Aurora Previsioned db snapshot
	- It's always encrypted (We can't turn off encryption)

</details>

<details>
<summary>Pricing</summary>

- For Shared storage:
	- The pricing is based on high watermark system 
	- See RDS provisioned pricing
- For DB instances:
	- We pay for the database resources that are used on a per second basis
	- It's attempting to provide a linear alignment between the needed compute capacity and the provided one
	- We could enable the pausing feature (scale it down to 0 ACU) to pause the db instance when it isn't needed

</details>

<details>
<summary>Use cases</summary>

- Intermittent workloads: an application uses a database and has random surges of traffic
- Unpredictable workloads: an application has unpredictable database usage patterns
- Development databases (Test, Staging, A/B Testing) used during work hours and will be shutted down automatically after work hours
- We want to remove the complexity of managing database instances
- We want automatically scaling database instances

</details>

<details>
<summary>Limits</summary>

- It exists in a single AZ (See failover description)
	- The Aurora Serverless Automatic multi-AZ failover takes longer than an Aurora Provisioned cluster (it has an ongoing costs 24/7 while it's running)
	- There is a trade-off here between different priorities: 
	- It's between a slight increase in the amount of time that failover takes vs. being able to scale back to zero capacity and then only pay for the storage
- It can't be set to be public: 
	- It's not a drop-in replacement for DynamoDB
	- But we can use its Query editor (Data API)
- Its cluster can't currently be accessed from across a VPN or an inter-region VPC peer

</details>

---

## Database - NoSQL - DynamoDB:

<details>
<summary>Description</summary>

- It's a NoSQL database service
- It's a serveless database product
- It's a global service
- It's partitioned regionally
- It's a Multimodel database, 
	- It includes features of more than one data model
	- It's wide-column store:
		- It's Key Value database
		- It's a 2 dimensional column store database
- It supports Attribute concept:
	- It's like a column in other dbs
	- It's a key (attribute name) and value
	- It could be a "Partition Key" (PK) or a "Hash Key"
	- It could be a "Sort Key" (SK) or a "Range Key"
	- It supports different types
	- A type of a given attribute could be different across rows
	- It could be Nested
- It supports Item concept: 
	- It's like a row in other dbs
	- It's a collection of attributes
	- It's inside a table that share the same key structure as every other item in the table
	- It has its unique primary key: PK only or PK and SK
	- It's a Json document
	- It could have up to 400 KB in size
- It supports Table concept: 
	- It's a collection of items: 0 or more items
	- Its name must be unique within its region and AWS account
	- It doesn't enforce a rigid schema across all of its items
	- It does only require a primary key for the table to be defined upfront
		- It could consist of 1 attribute: PK
		- It could consist of a composite key: (PK, SK)
	- Its ARN: 
		- Format: arn:${Partition}:dynamodb:${Region}:${Account}:table/${TableName}
		- E.g., arn:aws:dynamodb:us-east-1:191449997525:table/myDynamoDBTable
- E.g. We need to store weather data that is sent by weather station every 30 mn
	- We need a table: weather_data
	- For each item, we need a Partition Key (a number) to identify weather station
	- For each item, we need a Sort Key (date and time) to identify every single data sent by a weather station

</details>

<details>
<summary>Architecture</summary>

- DynamoDB data is split across Partitions:
	- A table starts with 1 partition and it grows depending on this table's size and its capacity (see scalability)
- A Hashing function is used to associate a data's PS to a partition where data will be put to or got from
- A partition contain 3 nodes:
	- 1 Leader node:
	- 2 additional nodes
- ![Architecture](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/images/HowItWorksPartitionKeySortKey.png)
- ![Partitions](https://d1o2okarmduwny.cloudfront.net/wp-content/uploads/2014/07/Screen-Shot-2019-04-23-at-2.10.39-PM.png)

</details>

<details>
<summary>Operations</summary>

- Get and Put an item:
	- It's reading an item
	- It requires to specify an item's primary key: PK only or PK and SK
	- It isn't allowed to get a partial item: its full size is read at once (all attributes)
- Put an item:
	- It's writing an item
	- It requires to specify an item's primary key: PK only or PK and SK
	- It isn't allowed to put a partial item: all attributes must be written at the same time
	- It returns HTTP status code 200 when data it stored persistently (succesfuly)
- Scan:
	- It doesn't require any parameters 
	- It no parameter is added, it will then list/retrieve all item in the scaned table
	- It allow additional filters on any attribute of the table
	- When a filter isn't on a primary key, 
		- It read all items of a table; 
		- It excludes items that don't match the filter; 
		- It returns the remaining items
		- It consumes the capacity of the entire table
	- Pros: It's more flexible; It'sapplied on different PS
	- Cons: It isn't an efficient operation
- Query:
	- It allows to perform lookups on the table (like scan operation)
	- It doesn't scan all items of a table
	- It requires a filter on the PS or PS and SK
	- It allows additional filters on any non key attribute
	- It consumes the data corresponding to the filtered keys (PS or PS and SK)
	- Pros: It's an efficient operation
	- Cons: It's always applied on 1 single PS
- Filter:
	- It could be applied on any attribute (PK, SK or a simple attribute not key)
	- It requires a value
	- It requires a type of the attribute when it isn't applied on a PK nor a SK

</details>

<details>
<summary>Index</summary>

- It provides an alternative representation of data in a table
- It's useful for applications with varying query demands
- Projected attributes: 
	- Indexes can have either Keys only, All table's attributes or some attributes
	- It allows to reduce the amount of data read when items are read from the index
	- It can help to improve performance but...
	- It can cause a huge performance penalty if non-projected attributes are read from it (they're fetched from its table)
- Local Secondary Index (LSI):
	- It must be created at the same time as creating a table
	- It must be created on tables with composite primary key
	- It uses the same PK but an alternative SK
	- Query operations could be run on the table or its LSIs (filter: PS and index's SK)
	- It's a part of the table:
		- It shares its table's read/writting modes: privisioned or on-demand
		- It shares the RCU and WCU values for the main table
		- It allows performing strongly consistent and eventually consistent reads on the table
	- The table’s SK is always projected into the index
	- ![E.g.,](https://blog.h4.nz/media/DynamoDB/LSI.png)
- Global Secondary Index (GSI):
	- It can be created at any point after the table is created
	- It can use different PK and SK
	- It's separated from its table:
		- It doesn't share the data with its table
		- Its data is replicated asynchronously from its table => latency
		- It doesnt' support Strong consistent read
		- It has its own setting: RCU/WCU; Auto-scalling WC and RC
		- It has its own RCU and WCU values
- Use cases:
	- We have a different type of access pattern not supported by table's PS or PS and SK

</details>

<details>
<summary>Global Tables</summary>

- It's possible to create a set of multi-master table
	- It allows to have a table in different AWS regions 
	- It replicates data to all of the other replica tables
	- Reads and Writes are possible from/to all replicas
- It requires to enable "streams" (see streams topic below)
- It requires the table to be empty
- It employs a [last writer wins conflict resolution protocol](https://dzone.com/articles/conflict-resolution-using-last-write-wins-vs-crdts)

</details>

<details>
<summary>Stream</summary>

- Stream:
	- It provides an ordered list of changes that occur to items within a table
	- It's a rolling 24-hour window of changes:
		- Every time an item is added, updated or, deleted to a table which has streams enabled 
		- An entry is added to that stream which details the insert, update, or delete operation
	- The information that is written in the stream can be configured with one of 4 view types:
		- KEY_ONLY: Whenever an item is added, updated, or deleted, the key(s) of that item are added to the stream
		- NEW_IMAGE: 
			- The entire item is added to the stream (post-change)
			- It's great when we want to perform an action based on the new value of an item
			- E.g., when we create a new account, we should send a confirmation email to the new email @
		- OLD_IMAGE: 
			- The entire item is added to the stream (pre-change)
			- It's great when we want to perform an action based on the old value of an item
			- E.g., when we update an email address, we should send an approval email to the old email @
		- NEW-AND-OLD-IMAGES: 
			- Both the new and old versions of the item are added to the stream
	- It's disabled by table
	- It's enabled per table
	- It contains data from the point of being enabled
	- It's durable, scalable and, reliable (HA achitecture)
	- ARN:
		- Format: arn:${Partition}:dynamodb:${Region}:${Account}:table/${TableName}/stream/${StreamLabel}
		- E.g.: arn:aws:dynamodb:us-west-1:191449997525:table/myDynamoDBTable/stream/2015-05-11T21:21:33.291
- Trigger:
	- It's similar to triggers in relational database engines
- Use cases:
	- Stream is used by AWS for replications envolved in globa tables
	- To implement an event driven pipeline: 
		- Stream containing changes + Trigger + Lamda function
		- E.g. 1, Send approval or confirmation email when it's changed or a new account is created
		- E.g. 2, Send a notification when something happen

</details>

<details>
<summary>Scalability (Capacity)</summary>

- Reading/Writing: 
	- For a given key value can't exceed the maximum performance that's allocated to the partition (not the table)
	- For 1 single PS value, we can only ever get the maximum performance that's allocated to the partition (not to the table)
	- So when we're allocating performance for a DynamoDB table, we're actually doing is allocating it to its partitions (not to the table)
- Writtings:
	- They're done on the leader node
	- Replications are made from the leader node to the other non leader nodes
	- It will consume 1 WCU for every 1KB or less of data
- Readings support 2 modes:
	- Strongly consistent read:
		- Data is read from the leader node
		- It returns the most up-to-date copy of data
		- It takes longer
		- It will consume 1 RCU for every 4KB or less of data
	- Eventually consistent mode:
		- Data is read in any of the 3 nodes
		- It's a mode that is preferring speed
		- Data received may not reflect the recent write
		- It's the default for read operations
		- It will consume 1 RCU for every 8KB or less of data
	- E.g., for 10 gets of items of 10 bytes:
		- We'll consume 10 RCU with strongly consistent read
		- We'll consume 5 RCU with eventually consistent mode
	- All costs and calculations are based on Strongly consistent mode
- Read/Writting modes:
	- On demand:
	- Provisioned Throughput mode:
		- A table is configured with read and write capacity units (RCU and WCU)
		- Every operation on items consumes at least 1 RCU/WCU
		- Partial RCU/WCU cannot be consumed
		- WCU: 1 KB of data or less written to a table per second 
		- RCU: 4 KB of data or less read from a table per second in a stronly consistent way
		- RCU: 8 KB of data or less read from a table per second in an eventual consistent way
		- Atomic transactions requires x2 the RCU
	- Auto-Scaling Provisioned:
		- We don't have to explicitly specify the RCU and WCU
		- We can enable auto-scaling
		- We can define a minimum and maximum RCU and WCU and 
		- DynamoDB will automatically adjust the RCU and WCU allocated to a table based on those demands
- Provisioned Throughput calculations:
	- E.g. 1: A system needs to store 60 patient records of 1.5 every minute
		- Assumption: 1 record written per second = 1 WCU of a maximum of 1 KB item (AWS provides a buffer to smooth this out)
		- Each write has a size of 1.5 KB = 2 WCU
		- Total WCU: 2
	- E.g. 2: A weather application reads data from a Dynamo DB table, Each Item in the table is 7 KB in size. How many RCUs should be set on the table to allow for 10 read per second:
		- Assumption: Eventual consistent read mode (since it's the default)
		- 10 reads per second = 10 RCU of a maximum 4 KB item
		- Each read has a size of 7 KB = 2 RCU
		- Total RCU for eventual consistent read = 20 RCUs / 2 = 10 RCUs
	- [How to Calculate Read and Write Capacity](https://linuxacademy.com/guide/20310-how-to-calculate-read-and-write-capacity-for-dynamodb/)

</details>

<details>
<summary>Consistency</summary>

-  Data is written in all AZs within a second (< 1s):

</details>

<details>
<summary>Resilience</summary>

- It's resilient on a regional level
- It stores table's partitions in at least 3 different AZs (1 replica / AZ)
- It can survive the failure of an AZ without any additional configuration
- They're stored on nodes

</details>
<details>
<summary>Disaster Recovery</summary>

- Point-in-time recovery:
	- It's a feature that requires to be enabled on a per table basis
	- Once enabled, it's then possible to restore to a point in time up to the last 35 days
- Backups
	- It's manual of a table (not be confused with automated backedup of RDS)
	- It stores data and configurations (settings) listed in the "Backup table details" page:
		- Primary partition key
		- Sort Key is it exists
		- Read/write capacity mode
		- Provisioned read capacity units
		- Provisioned write capacity units
		- Encryption Type
		- Auto Scaling
		- Stream enabled
		- Indexes
	- Resore:
		- It's done in a new table name
		- It can take several hours to complete
	- ARN:
		- Format: arn:${Partition}:dynamodb:${Region}:${Account}:table/${TableName}/backup/${BackupName}
		- E.g., arn:aws:dynamodb:us-east-1:191449997525:table/myDynamoDBTable/backup/myDynamoDBTableackup

</details>

<details>
<summary>Security</summary>

- It's a public service (like S3)
- It's private by default (like S3)
- To access a DynamoDB table, it requires
	- to give access to an IAM Identity in the same account (user, role, group) using identity policies or
	- to give access to an IAM role in the same account that allows an external identity to assume it
- It's NOT possible to apply ressource level permission (unlike S3)

</details>

<details>
<summary>Encryption</summary>

Encryption At rest 
	- It's enabled by default
	- DEFAULT: 
		- The key is owned by Amazon DynamoDB 
		- It's free
	- KMS - Customer managed CMK:
		- The key is stored in customers' account 
		- The key is created, owned and, managed by customers
		- AWS Key Management Service (KMS) charges apply
	- KMS - AWS managed CMK:
		- The key is stored in customer's aws account
		- The key is managed by AWS Key Management Service (KMS)
		- AWS KMS charges apply
		- It allows to separate the role: DynamoDB administrators don't necessarly have the permission to "read" (decrypt) data in dynamoDB
	- Historically, it used to be an option

</details>

<details>
<summary>Monitoring</summary>

- It comes with full integration with CloudWatch
- Read/Write capacity (Units/Second)
- Throttled read/write requests (Count)
- Throttled read/write events (Count)
- Latency for Get, Put, Query and, Scan operations
- Streams: GetRecords returned records (Count), GetRecords returned bytes (Bytes), GetRecords returned latency (Miliseconds), TTL deleted items (Count)
- Errors

</details>

<details>
<summary>Pricing</summary>

- It depends on the used read/write mode: On-demand, Provisioned
- On-demand:
	- No capacity planning is required
	- We're charged by operations (reads and writes)
	- New applications where the workload is too complex to forecast 
	- E.g., for a multi-tenant app. that it uses pay per use pricing: 
		- by using on-demand we make sure that our costs are directly aligned to the income that you're generating from the app
		- So we make sure that wherever price that we sell our application to our customers for we have included an appropriate amount of on-demand pricing for our underlying database
- Provisioned:
	- We specify a read and write capacity value on a table
	- It's cheaper than On-demande mode
- Reads:
	- Any costs for DynamoDB are based on strongly consistent reads 
	- Eventually consistent reads are half the cost of strongly consistent reads

</details>

<details>
<summary>Use cases</summary>

- Unstructured data:
	- Keys and values
	- Keys and other attributes
	- Json documents
	- Complex data types
- Serverless Applications that needs a web scale database, a serverless non relational database (not a fixed schema) + ID federation 
- It isn't for relational data

</details>

<details>
<summary>Limits</summary>

- Item's max size: 400 KB; it includes:
	- Attribute name binary length (UTF-8 length) 
	- Attribute value lengths (again binary length)
	- E.g., an item with 2 attributes: 
		- 1st is "shirt-color" with value "R" and 
		- 2nd is "shirt-size" with value "M" 
		- Item Total Size is 23 bytes 
- Table's hard max LSI #: 5
- Table's default max GSI #: 20 (could be increased by a support ticket)
- [For more details](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Limits.html)

</details>

<details>
<summary>Best practices</summary>

- [More details](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)

</details>

---

## Database - In-Memory Caching:

---

## Hybrid and Scaling - Load Balancing and Auto Scaling:

---

## Hybrid and Scaling - VPN and Direct Connect:

---

## Hybrid and Scaling - Snow*:

---

## Hybrid and Scaling - Identity Federation and SSO:

---

## Application Integration:

---

## Analytics:

---

## Logging and Monitoring:

---

##  Operations:

---

## Deployment:

---
