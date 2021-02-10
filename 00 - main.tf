terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = file("./accesskey")
  secret_key = file("./secretkey")
}

variable "vol_web_data" {
  description = "Vol Name of Web Data"
}

variable "vol_db_data" {
  description = "Vol Name of Db Data"
}

variable "ami_id" {
  description = "Default AMI ID used"
}

variable "instance_type" {
  description = "Default Instance Type"
}

variable "ssh_keyname" {
  description = "Default SSH Key Name"
}

variable "public_ip_web" {
  description = "EIP Name of WEB"
}

variable "public_ip_bastion" {
  description = "EIP Name of Bastion Host"
}

variable "use_nat_gateway" {
  description = "if true: use nat gateway to access internet, else: use nat instance"
  type        = bool
}

locals {
  az               = data.aws_availability_zones.available.names[0]
  use_nat_instance = !var.use_nat_gateway
}
