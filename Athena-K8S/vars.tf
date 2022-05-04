variable "profile" {
  default = "athena"
}
variable "karrosprofile" {
  default = "karros"
}
variable "k8s_version" {
  default = "1.19"
}
variable "eks_cluster_name" {
  default = "athena-eks-nonprod"
}
variable "region" {
  default = "us-east-2"
}
variable "vpc_cidr" {
  default = "10.22.0.0/16"
}
variable "azs" {
  type = "list"
  default = ["us-east-2a", "us-east-2b"]
}
variable "private_subnets" {
  type = "list"
  default = ["10.22.1.0/24", "10.22.2.0/24"]
}
variable "public_subnets" {
  type = "list"
  default = ["10.22.11.0/24", "10.22.12.0/24"]
}
variable "dhcp_domain_name_server" {
  type = "list"
  default = ["127.0.0.1", "10.22.0.2"]
}
variable "peer_region_usw2" {
  default = "us-east-2"
}
variable "athenanonprod" {
  default = "vpc-00c70a4a976b3ed0c"
}
variable "peer_region_east2" {
  default = "us-east-2"
}
variable "athenanonprod_cidr" {
  default = "10.11.0.0/16"
}
variable "athenanonprod_route_private_1" {
  default = "rtb-05ca3f2a9272b61e4"
}
variable "athenanonprod_route_private_2" {
  default = "rtb-0d4fd08a56ae7211b"
}
variable "athenanonprod_route_private_3" {
  default = "rtb-05b5a4e9f637d49db"
}
variable "athenanonprod_route_public" {
  default = "rtb-066c70c2b5c498139"
}
variable "endpoint_private_access" {
  default = "true"
}
variable "eip_nat_id" {
  default = ["eipalloc-002a2b79c33860dd1",]
}
variable "db_snapshot_id" {
  default = "arn:aws:rds:us-east-2:696952606624:snapshot:athena-development-ktvn-rds-eks"
}

# variable "owner_id" {
#   default = "690893158275"
# }
variable "db_identifier" {
  default = "eks-athena-nonprod"
}
variable "db_instance_type" {
  default = "db.t3.small"
}
variable "db_username" {
  default = "postgres"
}
variable "db_password" {
  default = "2ASU0sGt9UXz"
}