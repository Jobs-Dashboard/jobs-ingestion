variable "app_name" {
  type = string
}

variable "stage" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "gateway" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "server_private_ipv4" {
  type    = string
  default = "10.0.0.10" # some ip's are reserved
}

variable "instance_type" {
  type = string
}

variable "github_user" {}

variable "github_repo_url" {}

variable "digdag_ssl_domain" {}

variable "email_address" {}

variable "postgres_user" {}

variable "postgres_password" {}

variable "postgres_host" {}

variable "postgres_db_name" {}

variable "proxy_admin_password" {}

variable "email_address" {}

variable "mail_host" {}

variable "mail_username" {}

variable "mail_password" {}




