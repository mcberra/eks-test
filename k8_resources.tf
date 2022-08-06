/*
resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"

  labels = {
    istio-injection = "enabled"
  }
  }
}

resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name = "istio-ingress"

  labels = {
    istio-injection = "enabled"
  }
  }
}
resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "micros" {
  metadata {
    name = "micros"

  labels = {
    istio-injection = "enabled"
  }
  }

}
#microservices
data "kubectl_file_documents" "microservices" {
  content = file("./manifests/microservices.yaml")
}

resource "kubectl_manifest" "microservices" {
  count     = length(data.kubectl_file_documents.microservices.documents)
  yaml_body = element(data.kubectl_file_documents.microservices.documents, count.index)
  depends_on = [kubernetes_namespace.micros]
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