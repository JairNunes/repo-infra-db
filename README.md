# repo-infra-db

Terraform do RDS PostgreSQL da API de Oficina Mecânica (Fase 3, FIAP 13SOAT — Grupo 75).

Banco gerenciado consumido pela app NestJS (`repo-app`) e pela Lambda de autenticação (`repo-lambda-auth`).

## Arquitetura

![Componentes](https://raw.githubusercontent.com/JairNunes/repo-app/main/diagrams/01-componentes.png)

Esse repo provisiona o bloco `AWS RDS PostgreSQL 16` (canto inferior central). O endpoint e a connection URL são consumidos pela Lambda Auth (via `pg`) e pela app NestJS (via Prisma). Diagrama completo + fontes editáveis (drawio) em [`repo-app/diagrams/`](https://github.com/JairNunes/repo-app/tree/main/diagrams).

## Stack

- AWS RDS PostgreSQL 16.3 (`db.t3.micro`, 20GB gp3)
- AWS Secrets Manager pra connection URL
- Terraform 1.7.5 com provider AWS 5.40
- GitHub Actions

## Pré-requisitos

Credenciais AWS configuradas (GitHub Secrets `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`) e backend remoto do Terraform criado antes do primeiro `terraform init`:

```bash
aws s3api create-bucket --bucket oficina-mecanica-tfstate --region us-east-1
aws dynamodb create-table --table-name oficina-mecanica-tflock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region us-east-1
```

Também precisa do GitHub Secret `DB_PASSWORD` (senha do admin do RDS).

## Rodando local

```bash
export TF_VAR_db_password='senha-forte-aqui'
terraform init
terraform plan
terraform apply
```

## Outputs

- `db_endpoint` — host:porta
- `db_address` — só host
- `db_port` — 5432
- `db_name` — `oficina`
- `db_secret_arn` — ARN do secret no Secrets Manager

## Deploy

Push em `main` dispara `terraform apply` via GitHub Actions com approval manual no environment `production`.

## Custos

RDS db.t3.micro + 20GB gp3 ficam em torno de US$15-20/mês fora do free tier, mais US$0.40/mês do Secrets Manager. Pra projeto acadêmico: subir, gravar o vídeo e rodar `terraform destroy` no mesmo dia mantém o custo abaixo de US$1.

## Schema

O schema é gerenciado pelo Prisma do `repo-app` (`prisma/schema.prisma`). Migrações rodam no startup do pod via `prisma migrate deploy`. Entidades mantidas da Fase 2: `User`, `Customer`, `Vehicle`, `Service`, `Part`, `ServiceOrder`, `ServiceOrderService`, `ServiceOrderPart`.

## Branch protection

`main` protegida — PR obrigatório, status checks (`validate`, `plan`), sem commit direto. `develop` pra homologação.
