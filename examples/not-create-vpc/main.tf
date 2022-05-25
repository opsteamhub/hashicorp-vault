variable "squad" {}
variable "cert_domain_principal" {}
variable "cert_domain_replica" {}
variable "project_name" {}
variable "region_principal" {}
variable "region_replica" {}
variable "private_vault" {}
variable "aws_account" {}
variable "vault_image" {}
variable "vpc_id" {}
variable "subnet_public_id" {}
variable "subnet_private_id" {}

module "hashicorp-vault" {
  source = "github.com/opsteamhub/module-hashicorp-vault"

  project_name          = var.project_name
  aws_account           = var.aws_account
  vault_image           = var.vault_image
  squad                 = var.squad
  cert_domain_principal = var.cert_domain_principal
  cert_domain_replica   = var.cert_domain_replica
  region_principal      = var.region_principal
  region_replica        = var.region_replica
  create_vpc            = var.create_vpc
  vpc_id                = var.vpc_id
  subnet_public_id      = var.subnet_public_id
  subnet_private_id     = var.subnet_private_id
}