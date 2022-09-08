module "acm" {
  source  = "oozou/acm/aws"
  version = "1.0.4"

  acms_domain_name = {
    opensearch = {
      domain_name = "opensearch.example.com"
    }
  }
  route53_zone_name        = "example.com"
  is_automatic_verify_acms = true
}
