provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      CreatedVia = "terraform"
    }
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_devops.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_devops.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_devops.name, "--region", "us-west-2"]
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
