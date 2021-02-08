variable "name" {
  description = "NAT Gateway Name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "availability_zone" {
  description = "Availibility Zone of Created EC2"
}

variable "publicsubnet_id" {
  description = "ID of public subnet to access internet"
}

variable "nat_instance_type" {
  description = "NAT Instance EC2 Type"
}

variable "use_nat_instance" {
  description = "Use NAT Instance or Not"
  type        = bool
}
