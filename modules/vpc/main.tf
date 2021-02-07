resource "aws_vpc" "def_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
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
