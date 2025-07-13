# medusa-app
Design a medusa backend deployed on ECS Fargate configured with Actions for an Ecommerce application

This project automates the deployment of the [Medusa](https://github.com/linuxserver/Medusa) backend using:
- Terraform (IaC)
- AWS ECS Fargate (serverless containers)
- PostgreSQL on RDS
- GitHub Actions (CI/CD)
- Application Load Balancer for public access

---

## 📦 Architecture

[ GitHub ]
│
▼
[ GitHub Actions ]
│
▼
[ Terraform CLI ] ─────────────┐
▼
┌────────────────────────┐
│ AWS Resources │
└────────────────────────┘
├── ECS Fargate Cluster
├── Task with Medusa Container (linuxserver/medusa:1.0.22)
├── RDS PostgreSQL DB
├── Application Load Balancer
└── Security Group (Port 3000 Open)

## 🛠️ Terraform Modules

| Module | Purpose |
|--------|---------|
| `vpc/` | Uses default VPC & fetches public subnets |
| `iam/` | ECS task execution role |
| `rds/` | Creates PostgreSQL database |
| `ecs/` | ECS cluster, task def, service, ALB |
| `.github/workflows/deploy.yml` | GitHub Actions CI/CD |

---

## 🔐 Secrets to Set in GitHub

In your GitHub repository, add the following under `Settings → Secrets → Actions`:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

## 🚀 Deployment Steps

1. Push your code to the `main` branch.
2. GitHub Actions will run:
   - `terraform init`
   - `terraform plan`
   - `terraform apply`
3. Find the ALB DNS in GitHub Actions output or AWS Console.
4. Access the Medusa app at `http://<alb-dns>:3000`


## ✅ Outputs after `terraform apply`

- `medusa_service_url`: Public URL of the Medusa backend
- `rds_endpoint`: RDS PostgreSQL connection string
- `ecs_cluster_name`: Cluster name
- `ecs_service_name`: ECS service
- `task_definition_family`: Task definition ID