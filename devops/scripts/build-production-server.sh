#!/bin/bash
# Author Emad Zaamout | support@ahtcloud.com

# Not used anywhere. Just helps install all what you need on your production server to run a basic laravel project. Run manually.

sudo apt update
sudo apt dist-upgrade
sudo apt install apache2
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt install php8.0
sudo apt install php-curl php-cli php-mbstring git unzip php8.0-mysql php8.0-dom php8.0-xml php8.0-xmlwriter phpunit php-mbstring php-xml
sudo apt install libapache2-mod-php8.0
sudo a2enmod rewrite
sudo /etc/init.d/apache2 restart

# install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Create apache2 virtual host and store it inside ./etc/apache2/sites-availiable.
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
