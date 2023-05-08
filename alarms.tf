module "custom_opensearch_alarms" {
  source  = "oozou/cloudwatch-alarm/aws"
  version = "1.0.0"

  for_each   = var.custom_opensearch_alarms_configure
  depends_on = [aws_opensearch_domain.this]

  prefix      = var.prefix
  environment = var.environment
  name        = format("%s-%s-alarm", local.identifier, each.key)

  alarm_description = format(
    "%s's %s %s %s in period %ss with %s datapoint",
    lookup(each.value, "metric_name", null),
    lookup(each.value, "statistic", "Average"),
    lookup(each.value, "comparison_operator", null),
    lookup(each.value, "threshold", null),
    lookup(each.value, "period", 600),
    lookup(each.value, "evaluation_periods", 1)
  )

  comparison_operator = local.comparison_operators[lookup(each.value, "comparison_operator", null)]
  evaluation_periods  = lookup(each.value, "evaluation_periods", 1)
  metric_name         = lookup(each.value, "metric_name", null)
  namespace           = "AWS/ES"
  period              = lookup(each.value, "period", 600)
  statistic           = lookup(each.value, "statistic", "Average")
  threshold           = lookup(each.value, "threshold", null)

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = aws_opensearch_domain.this.domain_name
  }
  alarm_actions = lookup(each.value, "alarm_actions", null)
  ok_actions    = lookup(each.value, "ok_actions", null)
  # TODO set this to alrm to resource

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "opensearch_cpu_alarm" {
  count               = var.is_enable_default_alarms ? 1 : 0
  alarm_name          = format("%s-%s-alarm", local.identifier, "opensearch_high_CPU")
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ES"
  period              = "600"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm will trigger if the opensearch's cpu usage is too high"
  alarm_actions       = var.default_alarm_actions
  ok_actions          = var.default_ok_actions

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = aws_opensearch_domain.this.domain_name
  }

  tags = merge(local.tags, { Name = format("%s-%s-alarm", local.identifier, "opensearch_high_CPU") })
}

resource "aws_cloudwatch_metric_alarm" "opensearch_memory_alarm" {
  count               = var.is_enable_default_alarms ? 1 : 0
  alarm_name          = format("%s-%s-alarm", local.identifier, "opensearch_high_memory")
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "JVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "600"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm will trigger if the opensearch's memory usage is too high"
  alarm_actions       = var.default_alarm_actions
  ok_actions          = var.default_ok_actions

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = aws_opensearch_domain.this.domain_name
  }

  tags = merge(local.tags, { Name = format("%s-%s-alarm", local.identifier, "opensearch_high_memory") })
}

resource "aws_cloudwatch_metric_alarm" "opensearch_storage_low_alarm" {
  count               = var.is_enable_default_alarms ? 1 : 0
  alarm_name          = format("%s-%s-alarm", local.identifier, "opensearch_low_storage")
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = "600"
  statistic           = "Average"
  threshold           = var.volume_size * 0.1
  alarm_description   = "This alarm will trigger if the storage used for the OpenSearch domain falls below 20%."
  alarm_actions       = var.default_alarm_actions
  ok_actions          = var.default_ok_actions

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = aws_opensearch_domain.this.domain_name
  }

  tags = merge(local.tags, { Name = format("%s-%s-alarm", local.identifier, "opensearch_low_storage") })
}

resource "aws_cloudwatch_metric_alarm" "opensearch_health_alarm" {
  count               = var.is_enable_default_alarms ? 1 : 0
  alarm_name          = format("%s-%s-alarm", local.identifier, "opensearch_health")
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterStatus.red"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "This alarm will trigger if the OpenSearch domain is not healthy"
  alarm_actions       = var.default_alarm_actions
  ok_actions          = var.default_ok_actions

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = aws_opensearch_domain.this.domain_name
  }

  tags = merge(local.tags, { Name = format("%s-%s-alarm", local.identifier, "opensearch_health") })
}

