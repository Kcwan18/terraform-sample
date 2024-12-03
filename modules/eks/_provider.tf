terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm" 
      version = "~> 2.0"
    }
  }
}

# Extract common provider config into locals
locals {
  cluster_config = {
    host                   = aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.main.name, "--region", data.aws_region.current.name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = local.cluster_config.host
  cluster_ca_certificate = local.cluster_config.cluster_ca_certificate
  exec {
    api_version = local.cluster_config.exec.api_version
    args        = local.cluster_config.exec.args
    command     = local.cluster_config.exec.command
  }
}

# provider "helm" {
#   kubernetes {
#     host                   = local.cluster_config.host
#     cluster_ca_certificate = local.cluster_config.cluster_ca_certificate
#     exec {
#       api_version = local.cluster_config.exec.api_version
#       args        = local.cluster_config.exec.args
#       command     = local.cluster_config.exec.command
#     }
#   }
# }


