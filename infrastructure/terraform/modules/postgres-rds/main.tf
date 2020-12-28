#
# Module that provides the postgres-rds instance that will serve as a
# database server for the digdag server.
#

resource "aws_db_subnet_group" "_" {
  name       = "${var.app_name}-${var.stage}"
  subnet_ids = [var.subnet_id_a, var.subnet_id_b] # at least 2 are required

  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_security_group" "_" {
  name        = "${var.app_name}-${var.stage}-postgres"
  description = "Allow postgres to receive connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_db_instance" "_" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.8"
  skip_final_snapshot    = true
  instance_class         = var.instance_type
  name                   = var.database_name
  username               = var.postgres_user
  password               = var.postgres_password
  vpc_security_group_ids = [aws_security_group._.id]
  db_subnet_group_name   = aws_db_subnet_group._.name

  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}
