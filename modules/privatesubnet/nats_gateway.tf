resource "aws_eip" "nat_gw" {
  count = var.use_nats_gateway ? 1 : 0
  tags = {
    Name = join("", ["NAT ", var.name])
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.use_nats_gateway ? 1 : 0
  allocation_id = aws_eip.nat_gw[0].id
  subnet_id     = var.publicsubnet_id
  tags = {
    Name = join("", ["NAT ", var.name])
  }
}


resource "aws_route_table" "nat_gw" {
  count  = var.use_nats_gateway ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[0].id
  }
  tags = {
    Name = join("", ["NAT ", var.name])
  }
}

resource "aws_route_table_association" "nat_gw" {
  count          = var.use_nats_gateway ? 1 : 0
  route_table_id = aws_route_table.nat_gw[0].id
  subnet_id      = aws_subnet.privatesubnet.id
}
