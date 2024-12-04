

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
  source = "./modules/add-on/istio"
}

module "monitor" {
  source = "./modules/add-on/monitor"
  ingress_name = module.istio.istio_ingress_name
  nlb_endpoint = module.istio.nlb_endpoint
  dns = {
    prometheus = "prometheus.lab.one2.cloud"
    grafana = "grafana.lab.one2.cloud"
  }
}

module "kiali" {
  source = "./modules/add-on/kiali"
  ingress_name = module.istio.istio_ingress_name
  nlb_endpoint = module.istio.nlb_endpoint
  dns = "kiali.lab.one2.cloud"
}

module "bookinfo" {
  source = "./modules/add-on/bookinfo"
  ingress_name = var.ingress_name
  nlb_endpoint = var.nlb_endpoint
  dns = "bookinfo.lab.one2.cloud"

}

