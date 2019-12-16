#1. AMI
#1.1 aws configure
aws configure
#2. EC2:
#3. VPC
#4. Route 53:
#5. S3:
#5.1 Manage s3 buckets:
#..... Select all S3 buckets
aws s3 ls
#..... Create an s3 bucket:
aws s3
#..... Delete an empty bucket
aws s3 rb s3://my-bucket
#..... Delete a non empty bucket (non versioned objects)
aws s3 rb s3://my-bucket --force
#5.2 Manage objects in a bucket:
#..... Multipart uploading (Create a 10GB file + Multipart uploading)
dd if=/dev/zero of=10GBfile.data bs=1M count=10240
aws s3 cp ./10GBfile.data s3://mybucket/
#..... Delete an object in S3
aws s3 rm s3://mybucket/myfile
#..... Presigned URLs: Create a presigned URL that expires in 1 hour:
aws S3 presign s3://mybucket/myfile --expires-in 3600
#...... Invalidate a presigned URL
#...... It's not possible!
#6. EFS:
#6.1 Install Amazon EFS utilities
sudo yum install -y amzon-efs-utils
#6.2 Create a file system which type is EFS:
sudo mkdir /mnt/myefs
sudo mount -t efs [fs-ID]:/ /mnt/myefs
cd /mnt/myefs
#7. RDS:


