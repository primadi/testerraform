output "vpc_id" {
  value       = aws_vpc.def_vpc.id
  description = "VPC ID"
}

output "igw_id" {
  value       = aws_internet_gateway.def_igw.id
  description = "VPC Internet Gateway"
}
