module "tags" {
  source = "git@github.com:eduloginc/terraform-resource-tag.git?ref=v1.0.0"

  environment = var.environment
  owner       = var.owner
}