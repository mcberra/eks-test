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
  depends_on = [kubernetes_namespace.istio-system]
}

#prometheus
data "kubectl_file_documents" "prometheus" {
  content = file("./manifests/prometheus.yaml")
}

resource "kubectl_manifest" "prometheus" {
  count     = length(data.kubectl_file_documents.prometheus.documents)
  yaml_body = element(data.kubectl_file_documents.prometheus.documents, count.index)
  depends_on = [kubernetes_namespace.istio-system]
}

#kiali
data "kubectl_file_documents" "kiali" {
  content = file("./manifests/kiali.yaml")
}

resource "kubectl_manifest" "kiali" {
  count     = length(data.kubectl_file_documents.kiali.documents)
  yaml_body = element(data.kubectl_file_documents.kiali.documents, count.index)
  depends_on = [kubernetes_namespace.istio-system]
}

#jaeger
data "kubectl_file_documents" "jaeger" {
  content = file("./manifests/jaeger.yaml")
}

resource "kubectl_manifest" "jaeger" {
  count     = length(data.kubectl_file_documents.jaeger.documents)
  yaml_body = element(data.kubectl_file_documents.jaeger.documents, count.index)
  depends_on = [kubernetes_namespace.istio-system]
}

#microservices
data "kubectl_file_documents" "microservices" {
  content = file("./manifests/microservices.yaml")
}

resource "kubectl_manifest" "microservices" {
  count     = length(data.kubectl_file_documents.microservices.documents)
  yaml_body = element(data.kubectl_file_documents.microservices.documents, count.index)
}

#aws_test
data "kubectl_file_documents" "aws_test" {
  content = file("./manifests/aws_test.yaml")
}

resource "kubectl_manifest" "aws_test" {
  count     = length(data.kubectl_file_documents.aws_test.documents)
  yaml_body = element(data.kubectl_file_documents.aws_test.documents, count.index)
}

#cluster_autoscaler
data "kubectl_file_documents" "cluster_autoscaler" {
  content = file("./manifests/cluster-autoscaler-autodiscover.yaml")
}

resource "kubectl_manifest" "cluster_autoscaler" {
  count     = length(data.kubectl_file_documents.cluster_autoscaler.documents)
  yaml_body = element(data.kubectl_file_documents.cluster_autoscaler.documents, count.index)
}
*/