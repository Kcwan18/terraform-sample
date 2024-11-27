resource "kubernetes_namespace" "kiali" {
  count = var.enable_kiali ? 1 : 0
  
  metadata {
    name = "kiali-operator"
    labels = {
      istio-injection = "enabled"
    }
  }
}

# resource "helm_release" "kiali_prometheus" {
#   name       = "kiali-prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus"
#   namespace  = "istio-system"

#   set {
#     name  = "server.persistentVolume.enabled"
#     value = "false"
#   }

#   set {
#     name  = "alertmanager.enabled"
#     value = "false"
#   }

#   depends_on = [
#     helm_release.istiod
#   ]
# }

resource "helm_release" "kiali" {
  count = var.enable_kiali ? 1 : 0
  
  name             = "kiali"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = kubernetes_namespace.kiali[0].metadata[0].name
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

#   set {
#     name  = "cr.spec.external_services.prometheus.url"
#     value = "http://kiali-prometheus.istio-system:9090"
#   }

#   set {
#     name  = "cr.spec.deployment.accessible_namespaces[0]"
#     value = "**"
#   }

  depends_on = [
    helm_release.istiod[0],
    helm_release.kiali_prometheus[0]
  ]
}

resource "kubernetes_manifest" "kiali_gateway" {
  count = var.enable_kiali ? 1 : 0
  
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: kiali-gateway
      namespace: istio-system
    spec:
      selector:
        istio: ${var.istio_ingress_name}
      servers:
      - port:
          number: 80
          name: http
          protocol: HTTP
        hosts:
        - "*"
  YAML
  )
  depends_on = [helm_release.kiali[0]]
}

resource "kubernetes_manifest" "kiali_virtualservice" {
  count = var.enable_kiali ? 1 : 0  
  
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: kiali
      namespace: istio-system
    spec:
      hosts:
      - "*"
      gateways:
      - kiali-gateway
      http:
      - match:
        - uri:
            prefix: /kiali
        route:
        - destination:
            host: kiali
            port:
              number: 20001
  YAML
  )
  depends_on = [kubernetes_manifest.kiali_gateway[0]]
}
