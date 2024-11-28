module "istio" {
  source = "./cluster-addon/istio"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}


module "monitor" {
  source = "./cluster-addon/monitor"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  istio_ingress_name = module.istio.istio_ingress_name
}
