# This module serves to set up credentials and an iam user to send email
# with aws ses and smtp
resource "aws_iam_user" "ses-smtp" {
  name = "ses-smtp-user.${var.iam_ses_smtp_username}"
}

# policy that allows for sending email
resource "aws_iam_user_policy" "ses-smtp" {
  name = "AmazonSesSendingAccess"
  user = aws_iam_user.ses-smtp.name
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

# The way to generate the SMTP user and password required ot send email is to
# generate a
resource "aws_iam_access_key" "ses-smtp" {
  user    = aws_iam_user.ses-smtp.name
}