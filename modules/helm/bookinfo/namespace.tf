resource "kubernetes_namespace" "bookinfo" {
  metadata {
    name = "bookinfo"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}
