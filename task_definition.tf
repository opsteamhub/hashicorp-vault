locals {
  task_definition_vault = templatefile(
    "templates/task_definition_vault.json.tpl",
     {
        image_vault       = "${var.aws_account}.dkr.ecr.${var.region}.amazonaws.com/vault:15"
        disable_mlock     = var.disable_mlock
        kms_id            = aws_kms_key.vault.key_id
        seal_type         = var.seal_type
        cpu               = var.cpu
        memory            = var.memory
        awslogs_group     = local.log_name
        region            = var.region
        dynamodb_table    = aws_dynamodb_table.dynamodb_table.name
                
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
