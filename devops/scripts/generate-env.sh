#!/bin/bash
# Author Emad Zaamout | support@ahtcloud.com

# loads your .env file stored inside AWS Systems Manager (Paramater).

# aws paramater store name & region
PARAMATER="aws-codedeploy-bitbucket-laravel-ENV"
REGION="ca-central-1"

# Get parameters and put it into .env file inside application root
aws ssm get-parameter \
  --with-decryption \
  --name $PARAMATER \
  --region $REGION \
  --with-decryption \
  --query Parameter.Value \
  --output text > $WEB_DIR/.env

# Clear laravel configuration cache
chown $WEB_USER. .env
sudo -u $WEB_USER php artisan config:clear
