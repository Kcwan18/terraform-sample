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

module "k3s" {
  source = "./modules/k3s"
  slack_webhook_url = var.slack_webhook_url
}

module "outline" {
  source = "./modules/outline"
  slack_webhook_url = var.slack_webhook_url
}

module "eks" {
  source = "./modules/eks"
  slack_webhook_url = var.slack_webhook_url
}

