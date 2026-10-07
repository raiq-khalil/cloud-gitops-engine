variable "project_name" {
  description = "Base project identifier"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where workloads run"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for isolated container execution"
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID allowing inbound traffic strictly from ALB"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group to register container tasks"
  type        = string
}

variable "container_image" {
  description = "Full URI of the published container image in GHCR"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the FastAPI container"
  type        = number
  default     = 8000
}

variable "cpu" {
  description = "Fargate CPU units (256 = 0.25 vCPU)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Fargate Memory (512 = 512 MB)"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Number of container task replicas to maintain"
  type        = number
  default     = 1
}