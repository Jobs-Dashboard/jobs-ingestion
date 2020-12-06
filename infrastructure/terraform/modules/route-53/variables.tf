#
# Defines the variables for this module. By default all variables are strings
# unless otherwise specified.
#

# Variables from terraform/variables.tf
variable "app_name" {}
variable "stage" {}
variable "zone_domain_name" {}
variable "record_name" {}
variable "full_record_name" {}

# Variables from terraform/modules/digdag-server.tf
variable "aws_eip_public_ip" {}
