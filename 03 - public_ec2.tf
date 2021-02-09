module "ec2_web" {
  source = "./modules/publicec2"

  name              = "ec2_web"
  key_name          = "mykeypair"
  availability_zone = local.az
  vpc_id            = module.vpc.vpc_id
  publicsubnet_id   = module.publicsubnet.subnet_id
  ami_id            = "ami-0e2e44c03b85f58b3"
  instance_type     = "t2.micro"
  ebs_size          = 8
}

resource "aws_security_group_rule" "http_access" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ec2_web.security_group_id
}

output "ec2_web_public_ip" {
  value = module.ec2_web.public_ip
}

module "ec2_bastion" {
  source = "./modules/bastion"

  name              = "ec2_bastion"
  key_name          = "mykeypair"
  availability_zone = local.az
  vpc_id            = module.vpc.vpc_id
  publicsubnet_id   = module.publicsubnet.subnet_id
  ami_id            = "ami-0e2e44c03b85f58b3"
  instance_type     = "t2.micro"
}

output "ec2_bastion_public_ip" {
  value = module.ec2_bastion.public_ip
}

# Option 1 : Use NAT Gateway
module "nat_gateway" {
  source = "./modules/nat_gateway"

  name            = "ec_natgw"
  vpc_id          = module.vpc.vpc_id
  publicsubnet_id = module.publicsubnet.subnet_id
  use_nat_gateway = var.use_nat_gateway
}

# Option 2 : Use NAT Instance 
module "ec2_nat_instance" {
  source = "./modules/nat_instance"

  name              = "ec2_nat_i"
  availability_zone = local.az
  vpc_id            = module.vpc.vpc_id
  publicsubnet_id   = module.publicsubnet.subnet_id
  nat_instance_type = "t2.micro"
  use_nat_instance  = local.use_nat_instance
}
