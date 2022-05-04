output "fe_bucket_arn" {
  value = module.fe_s3_bucket.s3_bucket_arn
}
output "fe_bucket_name" {
  value = module.fe_s3_bucket.s3_bucket_id
}

output "s3_bucket_bucket_domain_name" {
  value = module.fe_s3_bucket.s3_bucket_bucket_domain_name
}