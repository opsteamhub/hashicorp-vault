resource "aws_eip" "eip_principal" {
  count = var.create_vpc ? 1 : 0
  vpc   = true

  tags = {
    Name          = join("-", ["eip", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

#####

resource "aws_eip" "eip_replica" {
  count    = var.create_replica ? 1 : 0
  provider = aws.replica
  vpc      = true

  tags = {
    Name          = join("-", ["eip", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

