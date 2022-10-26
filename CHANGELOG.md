# Change Log

All notable changes to this module will be documented in this file.

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
- Add outputs `opensearch_security_group_id` and `opensearch_client_security_group_id`

### Changed

- Remove dynamic ingress inside `aws_security_group.this`

### Removed

## [v1.0.0] - 2022-09-08

### Added

- init terraform-aws-opensearch
