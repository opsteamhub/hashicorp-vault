resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags = {
    Name = "${local.vault_name}-vault-kms-unseal-key"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_kms_alias" "vault" {
  name          = "alias/${local.vault_name}-vault-kms-unseal-key"
  target_key_id = aws_kms_key.vault.key_id
}
