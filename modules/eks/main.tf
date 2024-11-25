module "istio" {
  source = "./add-on/istio"
  providers = {
    kubernetes = kubernetes
    helm      = helm
  }
}