#!/bin/bash

echo "
Deploying the app named `jobs-ingestion`..."
APP_NAME="jobs-ingestion"
# name of the manually created bucket
TFSTATE_BUCKET_NAME="jobs-dashboard-tfstate"
REGION="eu-west-1"

echo "
Please type the stage name (like production, staging or development):"
read STAGE

echo "
Please type the aws cli profile:"
read AWS_PROFILE

# the key defines the path to the `.tfstate` file inside the s3 bucket
terraform init \
    -backend-config="region=${REGION}"
    -backend-config="bucket=${TFSTATE_BUCKET_NAME}"
    -backend-config="key=${APP_NAME}-${STAGE}/terraform.tfstate"
terraform apply \
    -var stage=$STAGE -var app_name=$APP_NAME \
    -var region=$REGION -var aws_profile=$AWS_PROFILE
