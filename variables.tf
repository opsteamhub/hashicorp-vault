variable "aws_account" {
    type        = string
    description = "AWS Account"
}

variable "project_name" {
    type        = string
    description = "Project Name"
}
variable "instance_type_vault" {
    type        = string
    description = "ec2 instance type"
    default     = "t3.medium"
}
variable "region" {
    type        = string
    description = "AWS Region"
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

variable "environment" {
    type        = string
    description = "environment"
    default     = ""
}
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

variable "certificate" {
    type        = string
    description = "Certificate Anima"
    default     = ""
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

variable "private_lb" {
    type        = bool
    description = "LB internal facing"
    default     = true
}

variable "subnet_tag_priv" {
    type        = string
    description = "Tag Subnet Privada"
    default     = ""
}

variable "subnet_tag_pub" {
    type        = string
    description = "Tag Subnet Publica"
    default     = ""
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


