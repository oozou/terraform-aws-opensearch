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

  /* -------------------------------------------------------------------------- */
  /*                                    Alarms                                  */
  /* -------------------------------------------------------------------------- */
    comparison_operators = {
      ">=" = "GreaterThanOrEqualToThreshold",
      ">"  = "GreaterThanThreshold",
      "<"  = "LessThanThreshold",
      "<=" = "LessThanOrEqualToThreshold",
    }

}

