#
# Defines the variables for this module. By default all variables are strings
# unless otherwise specified.
#

variable "app_name" {}
variable "stage" {}
variable "availability_zone_a" {
  type    = string
  default = "eu-west-1a"
}

variable "availability_zone_b" {
  type    = string
  default = "eu-west-1b"
}
