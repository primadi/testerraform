resource "aws_security_group" "ec2" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh_access" {
  count             = var.connect_bastion ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [join("", [var.bastion_ip, "/32"])]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}


resource "aws_security_group_rule" "all_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  availability_zone      = var.availability_zone
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = var.privatesubnet_id

  root_block_device {
    volume_type = "gp3"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_ebs_volume" "ec2" {
  count             = var.ebs_size > 0 ? 1 : 0
  availability_zone = var.availability_zone
  type              = "gp3"
  size              = var.ebs_size

  tags = {
    Name = var.name
  }
}

resource "aws_volume_attachment" "ec2" {
  count       = var.ebs_size > 0 ? 1 : 0
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ec2[0].id
  instance_id = aws_instance.ec2.id
}
