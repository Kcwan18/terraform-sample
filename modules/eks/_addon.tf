module "istio" {
  source = "./cluster-addon/istio"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  depends_on = [aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}


module "lab" {
  source = "./cluster-addon/istio-addon/lab"
  istio_ingress_name = module.istio.istio_ingress_name
  depends_on = [module.istio, aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}

module "kiali" {
  source = "./cluster-addon/istio-addon/kiali"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  istio_ingress_name = module.istio.istio_ingress_name
  depends_on = [module.istio, aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}

module "monitor" {
  source = "./cluster-addon/monitor"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  istio_ingress_name = module.istio.istio_ingress_name
  depends_on = [module.istio, aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}
