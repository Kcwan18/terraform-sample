module "lab" {
  source = "./istio-addon/lab"
  istio_ingress_name = var.istio_ingress_name
}
