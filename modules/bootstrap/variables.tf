variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "To manage a resources with tags"
  type        = string
}

variable "vpc_id" {
  description = "vpc id for create secgroup"
  type        = string
}

variable "subnet_id" {
  description = "IDs of subnets for create instance"
  type        = string
}

variable "tags" {
  description = "Tag for a resource taht create by this component"
  type        = map(string)
  default     = {}
}

variable "opensearch_endpoint" {
  description = "endpoint for call api opensearch"
  type        = string
}

variable "username" {
  description = "username for aurhentication to opensearch"
  type        = string
}

variable "password" {
  description = "password for aurhentication to opensearch"
  type        = string
}

variable "backend_roles" {
  description = "aws iam roles for access to opensearch"
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS account region"
  type     = string
  sensitive = true
}