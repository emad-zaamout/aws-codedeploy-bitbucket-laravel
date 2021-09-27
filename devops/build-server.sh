#!/bin/bash

# Author Emad Zaamout | support@ahtcloud.com
# Used inside Bitbucket pipelines. Builds our server for testing stage.

# Update/Install Packages
# use -y flag to prevent "Do you want to continue [Y/n]?" prompt from breaking our build process.
# use -q flag to make apt-get show less infomration in the logs (lessn noise).
apt -qy update
apt -qy install curl git zip unzip

docker-php-ext-install pdo_mysql ctype bcmath zip

# Install Composer
curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install NPM
apt -qy install npm

# ========================================
# PHP Extensions List
# ========================================
# bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd
# gettext gmp hash iconv imap interbase intl json ldap mbstring mysqli oci8 odbc
# opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql
# pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop
# simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy
# tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zend_test zip
