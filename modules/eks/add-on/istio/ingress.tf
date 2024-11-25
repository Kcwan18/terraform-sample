# resource "kubernetes_namespace" "istio-ingress" {
#   metadata {
#     name = "istio-ingress"
#   }
# }
# resource "helm_release" "istio_ingress" {
#   name       = "istio-ingress"
#   chart      = "gateway"
#   repository = var.istio_repository
#   namespace  = "istio-ingress"
#   wait       = true

#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }

#   set {
#     name  = "service.externalTrafficPolicy"
#     value = "Local"
#   }

#   set {
#     name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-proxy-protocol"
#     value = "*"
#   }

#   set {
#     name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
#     value = "true"
#   }

#   set {
#     name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
#     value = "nlb"
#   }

#   set {
#     name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
#     value = "internet-facing"
#   }

#   depends_on = [
#     kubernetes_namespace.istio-ingress
#   ]
# }
