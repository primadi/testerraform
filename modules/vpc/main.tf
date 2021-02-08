resource "aws_vpc" "def_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns
  enable_dns_support   = var.enable_dns
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "def_igw" {
  vpc_id = aws_vpc.def_vpc.id
  tags = {
    Name = var.name
  }
}
