resource "aws_security_group" "ec2" {
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
  user_data              = "#!/bin/bash\nmkdir /data; chown 'ec2-user' /data; echo '/dev/sdh /data ext4 defaults,nofail,noatime,nodiratime,barrier=0,data=writeback 0 2' >> /etc/fstab; mount -a"

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

data "aws_ebs_volume" "data" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = [var.ebs_vol_name]
  }
}

resource "aws_volume_attachment" "ec2" {
  count       = var.ebs_vol_name == "" ? 0 : 1
  device_name = "/dev/sdh"
  volume_id   = data.aws_ebs_volume.data.id
  instance_id = aws_instance.ec2.id
}
