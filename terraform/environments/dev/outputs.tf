output "dev_vpc_id" {
  value = module.vpc.vpc_id
}

output "dev_alb_dns_name" {
  description = "The public URL to reach the API once live"
  value       = module.alb.alb_dns_name
}

output "dev_target_group_arn" {
  value = module.alb.target_group_arn
}

output "dev_app_security_group_id" {
  value = module.security.app_security_group_id
}

output "dev_private_subnet_id" {
  value = module.vpc.private_subnet_id
}