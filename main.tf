

module "k3s" {
  source = "./modules/k3s"
  slack_webhook_url = var.slack_webhook_url
}

module "outline" {
  source = "./modules/outline"
  slack_webhook_url = var.slack_webhook_url
}

module "eks" {
  source = "./modules/eks"
  slack_webhook_url = var.slack_webhook_url
  user_arns        = var.user_arns
}

module "istio" {
  source = "./modules/helm/istio"
}

module "monitor" {
  source = "./modules/helm/monitor"
  istio_ingress = {
    name = module.istio.istio_ingress_name
    nlb_endpoint = module.istio.nlb_endpoint
  }
}

module "kiali" {
  source = "./modules/helm/kiali"
  istio_ingress = {
    name = module.istio.istio_ingress_name
    nlb_endpoint = module.istio.nlb_endpoint
  }
}

# a
