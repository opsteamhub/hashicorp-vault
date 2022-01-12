locals {
    vault_name  = var.project_name 
    log_name    = join("-", ["/ecs/task-definition", local.vault_name])
    provisioner = "Terraform"
    squad       = var.squad
    service     = local.vault_name
}
