output "custom_domain_endpoint" {
  description = "custom domain for opensearch"
  value       = format("%s.%s", var.cluster_name, var.cluster_domain)
}

output "endpoint" {
  description = "endpoint for opensearch"
  value       = aws_opensearch_domain.this.endpoint
}
