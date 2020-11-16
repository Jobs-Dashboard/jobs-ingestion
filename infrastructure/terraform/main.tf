provider "aws" {
  profile = var.aws_profile
  region  = var.region
  version = "~>2.50"
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

module "ses" {
  source                = "./modules/ses"
  region                = var.region
  iam_ses_smtp_username = var.iam_ses_smtp_username
}

module "route-53" {
  source                = "./modules/route-53"
  region                = var.region
  iam_ses_smtp_username = var.iam_ses_smtp_username
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
  source                 = "./modules/digdag-server"
  app_name               = var.app_name
  stage                  = var.stage
  ssh_key_name           = var.ssh_key_name
  subnet_id              = module.vpc.subnet_server_id_a
  gateway                = module.vpc.gateway
  vpc_security_group_ids = module.vpc.vpc_security_group_ids
  instance_type          = var.digdag_instance_type
  gitlab_user            = var.gitlab_user
  gitlab_token           = var.gitlab_token
  ssl_domain             = module.route-53.digdag_ssl_domain
  postgres_user          = module.digdag-rds.username
  postgres_password      = module.digdag-rds.password
  postgres_host          = module.digdag-rds.host
  postgres_db_name       = module.digdag-rds.db_name
  proxy_admin_password   = var.proxy_admin_password
  email_address          = var.email_address
  mail_host              = module.ses.smtp_endpoint
  mail_username          = module.ses.smtp_user
  mail_password          = module.ses.smtp_password
}
