resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitor.metadata[0].name

  set {
    name  = "server.persistentVolume.enabled"
    value = "false"
  }

  set {
    name  = "alertmanager.enabled" 
    value = "false"
  }

  set {
    name  = "server.retention"
    value = "6h"
  }
}

# Create Istio Gateway for Prometheus
resource "kubernetes_manifest" "prometheus_gateway" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: prometheus-gateway
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
        - ${var.dns.prometheus}
  YAML
  )
  depends_on = [helm_release.prometheus]
}

# Create VirtualService for Prometheus
resource "kubernetes_manifest" "prometheus_virtualservice" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: prometheus
      namespace: ${kubernetes_namespace.monitor.metadata[0].name}
    spec:
      hosts:
      - ${var.dns.prometheus}
      gateways:
      - prometheus-gateway
      http:
      - route:
        - destination:
            host: prometheus-server
            port:
              number: 80
  YAML
  )
  depends_on = [kubernetes_manifest.prometheus_gateway]
}

# Create DNS record for Prometheus
resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.lab.zone_id
  name    = var.dns.prometheus
  type    = "CNAME"
  ttl     = "300"
  records = [var.nlb_endpoint]
}
