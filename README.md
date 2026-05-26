# repo-infra-db

Terraform que provisiona o **RDS PostgreSQL** da API de Oficina Mecânica (Fase 3, FIAP 13SOAT — Grupo 72).

## Propósito

Banco gerenciado para a aplicação NestJS e a Lambda de autenticação. Consumido por:

- `repo-app` — via env `DATABASE_URL` injetada no ConfigMap do EKS
- `repo-lambda-auth` — via env `DATABASE_URL` injetada na Lambda (Secrets Manager)

## Stack

- AWS RDS PostgreSQL 16.3 (`db.t3.micro`, 20GB gp3)
- AWS Secrets Manager (connection URL)
- Terraform 1.7.5 + provider AWS 5.40
- GitHub Actions (CI/CD)

## Pré-requisitos

1. Conta AWS com credenciais configuradas (Access Key/Secret no GitHub Secrets `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`)
2. Bucket S3 para state remoto + tabela DynamoDB para lock:
   ```bash
   aws s3api create-bucket --bucket oficina-mecanica-tfstate --region us-east-1
   aws dynamodb create-table --table-name oficina-mecanica-tflock \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST --region us-east-1
   ```
3. GitHub Secret `DB_PASSWORD` configurado (senha do admin do RDS)

## Como rodar localmente

```bash
export TF_VAR_db_password='senha-forte-aqui'
terraform init
terraform plan
terraform apply
```

## Outputs

| Output | Uso |
|---|---|
| `db_endpoint` | Host:porta — usado pelo App e pela Lambda |
| `db_address` | Apenas host |
| `db_port` | 5432 |
| `db_name` | `oficina` |
| `db_secret_arn` | ARN do secret no Secrets Manager |

## Deploy

Push para `main` dispara `terraform apply` via GitHub Actions (com aprovação manual no environment `production`).

## Custos estimados

- RDS `db.t3.micro` + 20GB gp3: **~US$15-20/mês** (fora do free tier)
- Secrets Manager: **~US$0.40/mês**
- Total: **~US$16-21/mês**

Para reduzir custos durante o projeto: subir, gravar vídeo, executar `terraform destroy` no mesmo dia.

## Arquitetura

```
┌─────────────────────────────────────────────┐
│           AWS Cloud (us-east-1)              │
│                                              │
│   ┌──────────────┐    ┌──────────────────┐  │
│   │ Lambda Auth  │    │   App NestJS     │  │
│   │ (Node.js 20) │    │   (EKS Cluster)  │  │
│   └──────┬───────┘    └─────────┬────────┘  │
│          │                      │           │
│          └──────────┬───────────┘           │
│                     ▼                       │
│           ┌─────────────────────┐           │
│           │  RDS PostgreSQL 16  │           │
│           │  db.t3.micro / 20GB │           │
│           │  Backup 7d, SG 5432 │           │
│           └─────────────────────┘           │
│                     │                       │
│                     ▼                       │
│         ┌────────────────────────┐          │
│         │  AWS Secrets Manager   │          │
│         │  (DATABASE_URL)        │          │
│         └────────────────────────┘          │
└─────────────────────────────────────────────┘
```

## Schema

Schema gerenciado pelo Prisma no `repo-app` (`prisma/schema.prisma`). Migrações rodam no startup do app via `prisma migrate deploy`.

Entidades (Fase 2, mantidas):

- `User` — admin (email/senha)
- `Customer` — cliente (consultado por CPF pela Lambda)
- `Vehicle`
- `Service`, `Part`
- `ServiceOrder`, `ServiceOrderService`, `ServiceOrderPart`

## Branch protection

- `main` protegida: PR obrigatório, status checks (`validate`, `plan`), sem commits diretos
- `develop` para homologação
