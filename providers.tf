terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "wordpress-tfbucket"
    key    = "wordpress/terraform.tfstate"
    use_lockfile = true
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = var.aws_region
}
