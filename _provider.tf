terraform {
  # backend "s3" {
  #   bucket         = "kcwan-iac-terraform-sample"
  #   key            = "state/terraform.tfstate"
  #   region         = "ap-southeast-1"
  #   encrypt        = true
  #   dynamodb_table = "kcwan-iac-terraform-sample-lockid"
  # }

  cloud { 
    organization = "kcwan" 

    workspaces { 
      name = "personal" 
    } 
  } 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = var.aws_provider.region

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
}