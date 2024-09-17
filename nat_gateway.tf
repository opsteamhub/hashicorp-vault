resource "aws_nat_gateway" "nat_gateway_pub_a_principal" {
  count         =(var.create_nat_instance ? 0 : 1) * (var.create_vpc ? 1 : 0)
  allocation_id = aws_eip.eip_principal[0].id
  subnet_id     = aws_subnet.pub_subnet_a_principal[0].id

  tags = {
    Name          = join("-", ["ng", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

#####

resource "aws_nat_gateway" "nat_gateway_pub_a_replica" {
  count         = (var.create_nat_instance ? 0 : 1) * (var.create_replica ? 1 : 0)
  provider      = aws.replica
  allocation_id = aws_eip.eip_replica[0].id
  subnet_id     = aws_subnet.pub_subnet_a_replica[0].id

  tags = {
    Name          = join("-", ["ng", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

