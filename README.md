# AWS
## Compute - EC2 (Elastic Cloud Computing):

---

## Networking - VPC (Virtual Private Cloud):

<details>
<summary>Architecture (UML notations)</summary>

![VPC Architecture with UML notations](https://awscertifiedsolutionsarchitectassociatedocs.s3.amazonaws.com/VPCArchitectureUML.PNG)

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
- IPv4 CIDR:
	- From /28 (16 IPs) to /16 (65,536 IPs) 
	- We need to plan in advance CIDR to support whatever service we will deploy in the VPC:
	 	- [ ] We need to make sure our CIDR will support enough subnets
	 	- [ ] We need to make sure our CIDR will let our subnets have enough IP addresses
	 	- [ ] Some AWS services require a minimum number of IP addresses before they can deploy
	- We need to plan a CIDR that allows HA architecture:
	 	- [ ] We need to break our CIDR down based on the number of AZs we will be using and then 
	 	- [ ] We need to break down our CIDR based on the number of tiers (subnets) our VPC will have. E.g., public/private/db tiers
	- We need to plan for future evolutions: additional AZs, additional tiers (subnets)
	- Best Practice: ensure that VPCs we work with don't overlap CIDR blocks, whatever this is possible:
	 	- [ ] Lots of networking features don't like the same CIDR block
	 	- [ ] This will just make things a lot easier further down
	 	- [ ] Our corporate network VPCs, any other VPC we work with, 
	 	- [ ] VPCs of any partners and vendors that we interact with
	- Best Practice: It is recommended to plan for our VPC in advance even though, we can now update VPC CIDR
- IPv6: 
	- It supports IPv6
	- It isn't yet supported by all AWS services, though
	- AWS provides IPv6 blocks
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
	 	- [ ] Security Group: Default SG allows all inbound traffic from itself; allows all outbound traffic (see below)
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
- DHCP Options Sets:
	- It's a configuration that sets various things that have provided to resources inside a VPC when they use DHCP
	- It's a protocol that allows resources inside a network to auto configure their network card such as IP address
	- It allows any instance in a VPC to point to the specified domain and DNS servers to resolve their domain names
	- More details: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
- VPC DNS hostnames & DNS Resolution:
	- Even when an Internet Gateway is created and attached to a VPC and, 
	- A public IP is associated to an EC2 instance, a DNS name isn't associated to it
	- To do it, we should enable it in VPC > Edit DNS hostnames and Edit DNS resolution
	- Best Practice: Always enable VPC DNS hostnames and, VPC DNS resolution.
</details>

<details>
<summary>Subnet</summary>

- Analogy: it is like a floor (or a component of it) in our data center
- A VPC can have 1 or more subnets: The number of subnets depends on how VPC CIDR is split:
	- If all subnets have the same CIDR prefix, the formula would be: 2^(Subnet CIDR Prefix - VPC CIDR Prefix)
	- For a VPC of /16, we could create:
	- 1 single subnet of /16; 2 subnets of /17; 4 subnets of /18; 8 subnets of /19; 16 subnets of /20;
	- 32 subnets of /21; 64 subnets of /22; 128 subnets of /23; 256 subnets of /24
- It is inside an AZ: subnets can't span AZs
- Subnet max/min IP: same as VPC limit
- Its CIDR blocks:
	- It can't be bigger than CIDR blocks of the VPC it is attached to
	- It can't overlap with any CIDR blocks inside the VPC it is attached to
	- It can't be created outside of the CIDR of the VPC it is attached to
- Certain IPs are reserved in subnets:
	- Subnet's Network IP address: e.g., 10.0.0.0
	- Subnet's Router IP address ("+1"): Example: 10.0.0.1.
	- Subnet's DNS IP address ("+2"): E.g., 10.0.0.2
	 	- [ ] For VPCs with multiple CIDR blocks, the IP address of the DNS server is located in the primary CIDR
	 	- [ ] For more details: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html#AmazonDNS
	- Subnet's Future IP address ("+3"): e.g., 10.0.0.3
	- Subnet's Network Broadcast IP address ("Last"): E.g., 10.0.0.255
	- For more details: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
- Share a subnet: Organization or AWS account
	- Resources deployed to the subnet are owned by the account that deployed them: so we can't update them
	- The account we shared the subnet with can't update our subnet (what if there is a role that allow them so?)
- Subnet & Route Table:
	- A subnet must be associated with 1 and only 1 route table (main or custom)
	- When a subnet is created, it is associated by default to the VPC main route table
- Subnet & NACL:
	- A subnet must be associated with 1 and only 1 NACL (default or custom)
	- When a subnet is created, it is associated by default to the VPC default NACL
- A subnet is Public if:
	- If it is configured to allocate public IP
	- If the VPC has an associated Internet Gateway
	- If it is attached to a route table with a default route to the Internet Gateway
- Default Subnet:
	- It is a subnet that is created automatically by AWS at the same time as a default VPC
	- It is public
	- There is as many default subnets as AZs of the region where the default VPC is created in	
- Convention:
	- Subnet Name: sn-[public/private]-[AZ]: sn-public-a; sn-private-a
	- Subnet range: 
	 	- [ ] In some cases, humans do need to understand the networking structure that we use inside a VPC
	 	- [ ] So, we could match subnet's CIDR to its AZ and its application tear:
	 	- [ ] E.g., for a VPC 10.0.0.0/16 with Subnets: /24 + 2 AZs + 3 tiers (:
		- [ ] For AZ1: (Tier 1, 10.0.11.0); (Tier 2: 10.0.21.0); (Tier 3: 10.0.31.0)
		- [ ] For AZ2: (Tier 1, 10.0.12.0); (Tier 2: 10.0.22.0); (Tier 3: 10.0.32.0)
</details>

<details>
<summary>Router & Route table</summary>

- It is a virtual routing device that is in each VPC (fully managed by AWS)
- It has an interface in every subnet known as the "Subnet+1" address (is it the ENI?)
- It is highly available, scalable, and controls data entering and leaving the VPC and its subnets
- Route table:
	- It controls what the VPC router does with subnet Outbound traffic
	- A subnet must be associated with 1 and only 1 route table (main or custom)
	- Local route:
		- [ ] It's included in all route tables
		- [ ] It can't be deleted from its route table
		- [ ] It matches the CIDR of the VPC and lets traffic be routed between subnets
		- [ ] It doesn't forward traffic to any target because the VPC router can handle it
		- [ ] It allows all subnets in a VPC to be able to talk to one another even if they're in different AZs
	- It contains a collection of Static Routes: 
		- [ ] They're used when traffic from a subnet arrives at the VPC router
		- [ ] They contain a destination and a target: traffic is forwarded to the target if its destination matches the route destination
		- [ ] Default Routes (0.0.0.0/0 v4 and ::/0 v6) could be added that match any traffic not already matched
		- [ ] If multiple routes apply, the most specific is chosen
		- [ ] Example: A /32 (a single IP address) will be chosen before a /24, before a /16, before the default route (0.0.0.0/0) and, before VPC CIDR even the IP address is local
		- [ ] Targets can be IPs or an AWS networking gateway/object (Egress Only Internet Gateway, Instance, Internet Gateway, NAT Gateway, Network Interface, Peering Connection, Transit Gateway, Virtual Private Gateway)			
	- Main Route table:
		- [ ] It's created by default at the same time as a VPC is created
		- [ ] It's allocated by default to all subnets in the VPC
		- [ ] In a default VPC: it routes outbound traffic to local and to outside (Internet Gateway)
		- [ ] In a custom VPC: It routes outbound traffic to local
		- [ ] It's created at the same time as the VPC it is attached to
		- [ ] It's associated "implicitly" to all VPC's Subnets until they're explicitly associated to a custom one
		- [ ] Therefore, if it includes a route to an Internet Gateway, all existing and future subnets will be public by default (if Public IP is enabled)	
	- "Custom" route table: 
		- [ ] It could be created and customized to subnets' requirements.
		- [ ] It is explicitly associated with subnets.
	- Best Practice: 
		- [ ] It is recommended not to update the main route table
		- [ ] It is particularly recommended not to add the route to the Internet Gateway in the main route: 
		- [ ] Because, by default, all VPC's Subnets are associated "implicitly" to the main route
		- [ ] Therefore, if a route to an Internet Gateway is added to the main route, all existing and future subnets will be public by default (if Public IP is enabled)		
	- Route Propagation:
		- [ ] It uses a Virtual Private Gateway that should be associated to the VPC the route table is attached to
		- [ ] We could then elect to propagate any routes that it learned onto this particular route table 
		- [ ] It's a way that we can dynamically populate new routes that are learned by the virtual private gateway, which is used for VPNs on automatically populate our our table
		- [ ] Certain types of AWS networking products (VPN, Direct Connect) can dynamically learn routes using BGP (Border Gateway Protocol)
		- [ ] If we have got a VPN or direct connect that support BGP and we integrate those with our VPC, then we can enable this route propagation to automatically add those routes to our route tables
		- [ ] We don't need then to do it manually by a static route table

</details>

<details>
<summary>Internet Gateway</summary>

- It can route traffic for public IPs to and from the internet
- It is created and attached to a VPC
- A VPC could be attached to 1 and only 1 Internet Gateway
- It doesn't applies public IPv4 addresses to a resource's ENI
- Static NAT (Network Address Translation):
	- It is the process of 1:1 translation where an internet gateway converts a private address to a public IP address
	- It make the instance a true public machine
	- When an Internet Gateway receives any traffic from an EC2 instance, if the EC2 has an allocated public IP: 
		- [ ] Then the Internet Gateway adjusts those traffic's packets
		- [ ] It replaces the EC2 private IP in the packet source IP with the EC2 associated Public IP address
		- [ ] It sends then the packets through to the public Internet
	- When an Internet Gateway receives any traffic from the public internet,
		- [ ] It adjusts those packets,
		- [ ] It replaces the Public IP @ in the packet source IP with the associate EC2 private IP address
		- [ ] It sends then the packets to the EC2 instance through the VPC Router

</details>

<details>
<summary>NACL - Network Access Control Lists</summary>

</details>

<details>
<summary>SG - Security Group</summary>

</details>

<details>
<summary>Bastion Host - JumpBox</summary>

</details>

<details>
<summary>NAT Instances & NAT Gateway</summary>

</details>

<details>
<summary>VPC Peering</summary>

</details>

<details>
<summary>VPC EndPoint</summary>

</details>

<details>
<summary>Flow Logs</summary>

</details>

<details>
<summary>Load Balancers</summary>

</details>

---

## Storage - S3 (Simple Storage Service):

---
