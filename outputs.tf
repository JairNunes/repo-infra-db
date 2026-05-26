output "db_endpoint" {
  description = "Endpoint do RDS (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "Address do RDS (host)"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Nome do banco"
  value       = aws_db_instance.main.db_name
}

output "db_security_group_id" {
  description = "ID do security group do RDS (consumido pelo repo-infra-k8s)"
  value       = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  description = "Nome do subnet group"
  value       = aws_db_subnet_group.main.name
}

output "db_secret_arn" {
  description = "ARN do secret no Secrets Manager com connection URL"
  value       = aws_secretsmanager_secret.db_url.arn
}

output "database_url" {
  description = "Connection URL completa (use via Secrets Manager em produção)"
  value       = "postgresql://${var.db_username}:****@${aws_db_instance.main.endpoint}/${var.db_name}?schema=public"
  sensitive   = false
}
