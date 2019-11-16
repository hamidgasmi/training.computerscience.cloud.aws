# training.computerscience.cloud.aws
## Network - VPC (Virtual Private Cloud):
![VPC Architecture with UML notations](https://awscertifiedsolutionsarchitectassociatedocs.s3.amazonaws.com/VPCArchitectureUML.PNG)
 
<details>
<summary>Description</summary>
    
- It is a virtual network within AWS: it is our private data center inside AWS platform
- It can be configured to be public/private or a mixture.
- It is isolated from other VPCs by default.
	- It can't talk to anything outside itself unless we configure it otherwise.
	- It's isolated from network blast radius.
- It is Regional: it can't span regions.
- It is highly available: it is on multiple AZs which allows a HA (Highly Available) architecture.
- It can be connected to our data center and corporate networks: Hardware Virtual Private Network (VPN).
- It supports different Tenancy types: it could be:
	- Dedicated tenant: it can't be changed (Locked). It is expensive.
	- multi-tenant (default): it still could be switched to a dedicated tenant.
- IPv4 CIDR:
	- From /28 (16 IPs) to /16 (65,536 IPs) 
	- We need to plan in advance CIDR to support whatever service we will deploy in the VPC:
	 	- [ ] We need to make sure our CIDR will support enough subnets.
	 	- [ ] We need to make sure our CIDR will let our subnets have enough IP addresses.
	 	- [ ] Some AWS services require a minimum number of IP addresses before they can deploy.
	- We need to plan a CIDR that allows HA architecture:
	 	- [ ] We need to break our CIDR down based on the number of AZs we will be using and then 
	 	- [ ] We need to break down our CIDR based on the number of tiers (subnets) our VPC will have. E.g., public/private/db tiers.
	- We need to plan for future evolutions: additional AZs, additional tiers (subnets).
	- Best Practice: ensure that VPCs we work with don't overlap CIDR blocks, whatever this is possible:
	 	- [ ] Lots of networking features don't like the same CIDR block.
	 	- [ ] This will just make things a lot easier further down.
	 	- [ ] Our corporate network VPCs, any other VPC we work with, 
	 	- [ ] VPCs of any partners and vendors that we interact with.
	- Best Practice: It is recommended to plan for our VPC in advance even though, we can now update VPC CIDR..
- IPv6: 
	- It supports IPv6.
	- It isn't yet supported by all AWS services, though.
	- AWS provides IPv6 blocks.
- Default VPC:
	- It is created by default in every region for each new AWS account (to make easy the onboarding process).
	- It is required for some services:
	 	- [ ] Historically some services failed if the default VPC didn't exist.
	 	- [ ] It was initially not something we could create, but we could delete it.
	 	- [ ] So if we delete, we could run into problems where certain services wouldn't launch,
	 	- [ ] We needed to create a ticket to get it recreated on our behalf.
	- It is used as a default for most.
	- Initial state of Default VPC:
	 	- [ ] CIDR: default 172.31.0.0/16 (65,000 IP addresses)
	 	- [ ] Subnet: 1 /20 public subnet by AZ
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
	- Initial state of Default VPC:
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