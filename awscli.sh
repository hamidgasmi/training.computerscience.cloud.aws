#1. AMI
#1.1 aws configure
aws configure
#2. EC2:
#3. VPC
#4. Route 53:
#5. S3:
#5.1 Manage objects in a bucket:
#..... Select all S3 buckets
aws s3 ls
#..... Delete an object in S3
aws s3 rm s3://mybucket/myfile
#5.1. Multipart uploading
#...... Create a 10GB file
dd if=/dev/zero of=10GBfile.data bs=1M count=10240
aws s3 cp ./10GBfile.data s3://mybucket/
#5.2. Presigned URLs
#...... Create a presigned URL that expires in 1 hour:
aws S3 presign s3://mybucket/myfile --expires-in 3600
#...... Invalidate a presigned URL
#...... It's not possible!
