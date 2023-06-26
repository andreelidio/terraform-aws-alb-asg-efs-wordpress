#!/bin/bash
apt-get install httpd php php-mysql -y
cd /var/www/html
wget https://wordpress.org/wordpress-5.1.1...
tar -xzf wordpress-5.1.1.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf wordpress-5.1.1.tar.gz
chmod -R 755 wp-content
chown -R apache:apache wp-content
service httpd start
chkconfig httpd on

#Create EFS
mkdir /efs
mount -t efs ${workpress_efs}:/ /efs
echo ${workpress_efs}:/ /efs efs defaults,_netdev 0 0 >> /etc/fstab