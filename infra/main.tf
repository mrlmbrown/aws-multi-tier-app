# Root Infrastructure Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  azs          = var.azs
}

# Database Module
module "database" {
  source = "./modules/database"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  db_subnet_ids      = module.networking.private_subnet_ids
  app_security_group_id = module.app.app_security_group_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
}

# Application (EC2 Auto Scaling) Module
module "app" {
  source = "./modules/app"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id

  instance_type    = var.instance_type
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  db_endpoint = module.database.db_endpoint
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

# Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "URL to access the Application Load Balancer"
  value       = "http://${module.alb.alb_dns_name}"
}

output "db_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.app.asg_name
}
