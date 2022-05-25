## Module Hashicorp Vault

Módulo Terraform para provisionar o Hashicorp Vault na AWS utilizando Terraform. 
O módulo irá provisionar o Vault em cluster ECS e utilizarar como backend o DynamoDB.
A infra estrutura será provisionada em paralelo duas Regiões, para que seja mantida uma replica para Disaster Recovery.

Pré requisitos para provisionar o cluster ECS do Vault.
- Certificado válido no certificate manager da AWS, se for provisionar a replica, deverá ter o certificado disponivel nas duas regiões.
- Image no Vault no ECR realizando o build do seguinte projeto https://github.com/opsteamhub/vault-image-dynamodb


## Usage

```  
variable "squad" {}
variable "cert_domain_principal" {}
variable "cert_domain_replica" {}
variable "project_name" {}
variable "region_principal" {}
variable "region_replica" {}
variable "create_vpc" {}
variable "private_vault" {}
variable "create_replica" {}
variable "aws_account" {}
variable "vault_image" {}
variable "routes_principal" {}
variable "routes_replica" {}

module "hashicorp-vault" {
  source = "github.com/opsteamhub/module-hashicorp-vault"

  project_name          = var.project_name
  aws_account           = var.aws_account
  vault_image           = var.vault_image
  squad                 = var.squad
  cert_domain_principal = var.cert_domain_principal
  cert_domain_replica   = var.cert_domain_replica
  private_vault         = var.private_vault
  region_principal      = var.region_principal
  region_replica        = var.region_replica
  create_vpc            = var.create_vpc
  create_replica        = var.create_replica
  routes_principal      = var.routes_principal
  routes_replica        = var.routes_replica
}
```
## Examples

- [Single Cluster](./examples/single-cluster)
- [Replica Cluster](./examples/replica)
- [Route](./examples/route) 
- [No create VPC](./examples/not-create-vpc)

## Resources

| Name | Type |
|------|------|
| [aws_launch_configuration](./autoscaling.tf) | resource |
| [aws_autoscaling_group](./autoscaling.tf) | resource |
| [aws_cloudwatch_log_group](./cloudwatch_logs.tf) | resource |
| [aws_dynamodb_table](./dynamodb.tf) | resource |
| [aws_dynamodb_global_table](./dynamodb.tf) | resource |
| [aws_ecs_service](./ecs_service.tf) | resource |
| [aws_ecs_cluster](./ecs.tf_) | resource |