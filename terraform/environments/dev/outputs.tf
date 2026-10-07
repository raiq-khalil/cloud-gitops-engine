output "dev_vpc_id" {
  description = "The ID of the development VPC"
  value       = module.vpc.vpc_id
}

output "dev_alb_dns_name" {
  description = "The public URL to reach the API once live"
  value       = module.alb.alb_dns_name
}

output "dev_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = module.alb.target_group_arn
}

output "dev_app_security_group_id" {
  description = "Security group ID for private containers"
  value       = module.security.app_security_group_id
}

output "dev_private_subnet_id" {
  description = "Private subnet ID"
  value       = module.vpc.private_subnet_id
}

output "dev_ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.compute.cluster_name
}

output "dev_ecs_service_name" {
  description = "Name of the ECS Fargate service"
  value       = module.compute.service_name
}