terraform {
  backend "s3" {
    bucket         = "kcwan-iac-terraform-sample"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "kcwan-iac-terraform-sample-lockid"
  }
}

provider "aws" {
  region = var.aws_provider.region
}

