# Get current data
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

variable "eks_cluster_name" {
  type = string
  default = "eks-cluster"
}

variable "slack_webhook_url" {
  type = string
}

variable "user_arns" {
  type = list(string)
}


variable "enable_kiali" {
  type        = bool
  default     = false
  description = "Enable Kiali deployment in EKS cluster"
}

variable "enable_bookinfo" {
  type        = bool
  default     = false
  description = "Enable Bookinfo sample application deployment in EKS cluster"
}