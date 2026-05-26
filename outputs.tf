output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_address" {
  value = aws_db_instance.main.address
}

output "db_port" {
  value = aws_db_instance.main.port
}

output "db_name" {
  value = aws_db_instance.main.db_name
}

output "db_security_group_id" {
  value = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.main.name
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_url.arn
}

output "database_url" {
  value = "postgresql://${var.db_username}:****@${aws_db_instance.main.endpoint}/${var.db_name}?schema=public"
}
