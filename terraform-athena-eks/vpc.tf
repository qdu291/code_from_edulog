locals {
  vpc_name         = "${var.vpc_name}-${var.environment}"
  vpc_peering_id   = "pcx-0521552142c9c42b8" // athena-nonprod_to_dev-eks-cluter
  vpc_peering_id_2 = "pcx-078df2b6f7a5d5986" // Peering to Karros VPN Singapore
  # vpc_peering_id_main = "pcx-07ef810e86c609325" //From edulog-prod vpc in Production account for staging environment
  # vpc_peering_kafka   = "pcx-0186b43c07719ba8a" //p01.usw2.ingest.kafka-to-eks-staging
}

module "vpc" {
  source = "./modules/networking/vpc"

  vpc_name             = local.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr

  //Private subnet tag for Karpenter
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = local.eks_cluster_name
  }

  tags = module.tags.common_tags
}

# // Accept peering from Athena-nonprod
resource "aws_vpc_peering_connection_accepter" "peering" {
  vpc_peering_connection_id = local.vpc_peering_id
  auto_accept               = true

  tags = module.tags.common_tags
}

// Add routing rule to route table for vpc peering
resource "aws_route" "peering_routes" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = "10.11.0.0/16" // p01.usw2.stage
  vpc_peering_connection_id = local.vpc_peering_id

  depends_on = [
    aws_vpc_peering_connection_accepter.peering
  ]
}

// Accept peering to Karros VPN - Singapore
resource "aws_vpc_peering_connection_accepter" "peering_2" {
  vpc_peering_connection_id = local.vpc_peering_id_2
  auto_accept               = true

  tags = module.tags.common_tags
}

// Add routing rule to route table for vpc peering - for configserver
resource "aws_route" "peering_routes_2" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = "10.50.8.0/21" // p01.usw2.devops
  vpc_peering_connection_id = local.vpc_peering_id_2

  depends_on = [
    aws_vpc_peering_connection_accepter.peering_2
  ]
}

# // Accept peering from central account - for staging environment
# resource "aws_vpc_peering_connection_accepter" "peering_main" {
#   vpc_peering_connection_id = local.vpc_peering_id_main
#   auto_accept               = true

#   tags = module.tags.common_tags
# }

# // Add routing rule to route table for vpc peering - staging environment
# resource "aws_route" "peering_routes_main" {
#   for_each = toset(module.vpc.private_route_table_ids)

#   route_table_id            = each.key
#   destination_cidr_block    = "10.0.0.0/16" // edulog-prod-vpc
#   vpc_peering_connection_id = local.vpc_peering_id_main

#   depends_on = [
#     aws_vpc_peering_connection_accepter.peering_main
#   ]
# }

# // Kafka: Accept peering from central account - for staging environment
# resource "aws_vpc_peering_connection_accepter" "kafka_peering" {
#   vpc_peering_connection_id = local.vpc_peering_kafka
#   auto_accept               = true

#   tags = module.tags.common_tags
# }

# // Kafka: Add routing rule to route table for vpc peering - staging environment
# resource "aws_route" "kafka_peering_routes" {
#   for_each = toset(module.vpc.private_route_table_ids)

#   route_table_id            = each.key
#   destination_cidr_block    = "10.40.24.0/21" // p01.usw2.ingest
#   vpc_peering_connection_id = local.vpc_peering_kafka

#   depends_on = [
#     aws_vpc_peering_connection_accepter.kafka_peering
#   ]
# }