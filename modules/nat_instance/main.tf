data "aws_ami" "nat_i" {
  # find most recent AMI from Amazon for NAT Instance
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

  lifecycle {
    # create before destroy is needed, because attached security group cannot deleted
    # if terraform need to modify security group, terraform must do :
    # 1. Create new security group
    # 2. change attached instance to new security group
    # 3. delete old security group
    #
    # security group detail must define separated from security group,
    # reason: it is more easy for terraform to add/ delete rule if needed
    create_before_destroy = true
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

resource "aws_security_group_rule" "ssh_access" {
  count             = var.use_nat_instance ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_i[0].id
}

resource "aws_instance" "nat_i" {
  count                       = var.use_nat_instance ? 1 : 0
  ami                         = data.aws_ami.nat_i.id
  availability_zone           = var.availability_zone
  instance_type               = var.nat_instance_type
  key_name                    = var.key_name
  source_dest_check           = false
  subnet_id                   = var.publicsubnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.nat_i[0].id]

  root_block_device {
    # gp3 is more cheaper than gp2 :
    # https://cloudwiry.com/ebs-gp3-vs-gp2-pricing-comparison/
    volume_type = "gp3"
  }

  lifecycle {
    # no need to update terraform if public ip address change
    ignore_changes = [associate_public_ip_address]
  }

  tags = {
    Name = var.name
  }
}

data "aws_eip" "nat_i" {
  filter {
    name   = "tag:Name"
    values = [var.public_ip_name]
  }
}

resource "aws_eip_association" "nat_i" {
  count         = var.public_ip_name == "" ? 0 : 1
  instance_id   = aws_instance.nat_i[0].id
  allocation_id = data.aws_eip.nat_i.id
}

resource "aws_eip" "nat_i" {
  count    = var.public_ip_name == "" ? 1 : 0
  vpc      = true
  instance = aws_instance.nat_i[0].id

  tags = {
    Name = var.name
  }
}

# Internet Gateway has Route Table
# Route Table has Route
resource "aws_route_table" "nat_i" {
  count  = var.use_nat_instance ? 1 : 0
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
resource "aws_route" "nat_i" {
  count                  = var.use_nat_instance ? 1 : 0
  route_table_id         = aws_route_table.nat_i[0].id
  instance_id            = aws_instance.nat_i[0].id
  destination_cidr_block = "0.0.0.0/0"
}
