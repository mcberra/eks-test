resource "helm_release" "istio" {
  name       = "istio"
  repository = "https://charts.cloudposse.com/incubator/"
  chart      = "istio"
  version    = "1.1.0"
  namespace  = "istio"

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "gateways.istio-ingressgateway.enabled"
    value = "true"
  }

  set {
    name  = "gateways.istio-egressgateway.enabled"
    value = "true"
  }
  set {
    name  = "grafana.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
  set {
    name  = "tracing.enabled"
    value = "true"
  }
  set {
    name  = "servicegraph.enabled"
    value = "true"
  }
  set {
    name  = "kiali.enabled"
    value = "true"
  }
}