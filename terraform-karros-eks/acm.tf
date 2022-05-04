module "acm_stage" {
  source      = "./modules/acm"
  domain_name = var.domain_name
  tags        = module.tags.common_tags
}