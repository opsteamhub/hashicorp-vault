resource "aws_vpc" "vpc" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = "172.27.18.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = join("-", ["vpc", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
    "vpc_tag"       = var.vpc_tag
  }
}

resource "aws_vpc" "vpc_replica" {
  provider             = aws.replica
  cidr_block           = "10.20.10.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = join("-", ["vpc", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}