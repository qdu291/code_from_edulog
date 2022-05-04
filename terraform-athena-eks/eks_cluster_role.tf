data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

module "eks_cluster_role" {
  source = "./modules/iam_role"

  name               = "${var.environment}-eksClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]

  tags = merge(module.tags.common_tags, {
    "Name" = "${var.environment}-eksClusterRole"
  })
}

#### IAM ROLE FOR CLUSTER AUTOSCALER
data "aws_iam_policy_document" "eks_cluster_autoscaler_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks_cluster.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${substr(module.eks_cluster.cluster_oidc_issuer_url, 8, -1)}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }
  }
}

data "aws_iam_policy_document" "eks_cluster_autoscaler_policy" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
}

module "eks_cluster_autoscaler_role" {
  source             = "./modules/iam_role"
  name               = "${var.environment}-EksClusterAutoscalerRole"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_role.json
  inline_policy = [{
    name   = "EksClusterAutoScalerPolicy"
    policy = data.aws_iam_policy_document.eks_cluster_autoscaler_policy.json
  }]

  tags = merge(module.tags.common_tags, {
    "Name" = "${var.environment}-EksClusterAutoscalerRole"
  })
}

## IAM ROLE FOR AWS APPLICATION LOAD BALANCER CONTROLLER
data "aws_iam_policy_document" "eks_alb_controller_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks_cluster.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${substr(module.eks_cluster.cluster_oidc_issuer_url, 8, -1)}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

module "eks_alb_controller_role" {
  source             = "./modules/iam_role"
  name               = "${var.environment}-EksAlbControllerRole"
  assume_role_policy = data.aws_iam_policy_document.eks_alb_controller_role.json
  inline_policy = [{
    name   = "EksAlbControllerPolicy"
    policy = templatefile("${path.module}/templates/alb_controller/alb_controller_policy.json", {})
  }]

  tags = merge(module.tags.common_tags, {
    "Name" = "${var.environment}-EksAlbControllerRole"
  })
}

## IAM ROLE FOR EXTERNAL DNS
data "aws_iam_policy_document" "eks_external_dns_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks_cluster.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${substr(module.eks_cluster.cluster_oidc_issuer_url, 8, -1)}:sub"
      values = [
        "system:serviceaccount:external-dns:external-dns",
        "system:serviceaccount:external-dns:external-dns-private"
      ]
    }
  }
}

module "eks_external_dns_role" {
  source             = "./modules/iam_role"
  name               = "${var.environment}-EksExternalDnsRole"
  assume_role_policy = data.aws_iam_policy_document.eks_external_dns_role.json
  inline_policy = [{
    name   = "EksExternalDnsPolicy"
    policy = templatefile("${path.module}/templates/external_dns/external_dns_policy.json", {})
  }]

  tags = merge(module.tags.common_tags, {
    "Name" = "${var.environment}-EksExternalDnsRole"
  })
}

## IAM ROLE FOR AWS APPLICATION LOAD BALANCER CONTROLLER
data "aws_iam_policy_document" "eks_karpenter_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks_cluster.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${substr(module.eks_cluster.cluster_oidc_issuer_url, 8, -1)}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }
  }
}

module "eks_karpenter_role" {
  source             = "./modules/iam_role"
  name               = "${var.environment}-EksKarpenterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_karpenter_role.json
  managed_policy_arns = [
    aws_iam_policy.karpenter_policy.arn
  ]

  tags = merge(module.tags.common_tags, {
    "Name" = "${var.environment}-EksKarpenterRole"
  })
}
