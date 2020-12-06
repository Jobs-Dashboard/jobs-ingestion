#
# Defines the variables for this module. By default all variables are strings
# unless otherwise specified.
#

# Variables from terraform/variables.tf
variable "app_name" {}
variable "stage" {}
variable "instance_type" {}
variable "database_name" {}
variable "postgres_user" {}
variable "postgres_password" {}

# Variables from terraform/modules/vpc/variables.tf
variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "subnet_id_a" {}
variable "subnet_id_b" {}
