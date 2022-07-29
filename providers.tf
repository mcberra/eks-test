provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Environment       = terraform.workspace
      Terraform_managed = "true"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.macb-eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.macb-eks.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.macb-eks.name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.macb-eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.macb-eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.macb-eks.name]
      command     = "aws"
    }
  }
}