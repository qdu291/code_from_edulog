locals {
  vpc_name               = "${var.vpc_name}-${var.environment}"
  vpc_peering_id         = "pcx-0ce5b92cb86934a63" // p01.usw2.stage.es-to-eks-staging
  vpc_peering_id_2       = "pcx-0e82160f2fdfd49e4" //p01.usw2.devops.configserver-to-eks-staging
  vpc_peering_id_jenkins = "pcx-0aa7d1f3ae5c982db" //p01.use2.devops.jenkins-to-eks-staging
  vpc_peering_id_main    = "pcx-0c05e7c1938f339e9" //From athena-nonprod-vpc in NonProdAthena account for staging ---- athena-nonprod-vpc-msk-to-karros-eks-stage
  vpc_peering_kafka      = "pcx-0186b43c07719ba8a" //p01.usw2.ingest.kafka-to-eks-staging
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

// Accept peering from central account - for ES
resource "aws_vpc_peering_connection_accepter" "peering" {
  vpc_peering_connection_id = local.vpc_peering_id
  auto_accept               = true

  tags = module.tags.common_tags
}

// Add routing rule to route table for vpc peering
resource "aws_route" "peering_routes" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = "10.40.32.0/21" // p01.usw2.stage
  vpc_peering_connection_id = local.vpc_peering_id

  depends_on = [
    aws_vpc_peering_connection_accepter.peering
  ]
}

// Accept peering from central account - for configserver
resource "aws_vpc_peering_connection_accepter" "peering_2" {
  vpc_peering_connection_id = local.vpc_peering_id_2
  auto_accept               = true

  tags = module.tags.common_tags
}

// Add routing rule to route table for vpc peering - for configserver
resource "aws_route" "peering_routes_2" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = "10.40.8.0/21" // p01.usw2.devops
  vpc_peering_connection_id = local.vpc_peering_id_2

  depends_on = [
    aws_vpc_peering_connection_accepter.peering_2
  ]
}

// Accept peering from central account - for staging environment
resource "aws_vpc_peering_connection_accepter" "peering_main" {
  vpc_peering_connection_id = local.vpc_peering_id_main
  auto_accept               = true

  tags = module.tags.common_tags
}

// Add routing rule to route table for vpc peering - staging environment
resource "aws_route" "peering_routes_main" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = "10.11.0.0/16" // athena-nonprod-vpc
  vpc_peering_connection_id = local.vpc_peering_id_main

  depends_on = [
    aws_vpc_peering_connection_accepter.peering_main
  ]
}

// Kafka: Accept peering from central account - for staging environment
resource "aws_vpc_peering_connection_accepter" "kafka_peering" {
  vpc_peering_connection_id = local.vpc_peering_kafka
  auto_accept               = true

  tags = module.tags.common_tags
}

// Kafka: Add routing rule to route table for vpc peering - staging environment
resource "aws_route" "kafka_peering_routes" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = "10.40.24.0/21" // p01.usw2.ingest
  vpc_peering_connection_id = local.vpc_peering_kafka

  depends_on = [
    aws_vpc_peering_connection_accepter.kafka_peering
  ]
}

// Jenkins: Accept peering from central account - for staging environment
resource "aws_vpc_peering_connection_accepter" "jenkins_peering" {
  vpc_peering_connection_id = local.vpc_peering_id_jenkins
  auto_accept               = true

  tags = module.tags.common_tags
}

// Jenkins: Add routing rule to route table for vpc peering - staging environment
resource "aws_route" "jenkins_peering_routes" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = "10.20.8.0/21" // p01.usw2.ingest
  vpc_peering_connection_id = local.vpc_peering_id_jenkins

  depends_on = [
    aws_vpc_peering_connection_accepter.jenkins_peering
  ]
}