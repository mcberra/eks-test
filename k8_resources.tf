/*

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name = "istio-ingress"
  }
}
resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

#grafana
data "kubectl_file_documents" "grafana" {
  content = file("./manifests/grafana.yaml")
}

resource "kubectl_manifest" "grafana" {
  count     = length(data.kubectl_file_documents.grafana.documents)
  yaml_body = element(data.kubectl_file_documents.grafana.documents, count.index)
}

#prometheus
data "kubectl_file_documents" "prometheus" {
  content = file("./manifests/prometheus.yaml")
}

resource "kubectl_manifest" "prometheus" {
  count     = length(data.kubectl_file_documents.prometheus.documents)
  yaml_body = element(data.kubectl_file_documents.prometheus.documents, count.index)
}

#kiali
data "kubectl_file_documents" "kiali" {
  content = file("./manifests/kiali.yaml")
}

resource "kubectl_manifest" "kiali" {
  count     = length(data.kubectl_file_documents.kiali.documents)
  yaml_body = element(data.kubectl_file_documents.kiali.documents, count.index)
}

#jaeger
data "kubectl_file_documents" "jaeger" {
  content = file("./manifests/jaeger.yaml")
}

resource "kubectl_manifest" "jaeger" {
  count     = length(data.kubectl_file_documents.jaeger.documents)
  yaml_body = element(data.kubectl_file_documents.jaeger.documents, count.index)
}
*/