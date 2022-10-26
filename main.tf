resource "aws_iam_service_linked_role" "this" {
  count            = var.is_create_service_role ? 1 : 0
  aws_service_name = "opensearchservice.amazonaws.com"
}

resource "aws_opensearch_domain" "this" {
  depends_on = [
    aws_iam_service_linked_role.this[0],
  ]

  domain_name     = var.cluster_name
  engine_version  = var.cluster_version
  access_policies = data.aws_iam_policy_document.access_policy.json

  cluster_config {
    dedicated_master_enabled = var.is_master_instance_enabled
    dedicated_master_count   = var.is_master_instance_enabled ? var.master_instance_count : null
    dedicated_master_type    = var.is_master_instance_enabled ? var.master_instance_type : null

    instance_count = var.hot_instance_count
    instance_type  = var.hot_instance_type

    warm_enabled = var.is_warm_instance_enabled
    warm_count   = var.is_warm_instance_enabled ? var.warm_instance_count : null
    warm_type    = var.is_warm_instance_enabled ? var.warm_instance_type : null

    zone_awareness_enabled = (var.availability_zones > 1) ? true : false

    dynamic "zone_awareness_config" {
      for_each = (var.availability_zones > 1) ? [var.availability_zones] : []
      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  dynamic "vpc_options" {
    for_each = var.vpc_id == null ? [] : [1]
    content {
      subnet_ids         = var.subnets_ids
      security_group_ids = [aws_security_group.this[0].id]
    }
  }
  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = var.is_internal_user_database_enabled

    master_user_options {
      master_user_arn      = var.master_role_arn
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    custom_endpoint_enabled         = var.is_custom_endpoint_enabled
    custom_endpoint                 = format("%s.%s", var.cluster_name, var.cluster_domain)
    custom_endpoint_certificate_arn = var.acm_arn
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.encrypt_kms_key_id
  }

  tags = merge(
    {
      "Name" = format("%s-%s-elastic", local.prefix, var.cluster_name)
    },
    local.tags
  )
}

resource "aws_route53_record" "this" {
  count   = var.is_custom_endpoint_enabled ? 1 : 0
  zone_id = data.aws_route53_zone.opensearch[0].id
  name    = var.cluster_name
  type    = "CNAME"
  ttl     = "60"

  records = [aws_opensearch_domain.this.endpoint]
}
