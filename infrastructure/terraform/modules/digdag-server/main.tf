data "aws_caller_identity" "current" {}

data "template_file" "snowflake_config" {
  template = file("./modules/digdag-server/config_files/.snowsql/config")
  vars = {
    snowflake_accountname = var.snowflake_accountname
    snowflake_user        = var.snowflake_user
    snowflake_password    = var.snowflake_password
    snowflake_role        = var.snowflake_role
  }
}

data "template_file" "config_script" {
  template = file("./modules/digdag-server/config_files/config.sh")
  vars = {
    gitlab_user          = var.gitlab_user
    gitlab_token         = var.gitlab_token
    ssl_domain           = var.ssl_domain
    snowsql_config       = data.template_file.snowflake_config.rendered
    postgres_user        = var.postgres_user
    postgres_password    = var.postgres_password
    postgres_host        = var.postgres_host
    postgres_db_name     = var.postgres_db_name
    snowflake_db_name    = var.snowflake_db_name
    digdag_s3_bucket     = aws_s3_bucket.bucket.bucket
    proxy_admin_password = var.proxy_admin_password
    email_address        = var.email_address
    mail_host            = var.mail_host
    mail_username        = var.mail_username
    mail_password        = var.mail_password
  }
  depends_on = [data.template_file.snowflake_config]
}


data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Digdag deployment needs access to a bucket in order to store the artifacts
resource "aws_s3_bucket" "bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.app_name}-${var.stage}-digdag"
  acl    = "private"
  region = "eu-west-1"

  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.app_name}-${var.stage}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_iam_policy" "s3-policy" {
  name        = "${var.app_name}-${var.stage}-ec2-policy"
  description = "A policy to manage the permissions of ec2 on service ${var.app_name}-${var.stage}"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3-policy-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3-policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.app_name}-${var.stage}-ec2-iam-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "web" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  private_ip           = var.server_private_ipv4
  subnet_id            = var.subnet_id
  security_groups      = var.vpc_security_group_ids
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data            = data.template_file.config_script.rendered
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_eip" "eip" {
  instance                  = aws_instance.web.id
  associate_with_private_ip = var.server_private_ipv4
  depends_on                = [var.gateway]
}
