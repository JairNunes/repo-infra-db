variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "oficina-mecanica-db"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "oficina"
}

variable "db_username" {
  description = "RDS admin username"
  type        = string
  default     = "oficina_admin"
}

variable "db_password" {
  description = "RDS admin password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "publicly_accessible" {
  description = "Whether RDS is reachable from the internet"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "Extra CIDRs allowed to connect"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
