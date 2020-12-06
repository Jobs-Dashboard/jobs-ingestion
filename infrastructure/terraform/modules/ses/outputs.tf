#
# Outputs of this module
#
output "smtp_endpoint" {
  value = "email-smtp.${var.region}.amazonaws.com"
}
output "smtp_user" {
  value = aws_iam_access_key._.id
}
output "smtp_password" {
  value = aws_iam_access_key._.ses_smtp_password_v4
}
