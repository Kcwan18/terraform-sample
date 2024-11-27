variable "istio_repository" {
  type    = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_ingress_name" {
  type    = string
  default = "ingressgateway"
}

variable "enable_kiali" {
  type        = bool
  default     = false
  description = "Enable Kiali deployment"
}

variable "enable_bookinfo" {
  type        = bool
  default     = false
  description = "Enable Bookinfo sample application deployment"
}