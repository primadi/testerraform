module "ec2_postgres" {
  source = "./modules/privateec2"

  name              = "ec2_postgres"
  key_name          = "mykeypair"
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = module.vpc.vpc_id
  privatesubnet_id  = module.privatesubnet.subnet_id
  ami_id            = "ami-0e2e44c03b85f58b3"
  instance_type     = "t2.micro"
  ebs_size          = 8
  connect_bastion   = true
  bastion_ip        = module.ec2_bastion.bastion_ip
}

resource "aws_security_group_rule" "postgres_access" {
  type              = "ingress"
  from_port         = 7654
  to_port           = 7654
  protocol          = "tcp"
  cidr_blocks       = [module.vpc.vpc_cidr]
  security_group_id = module.ec2_postgres.security_group_id
}

