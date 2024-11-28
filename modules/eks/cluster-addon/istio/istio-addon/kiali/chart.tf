resource "kubernetes_namespace" "kiali" {
  metadata {
    name = "kiali-operator"
    labels = {
      istio-injection = "enabled"
    }
  }
}


resource "helm_release" "kiali" {
  name             = "kiali"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = kubernetes_namespace.kiali.metadata[0].name
  create_namespace = false

  set {
    name  = "cr.create"
    value = "true"
  }

  set {
    name  = "cr.namespace"
    value = "istio-system"
  }

  set {
    name  = "cr.spec.auth.strategy"
    value = "anonymous"
  }

}
