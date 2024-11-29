# Istio service mesh installation
module "istio" {
  source = "./cluster-addon/istio"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  depends_on = [aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}

# Lab environment setup with Istio integration
module "lab" {
  source              = "./cluster-addon/istio-addon/lab"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  istio_ingress = {
    name         = module.istio.istio_ingress_name
    nlb_endpoint = module.istio.nlb_endpoint
  }
  depends_on = [module.istio, aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}

# Kiali dashboard for Istio service mesh visualization
module "kiali" {
  source = "./cluster-addon/istio-addon/kiali"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  istio_ingress = {
    name         = module.istio.istio_ingress_name
    nlb_endpoint = module.istio.nlb_endpoint
  }
  depends_on = [module.istio, aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}

# Monitoring stack installation (Prometheus & Grafana)
module "monitor" {
  source = "./cluster-addon/monitor"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  istio_ingress = {
    name         = module.istio.istio_ingress_name
    nlb_endpoint = module.istio.nlb_endpoint
  }
  depends_on = [module.istio, aws_eks_cluster.main, kubernetes_config_map.aws_auth]
}
