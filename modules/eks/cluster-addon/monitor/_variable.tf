terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}


variable "istio_ingress" {
  type = object({
    name = string
    nlb_endpoint = string
  })
}

data "aws_route53_zone" "lab" {
  name = "lab.one2.cloud"
}

variable "domain" {
  type = object({
    grafana = string
    prometheus = string
  })
  default = {
    grafana = "grafana.lab.one2.cloud"
    prometheus = "prometheus.lab.one2.cloud"
  }
}