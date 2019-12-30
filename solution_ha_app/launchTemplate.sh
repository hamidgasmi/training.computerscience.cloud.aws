#!/bin/bash
yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/linuxacademy/content-aws-csa2019/master/lab_files/07_hybrid_scaling/ASGandALB/index.html
wget https://raw.githubusercontent.com/linuxacademy/content-aws-csa2019/master/lab_files/07_hybrid_scaling/ASGandALB/pinehead.png
service httpd start