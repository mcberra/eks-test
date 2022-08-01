terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
        aws = {
      source = "hashicorp/aws"
      version = "4.24.0"
    }
        kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }
        helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
  }
  backend "s3" {
  }
}
