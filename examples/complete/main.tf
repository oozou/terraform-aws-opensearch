module "opensearch" {
  source                     = "../../"
  cluster_name               = "opensearch"
  is_custom_endpoint_enabled = true
  cluster_domain             = "aws.waruwat.com" # route53 hostzone domain
  cluster_version            = "OpenSearch_1.1"
  subnets_ids                = module.vpc.private_subnet_ids
  vpc_id                     = module.vpc.vpc_id
  prefix                     = "oozou"
  environment                = "dev"
  hot_instance_count         = 3
  availability_zones         = 3
  is_master_instance_enabled = false
  is_warm_instance_enabled   = false
  master_user_name           = "admin"
  master_user_password       = "AdminOpenSearchExample1@" #must be sensitive value
  acm_arn                    = module.acm.certificate_arns.opensearch
  bootstrap_config = {
    vpc_id    = module.vpc.vpc_id
    subnet_id = module.vpc.private_subnet_ids[0]
  }
  additional_iam_roles = []
  tags                 = var.tags
  depends_on = [
    module.acm
  ]
}
