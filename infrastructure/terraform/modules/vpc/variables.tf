variable "app_name" {
  description = "The name of the App that will be launch"
}

variable "stage" {
  description = "Environment to launch"
}

variable "availability_zone_a" {
  type    = string
  default = "eu-west-1a"
}

variable "availability_zone_b" {
  type    = string
  default = "eu-west-1b"
}
