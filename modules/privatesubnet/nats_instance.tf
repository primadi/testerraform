data "aws_ami" "nat_i" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "access_via_nat_i" {
  count       = var.use_nats_instance ? 1 : 0
  description = "Access to internet via nat instance for private nodes"
  vpc_id      = var.vpc_id

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("", ["NAT ", var.name])
  }
}

resource "aws_security_group_rule" "allow_inbound_traffic" {
  count             = var.use_nats_instance ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [aws_subnet.privatesubnet.id]
  security_group_id = aws_security_group.access_via_nat_i[0].id
}

resource "aws_instance" "nat_i" {
  count                       = var.use_nats_instance ? 1 : 0
  ami                         = data.aws_ami.nat_i.id
  instance_type               = var.nat_instance_type
  source_dest_check           = false
  subnet_id                   = var.publicsubnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.access_via_nat_i[0].id]

  tags = {
    Name = join("", ["NAT ", var.name])
  }
}

resource "aws_route_table" "nat_i" {
  count  = var.use_nats_instance ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_i[0].id
  }
  tags = {
    Name = join("", ["NAT ", var.name])
  }
}

resource "aws_route_table_association" "nat_i" {
  count          = var.use_nats_instance ? 1 : 0
  route_table_id = aws_route_table.nat_i[0].id
  subnet_id      = aws_subnet.privatesubnet.id
}
