/* -------------------------------------------------------------------------- */
/*                          OpenSearch Security Group                         */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "this" {
  count = var.is_create_security_group ? 1 : 0

  name        = format("%s-%s-opensearch-sg", local.prefix, var.cluster_name)
  description = "Security group for allow internal VPC interact with OpenSearch"
  vpc_id      = data.aws_vpc.this[0].id

  tags = merge(local.tags, { "Name" : format("%s-%s-opensearch-sg", local.prefix, var.cluster_name) })
}

/* -------------------------------------------------------------------------- */
/*                             OpenSearch SG Rules                            */
/* -------------------------------------------------------------------------- */
# Security group rule for incoming to cluster connections (allow only from client)
resource "aws_security_group_rule" "from_client" {
  count = var.is_create_security_group ? 1 : 0

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this[0].id
  description       = "Ingress rule for allow traffic from opensearch client security group"

  source_security_group_id = aws_security_group.client[0].id
}

resource "aws_security_group_rule" "additional_opensearch_ingress" {
  count = var.is_create_security_group ? length(var.additional_opensearch_security_group_ingress_rules) : null

  type                     = "ingress"
  from_port                = var.additional_opensearch_security_group_ingress_rules[count.index].from_port
  to_port                  = var.additional_opensearch_security_group_ingress_rules[count.index].to_port
  protocol                 = var.additional_opensearch_security_group_ingress_rules[count.index].protocol
  cidr_blocks              = length(var.additional_opensearch_security_group_ingress_rules[count.index].source_security_group_id) > 0 ? null : var.additional_opensearch_security_group_ingress_rules[count.index].cidr_blocks
  source_security_group_id = length(var.additional_opensearch_security_group_ingress_rules[count.index].cidr_blocks) > 0 ? null : var.additional_opensearch_security_group_ingress_rules[count.index].source_security_group_id
  security_group_id        = aws_security_group.this[0].id
  description              = var.additional_opensearch_security_group_ingress_rules[count.index].description
}

resource "aws_security_group_rule" "to_internet" {
  count = var.is_create_security_group && var.is_enable_internet_access ? 1 : 0

  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "all"
  security_group_id = aws_security_group.this[0].id
  description       = "Egress rule for allow traffic to internet"

  cidr_blocks = ["0.0.0.0/0"]
}

/* -------------------------------------------------------------------------- */
/*                      OpenSearch Client Security Group                      */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "client" {
  count = var.is_create_security_group ? 1 : 0

  name        = format("%s-%s-opensearch-client-sg", local.prefix, var.cluster_name)
  description = "Security group to allow client to interact with OpenSearch"
  vpc_id      = data.aws_vpc.this[0].id

  tags = merge(local.tags, { "Name" : format("%s-%s-opensearch-client-sg", local.prefix, var.cluster_name) })
}

/* -------------------------------------------------------------------------- */
/*                         OpenSearch Client SG Rules                         */
/* -------------------------------------------------------------------------- */
# Additional Security group rule for incoming and outgoing client
resource "aws_security_group_rule" "additional_client_ingress" {
  count = var.is_create_security_group ? length(var.additional_opensearch_client_security_group_ingress_rules) : null

  type                     = "ingress"
  from_port                = var.additional_opensearch_client_security_group_ingress_rules[count.index].from_port
  to_port                  = var.additional_opensearch_client_security_group_ingress_rules[count.index].to_port
  protocol                 = var.additional_opensearch_client_security_group_ingress_rules[count.index].protocol
  cidr_blocks              = length(var.additional_opensearch_client_security_group_ingress_rules[count.index].source_security_group_id) > 0 ? null : var.additional_opensearch_client_security_group_ingress_rules[count.index].cidr_blocks
  source_security_group_id = length(var.additional_opensearch_client_security_group_ingress_rules[count.index].cidr_blocks) > 0 ? null : var.additional_opensearch_client_security_group_ingress_rules[count.index].source_security_group_id
  security_group_id        = aws_security_group.client[0].id
  description              = var.additional_opensearch_client_security_group_ingress_rules[count.index].description
}

# Security group rule for outgoing to opensearch connections
resource "aws_security_group_rule" "to_cluster" {
  count = var.is_create_security_group ? 1 : 0

  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.client[0].id
  description       = "Egress rule for allow traffic to rds cluster security group"

  source_security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "additional_client_egress" {
  count = var.is_create_security_group ? length(var.additional_opensearch_client_security_group_egress_rules) : null

  type                     = "egress"
  from_port                = var.additional_opensearch_client_security_group_egress_rules[count.index].from_port
  to_port                  = var.additional_opensearch_client_security_group_egress_rules[count.index].to_port
  protocol                 = var.additional_opensearch_client_security_group_egress_rules[count.index].protocol
  cidr_blocks              = length(var.additional_opensearch_client_security_group_egress_rules[count.index].source_security_group_id) > 0 ? null : var.additional_opensearch_client_security_group_egress_rules[count.index].cidr_blocks
  source_security_group_id = length(var.additional_opensearch_client_security_group_egress_rules[count.index].cidr_blocks) > 0 ? null : var.additional_opensearch_client_security_group_egress_rules[count.index].source_security_group_id
  security_group_id        = aws_security_group.client[0].id
  description              = var.additional_opensearch_client_security_group_egress_rules[count.index].description
}
