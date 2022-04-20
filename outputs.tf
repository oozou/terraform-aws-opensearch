output "domain" {
  description = "custom domain for opensearch"
  value       = format("%s.%s", var.cluster_name, data.aws_route53_zone.opensearch.name)
}
