terraform {
  required_version = ">= 1.5.0"

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

# 1. Multi-AZ VPC Module
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidr = var.private_subnet_cidr
  availability_zones  = var.availability_zones
  environment         = var.environment
  project_name        = var.project_name
}

# 2. Security Groups Module
module "security" {
  source = "../../modules/security"

  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
  project_name   = var.project_name
  container_port = var.container_port
}

# 3. Application Load Balancer Module
module "alb" {
  source = "../../modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  container_port        = var.container_port
}