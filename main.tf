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

module "k3s" {
  source = "./modules/k3s"
}
output "k3s_module_output" {
  description = "K3s module"
  value = {
    "ssh_command"     = "ssh -i 'ssh-key/k3s-key.pem' ec2-user@${module.k3s.instance_public_dns}"
    "check_user_data" = "cat /var/log/cloud-init-output.log"
  }
}
