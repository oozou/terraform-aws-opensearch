module "bootstrap" {
  source              = "./modules/bootstrap"
  vpc_id              = var.bootstrap_config != null ? var.bootstrap_config.vpc_id : var.vpc_id
  subnet_id           = var.bootstrap_config != null ? var.bootstrap_config.subnet_id : var.subnets_ids[0]
  prefix              = var.prefix
  environment         = var.environment
  opensearch_endpoint = aws_opensearch_domain.this.endpoint
  username            = var.master_user_name
  password            = var.master_user_password
  backend_roles       = var.additional_iam_roles
  tags                = var.tags
}
