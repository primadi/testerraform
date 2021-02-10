variable "name" {
  description = "EC2 Name"
}

variable "key_name" {
  description = "SSH Key Name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "availability_zone" {
  description = "Availibility Zone of Created EC2"
}

variable "publicsubnet_id" {
  description = "ID of public subnet"
}

variable "ami_id" {
  description = "AMI ID"
}

variable "instance_type" {
  description = "AMI Instance Type"
}

variable "public_ip_name" {
  description = "Name of Public IP, If Empty Auto Generate"
  type        = string
}
