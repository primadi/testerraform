variable "name" {
  description = "Subnet Name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "availability_zone" {
  description = "Subnet Availibility Zone"
}

variable "subnet_cidr" {
  description = "Subnet CIDR Block"
}

variable "use_nat_instance" {
  description = "Flag to use Nat Instance or not"
  default     = false
}

variable "use_nat_gateway" {
  description = "Flag to use Nat Gateway or not"
  default     = false
}

variable "nat_gateway_routetable_id" {
  description = "NAT Gateway route table id"
}

variable "nat_instance_routetable_id" {
  description = "NAT Instance route table id"
}

variable "nat_instance_securitygroup_id" {
  description = "NAT Instance Security Group ID - Use only if using nat instance"
  default     = ""
}
