/*
resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"

  namespace = "istio-system"

  depends_on = [aws_eks_cluster.macb-eks, kubernetes_namespace.istio-system]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"

  namespace = "istio-system"

  depends_on = [aws_eks_cluster.macb-eks, helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-ingress"

  timeout         = 240
  cleanup_on_fail = true
  force_update    = false

  depends_on = [aws_eks_cluster.macb-eks, helm_release.istiod, kubernetes_namespace.istio-ingress]
}

resource "helm_release" "kiali" {
  name       = "kiali"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-server"

  namespace = "istio-system"

  depends_on = [aws_eks_cluster.macb-eks, kubernetes_namespace.istio-system]
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  namespace = "istio-system"

  depends_on = [aws_eks_cluster.macb-eks, kubernetes_namespace.istio-system]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  namespace = "istio-system"

  depends_on = [aws_eks_cluster.macb-eks, kubernetes_namespace.istio-system]
}
resource "helm_release" "jaeger" {
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger"

  namespace = "istio-system"

  depends_on = [aws_eks_cluster.macb-eks, kubernetes_namespace.istio-system]
}
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }


  depends_on = [aws_eks_cluster.macb-eks, kubernetes_namespace.cert-manager]
}
*/