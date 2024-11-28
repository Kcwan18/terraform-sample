module "istio" {
  source = "./cluster-addon/istio"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}


module "prometheus" {
  source = "./cluster-addon/prometheus"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  istio_ingress_name = module.istio.istio_ingress_name
}
