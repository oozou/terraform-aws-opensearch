# AWS OpenSearch Terraform Module

Terraform module with create OpenSearch resources on AWS.

## Usage

```terraform
module "eks" {
  source                            = "git@github.com:oozou/terraform-aws-opensearch.git?ref=develop"
  cluster_name                      = "opensearch"
  cluster_domain                    = "aws.example.com" #domain will be opensearch.aws.example.com
  cluster_version                   = "OpenSearch_1.1"
  prefix                            = "oozou"
  environment                       = "dev"
  # subnets_ids                     = ["subnet-0def43dbc075d8752", "subnet-0972a6a0d8662f4f0", "subnet-086850caacfacff7f"]
  # vpc_id                          = "vpc-08c02229cfe5c0348"
  hot_instance_count                = 3
  availability_zones                = 3
  is_master_instance_enabled        = false
  is_warm_instance_enabled          = false
  is_internal_user_database_enabled = true
  master_user_name                  = "admin"
  master_user_password              = "Admin1234@"
  acm_arn                           = "arn:aws:acm:ap-southeast-1:557291035693:certificate/dda9fd68-88e0-4a7b-8f7e-29a94c10ae58"
  tags = {
    "key" = "value"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_service_linked_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_arn"></a> [acm\_arn](#input\_acm\_arn) | ACM certificate ARN for custom endpoint. | `string` | `""` | no |
| <a name="input_additional_allow_cidr"></a> [additional\_allow\_cidr](#input\_additional\_allow\_cidr) | cidr for allow connect to opensearch | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3. | `number` | `3` | no |
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | The hosted zone name of the OpenSearch cluster. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the OpenSearch cluster. | `string` | `"opensearch"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of OpenSearch or Elasticsearch to deploy. | `string` | `""` | no |
| <a name="input_encrypt_kms_key_id"></a> [encrypt\_kms\_key\_id](#input\_encrypt\_kms\_key\_id) | The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | To manage a resources with tags | `string` | n/a | yes |
| <a name="input_hot_instance_count"></a> [hot\_instance\_count](#input\_hot\_instance\_count) | The number of dedicated hot nodes in the cluster. | `number` | `1` | no |
| <a name="input_hot_instance_type"></a> [hot\_instance\_type](#input\_hot\_instance\_type) | The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.search"` | no |
| <a name="input_is_create_service_role"></a> [is\_create\_service\_role](#input\_is\_create\_service\_role) | Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html | `bool` | `true` | no |
| <a name="input_is_custom_endpoint_enabled"></a> [is\_custom\_endpoint\_enabled](#input\_is\_custom\_endpoint\_enabled) | Whether to enable custom endpoint for the OpenSearch domain. | `bool` | `true` | no |
| <a name="input_is_internal_user_database_enabled"></a> [is\_internal\_user\_database\_enabled](#input\_is\_internal\_user\_database\_enabled) | Whether the internal user database is enabled | `bool` | `false` | no |
| <a name="input_is_master_instance_enabled"></a> [is\_master\_instance\_enabled](#input\_is\_master\_instance\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `false` | no |
| <a name="input_is_warm_instance_enabled"></a> [is\_warm\_instance\_enabled](#input\_is\_warm\_instance\_enabled) | Indicates whether ultrawarm nodes are enabled for the cluster. | `bool` | `true` | no |
| <a name="input_master_instance_count"></a> [master\_instance\_count](#input\_master\_instance\_count) | The number of dedicated master nodes in the cluster. | `number` | `3` | no |
| <a name="input_master_instance_type"></a> [master\_instance\_type](#input\_master\_instance\_type) | The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.search"` | no |
| <a name="input_master_role_arn"></a> [master\_role\_arn](#input\_master\_role\_arn) | The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request. | `string` | `null` | no |
| <a name="input_master_user_name"></a> [master\_user\_name](#input\_master\_user\_name) | Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if is\_internal\_user\_database\_enabled is set to true. | `string` | `null` | no |
| <a name="input_master_user_password"></a> [master\_user\_password](#input\_master\_user\_password) | Main user's password, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if is\_internal\_user\_database\_enabled is set to true | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | List of IDs of subnets for create opensearch cluster | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC for create security group | `string` | `null` | no |
| <a name="input_warm_instance_count"></a> [warm\_instance\_count](#input\_warm\_instance\_count) | The number of dedicated warm nodes in the cluster. Valid values are between 2 and 150 | `number` | `3` | no |
| <a name="input_warm_instance_type"></a> [warm\_instance\_type](#input\_warm\_instance\_type) | The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing | `string` | `"ultrawarm1.medium.search"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain"></a> [domain](#output\_domain) | custom domain for opensearch |
<!-- END_TF_DOCS -->
