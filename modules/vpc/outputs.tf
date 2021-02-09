output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "igw_routetable_id" {
  value = aws_default_route_table.igw.id
}

output "vpc_cidr" {
  value       = var.vpc_cidr
  description = "VPC CIDR"
}
