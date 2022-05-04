resource "aws_route53_zone" "this" {
  name = var.domain_name
  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = module.tags.common_tags
}

# resource "aws_route53_zone_association" "vpn" {
#   zone_id    = aws_route53_zone.this.zone_id
#   vpc_id     = "vpc-1472eb73"
#   vpc_region = "ap-southeast-1"
# }

// Create a VPC association authorization to associate domain with VPN VPC in Singapore region
resource "null_resource" "vpn_vpc_association" {
  provisioner "local-exec" {
    command = <<EOT
  aws route53 create-vpc-association-authorization --hosted-zone-id ${aws_route53_zone.this.zone_id} --vpc VPCRegion=ap-southeast-1,VPCId=vpc-1472eb73 --region ap-southeast-1
  EOT
  }
}