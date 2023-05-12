module "bootstrap" {
  count                       = length(var.additional_iam_roles) > 0 ? 1 : 0
  source                      = "./modules/bootstrap"
  vpc_id                      = var.bootstrap_config != null ? var.bootstrap_config.vpc_id : var.vpc_id
  subnet_id                   = var.bootstrap_config != null ? var.bootstrap_config.subnet_id : var.subnets_ids[0]
  prefix                      = var.prefix
  environment                 = var.environment
  opensearch_endpoint         = aws_opensearch_domain.this.endpoint
  username                    = var.master_user_name
  password                    = var.master_user_password
  backend_roles               = var.additional_iam_roles
  tags                        = var.tags
  region                      = data.aws_region.current.name
  additional_sg_attacment_ids = [aws_security_group.client[0].id]
}

