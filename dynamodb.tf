resource "aws_dynamodb_table" "dynamodb_table" {
  name             = local.vault_name
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "Path"
  range_key        = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags = {
    Name          = local.vault_name
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

####

resource "aws_dynamodb_table" "dynamodb_table_replica" {
  count            = var.create_replica ? 1 : 0
  provider         = aws.replica
  name             = local.vault_name
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "Path"
  range_key        = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags = {
    Name          = local.vault_name
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_dynamodb_global_table" "vault_replica" {
  count = var.create_replica ? 1 : 0
  depends_on = [
    aws_dynamodb_table.dynamodb_table_replica,
    aws_dynamodb_table.dynamodb_table
  ]

  name = local.vault_name

  replica {
    region_name = var.region_principal
  }

  replica {
    region_name = var.region_replica
  }
}