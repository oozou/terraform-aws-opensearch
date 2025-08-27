# Change Log

All notable changes to this module will be documented in this file.

## [1.0.7] - 2025-08-27

### Changed
- Update ec2 module version

## [1.0.6] - 2023-06-09

### Changed
- Update master_instance_type var condition to allow other instance types

## [1.0.5] - 2023-05-12

### Added

- Add `local.cloudwatch_log_group_kms_key_arn` to control logic selecting KMS key arn
- Add tag to resource `aws_cloudwatch_metric_alarm.opensearch_health_alarm`
- Add data source `aws_region.this` and `aws_caller_identity.this`
- Add resource `aws_opensearch_domain_policy.this` to allow opensearch naming contain non alp
- Add data `aws_iam_policy_document.os_access_cloudwatch_policy` to use with new resource `aws_cloudwatch_log_resource_policy.os_access_cloudwatch_policy`
- Add log group encryption with related resources
  - Data `os_access_cloudwatch_policy.cloudwatch_log_group_kms_policy`
  - Module `cloudwatch_log_group_kms`

### Changed

- Update resource naming in data `aws_iam_policy_document.access_policy` to use `local.identifier`
- Set attribute `aws_iam_service_linked_role.this.access_policies` to null
- Update resource `aws_cloudwatch_log_group.this`'s attribute to use `local.cloudwatch_log_group_kms_key_arn`

### Removed

- Remove `aws_cloudwatch_log_group.example` since there's no usage

## [1.0.4] - 2023-01-05

### Added

- variables
  - is_enable_internet_access: option to enable/disable the outbound internet access, disable by default.

### Changed

- locals
  - update local identifier to includer cluster name

- main
  - update domain_name to use local identifier with prefix env information


## [v1.0.3] - 2022-12-22

### Added

- Add alarm.tf with default and custom opensearch alarms
- Add following vars
    - is_enable_default_alarms
    - default_alarm_actions
    - default_ok_actions
    - custom_opensearch_alarms_configure

## [v1.0.2] - 2022-11-08

### Added

- Add resource `aws_cloudwatch_log_group.this`
- Add log_publishing_options for `aws_opensearch_domain`

### Changed
- change bootstrap to user-data to get username/password from secret manager
- create bootstrap only if backend role list is not empty
- update OS aws_iam_policy_document principals to account scope


## [v1.0.1] - 2022-10-27

### Added

- Add resource `aws_security_group_rule.from_client`
- Add resource `aws_security_group_rule.additional_opensearch_ingress`
- Add resource `aws_security_group_rule.aws_security_group_rule`
- Add resource `aws_security_group.client`
- Add resource `aws_security_group_rule.additional_client_ingress`
- Add resource `aws_security_group_rule.to_cluster`
- Add resource `aws_security_group_rule.additional_client_egress`
- Add variables `additional_opensearch_security_group_ingress_rules`, `additional_opensearch_client_security_group_ingress_rules` and `additional_opensearch_client_security_group_egress_rules`
- Add outputs `security_group_id` and `client_security_group_id`

### Changed

- Remove dynamic ingress inside `aws_security_group.this`

### Removed

## [v1.0.0] - 2022-09-08

### Added

- init terraform-aws-opensearch
