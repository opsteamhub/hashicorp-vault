resource "aws_vpc" "vpc_replica" {
  provider             = aws.replica
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = join("-", ["vpc", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}