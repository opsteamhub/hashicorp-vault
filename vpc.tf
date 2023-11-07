resource "aws_vpc" "vpc" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.cidr_block_principal
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = join("-", ["vpc", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}

resource "aws_vpc" "vpc_replica" {
  count                = var.create_replica ? 1 : 0
  provider             = aws.replica
  cidr_block           = var.cidr_block_replica
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = join("-", ["vpc", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}