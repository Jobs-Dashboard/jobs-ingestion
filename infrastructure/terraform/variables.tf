variable "app_name" {
  description = "The name of the App that will be launched"
}

variable "stage" {
  description = "Environment to launched"
}

variable "digdag_instance_type" {
  description = "DigDag instance type"
}

variable "ssh_key_name" {
  description = "ssh key name"
}

variable "rds_instance_type" {
  description = "rds instance type"
}

# like "jobs-dashboard.ml"
variable "project_ssl_domain" {}

variable "github_user" {}

variable "github_repo_url" {}

# This email address is used to send and receive email,
# and used as a contact email.
variable "email_address" {}

variable "postgres_user" {}

variable "postgres_password" {}

variable "proxy_admin_password" {}

variable "papertrail_url" {}
