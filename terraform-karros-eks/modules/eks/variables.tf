// EKS Cluster Variables
variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "map_roles" {}
variable "tags" {
  type = map(string)
}

variable "root_volume_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

# variable "cluster_environment" {
#   type = string
# }

variable "eks_cluster_role_name" {
  type = string
}

variable "node_key_pair_name" {
  type = string
}

variable "private_sg_ids" {
  type = list(string)
}

variable "node_groups" {}

variable "cluster_endpoint_public_access" {
  type = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
}

variable "cluster_endpoint_private_access" {
  type = bool
}

variable "cluster_endpoint_private_access_cidrs" {
  type    = list(string)
  default = []
}

variable "cluster_create_endpoint_private_access_sg_rule" {
  type = bool
}

variable "enable_irsa" {
  type = bool
}

variable "openid_connect_audiences" {
  type = list(string)
}

variable "workers_additional_policies" {
  type = list(string)
}