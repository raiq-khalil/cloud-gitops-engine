variable "aws_region" {
  description = "Target AWS region for deploying development resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name identifier"
  type        = string
  default     = "cloud-gitops"
}

variable "environment" {
  description = "Target deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "Base VPC CIDR block for dev"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
  default     = "10.10.2.0/24"
}

variable "availability_zone" {
  description = "Target availability zone"
  type        = string
  default     = "us-east-1a"
}