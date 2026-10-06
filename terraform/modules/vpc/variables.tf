variable "vpc_cidr" {
  description = "Base IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet (DMZ / Load Balancers)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet (Application & Database tier)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Target availability zone for subnet deployment"
  type        = string
  default     = "us-east-1a"
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Base name tag for identifying resources"
  type        = string
  default     = "cloud-gitops"
}