data "aws_ami" "nat_i" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "nat_i" {
  count  = var.use_nat_instance ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "all_access" {
  count             = var.use_nat_instance ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_i[0].id
}

resource "aws_security_group_rule" "ping" {
  count             = var.use_nat_instance ? 1 : 0
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_i[0].id
}

resource "aws_instance" "nat_i" {
  count                       = var.use_nat_instance ? 1 : 0
  ami                         = data.aws_ami.nat_i.id
  availability_zone           = var.availability_zone
  instance_type               = var.nat_instance_type
  source_dest_check           = false
  subnet_id                   = var.publicsubnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.nat_i[0].id]

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  tags = {
    Name = var.name
  }
}

resource "aws_eip" "nat_i" {
  count    = var.use_nat_instance ? 1 : 0
  vpc      = true
  instance = aws_instance.nat_i[0].id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "nat_i" {
  count  = var.use_nat_instance ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_i[0].id
  }

  tags = {
    Name = var.name
  }

  lifecycle {
    create_before_destroy = true
  }

}
