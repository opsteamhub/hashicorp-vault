resource "aws_internet_gateway" "internet_gateway_replica" {
  provider = aws.replica
  vpc_id   = aws_vpc.vpc_replica.id

  tags = {
    Name          = join("-", ["ig", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}