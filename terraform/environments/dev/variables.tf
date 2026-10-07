variable "aws_region" {
  description = "Target AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base project name"
  type        = string
  default     = "cloud-gitops"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "Base VPC CIDR block"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs for ALB"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.10.10.0/24"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "container_port" {
  description = "Application port"
  type        = number
  default     = 8000
}

variable "container_image" {
  description = "Container image tag from GHCR"
  type        = string
  default     = "ghcr.io/raiq-khalil/cloud-gitops-engine:latest"
}