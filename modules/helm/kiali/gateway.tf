resource "kubernetes_manifest" "kiali_gateway" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: kiali-gateway
      namespace: istio-system
    spec:
      selector:
        istio: ${var.istio_ingress.name}
      servers:
      - port:
          number: 80
          name: http
          protocol: HTTP
        hosts:
        - ${var.domain.kiali}
  YAML
  )
  depends_on = [helm_release.kiali]
}

resource "kubernetes_manifest" "kiali_virtualservice" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: kiali
      namespace: istio-system
    spec:
      hosts:
      - ${var.domain.kiali}
      gateways:
      - kiali-gateway
      http:
      - route:
        - destination:
            host: kiali
            port:
              number: 20001
  YAML
  )
  depends_on = [kubernetes_manifest.kiali_gateway]
}


resource "aws_route53_record" "kiali" {
  zone_id = data.aws_route53_zone.lab.zone_id
  name    = var.domain.kiali
  type    = "CNAME"
  ttl     = "300"
  records = [var.istio_ingress.nlb_endpoint]
}
