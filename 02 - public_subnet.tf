module "publicsubnet" {
  source = "./modules/publicsubnet"

  name              = "arov2_public"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = "192.168.0.0/24"
  igw_routetable_id = module.vpc.igw_routetable_id
  availability_zone = local.az
}
