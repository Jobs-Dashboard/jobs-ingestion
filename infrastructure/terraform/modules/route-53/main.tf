# This module corresponds to the configuration of digdag server with route 53.

resource "aws_route53_zone" "primary" {
  # this is like a base name, and then we can create records that
  name = "${var.project_ssl_domain}"
}

resource "aws_route53_record" "digdag" {
  zone_id = aws_route53_zone.primary.zone_id
  # ex: digdag-production.jobs-dashboard.ml
  name    = "digdag-${var.stage}.${var.project_ssl_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.eip.public_ip]
}
