sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
cd /var/www/html/
sudo cp wp-config-sample.php wp-config.php
sudo nano wordpress/wp-config.php

sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 775 /var/www
sudo find /var/www -type d -exec sudo chmod 2775 {} \;
sudo find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd
