resource "aws_security_group" "ec2" {
  description = "Allow HTTP, HTTPS and SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.allow_https ? [1] : []
    content {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.allow_http ? [1] : []
    content {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.name
  }
}

# resource "aws_key_pair" "ec2" {
#   key_name   = var.key_name
#   public_key = var.public_key
# }

resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  availability_zone      = var.availability_zone
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = var.publicsubnet_id

  root_block_device {
    volume_type = "gp2"
    volume_size = var.ebs_size
  }

  tags = {
    Name = var.name
  }
}

resource "aws_eip" "ec2" {
  vpc      = true
  instance = aws_instance.ec2.id

  tags = {
    Name = var.name
  }
}
