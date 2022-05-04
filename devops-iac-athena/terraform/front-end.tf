module "fe_s3_bucket" {
  source = "./modules/front-end/fe-s3-bucket"

  fe_bucket = var.tenant
}

module "cloudfront" {
  source = "./modules/front-end/fe-cloudfront"

  depends_on = [module.fe_s3_bucket]

  tenant             = var.tenant
  bucket_domain_name = module.fe_s3_bucket.s3_bucket_bucket_domain_name
  ath_domain         = var.ath_domain
  fe_acm_arn         = var.fe_acm_arn
}

module "route53_records" {
  source = "./modules/front-end/fe-route53"

  depends_on = [module.cloudfront]

  fe_hosted_zone_id         = var.hosted_zone_id
  fe_hosted_zone_name       = var.hosted_zone_name
  ath_domain                = var.ath_domain
  tenant                    = var.tenant
  cloudfront_domain_name    = module.cloudfront.cloudfront_distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
}
