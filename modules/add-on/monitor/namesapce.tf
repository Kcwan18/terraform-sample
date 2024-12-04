resource "kubernetes_namespace" "monitor" {
  metadata {
    name = "monitor"
    labels = {
      istio-injection = "enabled"
    }
  }
}
