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

variable "ami_id" {
  description = "AMI ID"
}

variable "instance_type" {
  description = "AMI Instance Type"
}

variable "ebs_vol_name" {
  description = "EBS Volume Name"
  type        = string
}

variable "connect_bastion" {
  description = "Connect to bastion or not"
  type        = bool
}

variable "bastion_ip" {
  description = "Bastion IP Address"
}

variable "privatesubnet_id" {
  description = "ID of private subnet"
}
