resource "aws_security_group" "this" {
  count       = var.is_create_security_group ? 1 : 0
  name        = format("%s-%s-opensearch-sg", local.prefix, var.cluster_name)
  description = "Security group for allow internal VPC interact with OpenSearch"
  vpc_id      = data.aws_vpc.this[0].id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = concat([data.aws_vpc.this[0].cidr_block], var.additional_allow_cidr)
  }
  tags = merge(
    {
      "Name" = format("%s-%s-opensearch-sg", local.prefix, var.cluster_name)
    },
    local.tags
  )
}
