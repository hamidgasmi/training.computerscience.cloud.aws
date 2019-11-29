# AWS
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
	 	- [ ] Historically some services failed if the default VPC didn't exist
	 	- [ ] It was initially not something we could create, but we could delete it
	 	- [ ] So if we delete, we could run into problems where certain services wouldn't launch,
	 	- [ ] We needed to create a ticket to get it recreated on our behalf
	 	- [ ] It is used as a default for most
	- Its initial state is as follow:
	 	- [ ] CIDR: default 172.31.0.0/16 (65,000 IP addresses)
	 	- [ ] Subnet: 1 "/20" public subnet by AZ
	 	- [ ] DHCP: Default AWS Account DHCP option set is attached
	 	- [ ] DNS Names: Enabled
	 	- [ ] DNS Resolution: Enabled
	 	- [ ] Internet Gateway: Included
	 	- [ ] Route table: Main route table routes traffic to local and Internet Gateway (see below)
	 	- [ ] NACL: Default NACL allows all inbound and outbound traffic (see below)
	 	- [ ] Security Group: Default SG allows all inbound traffic (see below)
	 	- [ ] ENI: Same ENI is used by all subnets and all security group
- Custom VPC (or "Bespoke"): 
	- it can be designed and configured in any valid way
	- Its initial state is as follow:
	 	- [ ] CIDR: initial configuration
	 	- [ ] Subnet: none
	 	- [ ] DHCP: Default AWS Account DHCP option set is attached
	 	- [ ] DNS Names: Disabled
	 	- [ ] DNS Resolution: Enabled
	 	- [ ] Internet Gateway: none
	 	- [ ] Route table: Main route table routes traffic to local (see below)
	 	- [ ] NACL: Default NACL allows all inbound and outbound traffic (see below)
	 	- [ ] Security Group: Default SG allows all inbound traffic from itself; allows all outbound traffic (see below)
	 	- [ ] ENI: none

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
	 	- [ ] For VPCs with multiple CIDR blocks, the IP address of the DNS server is located in the primary CIDR
	 	- [ ] [For more details](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html#AmazonDNS)
	- Subnet's Future IP address ("+3"): e.g., 10.0.0.3
	- Subnet's Network Broadcast IP address ("Last"): E.g., 10.0.0.255
	- [For more details](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)

- Security and Sharing:
	- Share a subnet with Organizations or AWS accounts
	 	- [ ] Resources deployed to the subnet are owned by the account that deployed them: so we can't update them
	 	- [ ] The account we shared the subnet with can't update our subnet (what if there is a role that allow them so?)
	- A subnet is private by default
	- A subnet is Public if:
	 	- [ ] If it is configured to allocate public IP
	 	- [ ] If the VPC has an associated Internet Gateway
	 	- [ ] If it is attached to a route table with a default route to the Internet Gateway

- Type:
	- Default Subnet:
	 	- [ ] It is a subnet that is created automatically by AWS at the same time as a default VPC
	 	- [ ] It is public
	 	- [ ] There is as many default subnets as AZs of the region where the default VPC is created in
	- Custom Subnet: it is a subnet created by a customer in a costum VPC

- Limits:
	- Subnet max/min netmask: /16 ... /28 (same as VPC netmask limit)

- Associations:	
	- Subnet & VPC:
	 	- [ ] A subnet is attached to 1 VPC
	 	- [ ] A VPC can have 1 or more subnets: The number of subnets depends on VPC CIDR range and Subnets CIDR ranges 
	 	- [ ] If all subnets have the same CIDR prefix, the formula would be: 2^(Subnet CIDR Prefix - VPC CIDR Prefix)
	 	- [ ] For a VPC of /16, we could create: 1 single subnet of a /16 netmask; 2 subnets of /17; 4 subnets of /18; ... 256 subnets of /24
	- Subnet & Route Table:
	 	- [ ] A subnet must be associated with 1 and only 1 route table (main or custom)
	 	- [ ] When a subnet is created, it is associated by default to the VPC main route table
	- Subnet & NACL:
	 	- [ ] A subnet must be associated with 1 and only 1 NACL (default or custom)
	 	- [ ] When a subnet is created, it is associated by default to the VPC default NACL

</details>

<details>
<summary>Route table (RT)</summary>

- Description:
	- It controls what the VPC router does with subnet Outbound traffic	
	- It is a collection of Routes:
	 	- [ ] They're used when traffic from a subnet arrives at the VPC router
	 	- [ ] They contain a destination and a target 
		- [ ] Traffic is forwarded to the target if its destination matches the route's destination
	 	- [ ] Default Routes (0.0.0.0/0 IPv4 and ::/0 IPv6) could be added
	- Most Specific Route is always chosen:
	 	- [ ] It's when multiple routes' destination maches with traffic destination
	 	- [ ] A matched /32 destination route (a single IP address) will be always chosen first...
		- [ ] A matched /24 destination route will be chosen before a matched /16 destination route... 
		- [ ] The default route matches with all traffic destination but will be chosen last
	- A route Target can be 
	 	- [ ] An IP @ or 
	 	- [ ] An AWS networking gateway/object: Egress-Only Internet Gateway, Internet Gateway, NAT Gateway, Network Interface, Peering Connection, Transit Gateway, Virtual Private Gateway
	- VPC Router:
	 	- [ ] It is a virtual routing device that is in each VPC (fully managed by AWS)
	 	- [ ] It is highly available, scalable, and controls data entering and leaving the VPC and its subnets

- Location:
	- The Router has an interface in every subnet known as the "Subnet+1" address (is it the ENI?)
	- The Route table isn't neither located in a specific AZ		

- Types:
	- Local Route:
		- [ ] It's included in all route tables
		- [ ] It can't be deleted from its route table
		- [ ] It matches the CIDR of the VPC and lets traffic be routed between subnets
		- [ ] It doesn't forward traffic to any target because the VPC router can handle it
		- [ ] It allows all subnets in a VPC to be able to talk to one another even if they're in different AZs

	- Static Route: 
		- [ ] It's added manually to a route table
	- Propagated Route:
		- [ ] It's added dynamically to a route table by attaching a Virtual Private Gateway (VPG) to the VPC
		- [ ] We could then elect to propagate any route that it learned onto a particular route table 
		- [ ] It's a way that we can dynamically populate new routes that are learned by the VPG
		- [ ] Certain types of AWS networking products (VPN, Direct Connect) can dynamically learn routes using BGP (Border Gateway Protocol)
		- [ ] External networking products (a VPN or direct connect) that support BGP could be integrated with AWS VPC, they can dynamically generate Routes and insert them to a route table
		- [ ] We don't need then to do it manually by a static route table

	- Main Route table:
		- [ ] It's created by default at the same time as a VPC it is attached to
		- [ ] It's associated "implicitly" by default to all subnets in the VPC until they're explicitly associated to a custom one
		- [ ] In a default VPC: it routes outbound traffic to local and to outside (Internet Gateway)
		- [ ] In a custom VPC: It routes outbound traffic to local	
	- "Custom" route table: 
		- [ ] It could be created and customized to subnets' requirements
		- [ ] It is explicitly associated with subnets

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
		- [ ] Then the Internet Gateway adjusts those traffic's packets (Layer 3 in OSI model)
		- [ ] It replaces the EC2 private IP in the packet source IP with the EC2 associated Public IP address
		- [ ] It sends then the packets through to the public Internet
	- When an Internet Gateway receives any traffic from the public internet,
		- [ ] It adjusts those packets as well,
		- [ ] It replaces the Public IP @ in the packet source IP with the associate EC2 private IP address
		- [ ] It sends then the packets to the EC2 instance through the VPC Router

</details>

<details>
<summary>NACL - Network Access Control Lists</summary>

- It is a security feature that operates at Layer 4 of the OSI model (Transport Layer: TCP/UDP and below)
- It could be associated with multiples subnets
- A subnet has to be associated with 1 NACL:
- It impacts traffic crossing the boundary of a subnet
- It doesn't impact traffic local to a subnet: Communications between 2 instances inside a subnet aren't impacted
- It acts FIRST before Security Groups: if an IP is denied, it won't even reach security group
- It is stateless
- There're 2 sets of rules: Inbound and Outbound rules:
	- They're explicitly allow or deny traffic based on:
		- [ ] Traffic Type (protocol), 
		- [ ] Ports or port range, 
		- [ ] Source (or Destination): IP / CIDR: since NACL is involved at Layer 4, the source/destination can't be an AWS object
	- They're processed in number of order, "Rule #": Lowest first
	- When a match is found, that action is taken and processing stops
	- The "*" rule is an implicit deny: It is processed last
- Default NACL:
	- It is created by default at the same as the VPC
	- It is associated "implicitly" to all subnets as long as they're not associated explicitly to a custom NACL 
	- It Allows ALL traffic: Rule 100: Allow everything
- Custom NACL:
	- It is created by users
	- It should be associated "explicitly" to a subnet
	- It does block ALL traffic, by default: it only includes "*" rule only
- Ephemeral Ports:
	- When a client initiates communications with a server, it uses a well-known port # on that server: e.g., TCP/443
	- The response is from that well-known port to an ephemeral port on the client
	- The client decides the ephemeral port (e.g., TCP/22000): they're be thousands!
- To keep in mind: Because NACL are stateless and ephemeral ports are thousands, to manage the overhead of NACL rules is very high. In fact:
	- We should think to "allow" traffic for every "ephemeral" ports on Client Inbound and Outbound rules and, 
	- We should think to "allow" traffic for every "ephemeral" ports on Destination Inbound and Outbound rules as well
	- This means that for a single communication, we might have to worry about 4 individual sets of rules
	- This is why NACLs tend not to be used all that much generally in production usage (Security Groups are preferred)
- Use Case:
	- When we have an explicit deny that we would like to add
	- E.g., we got attacked from an IP @, we may need to deny it
- Best Practice: 
	- Inbound and Outbound Rules # should use an increment of 100: 
		- [ ] 100 for the 1st IPv4 rule, 101 for the 1st IPv6 rule
		- [ ] 200 for the 2nd IPv4 rule, 201 for the 2nd IPv6 rule
	-  Ensure that you place the DENY rules earlier in the table than the ALLOW rules that open the wide range of ephemeral ports

</details>

<details>
<summary>SG - Security Group</summary>

- It's a Software firewall that surrounds AWS products
- It a Layer 5 firewall (session firewall) in OSI model
- It is attached to an ENI
- It's associated with a single VPC: it doesn't span VPC's
- Multiple SGs could be assigned to an EC2 instance
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
	- Source/Destination: Since it is a Layer 5 Firewall, it supports
		- [ ] IP addresses, CIDRs (Layer 4 info)
		- [ ] a Security Group (Layer 5 info)
	- It can auto-reference itself in an Inbound rules' Source 
		- [ ] It allows traffic from itself
		- [ ] All resources in the same SG are allowed to communicate to each other
- Implicit Deny: Explicit Allow > Implicit Deny
	- We can't create rules that deny access
- Default SG: 
	- It is created at the same time as a VPC (Default VPC or Custom VPC)
	- Default VPC allows all inbound and outbound traffic (open to the word)
	- Custom VPC:
		- [ ] Inbound traffic: It allows all inbound traffic from resource with the same SG
		- [ ] Outbound traffic: it allows all outbound traffic
- Custom SG:
	- It is created by users
	- It implicitly denies all inbound traffic: there isn't any inbound rule
	- It allows all outbound traffic

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
		- [ ] Since bastion hosts require specific rules, we could make them in a unique SG
		- [ ] The SG could then be shared with bastion hosts only
		- [ ] It will allow to reduce bastion hosts creation overhead
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
		- [ ] The EC2 L3 layer will create a packet (Src IP, Dest IP) = (10.0.0.10, 1.3.3.7)
		- [ ] The EC2 instance will send the packet to the NAT Gateway
		- [ ] The NAT Gateway will update the packet Src IP by its EIP: (Src IP, Dest IP) = (172.162.0.10, 1.3.3.7)
		- [ ] The NAT Gateway will then send the packet to the Internet Gateway
		- [ ] The Internet Gateway will also update the packet Src IP by its Public IP: (Src IP, Dest IP) = (53.12.23.11, 1.3.3.7)
		- [ ] The Internet Gateway will then send the packet to the Internet
	- Ingoing Traffic:
		- [ ] it is similar to the outgoing process above
		- [ ] In this case, the packet Destination IP is updated
		- [ ] It is updated 1st by the Internet Gateway with the NAT Gateway EIP
		- [ ] Then, it is updated by the NAT Gateway with the EC2 Private IP
- NAT Gateway: 
	- 1 NAT Gateway inside an AZ
	- It requires a Public Subnet and a Public Elastic IP
	- It understands and allow session traffic (layer 5)
	- It's scalable but isn't highly available by design (Redundant): if an AZ fails, all underlying NAT Gateway will fail
	- Best Practice: 
		- [ ] We need 1 NAT Gateway by AZ
		- [ ] We need a Single Route table for each AZ (each NAT Gateway)
		- [ ] Each NAT Gateway should be then associates with all private subnets of the related AZ
	- Performance: 
		- [ ] Initially 5GB of bandwidth 
		- [ ] It can scale to 45GB
		- [ ] For more bandwidth, we can distribute the workload by splitting our resources into multiple subnets inside an AZ
		- [ ] Then specify for each subnet to go to a separate gateway
- NAT Instance:
	- It is a single EC2 instance
	- It could be created from a specific AMI
	- it requires to Disable EC2 Source/Destination Checks:
		- [ ] Each EC2 instance performs source/destination checks by default
		- [ ] This means that the instance must be the source or destination of any traffic it sends or receives
		- [ ] However, a NAT instance must be able to send and receive traffic when the source or destination is not itself
		- [ ] Therefore, it is required tp disable source/destination checks on the NAT instance
	- Disadvantage: 
		- [ ] It is a single point of failure
		- [ ] If the instance is terminated, the route status: blackhole
	- Use case: there is only one use case
		- [ ] When cost saving is absolutely required and, a NAT and bastion hosts are needed
		- [ ] We could then combine bastion host and NAT in the same machine
	- For more details:  
		- [ ] [NAT Instance](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html)
		- [ ] [NAT Gateway vs. NAT Instance](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html)

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
		- [ ] Routes are required at both sides
		- [ ] NACLs and SGs can be used to control access
		- [ ] SG reference is cross-account but it's not cross-region (see limits below)
	- DNS resolution to private IPs can be enabled, 
		- [ ] It is needed in both sides
		- [ ] Public DNSes will therefore be resolved to their private IP and,
		- [ ] It won't be traveling over the public Internet
- Data transit:
	- It is encrypted
	- It uses AWS global-backbone for VPC peering cross-region: low latency and higher performance than public internet
- Limits:
	- VPC CIDR blocks can't overlap
	- Transitive Peering is NOT Possible: 
		- [ ] A VPC can't talk to another VPC through a 3rd VPC
		- [ ] A Direct peering is required between 2 VPCs so that they can talk to each other
	- Cross-Region:
		- [ ] An SG can't be referenced from another region
		- [ ] IPv6 support isn't available cross-region
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
		- [ ] It is used for S3 buckets and DynamoDB
		- [ ] It is similar to Internet Gateway
		- [ ] Its related traffic goes through RT: (Destination, Target) = (AWS Service Prefix Lists, Gateway Endpoint ID)
		- [ ] Prefix Lists are more specific than general public internet (0.0.0.0/0)
		- [ ] Therefore, Prefix Lists will override the use of the IG when they're in the same RT
		- [ ] It can be restricted via policies: full access is selected by default
		- [ ] It is HA (Highly available) across AZs in a region: 1 Gateway endpoint by VPC
	- Interface endpoint:
		- [ ] It is used for most other AWS services such as SNS, SQS
		- [ ] It is an ENI with a private IP address
		- [ ] It provides another unique endpoint for the selected service (different from the service public endpoint)
		- [ ] It is attached to a subnet
		- [ ] For HA, it should be associated with multiple AZs
		- [ ] Its related traffic goes through SGs and NACLs
		- [ ] It doesn't require a RT: it adds or replaces the DNS for the service
		- [ ] It provides multiple DNS names: 1 per selected subnet + 1 general DNS name (not specific for an AZ)
		- [ ] It replaces the default service public DNS when "Private DNS Names" feature is enabled
		- [ ] [For more details about AWS Services endpoint](https://docs.aws.amazon.com/general/latest/gr/rande.html)

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
<summary>Conventions</summary>

- Subnet Name: sn-[public/private]-[AZ]: sn-public-a; sn-private-a
- Subnet range: 
	- In some cases, humans do need to understand the networking structure that we use inside a VPC
	- So, we could match a subnet's CIDR to its AZ and its application tear:
	- E.g., for a VPC 10.0.0.0/16 with Subnets: /24 + 2 AZs + 3 tiers:
		- [ ] For AZ1: (Tier 1, 10.0.11.0); (Tier 2: 10.0.21.0); (Tier 3: 10.0.31.0)
		- [ ] For AZ2: (Tier 1, 10.0.12.0); (Tier 2: 10.0.22.0); (Tier 3: 10.0.32.0)
- Peering Connection name: pc-[Requester VPC name]-[Accepter VPC name]. E.g., pc-VPC1-VPC2

</details>

---
## Networking - Route 53:

---

## Storage - S3 (Simple Storage Service):

---
