output "dev_vpc_id" {
  description = "The ID of the development VPC"
  value       = module.vpc.vpc_id
}

output "dev_public_subnet_id" {
  description = "The subnet ID for public ingress / load balancer"
  value       = module.vpc.public_subnet_id
}

output "dev_private_subnet_id" {
  description = "The subnet ID for isolated container workloads"
  value       = module.vpc.private_subnet_id
}

output "dev_nat_gateway_ip" {
  description = "Public Elastic IP assigned to the development NAT Gateway"
  value       = module.vpc.nat_gateway_ip
}