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
  region = var.aws_region
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
}

# Web/ALB Module
module "web" {
  source = "./modules/web"

  project_name      = var.project_name
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
}

# App Module
module "app" {
  source = "./modules/app"

  project_name          = var.project_name
  vpc_id                = module.networking.vpc_id
  vpc_cidr_block        = module.networking.vpc_cidr_block
  private_subnet_ids    = module.networking.private_subnet_ids
  alb_security_group_id = module.web.alb_security_group_id
  target_group_arn      = module.web.target_group_arn
}

# Database Module
module "database" {
  source = "./modules/database"

  project_name          = var.project_name
  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
  app_security_group_id = module.app.app_security_group_id
  db_password           = var.db_password
}
