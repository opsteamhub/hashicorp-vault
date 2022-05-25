variable "aws_account" {
  type        = string
  description = "AWS Account"
  default     = ""
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "cert_domain_principal" {
  type        = string
  description = "acm domain name"
}

variable "cert_domain_replica" {
  type        = string
  description = "acm domain name"
  default     = ""
}

variable "instance_type_vault" {
  type        = string
  description = "ec2 instance type"
  default     = "t3.medium"
}
variable "region_principal" {
  type        = string
  description = "AWS Region"
  default     = ""
}

variable "region_replica" {
  type        = string
  description = "AWS Region Replica"
  default     = ""
}

variable "image_vault" {
  type        = string
  description = "Image docker vault"
  default     = ""
}

variable "awslogs_group" {
  type        = string
  description = "AWS Logs Groups"
  default     = ""
}

#variable "vpc_tag" {
#  type        = string
#  description = "vpc_tag"
#}

variable "disable_mlock" {
  type        = string
  description = "VAULT_DISABLE_MLOCK"
  default     = "true"
}

variable "kms_id" {
  type        = string
  description = "VAULT_AWSKMS_SEAL_KEY_ID"
  default     = ""
}
variable "seal_type" {
  type        = string
  description = "VAULT_SEAL_TYPE"
  default     = "awskms"
}

variable "zone_id" {
  type        = string
  description = "zone_id anima.com.br"
  default     = ""
}

variable "dns_record" {
  type        = string
  description = "DNS Record"
  default     = ""
}

variable "private_vault" {
  type        = bool
  description = "LB internal facing"
  default     = true
}

variable "cpu" {
  type        = number
  description = "CPU task"
  default     = 1
}

variable "memory" {
  type        = number
  description = "Memory task"
  default     = 2048
}

variable "squad" {
  type        = string
  description = "Tag Squad"
  default     = "untagged"
}

variable "desired_capacity" {
  type        = number
  description = "Desired Capacity AutoScaling Group"
  default     = 1
}

variable "min_size" {
  type        = number
  description = "Min Size AutoScaling Group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Min Size AutoScaling Group"
  default     = 2
}

variable "desired_task_count" {
  type        = number
  description = "Desired Task ECS Service"
  default     = 1
}

variable "dynamodb_table" {
  type        = string
  description = "Dynamodb Table"
  default     = ""
}

variable "provisioner" {
  type        = string
  description = "Provisioner by Terraform"
  default     = "Terraform"
}

variable "create_vpc" {
}

variable "vpc_id" {
  default = null
}

variable "subnet_public_id" {
  default = []
}

variable "subnet_private_id" {
  default = []
}

variable "create_replica" {
  default = "false"
}

variable "vault_image" {}

variable "routes_principal" {
  type = list(object({
    transit_gateway_id        = optional(string)
    vpc_peering_connection_id = optional(string)
    cidr_block                = optional(string)
    gateway_id                = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
  }))
  default = []
}

variable "routes_replica" {
  type = list(object({
    transit_gateway_id        = optional(string)
    vpc_peering_connection_id = optional(string)
    cidr_block                = optional(string)
    gateway_id                = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
  }))
  default = []
}