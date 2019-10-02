#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
yum install amazon-efs-utils -y