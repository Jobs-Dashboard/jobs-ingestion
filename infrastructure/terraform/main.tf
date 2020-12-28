#
# Main terraform file. Calls the modules by passing the approppriate variables
# to them.
#

provider "aws" {
  profile = var.aws_profile
  region  = var.region
}

terraform {
  required_version = "~> 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.50"
    }
  }
  backend "s3" {}
}


module "vpc" {
  source = "./modules/vpc"

  app_name            = var.app_name
  stage               = var.stage
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
}

module "ses" {
  source = "./modules/ses"

  app_name = var.app_name
  stage    = var.stage
  region   = var.region
}

module "postgres-rds" {
  source = "./modules/postgres-rds"

  app_name          = var.app_name
  stage             = var.stage
  instance_type     = var.rds_instance_type
  database_name     = var.database_name
  postgres_user     = var.postgres_user
  postgres_password = var.postgres_password

  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  subnet_id_a    = module.vpc.aws_subnet_a_id
  subnet_id_b    = module.vpc.aws_subnet_b_id
}

module "digdag-server" {
  source = "./modules/digdag-server"

  app_name             = var.app_name
  stage                = var.stage
  region               = var.region
  ssh_key_name         = var.ssh_key_name
  proxy_admin_password = var.proxy_admin_password
  email_address        = var.email_address
  instance_type        = var.digdag_instance_type
  github_user          = var.github_user
  github_token         = var.github_token
  github_repo_url      = var.github_repo_url
  record_name          = var.record_name
  full_record_name     = var.full_record_name
  papertrail_url       = var.papertrail_url

  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.aws_subnet_a_id
  gateway           = module.vpc.gateway
  postgres_user     = module.postgres-rds.db_username
  postgres_password = module.postgres-rds.db_password
  postgres_host     = module.postgres-rds.db_host
  postgres_port     = module.postgres-rds.db_port
  postgres_db_name  = module.postgres-rds.db_name
  mail_host         = module.ses.smtp_endpoint
  mail_username     = module.ses.smtp_user
  mail_password     = module.ses.smtp_password
}
