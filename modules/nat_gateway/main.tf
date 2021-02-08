resource "aws_eip" "nat_gw" {
  count = var.use_nat_gateway ? 1 : 0
  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.use_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_gw[0].id
  subnet_id     = var.publicsubnet_id
  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "nat_gw" {
  count  = var.use_nat_gateway ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[0].id
  }
  tags = {
    Name = var.name
  }
}
