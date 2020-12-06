resource "aws_vpc" "_" {
  cidr_block = "10.0.0.0/23"
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_internet_gateway" "_" {
  vpc_id = aws_vpc._.id
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_subnet" "a" {
  cidr_block        = "10.0.0.0/24"
  vpc_id            = aws_vpc._.id
  availability_zone = var.availability_zone_a
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

# Db instance requires at least 2 different availability zones
resource "aws_subnet" "b" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc._.id
  availability_zone = var.availability_zone_b
  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc._.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway._.id
  }

  tags = {
    Service     = var.app_name
    Environment = var.stage
  }
}

resource "aws_route_table_association" "_" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.r.id
}

