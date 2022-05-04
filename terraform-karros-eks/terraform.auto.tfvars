##Tagging value
environment = "stage"
owner       = "devops"

## ROUTE53 VALUE
domain_name = "staging.karrostech.net"

## VPC Value
azs      = ["us-west-2a", "us-west-2b", "us-west-2c"]
vpc_name = "karros-eks"
vpc_cidr = "10.110.0.0/16"
private_subnets_cidr = [
  "10.110.0.0/21",
  "10.110.8.0/21",
  "10.110.16.0/21",
  "10.110.64.0/21",
  "10.110.72.0/21",
  "10.110.80.0/21",
  "10.110.128.0/21",
  "10.110.136.0/21",
  "10.110.144.0/21"
]

public_subnets_cidr = [
  "10.110.24.0/21",
  "10.110.32.0/21",
  "10.110.40.0/21"
]

eks_cluster_name     = "karros-eks"
eks_cluster_version  = "1.21"
eks_root_volume_type = "gp2"

node_groups = {
  "default" = {
    create_launch_template = true
    desired_capacity       = 3
    max_capacity           = 20
    min_capacity           = 1
    disk_size              = 100
    disk_type              = "gp3"
    instance_types         = ["m5.xlarge"]
    capacity_type          = "ON_DEMAND" // ON_DEMAND or SPOT
    k8s_labels = {
      "nodeType" = "default"
    }
    additional_tags = {}
    taint           = [{}]
    update_config = {
      max_unavailable_percentage = 25
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
    taints = {
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

cluster_endpoint_private_access = true
cluster_endpoint_private_access_cidrs = [
  "10.50.8.0/21", //Karros VPN range
  "10.20.8.0/21"  // Jenkins access
]
cluster_create_endpoint_private_access_sg_rule = true
