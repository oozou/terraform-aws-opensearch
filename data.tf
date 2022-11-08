data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "opensearch" {
  count = var.is_custom_endpoint_enabled ? 1 : 0
  name  = var.cluster_domain
}

data "aws_vpc" "this" {
  count = var.is_create_security_group ? 1 : 0
  id    = var.vpc_id
}

data "aws_iam_policy_document" "access_policy" {
  statement {
    actions   = ["es:*"]
    resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.cluster_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}
