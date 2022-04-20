# AWS OpenSearch Bootstrap Terraform Module

Terraform module with create bootstrap for aws role mapping to opensearch.

## Usage

```terraform
module "bootstrap" {
  source              = "./modules/bootstrap"
  vpc_id              = var.vpc_id
  subnet_id           = var.subnets_id
  prefix              = var.prefix
  environment         = var.environment
  opensearch_endpoint = aws_opensearch_domain.this.endpoint
  username            = var.master_user_name
  password            = var.master_user_password
  backend_roles       = var.additional_iam_roles
  tags                = var.tags
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.10.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | git::ssh://git@github.com/oozou/terraform-aws-ec2-instance.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [template_cloudinit_config.user_data](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/cloudinit_config) | data source |
| [template_file.cloud_init](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |
| [template_file.scripts](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_roles"></a> [backend\_roles](#input\_backend\_roles) | aws iam roles for access to opensearch | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | To manage a resources with tags | `string` | n/a | yes |
| <a name="input_opensearch_endpoint"></a> [opensearch\_endpoint](#input\_opensearch\_endpoint) | endpoint for call api opensearch | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | password for aurhentication to opensearch | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | IDs of subnets for create instance | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tag for a resource taht create by this component | `map(string)` | `{}` | no |
| <a name="input_username"></a> [username](#input\_username) | username for aurhentication to opensearch | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id for create secgroup | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
