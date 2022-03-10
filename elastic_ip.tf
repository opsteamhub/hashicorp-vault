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
  provider = aws.replica
  vpc      = true

  tags = {
    Name          = join("-", ["eip", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

