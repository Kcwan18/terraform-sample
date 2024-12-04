resource "kubernetes_manifest" "bookinfo_details_service" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: details
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: details
        service: details
    spec:
      ports:
      - port: 9080
        name: http
      selector:
        app: details
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_details_serviceaccount" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: bookinfo-details
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        account: details
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_details_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: details-v1
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: details
        version: v1
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: details
          version: v1
      template:
        metadata:
          labels:
            app: details
            version: v1
        spec:
          serviceAccountName: bookinfo-details
          containers:
          - name: details
            image: docker.io/istio/examples-bookinfo-details-v1:1.20.2
            imagePullPolicy: IfNotPresent
            ports:
            - containerPort: 9080
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}
