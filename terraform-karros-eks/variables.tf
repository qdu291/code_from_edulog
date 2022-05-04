### Tagging
variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

### ROUTE 53
variable "domain_name" {
  type = string
}

### VPC input
// EKS VPC Variables
variable "azs" {
  type = list(string)
}

variable "vpc_name" {
  type        = string
  description = "Name of VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR range"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = " VPC Private Subnet CIDR range"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = " VPC Public Subnet CIDR range"
}

variable "node_groups" {}

variable "eks_root_volume_type" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "private_sg_name" {
  type = string
}

variable "cluster_endpoint_public_access" {
  type = bool
}
variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
}

variable "cluster_endpoint_private_access" {
  type = bool
}

variable "cluster_create_endpoint_private_access_sg_rule" {
  type = bool
}

variable "cluster_endpoint_private_access_cidrs" {
  type = list(string)
}
