variable "tenant" {
  type    = string
  default = "test-tf"
}

variable "ath_domain" {
  type    = string
  default = "athena-nonprod.com"
}

variable "fe_acm_arn" {
  type = string
}

variable "bucket_domain_name" {
  type = string
}