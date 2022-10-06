# khai báo provider, xác thực
# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.20.1"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1" # Singapore region
  profile = "default"
}

# Configure terraform remote state with S3 bucket and locking with DynamoDB table

terraform {
  backend "s3" {
    bucket         = "vn-techmaster-devops-0011-terraform-state"
    key            = "testing/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
