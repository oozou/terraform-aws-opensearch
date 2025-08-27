module "ec2" {
  source                      = "oozou/ec2-instance/aws"
  version                     = "1.0.6"
  prefix                      = var.prefix
  environment                 = var.environment
  name                        = "os-bootstrap"
  ami                         = data.aws_ami.ubuntu.id
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  is_batch_run                = true
  is_create_default_profile   = true
  override_profile_policy     = [data.aws_iam_policy_document.this.json]
  user_data                   = data.template_cloudinit_config.user_data.rendered
  additional_sg_attacment_ids = var.additional_sg_attacment_ids
  tags                        = var.tags
}

resource "aws_secretsmanager_secret" "terraform_key" {
  name_prefix = format("%s-%s-test", var.prefix, var.environment)
  kms_key_id  = var.kms_key_id != "" ? var.kms_key_id : null
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "terraform_key" {
  secret_id = aws_secretsmanager_secret.terraform_key.id
  secret_string = jsonencode({
    username            = var.username
    password            = var.password
  })
}
