resource "aws_subnet" "privatesubnet" {
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "privatesubnet" {
  count          = var.use_nat_instance || var.use_nat_gateway ? 1 : 0
  route_table_id = var.use_nat_gateway ? var.nat_gateway_routetable_id : var.nat_instance_routetable_id
  subnet_id      = aws_subnet.privatesubnet.id
}

resource "aws_security_group_rule" "privatesubnet" {
  count             = var.use_nat_instance ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.subnet_cidr]
  security_group_id = var.nat_instance_securitygroup_id
}
