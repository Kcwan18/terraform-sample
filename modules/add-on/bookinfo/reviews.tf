resource "kubernetes_manifest" "bookinfo_reviews_service" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: reviews
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: reviews
        service: reviews
    spec:
      ports:
      - port: 9080
        name: http
      selector:
        app: reviews
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_reviews_serviceaccount" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: bookinfo-reviews
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        account: reviews
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_reviews_v1_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: reviews-v1
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: reviews
        version: v1
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: reviews
          version: v1
      template:
        metadata:
          labels:
            app: reviews
            version: v1
        spec:
          serviceAccountName: bookinfo-reviews
          containers:
          - name: reviews
            image: docker.io/istio/examples-bookinfo-reviews-v1:1.20.2
            imagePullPolicy: IfNotPresent
            env:
            - name: LOG_DIR
              value: "/tmp/logs"
            ports:
            - containerPort: 9080
            volumeMounts:
            - name: tmp
              mountPath: /tmp
            - name: wlp-output
              mountPath: /opt/ibm/wlp/output
          volumes:
          - name: wlp-output
            emptyDir: {}
          - name: tmp
            emptyDir: {}
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_reviews_v2_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: reviews-v2
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: reviews
        version: v2
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: reviews
          version: v2
      template:
        metadata:
          labels:
            app: reviews
            version: v2
        spec:
          serviceAccountName: bookinfo-reviews
          containers:
          - name: reviews
            image: docker.io/istio/examples-bookinfo-reviews-v2:1.20.2
            imagePullPolicy: IfNotPresent
            env:
            - name: LOG_DIR
              value: "/tmp/logs"
            ports:
            - containerPort: 9080
            volumeMounts:
            - name: tmp
              mountPath: /tmp
            - name: wlp-output
              mountPath: /opt/ibm/wlp/output
          volumes:
          - name: wlp-output
            emptyDir: {}
          - name: tmp
            emptyDir: {}
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_reviews_v3_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: reviews-v3
      namespace: ${kubernetes_namespace.bookinfo.metadata[0].name}
      labels:
        app: reviews
        version: v3
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: reviews
          version: v3
      template:
        metadata:
          labels:
            app: reviews
            version: v3
        spec:
          serviceAccountName: bookinfo-reviews
          containers:
          - name: reviews
            image: docker.io/istio/examples-bookinfo-reviews-v3:1.20.2
            imagePullPolicy: IfNotPresent
            env:
            - name: LOG_DIR
              value: "/tmp/logs"
            ports:
            - containerPort: 9080
            volumeMounts:
            - name: tmp
              mountPath: /tmp
            - name: wlp-output
              mountPath: /opt/ibm/wlp/output
          volumes:
          - name: wlp-output
            emptyDir: {}
          - name: tmp
            emptyDir: {}
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}
