# training.computerscience.cloud.aws
## Network - VPC (Virtual Private Cloud):
![VPC Architecture with UML notations](https://awscertifiedsolutionsarchitectassociatedocs.s3.amazonaws.com/VPCArchitectureUML.PNG)
 
<details>
<summary>Description</summary>
    
- It is a virtual network within AWS: it is our private data center inside AWS platform
- It can be configured to be public/private or a mixture.
- [ ] It is isolated from other VPCs by default.
	- [ ] It can't talk to anything outside itself unless we configure it otherwise.
	- [ ] It's isolated from network blast radius.
- [ ] It is Regional: it can't span regions.
- [ ] It is highly available: it is on multiple AZs which allows a HA (Highly Available) architecture.
- [ ] It can be connected to our data center and corporate networks: Hardware Virtual Private Network (VPN).
- [ ] It supports different Tenancy types: it could be:
	- [ ] Dedicated tenant: it can't be changed (Locked). It is expensive.
	- [ ] multi-tenant (default): it still could be switched to a dedicated tenant. 

</details>
