variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "To manage a resources with tags"
  type        = string
}

variable "cluster_name" {
  description = "The name of the OpenSearch cluster."
  type        = string
  default     = "opensearch"
}

variable "cluster_version" {
  description = "The version of OpenSearch or Elasticsearch to deploy."
  type        = string
  default     = ""
}

variable "cluster_domain" {
  description = "The hosted zone name of the OpenSearch cluster."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC for create security group"
  type        = string
  default     = null
}

variable "subnets_ids" {
  description = "List of IDs of subnets for create opensearch cluster"
  type        = list(string)
  default     = null
}

variable "additional_allow_cidr" {
  description = "cidr for allow connect to opensearch"
  type        = list(string)
  default     = []
}

variable "is_create_service_role" {
  description = "Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html"
  type        = bool
  default     = true
}

variable "is_master_instance_enabled" {
  description = "Indicates whether dedicated master nodes are enabled for the cluster."
  type        = bool
  default     = false
}

variable "master_instance_type" {
  description = "The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing"
  type        = string
  default     = "r6gd.large.search"

  validation {
    condition     = can(regex("^[t3|m3|r3|i3|i2|r6gd]", var.master_instance_type))
    error_message = "The EC2 master_instance_type must provide a SSD or NVMe-based local storage."
  }
}

variable "master_instance_count" {
  description = "The number of dedicated master nodes in the cluster."
  type        = number
  default     = 3
}

variable "hot_instance_type" {
  description = "The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing"
  type        = string
  default     = "r6gd.large.search"

  validation {
    condition     = can(regex("^[t3|m3|r3|i3|i2|r6gd]", var.hot_instance_type))
    error_message = "The EC2 hot_instance_type must provide a SSD or NVMe-based local storage."
  }
}

variable "hot_instance_count" {
  description = "The number of dedicated hot nodes in the cluster."
  type        = number
  default     = 1
}

variable "is_warm_instance_enabled" {
  description = "Indicates whether ultrawarm nodes are enabled for the cluster."
  type        = bool
  default     = true
}

variable "warm_instance_type" {
  description = "The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing"
  type        = string
  default     = "ultrawarm1.medium.search"
}

variable "warm_instance_count" {
  description = "The number of dedicated warm nodes in the cluster. Valid values are between 2 and 150"
  type        = number
  default     = 3
}

variable "availability_zones" {
  description = "The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3."
  type        = number
  default     = 3
}

variable "encrypt_kms_key_id" {
  description = "The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key."
  type        = string
  default     = ""
}

variable "is_internal_user_database_enabled" {
  description = " Whether the internal user database is enabled"
  type        = bool
  default     = true
}

variable "master_role_arn" {
  description = "The ARN for the master user of the cluster. leave it null if dont want to change the flow for authentication"
  type        = string
  default     = null
}

variable "master_user_name" {
  description = "Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if is_internal_user_database_enabled is set to true."
  type        = string
  default     = null
}

variable "master_user_password" {
  description = "Main user's password, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if is_internal_user_database_enabled is set to true"
  type        = string
  default     = null
  sensitive   = true
}

variable "is_custom_endpoint_enabled" {
  description = "Whether to enable custom endpoint for the OpenSearch domain."
  type        = bool
  default     = false
}

variable "acm_arn" {
  description = "ACM certificate ARN for custom endpoint."
  type        = string
  default     = ""
}


variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "bootstrap_config" {
  description = " config for bootstrap module require if not set the var.vpc_id and var.subnet_ids"
  type = object({
    vpc_id    = string
    subnet_id = string
  })
  default = null
}

variable "additional_iam_roles" {
  description = "aws iam roles for access to opensearch."
  type        = list(string)
  default     = []
}

variable "is_create_security_group" {
  description = "if true will create security group for opensearch"
  type        = bool
  default     = true
}

variable "additional_opensearch_security_group_ingress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional ingress rule for opensearch security group."
  default     = []
}

variable "additional_opensearch_client_security_group_ingress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional ingress rule for opensearch client security group."
  default     = []
}

variable "additional_opensearch_client_security_group_egress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional egress rule for opensearch client security group."
  default     = []
}
