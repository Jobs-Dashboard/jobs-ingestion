#
# This module serves to set up credentials and an iam user to send email
# with aws ses and smtp.
#

resource "aws_iam_user" "ses-smtp" {
  name = "ses-smtp-user.${var.iam_ses_smtp_username}"
}

# policy that allows for sending email
resource "aws_iam_user_policy" "ses-smtp" {
  name   = "AmazonSesSendingAccess"
  user   = aws_iam_user.ses-smtp.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ses:SendRawEmail",
            "Resource": "*"
        }
    ]
}
EOF
}

# The way to generate the SMTP user and password required to send email is to
# generate a aws_iam_access_key and then get the user and password from that (
# check the outputs.tf for how to get the user and the password).
resource "aws_iam_access_key" "ses-smtp" {
  user = aws_iam_user.ses-smtp.name
}

output "smtp_user" {
  value = aws_iam_access_key.ses-smtp.id
}

output "smtp_password" {
  value = aws_iam_access_key.ses-smtp.ses_smtp_password_v4
}
