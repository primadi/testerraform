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

variable "ebs_size" {
  description = "Additional EBS Vol Size"
  type        = number
}
