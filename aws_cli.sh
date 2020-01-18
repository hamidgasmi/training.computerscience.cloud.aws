##CLI Doc: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
#01. Configuration
##00.01: Linux Installation
sudo yum install epel-release 
sudo yum install python-pip 
sudo pip install awscli 

### Check if aws installation succeeds: # 
  
#02. IAM
##02.01. Authentication by secret keys: Not recommended (see reasons, below)! 
aws configure
### AWS Secret Access Key [None]: enter Key 
### AWS Secret Access Key [None]: enter Key 
### Default region name [Access Key]: us-east-1 
### Default output format [exist]: json 
 
### If aws is hacked, secret keys will be found in ~/.aws folder. # 
cd ~/.aws 
ls 
### config  credentials 
nano credentials  

##02.01. Authentication by login and password to an EC2 instance: 
ssh cloud_user@107.21.4.52 
###Password:  

### Get the policy (role) details, including the current version  
aws iam get-policy --policy-arn "arn:aws:iam::241021092242:policy/DevS3ReadAccess"
aws iam get-policy --policy-arn "arn:aws:iam::241021092242:role/DEV_ROLE"
### Get the policy details of a specific version 
aws iam get-policy-version --policy-arn "arn:aws:iam::241021092242:policy/DevS3ReadAccess" --version-id "v1" 

##02.02. IAM Users
	
##02.03. IAM Groups
 
##02.04. IAM Groups
###List all attached permission policies attached to a role
aws iam list-attached-role-policies --role-name DEV_ROLE


###02.04.01 Create IAM EC2 Role:
### Create a Json Trust Policy for an EC2 role
cat ./service_compute_ec2/roles/trust_policy_ec2.json
### Create the IAM role with the Trust Policy only
aws iam create-role --role-name DEV_ROLE --assume-role-policy-document file://service_compute_ec2/roles/trust_policy_ec2.json
### Create a Json role permission policy
cat ./service_compute_ec2/roles/dev_s3_read_access.json 
### Create a Managed Policy with the json file
aws iam create-policy --policy-name DevS3ReadAccess --policy-document file://service_compute_ec2/roles/dev_s3_read_access.json 
### Attach Managed Policy to the Role created above: 
aws iam attach-role-policy --role-name DEV_ROLE --policy-arn "arn:aws:iam::241021092242:policy/DevS3ReadAccess" 

#03. EC2:
#03.1 Stress test an EC2 instance:
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
stress --cpu 2 --timeout 30
#Get user data from an EC2 instance:
curl http://169.254.169.254/latest/user-data 
#Get EC2 meta-data from an EC2 instance: get available options
curl http://169.254.169.254/latest/meta-data/ 
#Get a specific EC2 meta-data from an EC2 instance (E.g., local-ipv4):
curl http://169.254.169.254/latest/meta-data/local-ipv4/ 

#06. VPC:
##06.01. Internet Gateway
#....... Attach a detached an IGW to a VPC 
aws ec2 attach-internet-gateway --vpc-id "vpc-092020d901c843073" --internet-gateway-id "igw-0bc2368fff8eeddbb" --region us-east-1 

#08. S3:
#08.1 Manage s3 buckets:
#..... Select all S3 buckets
aws s3 ls
#..... Create an s3 bucket:
aws s3
#..... Delete an empty bucket
aws s3 rb s3://my-bucket
#..... Delete a non empty bucket (non versioned objects)
aws s3 rb s3://my-bucket --force
#08.3 List object of a bucket
aws s3 ls --recursive s3://my-bucket
#08.2 Manage objects in a bucket:
#..... Copy a file from EC2 to S3 bucket
aws s3 cp index.html s3://my-bucket 
#..... Multipart uploading (Create a 10GB file + Multipart uploading)
dd if=/dev/zero of=10GBfile.data bs=1M count=10240
aws s3 cp ./10GBfile.data s3://my-bucket/
#..... Delete an object in S3
aws s3 rm s3://my-bucket/myfile
#..... Presigned URLs: Create a presigned URL that expires in 1 hour:
aws S3 presign s3://my-bucket/myfile --expires-in 3600
#...... Invalidate a presigned URL
#...... It's not possible!
#...... Copy a folder To an S3 bucket: 
aws s3 cp --recursive ./my-folder s3://my-bucket 
#...... Synchronize a folder that is previously copied to S3 
aws s3 sync ./my-folder s3://my-bucket

#10. EFS:
#10.1 Install Amazon EFS utilities
sudo yum install -y amzon-efs-utils
#10.2 Create a file system which type is EFS:
sudo mkdir /mnt/myefs
sudo mount -t efs [fs-ID]:/ /mnt/myefs
cd /mnt/myefs

#24. SNS:

#25. SQS:
aws sqs get-queue-attributes --queue-url https://URL --attribute-names All
aws sqs send-message --queue-url https://URL --message-body "INSERTMESSAGE"
aws sqs receive-message --queue-url https://URL
aws sqs delete-message --queue-url https://URL --receipt-handle "INSERTHANDLE"
aws sqs receive-message --wait-time-seconds 10 --max-number-of-messages 10 --queue-url https://URL
aws sqs --region us-east-1 receive-message --wait-time-seconds 10 --max-number-of-messages 10 --queue-url https://URL
aws sqs delete-message --queue-url https://URL --receipt-handle "INSERTHANDLE"

#31. KMS:
#31.1. Create a Customer Managed CMK
#31.1.1 Linux/Mac OS
aws kms create-key --description "LA KMS DEMO CMK"
aws kms create-alias --target-key-id XXX --alias-name "alias/lakmsdemo" --region us-east-1
echo "this is a secret message" > topsecret.txt
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob 
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob | base64 --decode > topsecret.encrypted
aws kms decrypt --ciphertext-blob fileb://topsecret.encrypted --output text --query Plaintext | base64 --decode 
aws kms generate-data-key --key-id KEYID --key-spec AES_256 --region us-east-1
#31.1.2. Windows:
aws kms create-key --description "LA KMS DEMO CMK"
aws kms create-alias --target-key-id XXX --alias-name "alias/lakmsdemo" --region us-east-1
echo "this is a secret message" topsecret.txt
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob 
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob > topsecret.base64.encrypted
certutil -decode topsecret.base64.encrypted topsecret.encrypted

aws kms decrypt --ciphertext-blob fileb://topsecret.encrypted --output text --query Plaintext > topsecret.decrypted.base64
certutil topsecret.decrypted.base64 topsecret.decrypted
#31.2. Create a DEK
#31.2.1 Linux/Mac OS:
aws kms generate-data-key --key-id KEYID --key-spec AES_256
#31.2.2. Windows:
aws kms generate-data-key --key-id KEYID --key-spec AES_256

