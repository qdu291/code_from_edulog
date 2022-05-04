# data "aws_security_group" "default" {
#   name   = "default"
# #   vpc_id = module.vpc.vpc_id
#   vpc_id = "${module.vpc.vpc_id}"
# }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "athena-eks-nonprod-vpc"

  cidr = "${var.vpc_cidr}" # 10.0.0.0/8 is reserved for EC2-Classic

  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  reuse_nat_ips = true
  external_nat_ip_ids = "${var.eip_nat_id}"
  enable_vpn_gateway = false


  tags = {
    Name        = "athena-eks-nonprod-vpc"
    author      = "ktvn-devops"
    environment = "ethena-eks-nonprod"
    project     = "ethena-eks"
  }

  vpc_endpoint_tags = {
    author      = "ktvn-devops"
    environment = "ethena-eks-nonprod"
    project     = "ethena-eks"
    Endpoint    = "true"
  }

  public_route_table_tags = {
    Name        = "athena-eks-nonprod-vpc-public-rtb"
    environment = "ethena-eks-nonprod"
    project     = "ethena-eks"
    Endpoint    = "true"
  }

  public_subnet_tags = {
    Name        = "ethena-eks-nonprod-k8s-public_subnet"
    environment = "ethena-eks-nonprod"
    project     = "ethena-eks"
    Endpoint    = "true"
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  private_subnet_tags = {
    Name        = "ethena-eks-nonprod-k8s-private_subnet"
    environment = "ethena-eks-nonprod"
    project     = "ethena-eks"
    Endpoint    = "true"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  igw_tags = {
    Name        = "ethena-eks-nonprod-k8s-igw"
    environment = "ethena-eks-nonprod"
    project     = "ethena-eks"
    Endpoint    = "true"
  }
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnet1" {
  value = module.vpc.private_subnets.0
}

output "private_subnet2" {
  value = module.vpc.private_subnets.1
}


output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnet1" {
  value       = module.vpc.public_subnets.0
}

output "public_subnet2" {
  value       = module.vpc.public_subnets.1
}


# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC endpoints
output "vpc_endpoint_ssm_id" {
  description = "The ID of VPC endpoint for SSM"
  value       = module.vpc.vpc_endpoint_ssm_id
}

output "vpc_endpoint_ssm_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SSM."
  value       = module.vpc.vpc_endpoint_ssm_network_interface_ids
}

output "vpc_endpoint_ssm_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SSM."
  value       = module.vpc.vpc_endpoint_ssm_dns_entry
}

# VPC CIDR
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Private route table id
output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}