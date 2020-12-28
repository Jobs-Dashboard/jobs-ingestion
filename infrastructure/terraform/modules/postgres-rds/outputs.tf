#
# Outputs of this module
#

output "aws_db_instance_arn" {
  value = aws_db_instance._.arn
}
output "db_host" {
  value = aws_db_instance._.address
}
output "db_port" {
  value = aws_db_instance._.port
}
output "db_name" {
  value = aws_db_instance._.name
}
output "db_username" {
  value = aws_db_instance._.username
}
output "db_password" {
  value = aws_db_instance._.password
}
