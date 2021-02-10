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

# NAT Gateway has Route Table
# Route Table has Route
resource "aws_route_table" "nat_gw" {
  count  = var.use_nat_gateway ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }

  lifecycle {
    # create before destroy is needed, because associated route table cannot deleted
    # if terraform need to modify security group, terraform must do :
    # 1. Create new route table
    # 2. change associated instance to new route table
    # 3. delete old route table
    #
    # route  detail must define separated from route table,
    # reason: it is more easy for terraform to add/ delete route if needed
    create_before_destroy = true
  }
}

# Route Represent Single Route of Route Table
# Must be separated from Route Table
resource "aws_route" "nat_gw" {
  count                  = var.use_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.nat_gw[0].id
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
  destination_cidr_block = "0.0.0.0/0"
}
