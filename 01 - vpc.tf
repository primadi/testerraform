module "vpc" {
  source = "./modules/vpc"

  name     = "vpc_arov2"
  vpc_cidr = "192.168.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "use_nat_gateway" {
  description = "if true: use nat gateway to access internet, else: use nat instance"
  type        = bool
}

locals {
  az               = data.aws_availability_zones.available.names[0]
  use_nat_instance = !var.use_nat_gateway
}
