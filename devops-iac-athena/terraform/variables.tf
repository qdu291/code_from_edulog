variable "tenant" {
  type    = string
  default = "test-tf"
}

variable "hosted_zone_id" {
  type    = string
  default = "Z0554033189HKTXE7UEFR"
}

variable "hosted_zone_name" {
  type    = string
  default = "athena-nonprod.com"
}

variable "ath_domain" {
  type    = string
  default = "athena-nonprod.com"
}

variable "fe_acm_arn" {
  type    = string
  default = "arn:aws:acm:us-east-2:696952606624:certificate/99a317f8-79c9-476c-b2cd-7882c1640778"
}