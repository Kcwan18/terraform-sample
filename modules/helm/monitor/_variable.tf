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



data "aws_route53_zone" "lab" {
  name = "lab.one2.cloud"
}

variable "ingress_name" {}
variable "nlb_endpoint" {}
variable "dns" {}

# variable "domain" {
#   type = object({
#     bookinfo = string
#   })
#   default = {
#     bookinfo = "bookinfo.lab.one2.cloud"
#   }
# }


# variable "istio_ingress" {
#   type = object({
#     name = string
#     nlb_endpoint = string
#   })
# }
