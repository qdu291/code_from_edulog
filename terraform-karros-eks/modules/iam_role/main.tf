resource "aws_iam_role" "this" {
  name                = var.name
  assume_role_policy  = var.assume_role_policy
  managed_policy_arns = var.managed_policy_arns != [] ? var.managed_policy_arns : []
  dynamic "inline_policy" {
    for_each = var.inline_policy
    content {
      name   = inline_policy.value.name
      policy = inline_policy.value.policy
    }
  }

  tags = var.tags
}