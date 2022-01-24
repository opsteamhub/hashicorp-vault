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

