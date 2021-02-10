module "ec2_db" {
  source = "./modules/privateec2"

  name              = "ec2_db"
  key_name          = var.ssh_keyname
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = module.vpc.vpc_id
  privatesubnet_id  = module.privatesubnet.subnet_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  ebs_vol_name      = var.vol_db_data
  connect_bastion   = true
  bastion_ip        = module.ec2_nat_instance.private_ip # use nat instance as bastion
  # bastion_ip        = module.ec2_bastion.bastion_ip
}

output "ec2_db_ip" {
  value = module.ec2_db.private_ip
}

resource "aws_security_group_rule" "tarantool_access" {
  type              = "ingress"
  from_port         = 3301
  to_port           = 3301
  protocol          = "tcp"
  cidr_blocks       = [module.vpc.vpc_cidr]
  security_group_id = module.ec2_db.security_group_id
}

