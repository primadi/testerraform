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

variable "publicsubnet_id" {
  description = "ID of public subnet to access internet"
}

variable "use_nats_instance" {
  description = "if true, this subnet use nats instance to access internet"
  type        = bool
}

variable "nat_instance_type" {
  description = "NAT Instance Type"
}

variable "use_nats_gateway" {
  description = "if true, this subnet use nats gateway to access internet"
  type        = bool
}
