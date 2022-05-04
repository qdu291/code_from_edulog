terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "karrostech"

    workspaces {
      name = "athena-eks-cluster-dev"
    }
  }

  required_version = "~> 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_id]
      command     = "aws"
    }
  }
}

data "aws_region" "current" {}