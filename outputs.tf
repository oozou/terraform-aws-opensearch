output "custom_domain_endpoint" {
  description = "custom domain for opensearch"
  value       = format("%s.%s", var.cluster_name, var.cluster_domain)
}

output "endpoint" {
  description = "endpoint for opensearch"
  value       = aws_opensearch_domain.this.endpoint
}

output "opensearch_security_group_id" {
  description = "Security group id for the opensearch."
  value       = try(aws_security_group.this[0].id, "")
}

output "opensearch_client_security_group_id" {
  description = "Security group id for the opensearch client."
  value       = try(aws_security_group.client[0].id, "")
}
