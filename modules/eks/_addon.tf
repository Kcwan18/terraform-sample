module "istio" {
  source = "./add-on/istio"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  enable_kiali    = var.enable_kiali
  enable_bookinfo = var.enable_bookinfo
}


