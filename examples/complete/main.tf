module "opensearch" {
  source                     = "../../"
  cluster_name               = "opensearch"
  is_custom_endpoint_enabled = false
  cluster_domain             = "example.com" # route53 hostzone domain
  cluster_version            = "OpenSearch_1.1"
  subnets_ids                = [module.vpc.private_subnet_ids[0]]
  vpc_id                     = module.vpc.vpc_id
  prefix                     = var.prefix
  environment                = var.environment
  hot_instance_count         = 1
  availability_zones         = 1
  is_master_instance_enabled = false
  is_warm_instance_enabled   = false
  is_create_service_role     = false
  master_user_name           = "admin"
  master_user_password       = "AdminOpenSearchExample1@" #must be sensitive value
  enabled_cloudwatch_logs_exports = ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS","ES_APPLICATION_LOGS","AUDIT_LOGS"]
  acm_arn                    = ""
  bootstrap_config = {
    vpc_id    = module.vpc.vpc_id
    subnet_id = module.vpc.private_subnet_ids[0]
  }
  additional_iam_roles = ["arn:aws:iam::855546030651:role/sbth-dev-bpc-ecs-access-role"]
  tags                 = var.tags

}
