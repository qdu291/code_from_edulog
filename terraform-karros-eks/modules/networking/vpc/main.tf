resource "aws_eip" "nat_gateway_ips" {
  count = length(var.azs)
  vpc   = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr


  reuse_nat_ips       = true                         # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.nat_gateway_ips.*.id # <= IPs specified here as input to the module

  ## One NAT Gateway per AZ
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = merge({
    "kubernetes.io/role/internal-elb" = 1
    },
  var.private_subnet_tags)
}