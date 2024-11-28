# resource "kubernetes_manifest" "prometheus_gateway" {
#   manifest = yamldecode(<<-YAML
#     apiVersion: networking.istio.io/v1alpha3
#     kind: Gateway
#     metadata:
#       name: prometheus-gateway
#       namespace: prometheus
#     spec:
#       selector:
#         istio: ${var.istio_ingress_name}
#       servers:
#       - port:
#           number: 80
#           name: http
#           protocol: HTTP
#         hosts:
#         - "*"
#       - port:
#           number: 9090
#           name: http2
#           protocol: HTTP
#         hosts:
#         - "*"
#   YAML
#   )
# }

# resource "kubernetes_manifest" "prometheus_virtualservice" {
#   manifest = yamldecode(<<-YAML
#     apiVersion: networking.istio.io/v1alpha3
#     kind: VirtualService
#     metadata:
#       name: prometheus
#       namespace: prometheus 
#     spec:
#       hosts:
#       - "*"
#       gateways:
#       - prometheus-gateway
#       http:
#       - match:
#         - uri:
#             prefix: /prometheus
#         route:
#         - destination:
#             host: prometheus-server
#             port:
#               number: 80
#   YAML
#   )
#   depends_on = [kubernetes_manifest.prometheus_gateway]
# }
