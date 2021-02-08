module "vpc" {
  source = "./modules/vpc"

  name     = "vpc_arov2"
  vpc_cidr = "192.168.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az = data.aws_availability_zones.available.names[0]
}
