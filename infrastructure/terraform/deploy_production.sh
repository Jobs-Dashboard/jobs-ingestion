#!/bin/bash

#--------------------------------------------------------------
# Script used to deploy the infrastructure.
#
# Here we should ask for user input or define variables that:
# * depend on the development environment of the person who is doing the
#   deployment
# * are used it in the `terraform init` command
#--------------------------------------------------------------

# name of the manually created bucket
TFSTATE_BUCKET_NAME="jobs-dashboard-tfstate"
# we have the region here because we use it in the `terraform init`, otherwise
# we would just have this in the production.tfvars file.
REGION="eu-west-1"
AVAILABILITY_ZONE_A="eu-west-1a"
AVAILABILITY_ZONE_B="eu-west-1b"
STAGE="production"
# The aws profile that you want to use for this deployment
# (choose from ~/.aws/credentials).
#read AWS_PROFILE
AWS_PROFILE="default"

APP_NAME="jobs-ingestion"
echo "
Deploying the app named ${APP_NAME}"

# the key defines the path to the `.tfstate` file inside the s3 bucket
terraform init \
    -backend-config="region=${REGION}" \
    -backend-config="bucket=${TFSTATE_BUCKET_NAME}" \
    -backend-config="key=${APP_NAME}-${STAGE}/terraform.tfstate"

terraform destroy \
    -target module.digdag-server.aws_instance._ \
    -var stage=$STAGE -var app_name=$APP_NAME \
    -var region=$REGION -var availability_zone_a=$AVAILABILITY_ZONE_A \
    -var availability_zone_b=$AVAILABILITY_ZONE_B \
    -var aws_profile=$AWS_PROFILE -var-file="${STAGE}.tfvars" \
    -var-file="${STAGE}.secrets.tfvars"

terraform apply \
    -var stage=$STAGE -var app_name=$APP_NAME \
    -var region=$REGION -var availability_zone_a=$AVAILABILITY_ZONE_A \
    -var availability_zone_b=$AVAILABILITY_ZONE_B \
    -var aws_profile=$AWS_PROFILE -var-file="${STAGE}.tfvars" \
    -var-file="${STAGE}.secrets.tfvars"
