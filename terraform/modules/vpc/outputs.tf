output "vpc_id" {
  description = "The ID of the provisioned VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  value       = aws_subnet.public[*].id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private.id
}

output "nat_gateway_ip" {
  description = "Elastic IP allocated to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}