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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.2.0 |

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
| [aws_eip](./elastic_ip.tf_) | resource |
| [aws_iam_role_policy](./iam.tf) | resource |
| [aws_iam_role](./iam.tf) | resource |
| [aws_iam_role_policy_attachment](./iam.tf) | resource |
| [aws_iam_instance_profile](./iam.tf) | resource |
| [aws_internet_gateway](./internet_gateway.tf) | resource |
| [aws_kms_key](./kms.tf) | resource |
| [aws_kms_alias](./kms.tf) | resource |
| [aws_kms_replica_key](./kms.tf) | resource |
| [aws_lb_target_group](./loadbalancer.tf) | resource |
| [aws_lb](./loadbalancer.tf) | resource |
| [aws_lb_listener](./loadbalancer.tf) | resource |
| [aws_nat_gateway](./nat_gateway.tf) | resource |
| [aws_route_table](./route_table.tf) | resource |
| [aws_route_table_association](./route_table.tf) | resource |
| [aws_route53_zone](./route53.tf) | resource |
| [aws_route53_record](./route53.tf) | resource |
| [aws_security_group](./security_groups.tf) | resource |
| [aws_subnet](./subnets.tf) | resource |
| [aws_ecs_task_definition](./task_definition.tf) | resource |
| [aws_vpc](./vpc.tf) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="project_name"></a> [project\_name](#input\_project\_name) | Nome da stack do vault, será utilizado na criação dos resources. | `string` | `null` | yes |
| <a name="aws_account"></a> [aws_account](#input\_aws\_account) | AWS Account ID, requirido para formar a URI da image ECR do Vault. | `string` | `""` | yes |
| <a name="vault_image"></a> [aws_account](#input\_vault\_image) | Nome da imagem do vault hospedada no ECR. | `string` | `null` | yes |



## Authors

Module is maintained by [Rafael Vinícius](https://github.com/faelvinicius) with help from [these awesome from Opsteam](https://ops.team/).