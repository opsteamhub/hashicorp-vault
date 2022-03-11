resource "aws_ecs_cluster" "ecs_cluster" {
  name = join("-", ["cluster", local.vault_name])

  tags = {
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

#####

resource "aws_ecs_cluster" "ecs_cluster_replica" {
  count    = var.create_replica ? 1 : 0
  provider = aws.replica
  name     = join("-", ["cluster", local.vault_name])

  tags = {
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}