#
# This module corresponds to the configuration of digdag server with route 53.
#

resource "aws_route53_zone" "_" {
  # this is a base name (like jobs-dashboard.ml), and then we can create
  # records for each service in the project (like digdag.jobs-dashboard.ml)
  # that have the base name as a suffix
  name = var.zone_domain_name

  tags = {
    Service = var.app_name
  }
}

resource "aws_route53_record" "_" {
  zone_id = aws_route53_zone._.zone_id
  # ex: digdag.jobs-dashboard.ml
  name    = var.full_record_name
  type    = "A"
  ttl     = "300"
  records = [var.aws_eip_public_ip]
}
