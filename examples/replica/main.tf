variable "squad" {}
variable "cert_domain_principal" {}
variable "cert_domain_replica" {}
variable "project_name" {}
variable "region_principal" {}
variable "region_replica" {}
variable "create_vpc" {}
variable "private_vault" {}
variable "create_replica" {}
variable "aws_account" {}
variable "vault_image" {}

module "hashicorp-vault" {
  source = "github.com/opsteamhub/module-hashicorp-vault"

  project_name          = var.project_name
  aws_account           = var.aws_account
  vault_image           = var.vault_image
  squad                 = var.squad
  cert_domain_principal = var.cert_domain_principal
  cert_domain_replica   = var.cert_domain_replica
  private_vault         = var.private_vault
  region_principal      = var.region_principal
  region_replica        = var.region_replica
  create_vpc            = var.create_vpc
  create_replica        = var.create_replica
}