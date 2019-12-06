# AWS:
## Compute - EC2 (Elastic Cloud Computing):

---

## Networking - VPC (Virtual Private Cloud):

<details>
<summary>Architecture (UML notations)</summary>

![VPC Architecture with UML notations](https://awscertifiedsolutionsarchitectassociatedocs.s3.amazonaws.com/VPC_ArchitectureUML.PNG)

</details>

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

- Use Case:
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
	- Use case: there is only one use case
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
- Use case:
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
- Use case:
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
- It allows outbound and inbound response traffic.
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
- Objects are replicated across all its region AZs
- It's a universal namespace:  
	- A bucket name must be unique globally
	- Its URL format is: https://region.amazonaws.com/bucketname
	- E.g., https://selfservedweb.s3.amazonaws.com/Web_Scalability_for_StartupEngineers.pdf

</details>
 
<details>
<summary>Permission</summary>

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
<summary></summary>
</details>

<details>
<summary>Limits</summary>

- Unlimited storage
- Unlimited object #
- Default limit of 100 buckets / AWS account
- Hard limit of 5 GB / PUT
- Hard limit of 3500 PUTs / second 

</details>

- [S3 FAQ](https://aws.amazon.com/s3/faqs/)

    S3 guarantees:
		Built for availability of 4 nines (99.99%) for S3 platform

How does data consistency work on the cloud:
    Read after write consistency for PUTS of new objects: a new object is ready to read as soon as it is uploaded

    Eventual consistency for overwrite PUTS and DELETE:
        The update or delete may need some time to propagate
        It means for example, the for a short time (less than a second?) we could get the previous version
        After this short time, we'll always get the current version regardless of our location

S3 Features:
    Tiered Storage Available: See below
        See different tiers below
        It could be at bucket level or storage level

    Lifecycle Management:
        Automate moving files/versions in S3 tiers
        It is done by creating Life Cycle rules
        We could add tags to make the rule applied to specific objects
        Storage class transition could be enabled for current versions or/and previous versions
        Configure object expirations
        Clean up expired object delete markers (You cannot enable clean up expired object delete markers if you enable Expiration)
         Clean up incomplete multipart uploads

    Cross Region Replication (CRR):
        Use cases:
            Compliancy of data and making sure data is kept in a dedicated region (for example for GDPR compliance)
            To minimize latency for your applications using the S3 bucket
        It includes: 
            Files data
            Files permission (replicated files will have same permission as source files)
        Versioning is required
        The replication isn't done on existing files (only new files uploaded after the rule is created)
        It supports replication of an entire bucket or based on prefixes, one or more object tags or a combination of the two
        We can set overlapping rules with priorities
        It does not support delete marker replication: it would prevent any delete actions from replicating
        Replicate object encrypted with AWS KMS?
        Buckets configured for cross-region replication can be owned by the same AWS account or by different accounts

    Versioning:  
        once it is enabled, we can't disable it
        Be careful, the bucked size could get very big. Since the previous versions aren't deleted
        If versions are hided and a file is deleted, a new version will be created and marked as deleted

        If we delete the version marked as deleted, be go back to the latest version before the deletion
        To delete physically the files, all versions should be selected and deleted

    MFA Delete:  
        Versioning is required

    Secure our data using Access Control Lists and Bucket Policies. 
        Permission could be setup on buckets and theirs objects (files). 

S3 Class (Tiers): 
    S3 Standards:
        Amazon guarantees an available of 3 nines (99.9%)
        Amazon guarantees a durability of 11 nines (99.999999999%) for S3 information
        Redundancy across multiples devices in multiple facilities
        It is designed to sustain the loss of 2 facilities concurrently
        First byte latency: milliseconds

    S3 IA (Infrequently Accessed): 
        It is for data that is accessed less frequently,
        But it requires a rapid access when needed
        Lower fee than S3 for storage
        But we're charged a retrieval fee
        Amazon guarantees a durability of 11 nines (99.999999999%) for S3 information
        Availability SLA: available of 3 nines (99.9%)
        First byte latency: milliseconds

    S3 One Zone - IA 
        It doesn't required the multiple availability zone
        Lower-cost option accessed data
        Amazon guarantees a durability of 11 nines (99.999999999%) for S3 information
        Availability SLA: 2 nines of availability (99.5%). 
        First byte latency: milliseconds

    S3 - Intelligent Tiering: 
        Designed to optimize cost 
        It relies to a machine learning to automatically move data the most-effective access tier 
        Without performance impact or operational overhead. 
        Availability SLA: 2 nines of availability (99%)
        First byte latency: milliseconds

    S3 - Glacier: 
        It is a secure, durable and low cost storage class for data archiving. 
        Retrieval time is configurable: from minutes to hours. 
        Availability SLA: 2 nines of availability (99%). 
        First byte latency: select minutes or hours. 

    S3 - Glacier Deep Archive: 
        It is S3 lowest-cost storage class 
        Availability SLA: 2 nines of availability (99%). 
        First byte latency: select hours (Retrieval time >= 12 hours). 

    S3 RRS - Reduced Redundancy Storage 
        It is obsolete. 
        Durability of 4 nines (99.99%). 
        Availability SLA: ?. 
        First byte latency: milliseconds. 
 
S3 Pricing: 
    Storage: Gigabyte used 
    Requests: nbr of requests to this objects (read, write?) 
    Storage Management Pricing: S3 Tier used. 
    Data Transfer Pricing: 
    Transfer Acceleration: uses Amazon CDN (AWS CloudFront). 
    Cross Region Replication Pricing: replication for availability. 

S3 Log requests:
    All requests to S3 bucket could be logged. 
    We could store logs in another S3 bucket in the same AWS account or even in a completely different AWS account. 

---

