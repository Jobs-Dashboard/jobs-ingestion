provider "aws" {
  profile = var.aws_profile
  region  = var.region
  version = "~>2.45"
}

terraform {
  required_version = "~>0.12"
  backend "s3" {}
}

module "vpc" {
  source   = "./modules/vpc"
  app_name = var.app_name
  stage    = var.stage
}

module "digdag-rds" {
  source            = "./modules/postgres-rds"
  app_name          = var.app_name
  stage             = var.stage
  subnet_id_a       = module.vpc.subnet_server_id_a
  subnet_id_b       = module.vpc.subnet_server_id_b
  instance_type     = var.rds_instance_type
  security_group    = module.vpc.postgres_security_group_id
  postgres_user     = var.postgres_user
  postgres_password = var.postgres_password
}

module "digdag-server" {
  source                   = "./modules/digdag-server"
  app_name                 = var.app_name
  stage                    = var.stage
  ssh_key_name             = var.ssh_key_name
  subnet_id                = module.vpc.subnet_server_id_a
  gateway                  = module.vpc.gateway
  vpc_security_group_ids   = module.vpc.vpc_security_group_ids
  instance_type            = var.digdag_instance_type
  gitlab_user              = var.gitlab_user
  gitlab_token             = var.gitlab_token
  ssl_domain               = var.digdag_ssl_domain
  contact_email            = var.contact_email
  postgres_user            = module.digdag-rds.username
  postgres_password        = module.digdag-rds.password
  postgres_host            = module.digdag-rds.host
  postgres_db_name         = module.digdag-rds.db_name
  proxy_admin_password     = var.proxy_admin_password
  mail_from                = "${var.app_name}.${var.stage}@bond-touch.net"
  mail_host                = var.mail_host
  mail_username            = var.mail_username
  mail_password            = var.mail_password
}
