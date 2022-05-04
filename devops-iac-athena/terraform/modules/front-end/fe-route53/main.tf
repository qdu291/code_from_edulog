module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.0.0"

  zone_id   = var.fe_hosted_zone_id
  zone_name = var.fe_hosted_zone_name

  records = [
    {
      name = join(".", ["${var.tenant}", "${var.ath_domain}"])
      type = "A"
      alias = {
        name    = var.cloudfront_domain_name
        zone_id = var.cloudfront_hosted_zone_id
      }
    },
  ]
}