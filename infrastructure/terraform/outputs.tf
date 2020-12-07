#
# Defines the output outputs for a deployment.
#

# Outputs from terraform/variables.tf
output "aws_default_region" {
  value = var.region
}
output "stage" {
  value = var.stage
}

# Outputs from terraform/modules/digdag-server/outputs.tf
output "aws_instance_arn" {
  value = module.digdag-server.aws_instance_arn
}
output "aws_eip_public_ip" {
  value = module.digdag-server.aws_eip_public_ip
}
output "aws_s3_bucket_name" {
  value = module.digdag-server.aws_eip_public_ip
}

# Outputs from terraform/modules/postgres-rds/outputs.tf
output "aws_db_instance_arn" {
  value = module.postgres-rds.aws_db_instance_arn
}
output "aws_db_instance_host" {
  value = module.postgres-rds.db_host
}

# Outputs from terraform/modules/route-53/outputs.tf
output "aws_route53_record_name" {
  value = module.route-53.aws_route53_record_name
}
output "aws_route53_record_fqdn" {
  value = module.route-53.aws_route53_record_fqdn
}

# Outputs from terraform/modules/ses/outputs.tf
output "smtp_endpoint" {
  value = module.ses.smtp_endpoint
}
output "smtp_user" {
  value = module.ses.smtp_user
}
output "smtp_password" {
  value = module.ses.smtp_password
}

# Outputs from terraform/modules/vpc/outputs.tf
output "vpc_arn" {
  value = module.vpc.vpc_arn
}
