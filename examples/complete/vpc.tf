module "vpc" {
  source                       = "oozou/vpc/aws"
  version                      = "1.1.7"
  prefix                       = var.prefix
  environment                  = var.environment
  cidr                         = "10.105.0.0/16"
  private_subnets              = ["10.105.60.0/22", "10.105.64.0/22", "10.105.68.0/22"]
  public_subnets               = ["10.105.0.0/24", "10.105.1.0/24", "10.105.2.0/24"]
  database_subnets             = ["10.105.20.0/23", "10.105.22.0/23", "10.105.24.0/23"]
  availability_zone            = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  is_enable_dns_hostnames      = true
  is_enable_dns_support        = true
  is_create_nat_gateway        = true
  is_enable_single_nat_gateway = true
  account_mode                 = "hub"
  tags                         = var.tags
}
