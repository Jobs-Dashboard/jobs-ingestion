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

variable "digdag_ssl_domain" {

}

variable "gitlab_user" {

}

variable "gitlab_token" {

}

variable "contact_email" {
  type    = string
  default = "bond.touch@daredata.engineering"
}

variable "postgres_user" {

}

variable "postgres_password" {

}

variable "snowflake_db_name" {
  type = string
}

variable "snowflake_role" {
  type = string
}

variable "snowflake_accountname" {
  type = string
}

variable "snowflake_user" {
  type = string
}

variable "snowflake_password" {
  type = string
}

variable "proxy_admin_password" {}


variable "mail_host" {
}

variable "mail_username" {}

variable "mail_password" {}
