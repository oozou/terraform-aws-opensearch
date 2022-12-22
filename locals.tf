locals {
  prefix = format("%s-%s", var.prefix, var.environment)

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags,
  )
  identifier = format("%s-%s-%s-opensearch", var.prefix, var.environment, "test")

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

