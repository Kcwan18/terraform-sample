# resource "kubernetes_namespace" "istio_ingress" {
#   metadata {
#     name = "istio-ingress"
#   }
#   depends_on = [helm_release.istiod]
# }

resource "helm_release" "istio_ingress" {
  name             = var.istio_ingress_name
  repository       = var.istio_repository
  chart            = "gateway"
  namespace        = kubernetes_namespace.istio_system.metadata[0].name
  create_namespace = false
  wait             = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-proxy-protocol"
    value = "*"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
    type  = "string"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  depends_on = [helm_release.istiod]
}

# data "http" "gateway_api_crds" {
#   url = "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml"
# }

# locals {
#   gateway_api_crds = [
#     for doc in split("---", data.http.gateway_api_crds.response_body) : doc
#     if length(regexall("^\\s*#", doc)) == 0 && 
#        length(regexall("^\\s*$", doc)) == 0
#   ]
# }

# resource "kubernetes_manifest" "gateway_api_crds" {
#   for_each = { for idx, doc in local.gateway_api_crds : idx => doc }
#   manifest = {
#     for k, v in yamldecode(each.value) : k => v
#     if k != "status"
#   }

#   depends_on = [helm_release.istiod]
# }