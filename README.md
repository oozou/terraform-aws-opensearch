# AWS OpenSearch Terraform Module

Terraform module with create OpenSearch resources on AWS.

## Usage

```terraform
module "opensearch" {
  source                            = "git@github.com:oozou/terraform-aws-opensearch.git?ref=develop"
  cluster_name                      = "opensearch"
  cluster_domain                    = "aws.waruwat.work" # route53 hostzone domain
  cluster_version                   = "OpenSearch_1.1"
  # subnets_ids                       = ["subnet-xxx"]
  # vpc_id                            = "vpc-xxx"
  prefix                            = "oozou"
  environment                       = "dev"
  hot_instance_count                = 1
  availability_zones                = 1
  is_master_instance_enabled        = false
  is_warm_instance_enabled          = false
  master_user_name                  = "admin"
  master_user_password              = "AdminOpenSearch1@" #must be sensitive value
  acm_arn                           = "arn:aws:acm:ap-southeast-1:xxxx"
  bootstrap_config = {
    vpc_id    = "vpc-xxx"
    subnet_id = "subnet-xxx"
  }
  additional_iam_roles = [aws_iam_role.test_role.arn]
  tags = {
    "terraform" = "true",
    "workspace" = "local"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap"></a> [bootstrap](#module\_bootstrap) | ./modules/bootstrap | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_iam_service_linked_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.additional_client_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.additional_client_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.additional_opensearch_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.from_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.to_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.to_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
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
| <a name="input_additional_iam_roles"></a> [additional\_iam\_roles](#input\_additional\_iam\_roles) | aws iam roles for access to opensearch. | `list(string)` | `[]` | no |
| <a name="input_additional_opensearch_client_security_group_egress_rules"></a> [additional\_opensearch\_client\_security\_group\_egress\_rules](#input\_additional\_opensearch\_client\_security\_group\_egress\_rules) | Additional egress rule for opensearch client security group. | <pre>list(object({<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    cidr_blocks              = list(string)<br>    source_security_group_id = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_opensearch_client_security_group_ingress_rules"></a> [additional\_opensearch\_client\_security\_group\_ingress\_rules](#input\_additional\_opensearch\_client\_security\_group\_ingress\_rules) | Additional ingress rule for opensearch client security group. | <pre>list(object({<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    cidr_blocks              = list(string)<br>    source_security_group_id = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_opensearch_security_group_ingress_rules"></a> [additional\_opensearch\_security\_group\_ingress\_rules](#input\_additional\_opensearch\_security\_group\_ingress\_rules) | Additional ingress rule for opensearch security group. | <pre>list(object({<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    cidr_blocks              = list(string)<br>    source_security_group_id = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3. | `number` | `3` | no |
| <a name="input_bootstrap_config"></a> [bootstrap\_config](#input\_bootstrap\_config) | config for bootstrap module require if not set the var.vpc\_id and var.subnet\_ids | <pre>object({<br>    vpc_id    = string<br>    subnet_id = string<br>  })</pre> | `null` | no |
| <a name="input_cloudwatch_log_kms_key_id"></a> [cloudwatch\_log\_kms\_key\_id](#input\_cloudwatch\_log\_kms\_key\_id) | The ARN for the KMS encryption key. | `string` | `null` | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Retention day for cloudwatch log group | `number` | `90` | no |
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | The hosted zone name of the OpenSearch cluster. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the OpenSearch cluster. | `string` | `"opensearch"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of OpenSearch or Elasticsearch to deploy. | `string` | `""` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values INDEX\_SLOW\_LOGS, SEARCH\_SLOW\_LOGS, ES\_APPLICATION\_LOGS, AUDIT\_LOGS | `list(string)` | `[]` | no |
| <a name="input_encrypt_kms_key_id"></a> [encrypt\_kms\_key\_id](#input\_encrypt\_kms\_key\_id) | The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | To manage a resources with tags | `string` | n/a | yes |
| <a name="input_hot_instance_count"></a> [hot\_instance\_count](#input\_hot\_instance\_count) | The number of dedicated hot nodes in the cluster. | `number` | `1` | no |
| <a name="input_hot_instance_type"></a> [hot\_instance\_type](#input\_hot\_instance\_type) | The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.search"` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | Baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the GP3 and Provisioned IOPS EBS volume types. | `number` | `"3000"` | no |
| <a name="input_is_create_security_group"></a> [is\_create\_security\_group](#input\_is\_create\_security\_group) | if true will create security group for opensearch | `bool` | `true` | no |
| <a name="input_is_create_service_role"></a> [is\_create\_service\_role](#input\_is\_create\_service\_role) | Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html | `bool` | `true` | no |
| <a name="input_is_custom_endpoint_enabled"></a> [is\_custom\_endpoint\_enabled](#input\_is\_custom\_endpoint\_enabled) | Whether to enable custom endpoint for the OpenSearch domain. | `bool` | `false` | no |
| <a name="input_is_ebs_enabled"></a> [is\_ebs\_enabled](#input\_is\_ebs\_enabled) | if true will add ebs | `bool` | `false` | no |
| <a name="input_is_internal_user_database_enabled"></a> [is\_internal\_user\_database\_enabled](#input\_is\_internal\_user\_database\_enabled) | Whether the internal user database is enabled | `bool` | `true` | no |
| <a name="input_is_master_instance_enabled"></a> [is\_master\_instance\_enabled](#input\_is\_master\_instance\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `false` | no |
| <a name="input_is_warm_instance_enabled"></a> [is\_warm\_instance\_enabled](#input\_is\_warm\_instance\_enabled) | Indicates whether ultrawarm nodes are enabled for the cluster. | `bool` | `true` | no |
| <a name="input_master_instance_count"></a> [master\_instance\_count](#input\_master\_instance\_count) | The number of dedicated master nodes in the cluster. | `number` | `3` | no |
| <a name="input_master_instance_type"></a> [master\_instance\_type](#input\_master\_instance\_type) | The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.search"` | no |
| <a name="input_master_role_arn"></a> [master\_role\_arn](#input\_master\_role\_arn) | The ARN for the master user of the cluster. leave it null if dont want to change the flow for authentication | `string` | `null` | no |
| <a name="input_master_user_name"></a> [master\_user\_name](#input\_master\_user\_name) | Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if is\_internal\_user\_database\_enabled is set to true. | `string` | `null` | no |
| <a name="input_master_user_password"></a> [master\_user\_password](#input\_master\_user\_password) | Main user's password, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if is\_internal\_user\_database\_enabled is set to true | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | List of IDs of subnets for create opensearch cluster | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_throughput"></a> [throughput](#input\_throughput) | Type of EBS volumes attached to data nodes. | `number` | `"125"` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Required if ebs\_enabled is set to true. Size of EBS volumes attached to data nodes (in GiB) | `number` | `20` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of EBS volumes attached to data nodes. | `string` | `"gp3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC for create security group | `string` | `null` | no |
| <a name="input_warm_instance_count"></a> [warm\_instance\_count](#input\_warm\_instance\_count) | The number of dedicated warm nodes in the cluster. Valid values are between 2 and 150 | `number` | `3` | no |
| <a name="input_warm_instance_type"></a> [warm\_instance\_type](#input\_warm\_instance\_type) | The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing | `string` | `"ultrawarm1.medium.search"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_security_group_id"></a> [client\_security\_group\_id](#output\_client\_security\_group\_id) | Security group id for the opensearch client. |
| <a name="output_custom_domain_endpoint"></a> [custom\_domain\_endpoint](#output\_custom\_domain\_endpoint) | custom domain for opensearch |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | endpoint for opensearch |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group id for the opensearch. |
<!-- END_TF_DOCS -->
