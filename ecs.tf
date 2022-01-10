resource "aws_ecs_cluster" "ecs_cluster" {
    name  = join("-", ["cluster", local.vault_name])

    tags = {
      ProvisionedBy = local.provisioner
      Squad         = local.squad
      Service       = local.service      
    }
}

