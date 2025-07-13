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

module "ecs" {
  source = "./ecs"
  execution_role_arn = module.iam.execution_role_arn
  subnets            = module.network.subnets
  security_group     = module.network.security_group
}

output "medusa_service_url" {
  description = "The public DNS name of the ALB serving the Medusa app"
  value       = module.ecs.alb_dns
}

output "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS Service"
  value       = module.ecs.service_name
}

output "task_definition_family" {
  description = "Family name of the ECS Task Definition"
  value       = module.ecs.task_family
}
