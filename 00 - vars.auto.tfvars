vol_web_data      = "web_data"
vol_db_data       = "db_data"
ami_id            = "ami-0e2e44c03b85f58b3"
instance_type     = "t2.micro"
ssh_keyname       = "mykeypair"
public_ip_web     = "web_eip"       #if empty auto generate eip
public_ip_bastion = "bastion_eip"   #if empty auto generate eip


# if true  : use nat gateway
# if false : use nat instance
use_nat_gateway   = false
