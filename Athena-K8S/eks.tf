resource "aws_iam_role" "athena_eks_cluster_role" {
  name = "athena-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.athena_eks_cluster_role.name
}

resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_cluster" "athena_eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.athena_eks_cluster_role.arn
  version  = var.k8s_version
  enabled_cluster_log_types = ["api", "audit"]


  vpc_config {
    subnet_ids = [module.vpc.private_subnets.0, module.vpc.private_subnets.1,module.vpc.public_subnets.0, module.vpc.public_subnets.1]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role-AmazonEKSClusterPolicy,
    aws_cloudwatch_log_group.eks_logs
  ]
}

resource "aws_iam_role" "eks_node_group_role" {
  name = "athena-eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "athena-eks_node_group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "athena-eks_node_group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "athena-eks_node_group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}
resource "aws_iam_role_policy_attachment" "athena-eks_node_group-s3Access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "workers_autoscaling" {
  policy_arn = aws_iam_policy.eks_worker_autoscaling.arn
  role       = aws_iam_role.eks_node_group_role.name
}
resource "aws_iam_role_policy_attachment" "eks_route53" {
  policy_arn = aws_iam_policy.eks_route53.arn
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_policy" "eks_route53" {
  name_prefix = "eks-worker-route53-${aws_eks_cluster.athena_eks_cluster.name}"
  description = "EKS worker node route54 policy for cluster ${aws_eks_cluster.athena_eks_cluster.name}"
  policy      = data.aws_iam_policy_document.eks_route53.json
}

data "aws_iam_policy_document" "eks_route53" {
  statement {
    sid    = "eksroute53"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "eksroute53changeRecords"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "eks_worker_autoscaling" {
  name_prefix = "eks-worker-autoscaling-${aws_eks_cluster.athena_eks_cluster.name}"
  description = "EKS worker node autoscaling policy for cluster ${aws_eks_cluster.athena_eks_cluster.name}"
  policy      = data.aws_iam_policy_document.eks_worker_autoscaling.json
}

data "aws_iam_policy_document" "eks_worker_autoscaling" {
  statement {
    sid    = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.athena_eks_cluster.name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}
####
resource "aws_iam_role_policy_attachment" "ingressALB" {
  policy_arn = aws_iam_policy.ingressALB.arn
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_policy" "ingressALB" {
  name_prefix = "ingressALB-${aws_eks_cluster.athena_eks_cluster.name}"
  description = "EKS alb ingress ${aws_eks_cluster.athena_eks_cluster.name}"
  policy      = data.aws_iam_policy_document.ingressALB.json
}

data "aws_iam_policy_document" "ingressALB" {
  statement {
    sid    = "eksingressALB"
    effect = "Allow"

    actions = [
      "acm:DescribeCertificate",
          "acm:ListCertificates",
          "acm:GetCertificate"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksingressALBec2"
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress"
    ]

    resources = ["*"]

  }

  statement {
    sid    = "eksingressALBloadbalancer"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
      "elasticloadbalancing:DescribeListenerCertificates"
    ]

    resources = ["*"]

  }
  statement {
    sid    = "eksingressSSL"
    effect = "Allow"

    actions = [
      "iam:GetServerCertificate",
      "iam:ListServerCertificates"
    ]

    resources = ["*"]

  }
  statement {
    sid    = "eksingressWAF"
    effect = "Allow"

    actions = [
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL"
    ]

    resources = ["*"]

  }
  statement {
    sid    = "eksingresstTagResource"
    effect = "Allow"

    actions = [
      "tag:GetResources",
      "tag:TagResources"
    ]

    resources = ["*"]

  }
  statement {
    sid    = "eksingressGetWAF"
    effect = "Allow"

    actions = [
      "waf:GetWebACL"
    ]

    resources = ["*"]

  }
}

#####
resource "aws_iam_role_policy_attachment" "external-dns-policy" {
  policy_arn = aws_iam_policy.eks_worker_autoscaling.arn
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_node_group" "system_nodes" {
  cluster_name    = aws_eks_cluster.athena_eks_cluster.name
  node_group_name = "system_nodes"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = module.vpc.private_subnets.*
  instance_types  = ["m5.xlarge"]
  tags = {
    Name        = "Athena-nonprod-eks-system_nodes"
    project     = "Athena"
    environment = "nonprod"
  }
  scaling_config {
    desired_size = 1
    max_size     = 50
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.athena-eks_node_group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.athena-eks_node_group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.athena-eks_node_group-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.athena_eks_cluster.name
  node_group_name = "nodes"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = module.vpc.private_subnets.*
  instance_types  = ["m5.xlarge"]
  tags = {
    Name        = "Athena-nonprod-eks-nodes"
    project     = "Athena"
    environment = "nonprod"
  }
  scaling_config {
    desired_size = 1
    max_size     = 50
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.athena-eks_node_group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.athena-eks_node_group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.athena-eks_node_group-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "null_resource" "k8s_cluster_test" {
    triggers = {
      uuid = uuid()
    }
    provisioner "local-exec" {
        command = <<EOT
            aws eks --region "${var.region}" update-kubeconfig --name $(terraform output cluster_name)
        EOT
    }
    provisioner "local-exec" {
        command = <<EOT
            sleep 300s
            kubectl apply -f ./auto-scale
        EOT
    }
    provisioner "local-exec" {
        command = <<EOT
            kubectl create rolebinding default-viewer --clusterrole=view --serviceaccount=default:default --namespace=default || true
        EOT
    }
    provisioner "local-exec" {
        command = <<EOT
            kubectl apply ./aws-auth/aws-auth.yml || true
        EOT
    }
    provisioner "local-exec" {
        command = <<EOT
            kubectl apply -f ./dns-manager
        EOT
    }
    depends_on = [aws_eks_cluster.athena_eks_cluster, aws_eks_node_group.system_nodes, aws_eks_node_group.nodes]
}

output "cluster_name" {
  value = aws_eks_cluster.athena_eks_cluster.name
}

output "endpoint" {
  value = aws_eks_cluster.athena_eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.athena_eks_cluster.certificate_authority[0].data
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.athena_eks_cluster.vpc_config[0].cluster_security_group_id
}