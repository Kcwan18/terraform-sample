resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitor.metadata[0].name

  set {
    name  = "persistence.enabled"
    value = "false"
  }

  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "Prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].url"
    value = "http://prometheus-server:80"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].access"
    value = "proxy"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].isDefault"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

# Create Istio Gateway for Grafana
resource "kubernetes_manifest" "grafana_gateway" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: grafana-gateway
      namespace: ${kubernetes_namespace.monitor.metadata[0].name}
    spec:
      selector:
        istio: ${var.ingress_name}
      servers:
      - port:
          number: 80
          name: http
          protocol: HTTP
        hosts:
        - ${var.dns.grafana}
  YAML
  )
  depends_on = [helm_release.grafana]
}

# Create VirtualService for Grafana
resource "kubernetes_manifest" "grafana_virtualservice" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: grafana
      namespace: ${kubernetes_namespace.monitor.metadata[0].name}
    spec:
      hosts:
      - ${var.dns.grafana}
      gateways:
      - grafana-gateway
      http:
      - route:
        - destination:
            host: grafana
            port:
              number: 80
  YAML
  )
  depends_on = [kubernetes_manifest.grafana_gateway]
}


resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.lab.zone_id
  name    = var.dns.grafana
  type    = "CNAME"
  ttl     = "300"
  records = [var.nlb_endpoint]
}
