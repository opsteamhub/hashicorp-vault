locals {
  region_principal = var.region_principal
  region_replica   = var.region_replica
  vault_name       = var.project_name
  log_name         = join("-", ["/ecs/task-definition", local.vault_name])
  provisioner      = var.provisioner
  squad            = var.squad
  service          = local.vault_name
}
