variable "name" {
  description = "NAT Gateway Name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "publicsubnet_id" {
  description = "ID of public subnet to access internet"
}

variable "use_nat_gateway" {
  description = "Use NAT Gateway or Not"
  type        = bool
}
