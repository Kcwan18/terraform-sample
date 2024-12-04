output "istio_ingress_name" {
  description = "The name of the Istio ingress gateway"
  value       = "ingressgateway"
}

data "kubernetes_service" "istio_ingress" {
  metadata {
    name      = var.istio_ingress_name
    namespace = kubernetes_namespace.istio_system.metadata[0].name
  }
  depends_on = [helm_release.istio_ingress]
}

output "nlb_endpoint" {
  description = "The DNS name of the NLB created for the Istio ingress gateway"
  value       = data.kubernetes_service.istio_ingress.status[0].load_balancer[0].ingress[0].hostname
}
