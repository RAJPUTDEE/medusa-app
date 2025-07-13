# 🚀 Medusa Application Deployment on AWS ECS (Fargate)

This project demonstrates Infrastructure as Code (IaC) for deploying the Medusa headless commerce backend using [linuxserver/medusa](https://docs.linuxserver.io/images/docker-medusa/) Docker image on AWS ECS Fargate. The deployment is managed via Terraform, and the CI/CD pipeline is powered by GitHub Actions.

---

## 📦 Tech Stack

- **Terraform** (IaC)
- **AWS ECS with Fargate** (Container Orchestration)
- **Application Load Balancer (ALB)** (Traffic routing)
- **AWS IAM** (Execution role)
- **GitHub Actions** (CI/CD automation)

---

## 🔧 Project Structure
.
├── main.tf # Root Terraform config
├── terraform.tfvars # Variable values (empty since no DB used)
├── variables.tf # Input variables
├── vpc/
│ └── main.tf # Default VPC & Security Group
├── iam/
│ └── main.tf # ECS Task Execution Role & policy
├── ecs/
│ └── main.tf # ECS cluster, ALB, Task Definition, Service
└── .github/
 └── workflows/
   └── deploy.yml # GitHub Actions pipeline

## ⚙️ Deployment Instructions

### 🧑‍💻 Prerequisites
- AWS account with IAM credentials set as GitHub secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
- Default VPC and public subnets must exist in your region.
- GitHub repository with code pushed to `main` branch.


### 🚀 Deploy Using GitHub Actions

1. **Push your code** to the `main` branch.
2. **GitHub Actions** will:
   - Initialize Terraform
   - Create ECS Cluster, ALB, Task Definition, and Service

### 🌐 Accessing Medusa

Once deployed, the application will be available at:

http://<ALB-DNS-Name>:8081
You can get the ALB DNS from AWS Console or Terraform output.

🐳 About the Docker Image
The deployment uses the image:
📦 lscr.io/linuxserver/medusa:latest

Container Configuration:

Port: 8081

Volumes (ephemeral):

/config, /downloads, /tv

Environment Variables:

PUID=1000

PGID=1000

TZ=Etc/UTC


📄 Terraform Outputs
After successful deployment, Terraform will output:

alb_dns: Public URL to access Medusa

ecs_cluster_name: ECS cluster name

ecs_service_name: ECS service name

task_definition_family: Task family used for Medusa container

♻️ Clean Up
To destroy the infrastructure manually:

terraform destroy -auto-approve
Or modify the GitHub Actions workflow to use destroy step if needed.

🙋 Author
👤 Rajput Deepak Singh

✉️ Feel free to reach out at: singh.deepak839@gmail.com

📌 Notes
RDS integration was skipped in favor of a simpler SQLite fallback due to AWS cost.

Ensure your ALB Security Group allows port 8081 inbound from 0.0.0.0/0.

