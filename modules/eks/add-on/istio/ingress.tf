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


#   depends_on = [
#     kubernetes_namespace.istio-ingress
#   ]
# }
