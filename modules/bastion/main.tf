resource "aws_security_group" "bastion" {
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

resource "aws_security_group_rule" "ssh_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "all_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  availability_zone      = var.availability_zone
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = var.publicsubnet_id

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

data "aws_eip" "bastion" {
  filter {
    name   = "tag:Name"
    values = [var.public_ip_name]
  }
}

resource "aws_eip_association" "bastion" {
  count         = var.public_ip_name == "" ? 0 : 1
  instance_id   = aws_instance.bastion.id
  allocation_id = data.aws_eip.bastion.id
}

resource "aws_eip" "bastion" {
  count    = var.public_ip_name == "" ? 1 : 0
  vpc      = true
  instance = aws_instance.ec2.id

  tags = {
    Name = var.name
  }
}
