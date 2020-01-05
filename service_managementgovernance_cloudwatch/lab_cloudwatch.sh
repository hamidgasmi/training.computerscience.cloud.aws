#1. Connect to the EC2 instance:
ssh cloud_user@ec2-35-170-58-205.compute-1.amazonaws.com
#1. Install the CloudWatch agent:
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
#2. Execute the CloudWatch agent wizard:
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
#... Do you want to monitor any log files? 1 (Yes)
#Start the CloudWatch agent:
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s