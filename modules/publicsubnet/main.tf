resource "aws_subnet" "publicsubnet" {
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "publicsubnet" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = var.igw_routetable_id
}
