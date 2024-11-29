resource "kubernetes_manifest" "kiali_gateway" {
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
  depends_on = [kubernetes_manifest.kiali_gateway]
}
