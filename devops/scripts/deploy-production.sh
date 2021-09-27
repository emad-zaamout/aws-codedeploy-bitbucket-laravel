#!/bin/bash
# Author Emad Zaamout | support@ahtcloud.com

# Runs inside Bitbucket pipelines. Creates a tar bundle for our project
# and stores it in AWS S3 Bucket. Then creates a new deployment using
# AWS CodeDeploy. The files are listed inside the bundle.conf file.

# Make sure you set the following Repository Variables inside Bitbucket [Repository Settings].

# S3_BUCKET
# APPLICATION_NAME = CodeDeploy application name
# DEPLOYMENT_CONFIG_NAME = CodeDeploy > Deployment Configuration
# DEPLOYMENT_GROUP_NAME = your CodeDeploy > Deployments > Deployment Group Column

HASH=`git rev-parse --short HEAD`
BUNDLE=$HASH.tar.gz
S3_BUCKET_ENDPOINT="s3://$S3_BUCKET/bundles/"

rm -rf bundle-*.tar.gz

tar \
  --exclude='*.git*' \
  --exclude='storage/logs/*' \
  --exclude='vendor/*' \
  --exclude='bootstrap/cache/*' \
  --exclude='artifact/*' \
  --exclude='.styleci.yml' \
  --exclude='.env' \
  -zcf $BUNDLE -T bundle.conf > /dev/null 2>&1

aws s3 cp $BUNDLE $S3_BUCKET_ENDPOINT > /dev/null 2>&1
echo "[-] Your CodeDeploy S3 endpoint will be: $S3_BUCKET_ENDPOINT$BUNDLE"

# https://docs.aws.amazon.com/cli/latest/reference/deploy/create-deployment.html
aws deploy create-deployment \
  --application-name $APPLICATION_NAME \
  --deployment-config-name $DEPLOYMENT_CONFIG_NAME \
  --deployment-group-name $DEPLOYMENT_GROUP_NAME \
  --file-exists-behavior OVERWRITE \
  --s3-location bucket=$S3_BUCKET_ENDPOINT,bundleType=tgz,key=bundles/$BUNDLE
