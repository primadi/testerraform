variable "vpc_cidr" {
  description = "VPC CIDR Block"
  default     = "192.168.0.0/16"
}

variable "name" {
  description = "VPC Name"
}

variable "enable_dns" {
  description = "Enable DNS Hostname and Support"
  default     = false
}
