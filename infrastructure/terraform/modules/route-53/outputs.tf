#
# Outputs of this module
#
output "aws_route53_record_name" {
  value = aws_route53_record._.name
}
output "aws_route53_record_fqdn" {
  value = aws_route53_record._.fqdn
}
