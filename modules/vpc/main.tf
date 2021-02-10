resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.name
  }
}

resource "aws_default_route_table" "igw" {
  # this is default route table for VPC, cannot created or deleted
  # this is special resources, terraform not create it,
  # but referring to default route table in VPC
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    Name = var.name
  }
}

# Route Represent Single Route of Route Table
# Must be separated from Route Table
resource "aws_route" "igw" {
  route_table_id         = aws_default_route_table.igw.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}
