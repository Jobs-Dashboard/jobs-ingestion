#
# This module corresponds to the configuration of digdag server with route 53.
#

resource "aws_route53_zone" "primary" {
  # this is a base name (like jobs-dashboard.ml), and then we can create
  # records for each service in the project (like digdag.jobs-dashboard.ml)
  # that have the base name as a suffix
  name = "${var.project_ssl_domain}"
}

resource "aws_route53_record" "digdag" {
  zone_id = aws_route53_zone.primary.zone_id
  # ex: digdag.jobs-dashboard.ml
  name    = var.digdag_ssl_domain
  type    = "A"
  ttl     = "300"
  records = [aws_eip.eip.public_ip]
}
