#
# Defines the variables for this module. By default all variables are strings
# unless otherwise specified.
#

# Variables from terraform/variables.tf
variable "app_name" {}
variable "stage" {}
variable "region" {}
variable "ssh_key_name" {}
variable "proxy_admin_password" {}
variable "email_address" {}
variable "instance_type" {}
variable "github_user" {}
variable "github_token" {}
variable "github_repo_url" {}
variable "record_name" {}
variable "full_record_name" {}
variable "papertrail_url" {}

# Variables from terraform/modules/vpc/variables.tf
variable "vpc_id" {}
variable "subnet_id" {}
variable "gateway" {}

# Variables from terraform/modules/postgres-rds/variables.tf
variable "postgres_user" {}
variable "postgres_password" {}
variable "postgres_host" {}
variable "postgres_port" {}
variable "postgres_db_name" {}

# Variables from terraform/modules/ses/variables.tf
variable "mail_host" {}
variable "mail_username" {}
variable "mail_password" {}
