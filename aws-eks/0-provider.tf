provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      CreatedVia = "terraform"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
