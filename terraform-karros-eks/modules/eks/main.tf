module "eks" {
  // Cluster define
  source  = "terraform-aws-modules/eks/aws"
  version = "17.23.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  // API access via private endpoint
  cluster_endpoint_private_access                = true
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs
  cluster_create_endpoint_private_access_sg_rule = true

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  // Logging
  cluster_enabled_log_types     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_log_retention_in_days = 90

  // VPC define
  vpc_id  = var.vpc_id
  subnets = var.private_subnets

  // Tag define
  tags = var.tags

  // Role configured
  manage_cluster_iam_resources = false
  cluster_iam_role_name        = var.eks_cluster_role_name

  // enable IRSA
  enable_irsa              = var.enable_irsa
  openid_connect_audiences = var.openid_connect_audiences

  // Additional worker policy
  workers_additional_policies = var.workers_additional_policies
  ## Role mapping
  map_roles = var.map_roles
  node_groups_defaults = {
    ami_type = "AL2_x86_64"
    key_name = var.node_key_pair_name
    additional_tags = {
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"             = "TRUE"
    }
  }

  node_groups = var.node_groups
}
