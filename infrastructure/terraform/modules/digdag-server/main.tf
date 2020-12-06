#
# Module that provides the digdag server
#

# used as a prefix to the bucket name
data "aws_caller_identity" "current" {}

data "template_file" "_" {
  template = file("./modules/digdag-server/config_files/config.sh")
  vars = {
    postgres_user        = var.postgres_user
    postgres_password    = var.postgres_password
    postgres_host        = var.postgres_host
    postgres_db_name     = var.postgres_db_name
    digdag_s3_bucket     = aws_s3_bucket._.bucket
    mail_host            = var.mail_host
    email_address        = var.email_address
    mail_username        = var.mail_username
    mail_password        = var.mail_password
    full_record_name     = var.full_record_name
    record_name          = var.record_name
    proxy_admin_password = var.proxy_admin_password
    papertrail_url       = var.papertrail_url
    stage                = var.stage
    github_user          = var.github_user
    github_token         = var.github_token
    github_repo_url      = var.github_repo_url
  }
}

data "aws_ami" "_" {
  most_recent = true

  # Amazon Machine Image
  owners = ["099720109477"]

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
resource "aws_s3_bucket" "_" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.app_name}-${var.stage}-digdag"
  acl    = "private"
  region = var.region

  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_iam_role" "_" {
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

resource "aws_iam_policy" "_" {
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
        "${aws_s3_bucket._.arn}",
        "${aws_s3_bucket._.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "_" {
  role       = aws_iam_role._.name
  policy_arn = aws_iam_policy._.arn
}

resource "aws_iam_instance_profile" "_" {
  name = "${var.app_name}-${var.stage}-ec2-iam-instance-profile"
  role = aws_iam_role._.name
}

resource "aws_security_group" "_" {
  name        = "${var.app_name}-${var.stage}-allow_tls_ssh"
  description = "Allow TLS and SSH inbound trafic to the machine"
  vpc_id      = var.vpc_id

  ingress {
    # Certbot needs http to verify the certificate and
    # nginx will redirect request from port 80 to port 443.
    description = "Allow HTTP Connections"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow TLS Connections"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH Connections"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_eip" "_" {
  instance                  = aws_instance._.id
  associate_with_private_ip = aws_instance._.private_ip
  depends_on                = [var.gateway]
}

resource "aws_instance" "_" {
  ami                  = data.aws_ami._.id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  security_groups      = [aws_security_group._.id]
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile._.name
  user_data            = data.template_file._.rendered

  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}
