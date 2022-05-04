##Tagging value
environment = "dev"
owner       = "devops"

## ROUTE53 VALUE
domain_name = "eks-dev.athena-nonprod.com"

## VPC Value
azs      = ["us-east-2a", "us-east-2b", "us-east-2c"]
vpc_name = "athena-eks"
vpc_cidr = "10.23.0.0/16"
private_subnets_cidr = [
  "10.23.0.0/21",
  "10.23.8.0/21",
  "10.23.16.0/21",
  "10.23.64.0/21",
  "10.23.72.0/21",
  "10.23.80.0/21",
  "10.23.128.0/21",
  "10.23.136.0/21",
  "10.23.144.0/21"
]

public_subnets_cidr = [
  "10.23.24.0/21",
  "10.23.32.0/21",
  "10.23.40.0/21"
]

eks_cluster_name     = "athena-eks"
eks_cluster_version  = "1.21"
eks_root_volume_type = "gp2"

node_groups = {
  "default" = {
    create_launch_template = true
    desired_capacity       = 2
    max_capacity           = 20
    min_capacity           = 1
    disk_size              = 100
    disk_type              = "gp3"
    instance_types         = ["r5.large"]
    capacity_type          = "ON_DEMAND" // ON_DEMAND or SPOT
    k8s_labels = {
      "nodeType" = "default"
    }
    additional_tags = {}
    taint           = [{}]
    update_config = {
      max_unavailable_percentage = 50
    }
  }
  "system" = {
    create_launch_template = true
    desired_capacity       = 2
    max_capacity           = 4
    min_capacity           = 1
    disk_size              = 100
    disk_type              = "gp3"
    instance_types         = ["t3.medium"]
    capacity_type          = "ON_DEMAND" // ON_DEMAND or SPOT
    k8s_labels = {
      "nodeType" = "system"
    }
    additional_tags = {}
    taint = {
      "system" = {
        key    = "component"
        value  = "system"
        effect = "NO_SCHEDULE"
      }
    }
    update_config = {
      max_unavailable_percentage = 25
    }
  }
}

//Security groups for Node groups
private_sg_name = "node-group-private-sg"

## K8s API access
cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = []

cluster_endpoint_private_access                = true
cluster_endpoint_private_access_cidrs          = ["10.11.0.0/16"]
cluster_create_endpoint_private_access_sg_rule = true
