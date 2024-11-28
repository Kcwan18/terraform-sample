module "lab" {
  source = "./istio-addon/lab"
  istio_ingress_name = var.istio_ingress_name
  depends_on = [ helm_release.istio_base ]
}

module "kiali" {
  source = "./istio-addon/kiali"
  istio_ingress_name = var.istio_ingress_name
  depends_on = [ helm_release.istio_base ]
}
