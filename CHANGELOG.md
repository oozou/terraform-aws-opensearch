# Change Log

All notable changes to this module will be documented in this file.

## [v1.0.3] - 2022-12-22

### Added

- Add alarm.tf with default and custom opensearch alarms
- Add following vars
    - is_enable_default_alarms
    - default_alarm_actions
    - default_ok_actions
    - custom_rds_alarms_configure
    - event_categories

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
