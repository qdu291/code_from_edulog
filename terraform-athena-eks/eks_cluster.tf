locals {
  eks_cluster_name = "${var.eks_cluster_name}-${var.environment}"
  private_sg_ids   = [aws_security_group.private_sg.id]

  ## Mapping identity

  # roles: list(object({ rolearn = string username = string groups = list(string) }))
  map_roles = [
    {
      rolearn  = "arn:aws:iam::696952606624:role/OrganizationAccountAccessRole"
      username = "ktvn-devops" //This is username in K8s cluster
      groups   = ["system:masters"]
    },
    {
      username = "system:node:{{EC2PrivateDNSName}}"
      rolearn  = module.eks_cluster.worker_iam_role_arn
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  map_users = [
    {
      userarn  = "arn:aws:iam::696952606624:user/thanhduong"
      username = "thanhduong"
      groups = [
        "system:masters"
      ]
    }
  ]
}

//Kapenter policy
data "aws_iam_policy_document" "karpenter_policy" {
  statement {
    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:RunInstances",
      "ec2:CreateTags",
      "iam:PassRole",
      "ec2:TerminateInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ssm:GetParameter"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "karpenter_policy" {
  name   = "KarpenterPolicy"
  policy = data.aws_iam_policy_document.karpenter_policy.json
}

resource "aws_key_pair" "eks" {
  key_name   = "devops"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC43XHnfTjnt7yPuQta+g9r82gELZ/fD9s6Ez6JuqwLHwBp1C5vECC9b3+Xx/T8J+Msd1mAzCyP7qY0Fvz7InlsSJznpgE7V+GWNaLsGhOpA1jMHPGKnjbju2hdZOy49mH1ZLX5ggvDwfpxstJYm2tXfRKLZ6Y19Mn1z5z2aycVh7+RB8EMnv3QHeYsm5/XXyTZ9fOVCI1eXWEuX3Da7mbHCemAD1DY4XPaJDvSRPbVQBXXaP3PEeSeCDPYRRKjb56nhqNCTkT8fnG2Y4KmSoLzdWUk5STPfBFBtQ37KfEBiSb1W6IUtEB33Qg4r5tbdnpmRDDzYyq+vO7CC9tNzdWL devops"
}

data "external" "terraform_cloud_ip" {
  program = ["bash", "-c", "echo \"{\\\"ip\\\" : \\\"$(curl -s ipinfo.io/ip)/32\\\"}\""]
}

module "eks_cluster" {
  source = "./modules/eks"

  cluster_name    = local.eks_cluster_name
  cluster_version = var.eks_cluster_version
  map_roles       = local.map_roles
  map_users       = local.map_users

  root_volume_type = var.eks_root_volume_type

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  // API access via private endpoint
  cluster_endpoint_private_access                = var.cluster_endpoint_private_access
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs
  cluster_create_endpoint_private_access_sg_rule = var.cluster_create_endpoint_private_access_sg_rule

  // API access via public endpoint was restricted from TFC only
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  // cluster_endpoint_public_access_cidrs = ["0.0.0.0/0", data.external.terraform_cloud_ip.result.ip]
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access == true ? ["0.0.0.0/0", data.external.terraform_cloud_ip.result.ip] : null

  eks_cluster_role_name = module.eks_cluster_role.role_name

  // Enable IRSA
  enable_irsa              = true
  openid_connect_audiences = ["sts.amazonaws.com"]

  // Additional policy for worker
  workers_additional_policies = [
    aws_iam_policy.karpenter_policy.arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  private_sg_ids     = local.private_sg_ids
  node_key_pair_name = aws_key_pair.eks.key_name
  node_groups        = var.node_groups
  tags               = module.tags.common_tags

  depends_on = [module.eks_cluster_role]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

resource "aws_security_group" "private_sg" {
  name_prefix = var.private_sg_name
  description = "Additional security group applied for Dev Node Group"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "allow SSH from VPC CIDR"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [module.vpc.vpc_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "allow traffic to internet"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}
