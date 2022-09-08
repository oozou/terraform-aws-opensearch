output "custom_domain_endpoint" {
  description = "custom domain for opensearch"
  value       = module.opensearch.custom_domain_endpoint
}

output "endpoint" {
  description = "endpoint for opensearch"
  value       = module.opensearch.endpoint
}
