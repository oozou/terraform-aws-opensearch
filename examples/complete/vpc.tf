module "vpc" {
  source  = "oozou/vpc/aws"
  version = "1.2.4"

  prefix      = var.prefix
  environment = var.environment
  cidr                         = "10.105.0.0/16"
  private_subnets              = ["10.105.60.0/22", "10.105.64.0/22", "10.105.68.0/22"]
  public_subnets               = ["10.105.0.0/24", "10.105.1.0/24", "10.105.2.0/24"]
  database_subnets             = ["10.105.20.0/23", "10.105.22.0/23", "10.105.24.0/23"]
  availability_zone            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  is_enable_dns_hostnames      = true
  is_enable_dns_support        = true
  is_create_nat_gateway        = true
  is_enable_single_nat_gateway = true
  account_mode                 = "hub"
  tags                         = var.tags
}
