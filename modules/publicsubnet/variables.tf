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
  default     = "192.168.0.0/24"
}

variable "igw_id" {
  description = "Internet Gateway"
}
