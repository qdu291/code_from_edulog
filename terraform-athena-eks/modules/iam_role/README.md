<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | n/a | `any` | n/a | yes |
| <a name="input_inline_policy"></a> [inline\_policy](#input\_inline\_policy) | n/a | <pre>list(object({<br>    name   = string<br>    policy = any<br>  }))</pre> | `[]` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | n/a |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | n/a |
<!-- END_TF_DOCS -->