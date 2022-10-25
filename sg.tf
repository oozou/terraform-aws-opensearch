resource "aws_security_group" "client" {
  count       = var.is_create_security_group ? 1 : 0
  name        = format("%s-%s-opensearch-sg", local.prefix, var.cluster_name)
  description = "Security group for allow internal VPC interact with OpenSearch"
  vpc_id      = data.aws_vpc.this[0].id

  lifecycle {
    create_before_destroy = true
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.this.id]
  }

  tags = merge(
    {
      "Name" = format("%s-%s-opensearch-sg", local.prefix, var.cluster_name)
    },
    local.tags
  )
}

resource "aws_security_group" "this" {
  count       = var.is_create_security_group ? 1 : 0
  name        = format("%s-%s-opensearch-sg", local.prefix, var.cluster_name)
  description = "Security group for allow internal VPC interact with OpenSearch"
  vpc_id      = data.aws_vpc.this[0].id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = format("%s-%s-opensearch-sg", local.prefix, var.cluster_name)
    },
    local.tags
  )
}
