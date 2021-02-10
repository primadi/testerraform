module "ec2_web" {
  source = "./modules/publicec2"

  name              = "ec2_web"
  key_name          = var.ssh_keyname
  availability_zone = local.az
  vpc_id            = module.vpc.vpc_id
  publicsubnet_id   = module.publicsubnet.subnet_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  ebs_vol_name      = var.vol_web_data
  public_ip_name    = var.public_ip_web
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

# module "ec2_bastion" {
#   source = "./modules/bastion"
#   name              = "ec2_bastion"
#   key_name          = var.ssh_keyname
#   availability_zone = local.az
#   vpc_id            = module.vpc.vpc_id
#   publicsubnet_id   = module.publicsubnet.subnet_id
#   ami_id            = var.ami_id
#   instance_type     = var.instance_type
# }

# output "ec2_bastion_public_ip" {
#   value = module.ec2_bastion.public_ip
# }

# Option 1 : Use NAT Gateway
module "nat_gateway" {
  source = "./modules/nat_gateway"

  name            = "natgw"
  vpc_id          = module.vpc.vpc_id
  publicsubnet_id = module.publicsubnet.subnet_id
  use_nat_gateway = var.use_nat_gateway
}

# Option 2 : Use NAT Instance 
module "ec2_nat_instance" {
  source = "./modules/nat_instance"

  name              = "ec2_nat_i"
  availability_zone = local.az
  key_name          = var.ssh_keyname
  vpc_id            = module.vpc.vpc_id
  publicsubnet_id   = module.publicsubnet.subnet_id
  nat_instance_type = var.instance_type
  use_nat_instance  = local.use_nat_instance
  public_ip_name    = var.public_ip_bastion
}

output "ec2_bastion_ip" {
  value = var.use_nat_gateway ? module.nat_gateway.public_ip : module.ec2_nat_instance.public_ip
}
