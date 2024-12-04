resource "kubernetes_manifest" "bookinfo_ratings_service" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: ratings
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: ratings
        service: ratings
    spec:
      ports:
      - port: 9080
        name: http
      selector:
        app: ratings
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_ratings_serviceaccount" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: bookinfo-ratings
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        account: ratings
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_ratings_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ratings-v1
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: ratings
        version: v1
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: ratings
          version: v1
      template:
        metadata:
          labels:
            app: ratings
            version: v1
        spec:
          serviceAccountName: bookinfo-ratings
          containers:
          - name: ratings
            image: docker.io/istio/examples-bookinfo-ratings-v1:1.20.2
            imagePullPolicy: IfNotPresent
            ports:
            - containerPort: 9080
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

