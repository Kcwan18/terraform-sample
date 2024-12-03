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

  set {
    name  = "cr.spec.external_services.prometheus.url"
    value = "http://prometheus-server.monitor:80"
  }

  set {
    name  = "cr.spec.external_services.grafana.enabled"
    value = "true"
  }

  set {
    name  = "cr.spec.external_services.grafana.internal_url"
    value = "http://grafana.monitor:80"
  }

  set {
    name  = "cr.spec.deployment.accessible_namespaces"
    value = "[\"**\"]"
  }

  # set {
  #   name  = "cr.spec.istio_namespace"
  #   value = "istio-system"
  # }

  # set {
  #   name  = "cr.spec.deployment.ingress_enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "cr.spec.server.web_root"
  #   value = "/kiali"
  # }

  # set {
  #   name  = "cr.spec.external_services.istio.gateway_selector.istio"
  #   value = "ingressgateway"
  # }

  # set {
  #   name  = "cr.spec.external_services.istio.gateway_selector_namespace"
  #   value = "istio-system"
  # }

#   set {
#     name  = "cr.spec.external_services.grafana.dashboards"
#     value = jsonencode([
#       {
#         name = "Istio Service Dashboard"
#         variables = {
#           namespace = "var-namespace"
#           service   = "var-service"
#         }
#       }
#     ])
#   }
}
