#! /bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><body><h1>Hello</h1></html></body>" > index.html
aws s3 cp index.html s3://selfservedweb