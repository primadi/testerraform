module "privatesubnet" {
  source = "./modules/privatesubnet"

  name              = "private_subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = "192.168.1.0/24"
  availability_zone = local.az

  # Option 1 : use nat gateway to access internet :
  use_nat_gateway           = var.use_nat_gateway
  nat_gateway_routetable_id = module.nat_gateway.nat_routetable_id

  # option 2 : use nat instance to access internet :
  use_nat_instance              = local.use_nat_instance
  nat_instance_routetable_id    = module.ec2_nat_instance.nat_routetable_id
  nat_instance_securitygroup_id = module.ec2_nat_instance.nat_instance_securitygroup_id
}
