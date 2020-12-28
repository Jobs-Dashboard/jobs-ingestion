#
# Defines the variables for a deployment. By default all variables are strings
# unless otherwise specified.
#

# Variables from `deploy_<stage>.sh`
variable "app_name" {}
variable "stage" {}
variable "region" {}
variable "availability_zone_a" {}
variable "availability_zone_b" {}
variable "aws_profile" {}

# Variables from `<stage>.tfvars`
variable "digdag_instance_type" {}
variable "ssh_key_name" {}
variable "rds_instance_type" {}
variable "record_name" {}
variable "full_record_name" {}
variable "postgres_user" {}
variable "email_address" {}
variable "github_repo_url" {}
variable "github_user" {}
variable "papertrail_url" {}
variable "database_name" {}

# Variables from `<stage>.secrets.tfvars`
variable "postgres_password" {}
variable "proxy_admin_password" {}
variable "github_token" {}
