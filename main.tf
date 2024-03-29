data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

resource "aws_iam_service_linked_role" "this" {
  count            = var.is_create_service_role ? 1 : 0
  aws_service_name = "opensearchservice.amazonaws.com"
}

resource "aws_opensearch_domain" "this" {
  depends_on = [
    aws_iam_service_linked_role.this[0],
  ]

  domain_name     = local.identifier
  engine_version  = var.cluster_version
  access_policies = null

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

  dynamic "log_publishing_options" {
    for_each = aws_cloudwatch_log_group.this

    content {
      cloudwatch_log_group_arn = log_publishing_options.value.arn
      log_type                 = lookup(log_publishing_options.value.tags, "Type")
    }
  }

  dynamic "vpc_options" {
    for_each = var.vpc_id == null ? [] : [1]

    content {
      subnet_ids         = var.subnets_ids
      security_group_ids = [aws_security_group.this[0].id]
    }
  }

  ebs_options {
    ebs_enabled = var.is_ebs_enabled
    volume_size = var.volume_size
    volume_type = var.volume_type
    iops        = var.iops
    throughput  = var.throughput
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

resource "aws_opensearch_domain_policy" "this" {
  domain_name     = aws_opensearch_domain.this.domain_name
  access_policies = data.aws_iam_policy_document.access_policy.json
}

resource "aws_route53_record" "this" {
  count   = var.is_custom_endpoint_enabled ? 1 : 0
  zone_id = data.aws_route53_zone.opensearch[0].id
  name    = var.cluster_name
  type    = "CNAME"
  ttl     = "60"

  records = [aws_opensearch_domain.this.endpoint]
}

data "aws_iam_policy_document" "os_access_cloudwatch_policy" {
  statement {
    sid = "AllowCloudWatchToDoCryptography"
    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream"
    ]
    resources = [format("arn:aws:logs:%s:%s:log-group:/aws/opensearch/%s/*:*", data.aws_region.this.name, data.aws_caller_identity.this.account_id, local.identifier)]

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "os_access_cloudwatch_policy" {
  policy_name = format("%s-access-cloudwatch-policy", local.identifier)

  policy_document = data.aws_iam_policy_document.os_access_cloudwatch_policy.json
}

/* -------------------------------------------------------------------------- */
/*                                 Cloudwatch                                 */
/* -------------------------------------------------------------------------- */
data "aws_iam_policy_document" "cloudwatch_log_group_kms_policy" {
  statement {
    sid = "AllowCloudWatchToDoCryptography"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = tolist([format("logs.%s.amazonaws.com", data.aws_region.this.name)])
    }

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      # values   = [format("arn:aws:logs:%s:%s:log-group:/aws/opensearch/%s/%s", data.aws_region.this.name, data.aws_caller_identity.this.account_id, local.identifier)]
      values = formatlist(format("arn:aws:logs:%s:%s:log-group:/aws/opensearch/%s/%%s", data.aws_region.this.name, data.aws_caller_identity.this.account_id, local.identifier), var.enabled_cloudwatch_logs_exports)
    }
  }
}

module "cloudwatch_log_group_kms" {
  count   = length(var.enabled_cloudwatch_logs_exports) > 0 && var.is_create_default_kms && length(var.encrypt_kms_key_id) == 0 ? 1 : 0
  source  = "oozou/kms-key/aws"
  version = "1.0.0"

  prefix               = var.prefix
  environment          = var.environment
  name                 = format("%s-opensearch-log-group", var.cluster_name)
  key_type             = "service"
  append_random_suffix = true
  description          = format("Secure Secrets Manager's service secrets for service %s", local.identifier)
  additional_policies  = [data.aws_iam_policy_document.cloudwatch_log_group_kms_policy.json]

  tags = merge(local.tags, { "Name" : format("%s-opensearch-log-group", local.identifier) })
}

resource "aws_cloudwatch_log_group" "this" {
  for_each = toset(var.enabled_cloudwatch_logs_exports)

  name              = format("/aws/opensearch/%s/%s", local.identifier, each.value)
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = local.cloudwatch_log_group_kms_key_arn

  tags = merge(
    local.tags,
    { "Name" = format("%s_%s", local.identifier, each.value) },
    { "Type" = each.value }
  )
}
