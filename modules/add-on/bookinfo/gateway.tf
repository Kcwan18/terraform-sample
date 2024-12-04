

resource "kubernetes_manifest" "bookinfo_gateway" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1
    kind: Gateway
    metadata:
      name: bookinfo-gateway
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
    spec:
      selector:
        istio: ${var.ingress_name}
      servers:
      - port:
          number: 80
          name: http
          protocol: HTTP
        hosts:
        - "*"
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_virtualservice" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1
    kind: VirtualService
    metadata:
      name: bookinfo
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
    spec:
      hosts:
      - "*"
      gateways:
      - bookinfo-gateway
      http:
      - match:
        - uri:
            exact: /productpage
        - uri:
            prefix: /static
        - uri:
            exact: /login
        - uri:
            exact: /logout
        - uri:
            prefix: /api/v1/products
        route:
        - destination:
            host: productpage
            port:
              number: 9080
  YAML
  )
  depends_on = [kubernetes_manifest.bookinfo_gateway]
}

resource "aws_route53_record" "bookinfo" {
  zone_id = data.aws_route53_zone.lab.zone_id
  name    = var.dns
  type    = "CNAME"
  ttl     = "300"
  records = [var.nlb_endpoint]
}
