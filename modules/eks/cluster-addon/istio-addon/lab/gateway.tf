

resource "kubernetes_manifest" "bookinfo_gateway" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: bookinfo-gateway
      namespace: bookinfo
    spec:
      selector:
        istio: ${var.istio_ingress.name}
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
    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: bookinfo
      namespace: bookinfo
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
