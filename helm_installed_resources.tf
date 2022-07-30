/*
resource "helm_release" "istio_base" {
  name  = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "base"

  namespace       = "istio-system"

  depends_on = [ aws_eks_cluster.macb-eks,kubernetes_namespace.istio-system ]
}

resource "helm_release" "istiod" {
  name  = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "istiod"

  namespace       = "istio-system"

  depends_on = [ aws_eks_cluster.macb-eks,helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name  = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "gateway"
  namespace       = "istio-system"

  timeout = 240
  cleanup_on_fail = true
  force_update    = false

  depends_on = [ aws_eks_cluster.macb-eks,helm_release.istiod ]
}
*/