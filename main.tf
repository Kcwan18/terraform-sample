terraform {
  backend "s3" {
    bucket         = "kcwan-iac-terraform-sample"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "kcwan-iac-terraform-sample-lockid"
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
  region = var.aws_provider.region

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
}

module "k3s" {
  source = "./modules/k3s"
}

output "k3s_module_output" {
  description = "Commands to interact with K3s cluster"
  value = {
    "ssh_command"     = "ssh -i 'ssh-key/k3s-key.pem' ec2-user@${module.k3s.instance_public_dns}"
    "check_user_data" = "cat /var/log/cloud-init-output.log"
  }
  sensitive = false
}

module "outline" {
  source = "./modules/outline"
}

output "outline_module_output" {
  description = "Commands to interact with Outline server"
  value = {
    "ssh_command"     = "ssh -i 'ssh-key/outline-key.pem' ec2-user@${module.outline.instance_public_dns}"
    "check_user_data" = "cat /var/log/cloud-init-output.log"
  }
  sensitive = false
}
