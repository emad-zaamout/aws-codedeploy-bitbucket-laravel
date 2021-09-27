#!/bin/bash
# Author Emad Zaamout | support@ahtcloud.com

# Not used anywhere. Just helps you set up apache2 conf, disable default site and enable new site. Change variables.
APACHE_DIR="/etc/apache2"
CONFIG_FILE_NAME="aws-codedeploy-bitbucket-laravel.conf"
WEBSITE_DIR="/var/www/aws-codedeploy-bitbucket-laravel"
SERVER_ADMIN="your@email.com"
# were using our server public ip. If you want to use a domain, make sure to
# change those values
SERVER_NAME=$(wget -qO- ifconfig.me/ip)
SERVER_ALIAS=$(wget -qO- ifconfig.me/ip)

cd $APACHE_DIR/sites-availiable

echo "<VirtualHost *:80>" > $CONFIG_FILE_NAME
echo "  ServerAdmin $SERVER_ADMIN" >> $CONFIG_FILE_NAME
echo "  ServerName $SERVER_NAME" >> $CONFIG_FILE_NAME
echo "  ServerAlias $SERVER_ALIAS" >> $CONFIG_FILE_NAME
echo "  DocumentRoot $WEBSITE_DIR/public" >> $CONFIG_FILE_NAME
echo "  ErrorLog ${APACHE_LOG_DIR}/error.log" >> $CONFIG_FILE_NAME
echo "  CustomLog ${APACHE_LOG_DIR}/access.log combined" >> $CONFIG_FILE_NAME
echo "  <Directory $WEBSITE_DIR>" >> $CONFIG_FILE_NAME
echo "    Require all granted" >> $CONFIG_FILE_NAME
echo "    AllowOverride All" >> $CONFIG_FILE_NAME
echo "    Options Indexes Multiviews FollowSymLinks" >> $CONFIG_FILE_NAME
echo "  </Directory>" >> $CONFIG_FILE_NAME
echo "</VirtualHost>" >> $CONFIG_FILE_NAME

# disable default site + enable new site
sudo a2dissite 000-default.conf
sudo a2ensite $CONFIG_FILE_NAME

# enable rewrite module
sudo a2enmod rewrite

# restart apache
sudo /etc/init.d/apache2 restart
