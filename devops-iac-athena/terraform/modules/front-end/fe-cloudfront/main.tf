module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "2.9.3"

  aliases             = [join(".", ["${var.tenant}", "${var.ath_domain}"])]
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  retain_on_delete    = false
  wait_for_deployment = false

  origin = {
    s3_one = {
      domain_name = var.bucket_domain_name
      origin_id   = join("-", ["${var.tenant}", "cdn"])
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_root_object = "index.html"
  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    compress               = true
    query_string           = true
  }

  viewer_certificate = {
    acm_certificate_arn = var.fe_acm_arn
    ssl_support_method  = "sni-only"
  }
}