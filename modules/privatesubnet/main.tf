resource "aws_subnet" "privatesubnet" {
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = var.name
  }
}
