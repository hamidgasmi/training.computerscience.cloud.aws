#01. AMI
#01.1 aws configure
aws configure

#02. EC2:
#02.1 Stress test an EC2 instance:
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
stress --cpu 2 --timeout 30

#03. VPC
#04. Route 53:
#05. S3:
#05.1 Manage s3 buckets:
#..... Select all S3 buckets
aws s3 ls
#..... Create an s3 bucket:
aws s3
#..... Delete an empty bucket
aws s3 rb s3://my-bucket
#..... Delete a non empty bucket (non versioned objects)
aws s3 rb s3://my-bucket --force
#05.3 List object of a bucket
aws s3 ls --recursive s3://my-bucket
#05.2 Manage objects in a bucket:
#..... Multipart uploading (Create a 10GB file + Multipart uploading)
dd if=/dev/zero of=10GBfile.data bs=1M count=10240
aws s3 cp ./10GBfile.data s3://mybucket/
#..... Delete an object in S3
aws s3 rm s3://mybucket/myfile
#..... Presigned URLs: Create a presigned URL that expires in 1 hour:
aws S3 presign s3://mybucket/myfile --expires-in 3600
#...... Invalidate a presigned URL
#...... It's not possible!

#06. EFS:
#06.1 Install Amazon EFS utilities
sudo yum install -y amzon-efs-utils
#06.2 Create a file system which type is EFS:
sudo mkdir /mnt/myefs
sudo mount -t efs [fs-ID]:/ /mnt/myefs
cd /mnt/myefs

#07. RDS:

#08. KMS:
#08.1. Create a Customer Managed CMK
#08.1.1 Linux/Mac OS
aws kms create-key --description "LA KMS DEMO CMK"
aws kms create-alias --target-key-id XXX --alias-name "alias/lakmsdemo" --region us-east-1
echo "this is a secret message" > topsecret.txt
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob 
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob | base64 --decode > topsecret.encrypted
aws kms decrypt --ciphertext-blob fileb://topsecret.encrypted --output text --query Plaintext | base64 --decode 
aws kms generate-data-key --key-id KEYID --key-spec AES_256 --region us-east-1
#08.1.2. Windows:
aws kms create-key --description "LA KMS DEMO CMK"
aws kms create-alias --target-key-id XXX --alias-name "alias/lakmsdemo" --region us-east-1
echo "this is a secret message" topsecret.txt
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob 
aws kms encrypt --key-id KEYID --plaintext file://topsecret.txt --output text --query CiphertextBlob > topsecret.base64.encrypted
certutil -decode topsecret.base64.encrypted topsecret.encrypted

aws kms decrypt --ciphertext-blob fileb://topsecret.encrypted --output text --query Plaintext > topsecret.decrypted.base64
certutil topsecret.decrypted.base64 topsecret.decrypted
#08.2. Create a DEK
#08.2.1 Linux/Mac OS:
aws kms generate-data-key --key-id KEYID --key-spec AES_256
#08.2.2. Windows:
aws kms generate-data-key --key-id KEYID --key-spec AES_256

#09. SNS:
#10. SQS:
aws sqs get-queue-attributes --queue-url https://URL --attribute-names All
aws sqs send-message --queue-url https://URL --message-body "INSERTMESSAGE"
aws sqs receive-message --queue-url https://URL
aws sqs delete-message --queue-url https://URL --receipt-handle "INSERTHANDLE"
aws sqs receive-message --wait-time-seconds 10 --max-number-of-messages 10 --queue-url https://URL
aws sqs --region us-east-1 receive-message --wait-time-seconds 10 --max-number-of-messages 10 --queue-url https://URL
aws sqs delete-message --queue-url https://URL --receipt-handle "INSERTHANDLE"