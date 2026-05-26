variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment (prod, homolog)"
  type        = string
  default     = "prod"
}

variable "db_identifier" {
  description = "Identifier da instância RDS"
  type        = string
  default     = "oficina-mecanica-db"
}

variable "db_name" {
  description = "Nome do banco inicial"
  type        = string
  default     = "oficina"
}

variable "db_username" {
  description = "Usuário admin do RDS"
  type        = string
  default     = "oficina_admin"
}

variable "db_password" {
  description = "Senha do RDS — passe via TF_VAR_db_password ou GitHub Secret"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "publicly_accessible" {
  description = "Se RDS é acessível pela internet (true facilita pra testar Lambda + dev local)"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "CIDRs adicionais permitidos a conectar (default: aberto pra teste acadêmico)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
