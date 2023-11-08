data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "backup" {
  name               = join("-", ["role", "backup", local.vault_name])
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup.name
}

resource "aws_backup_selection" "backup" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = join("-", ["backup", local.vault_name])
  plan_id      = aws_backup_plan.backup.id

  resources = [
    aws_dynamodb_table.dynamodb_table.arn
  ]
}

resource "aws_kms_key" "backup" {
  description             = "${local.vault_name}-backup"
  deletion_window_in_days = 7
  multi_region            = true

  tags = {
    Name          = "${local.vault_name}-backup"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_kms_alias" "backup" {
  name          = "alias/${local.vault_name}-backup-vault"
  target_key_id = aws_kms_key.backup.key_id
}

resource "aws_backup_vault" "backup" {
  name        = local.vault_name
  kms_key_arn = aws_kms_key.backup.arn
}

resource "aws_backup_plan" "backup" {
  name = local.vault_name
  
  rule {
    rule_name         = var.backup_rule_name
    enable_continuous_backup = false
    target_vault_name = aws_backup_vault.backup.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.backup_lifecycle
    }
  }
}

#### REPLICA ####

data "aws_iam_policy_document" "assume_role_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica  
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "backup_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica
  name               = join("-", ["role", "backup", local.vault_name, "replica"])
  assume_role_policy = data.aws_iam_policy_document.assume_role_replica[0].json
}

resource "aws_iam_role_policy_attachment" "backup_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_replica[0].name
}

resource "aws_backup_selection" "backup_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica    
  iam_role_arn = aws_iam_role.backup_replica[0].arn
  name         = join("-", ["backup", local.vault_name, "replica"])
  plan_id      = aws_backup_plan.backup_replica[0].id

  resources = [
    aws_dynamodb_table.dynamodb_table_replica[0].arn
  ]
}

resource "aws_kms_key" "backup_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica    
  description             = "${local.vault_name}-backup-replica"
  deletion_window_in_days = 7
  multi_region            = true

  tags = {
    Name          = "${local.vault_name}-backup-replica"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_kms_alias" "backup_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica    
  name          = "alias/${local.vault_name}-backup-vault-replica"
  target_key_id = aws_kms_key.backup_replica[0].key_id
}

resource "aws_backup_vault" "backup_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica    
  name        = local.vault_name
  kms_key_arn = aws_kms_key.backup_replica[0].arn
}

resource "aws_backup_plan" "backup_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica    
  name = local.vault_name
  
  rule {
    rule_name         = var.backup_rule_name
    enable_continuous_backup = false
    target_vault_name = aws_backup_vault.backup_replica[0].name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.backup_lifecycle_replica
    }
  }
}