#!/bin/bash

# Author Emad Zaamout | support@ahtcloud.com
# Builds Laravel App for production. Used inside Bitbucket pipelines to build
# our project and prepare it for deployment.

# Install Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#composer install --no-dev --no-interaction

# Install NPM
#apt -qy install node
apt -qy install npm

npm install
npm run prod

# Install aws cli (used by deploy scripts)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf ./aws
rm -f awscliv2.zip

# clean up
rm -rf ./aws
rm -rf awscliv2.zip
