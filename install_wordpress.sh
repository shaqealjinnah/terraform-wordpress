#!/bin/bash
# Update packages
apt-get update -y
apt-get upgrade -y

# Install Apache, MySQL, PHP
apt-get install -y apache2 php php-mysql libapache2-mod-php mysql-server wget unzip

# Start services
systemctl start apache2
systemctl enable apache2
systemctl start mysql
systemctl enable mysql

# MySQL Setup
mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'StrongPassword123';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Install WordPress
cd /var/www/html
rm -f index.html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# Configure WordPress
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/wpuser/" wp-config.php
sed -i "s/password_here/StrongPassword123/" wp-config.php

# Set permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Enable Apache rewrite
a2enmod rewrite
systemctl restart apache2