locals {
  prefix     = format("%s-%s", var.prefix, var.environment)
  identifier = format("%s-%s-%s-opensearch", var.prefix, var.environment, var.cluster_name)

  cloudwatch_log_group_kms_key_arn = length(var.encrypt_kms_key_id) > 0 ? var.encrypt_kms_key_id : var.is_create_default_kms && length(var.enabled_cloudwatch_logs_exports) > 0 ? module.cloudwatch_log_group_kms[0].key_arn : null

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags,
  )

  /* --------------------------------- Alarms --------------------------------- */
  comparison_operators = {
    ">=" = "GreaterThanOrEqualToThreshold",
    ">"  = "GreaterThanThreshold",
    "<"  = "LessThanThreshold",
    "<=" = "LessThanOrEqualToThreshold",
  }

}
