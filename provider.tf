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
  access_key = "AKIAROQAKRBBQQZKOMH3"
  secret_key = "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"
}
