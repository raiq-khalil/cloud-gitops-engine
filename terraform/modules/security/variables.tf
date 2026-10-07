variable "project_name" {
  description = "Base project name tag"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "container_port" {
  description = "Internal application port exposed by the container"
  type        = number
  default     = 8000
}