# Backend S3 pro state remoto.
# Pra usar: criar o bucket S3 e a tabela DynamoDB antes do primeiro `terraform init`.
#
# aws s3api create-bucket --bucket oficina-mecanica-tfstate --region us-east-1
# aws dynamodb create-table --table-name oficina-mecanica-tflock \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST --region us-east-1

terraform {
  backend "s3" {
    bucket         = "oficina-mecanica-tfstate"
    key            = "infra-db/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "oficina-mecanica-tflock"
    encrypt        = true
  }
}
