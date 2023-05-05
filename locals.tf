locals {
  prefix = format("%s-%s", var.prefix, var.environment)

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags,
  )
  identifier = format("%s-%s-%s-opensearch", var.prefix, var.environment, var.cluster_name)

  cloudwatch_log_group_kms_key_arn = var.cloudwatch_log_group_kms_key_arn != null ? var.cloudwatch_log_group_kms_key_arn : var.is_create_default_kms && length(enabled_cloudwatch_logs_exports) > 0 ? module.cloudwatch_log_group_kms[0].key_arn : null

  /* --------------------------------- Alarms --------------------------------- */
  comparison_operators = {
    ">=" = "GreaterThanOrEqualToThreshold",
    ">"  = "GreaterThanThreshold",
    "<"  = "LessThanThreshold",
    "<=" = "LessThanOrEqualToThreshold",
  }

}

