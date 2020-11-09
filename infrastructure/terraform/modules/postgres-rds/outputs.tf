output "host" {
  value = aws_db_instance.default.address
}

output "db_name" {
  value = aws_db_instance.default.name
}

output "username" {
  value = aws_db_instance.default.username
}

output "password" {
  value = aws_db_instance.default.password
}

