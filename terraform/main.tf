terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "network" {
  source = "./vpc"
}

module "iam" {
  source = "./iam"
}

module "db" {
  source = "./rds"
  db_password = var.db_password
}

module "ecs" {
  source = "./ecs"
  db_endpoint     = module.db.db_endpoint
  db_password     = var.db_password
  execution_role_arn = module.iam.execution_role_arn
  subnets         = module.network.subnets
  security_group  = module.network.security_group
}

output "service_url" {
  value = module.ecs.alb_dns
}
