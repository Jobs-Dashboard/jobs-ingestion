#
# Outputs of this module
#
output "vpc_id" {
  value = aws_vpc._.id
}
output "vpc_arn" {
  value = aws_vpc._.arn
}
output "vpc_cidr_block" {
  value = aws_vpc._.cidr_block
}
output "aws_subnet_a_id" {
  value = aws_subnet.a.id
}
output "aws_subnet_b_id" {
  value = aws_subnet.b.id
}
output "gateway" {
  value = aws_internet_gateway._
}
