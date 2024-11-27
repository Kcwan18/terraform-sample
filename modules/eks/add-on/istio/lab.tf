resource "kubernetes_labels" "default_namespace_istio_injection" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    "istio-injection" = "enabled"
  }
  depends_on = [helm_release.istiod]
}

resource "kubernetes_namespace" "bookinfo" {
  metadata {
    name = "bookinfo"
    labels = {
      "istio-injection" = "enabled"
    }
  }
  depends_on = [helm_release.istiod]
}


resource "kubernetes_manifest" "bookinfo_productpage" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: productpage
      namespace: bookinfo
      labels:
        app: productpage
        service: productpage
    spec:
      ports:
      - port: 9080
        name: http
      selector:
        app: productpage
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_productpage_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: productpage-v1
      namespace: bookinfo
      labels:
        app: productpage
        version: v1
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: productpage
          version: v1
      template:
        metadata:
          labels:
            app: productpage
            version: v1
        spec:
          containers:
          - name: productpage
            image: docker.io/istio/examples-bookinfo-productpage-v1:1.18.0
            imagePullPolicy: IfNotPresent
            ports:
            - containerPort: 9080
            securityContext:
              runAsUser: 1000
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_details" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: details
      namespace: bookinfo
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

resource "kubernetes_manifest" "bookinfo_details_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: details-v1
      namespace: bookinfo
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
          containers:
          - name: details
            image: docker.io/istio/examples-bookinfo-details-v1:1.18.0
            imagePullPolicy: IfNotPresent
            ports:
            - containerPort: 9080
            securityContext:
              runAsUser: 1000
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_ratings" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: ratings
      namespace: bookinfo
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

resource "kubernetes_manifest" "bookinfo_ratings_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ratings-v1
      namespace: bookinfo
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
          containers:
          - name: ratings
            image: docker.io/istio/examples-bookinfo-ratings-v1:1.18.0
            imagePullPolicy: IfNotPresent
            ports:
            - containerPort: 9080
            securityContext:
              runAsUser: 1000
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_reviews" {
  manifest = yamldecode(<<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: reviews
      namespace: bookinfo
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

resource "kubernetes_manifest" "bookinfo_reviews_v1_deployment" {
  manifest = yamldecode(<<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: reviews-v1
      namespace: bookinfo
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
          containers:
          - name: reviews
            image: docker.io/istio/examples-bookinfo-reviews-v1:1.18.0
            imagePullPolicy: IfNotPresent
            env:
            - name: LOG_DIR
              value: "/tmp/logs"
            ports:
            - containerPort: 9080
            securityContext:
              runAsUser: 1000
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
      namespace: bookinfo
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
          containers:
          - name: reviews
            image: docker.io/istio/examples-bookinfo-reviews-v2:1.18.0
            imagePullPolicy: IfNotPresent
            env:
            - name: LOG_DIR
              value: "/tmp/logs"
            ports:
            - containerPort: 9080
            securityContext:
              runAsUser: 1000
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
      namespace: bookinfo
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
          containers:
          - name: reviews
            image: docker.io/istio/examples-bookinfo-reviews-v3:1.18.0
            imagePullPolicy: IfNotPresent
            env:
            - name: LOG_DIR
              value: "/tmp/logs"
            ports:
            - containerPort: 9080
            securityContext:
              runAsUser: 1000
  YAML
  )
  depends_on = [kubernetes_namespace.bookinfo]
}

resource "kubernetes_manifest" "bookinfo_gateway" {
  manifest = yamldecode(<<-YAML
    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: bookinfo-gateway
      namespace: bookinfo
    spec:
      selector:
        istio: ingress
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