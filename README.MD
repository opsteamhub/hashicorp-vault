#### Module Hashicorp Vault

###### main.tf
```
module "vault" {
  source = "./hashicorp-vault"

  project_name          = var.project_name
  vpc_tag               = var.vpc_tag
  private_subnet        = var.private_subnet
  public_subnet         = var.public_subnet
  squad                 = var.squad
  cert_domain_principal = var.cert_domain_principal
  cert_domain_replica   = var.cert_domain_replica
  private_vault         = var.private_vault
  region_principal      = var.region_principal
  region_replica        = var.region_replica
  aws_account           = var.aws_account

}
```

###### Dynamic Routes
