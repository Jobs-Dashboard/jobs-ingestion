output "smtp_endpoint" {
  value = "email-smtp.${var.region}.amazonaws.com"
}

output "smtp_user" {
  value = aws_iam_access_key.ses-smtp.id
}

output "smtp_password" {
  value = aws_iam_access_key.ses-smtp.ses_smtp_password_v4
}
