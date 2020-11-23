#
# Module that provides the postgres-rds instance that will serve as a
# database server for the digdag server.
#

resource "aws_db_subnet_group" "default" {
  name       = "${var.app_name}-${var.stage}-digdag-db-subnet-group"
  subnet_ids = [var.subnet_id_a, var.subnet_id_b] # at least 2 are required

  tags = {
    Name = "${var.app_name}-${var.stage}-digdag-db-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.5"
  instance_class         = var.instance_type
  name                   = "${var.app_name}${var.stage}DigdagDb"
  username               = var.postgres_user
  password               = var.postgres_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.security_group]
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
  skip_final_snapshot = true
}

