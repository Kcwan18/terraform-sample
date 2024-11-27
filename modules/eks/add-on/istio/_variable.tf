variable "istio_repository" {
  type = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_ingress_name" {
  type = string
  default = "ingressgateway"
}

# variable "subnet_ids" {
#   type        = list(string)
#   description = "List of subnet IDs where the load balancer can be created"
# }