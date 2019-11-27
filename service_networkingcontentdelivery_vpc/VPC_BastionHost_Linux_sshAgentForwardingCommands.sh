chmod 400 vpcdemo.pem
#ssh Agent Forwarding
ssh-add -k vpcdemo.pem
#ssh the bastion host: To avoid copying the pem key to the bastion host:
ssh -A -i "vpcdemo.pem" ec2-user@54.82.83.247.compute-1.amazonaws.com
#ssh the private EC2 instance: uses the pem key that is in my local machine via the bastion host:
ssh ec2-user@10.0.11.199
