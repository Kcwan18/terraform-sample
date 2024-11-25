resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = var.istio_repository
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = false

  set {
    name  = "defaultRevision"
    value = "default"
  }

  depends_on = [kubernetes_namespace.istio-system]
}

resource "helm_release" "istiod" {
  name             = "istiod"
  repository       = var.istio_repository
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = false
  wait             = true

  depends_on = [helm_release.istio_base]
}
