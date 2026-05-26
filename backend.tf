# Bucket S3 e tabela DynamoDB precisam existir antes do primeiro init. Ver README.

terraform {
  backend "s3" {
    bucket         = "oficina-mecanica-tfstate"
    key            = "infra-db/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "oficina-mecanica-tflock"
    encrypt        = true
  }
}
