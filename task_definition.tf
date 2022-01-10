locals {
  task_definition_vault = templatefile(
    "templates/task_definition_vault.json.tpl",
     {
        image_vault       = var.image_vault
        disable_mlock     = var.disable_mlock
        kms_id            = aws_kms_key.vault.key_id
        seal_type         = var.seal_type
        cpu               = var.cpu
        memory            = var.memory
        awslogs_group     = local.log_name
        region            = var.region
        dynamodb_table    = var.dynamodb_table
                
      })
}
resource "aws_ecs_task_definition" "task_definition_vault" {
  family                = join("-", ["task-definition", local.vault_name])
  container_definitions = local.task_definition_vault
  task_role_arn         = aws_iam_role.task_vault.arn 

  tags = {
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }  

}
