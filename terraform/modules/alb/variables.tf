variable "project_name" {
  description = "Base project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "Target VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to host the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID allowing inbound HTTP traffic"
  type        = string
}

variable "container_port" {
  description = "Application port backend targets listen on"
  type        = number
  default     = 8000
}

variable "health_check_path" {
  description = "Endpoint path for diagnostic health checks"
  type        = string
  default     = "/health"
}