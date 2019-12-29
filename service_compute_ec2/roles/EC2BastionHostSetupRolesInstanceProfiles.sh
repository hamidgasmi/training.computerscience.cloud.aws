#Connect to Bastion Host
ssh cloud_user@34.205.37.191
#Setting up the default region name (us-east-1) and the Default output format (json) 
#Command asks for AWS Access Key ID and Secret Access Key (Blank).
aws configure
#I. Create Dev role
#I.1. Create the trust policy json document:
nano trust_policy_ec2.json
#I.2. Create the role
aws iam create-role --role-name DEV_ROLE --assume-role-policy-document file://trust_policy_ec2.json
#I.3 Create the permission policy json document
nano dev_s3_read_access.json
#I.4 create the managed policy with the json file above
aws iam create-policy --policy-name DevS3ReadAccess --policy-document file://dev_s3_read_access.json
#I.5 Attach the new permission policy to the role
aws iam attach-role-policy --role-name DEV_ROLE --policy-arn "arn:aws:iam::132311681211:policy/DevS3ReadAccess"
#I.6 Verify sitting
#... Verify the managed policy was attached:
aws iam list-attached-role-policies --role-name DEV_ROLE
#... Get the policy details, including the current version:
aws iam get-policy --policy-arn "arn:aws:iam::132311681211:policy/DevS3ReadAccess"
#... Get the permissions associated with the current policy version
aws iam get-policy-version --policy-arn "arn:aws:iam::132311681211:policy/DevS3ReadAccess" --version-id "v1"
#I.7 Create the DEV Instance Profile
aws iam create-instance-profile --instance-profile-name DEV_PROFILE
#I.8 Add role to the new instance profile
aws iam add-role-to-instance-profile --instance-profile-name DEV_PROFILE --role-name DEV_ROLE
#I.9 Verify the configuration:
aws iam get-instance-profile --instance-profile-name DEV_PROFILE
#I.10 Attach the DEV_PROFILE to an Instance:
aws ec2 associate-iam-instance-profile --instance-id i-0a9848612e89442d7 --iam-instance-profile Name="DEV_PROFILE"
#I.11 Verify the configuration:
aws ec2 describe-instances --instance-ids i-0a9848612e89442d7

