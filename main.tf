module "vpc" {
  source = "./modules/vpc"

  name     = "vpc_arov2"
  vpc_cidr = "192.168.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "publicsubnet" {
  source = "./modules/publicsubnet"

  name              = "arov2_public"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = "192.168.0.0/24"
  igw_id            = module.vpc.igw_id
  availability_zone = data.aws_availability_zones.available.names[0]
}

module "privatesubnet" {
  source = "./modules/privatesubnet"

  name              = "arov2_private"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = "192.168.1.0/24"
  publicsubnet_id   = module.publicsubnet.subnet_id
  use_nats_instance = false
  nat_instance_type = "t2.micro"
  use_nats_gateway  = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

module "testec2" {
  source = "./modules/publicec2"

  name              = "testec2"
  key_name          = "dev-keypair"
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = module.vpc.vpc_id
  publicsubnet_id   = module.publicsubnet.subnet_id
  ami_id            = "ami-0e2e44c03b85f58b3"
  instance_type     = "t2.micro"
  ebs_size          = 8
  allow_http        = true
  allow_https       = false
}

output "testec2_ip" {
  value = module.testec2.public_ip
}
