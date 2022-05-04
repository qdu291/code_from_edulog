resource "aws_route53_zone" "this" {
  name = var.domain_name
  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = module.tags.common_tags
}