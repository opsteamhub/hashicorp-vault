## Module Hashicorp Vault

Módulo Terraform para provisionar o Hashicorp Vault na AWS utilizando Terraform. 
O módulo irá provisionar o Vault em cluster ECS e utilizarar como backend o DynamoDB.
A infra estrutura será provisionada em paralelo duas Regiões, para que seja mantida uma replica para Disaster Recovery.

Pré requisitos para provisionar o cluster ECS do Vault.
- Certificado válido no certificate manager da AWS, se for provisionar a replica, deverá ter o certificado disponivel nas duas regiões.
- Image no Vault no ECR realizando o build do seguinte projeto https://github.com/opsteamhub/vault-image-dynamodb


## Usage

```  
module "hashicorp-vault" {
  source = "github.com/opsteamhub/module-hashicorp-vault"

  project_name          = "vault-name"
  aws_account           = "1111111111"
  vault_image           = "vault:latest"
  squad                 = "Cross"
  cert_domain_principal = "domain.com"
  cert_domain_replica   = "domain.com"
  region_principal      = "us-east-1"
  region_replica        = "eu-west-1"
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
| <a name="vault_image"></a> [vault_image](#input\_vault\_image) | Nome da imagem do vault hospedada no ECR. | `string` | `"null"` | yes |
| <a name="squad"></a> [squad](#input\_squad) | Tag squad, utilizado para definir squad responsável por manter o vault. | `string` | `"untagged"` | no |
| <a name="cert_domain_principal"></a> [cert_domain_principal](#input\_cert\_domain\_principal) | Domain Name do certificado hospedado no ACM da região principal onde o vault será provisionado. | `string` | `""` | yes |
| <a name="cert_domain_replica"></a> [cert_domain_replica](#input\_cert\_domain\_replica) | Domain Name do certificado hospedadono ACM da região replica onde o vault será provisionado. | `string` | `""` | yes |
| <a name="private_vault"></a> [private_vault](#input\_private\_vault ) | Utilizado para definir se o ALB do Vault vai ser privado ou publico. | `bool` | `true` | no |
| <a name="region_principal"></a> [region_principal](#input\_region\_principal) | Utilizado para definir a região principal que o Vault será provisionado. | `string` | `""` | yes |
| <a name="region_replica"></a> [region_replica](#input\_region\_replica) | Utilizado para definir a região replica que o Vault será provisionado. | `string` | `""` | yes |
| <a name="create_vpc"></a> [create_vpc](#input\_create\_vpc) | Requerido se for não for utilizar alguma VPC existe na região principal aonde o Vault vai ser provisionado. | `bool` | `true` | no |
| <a name="create_replica"></a> [create_replica](#input\_create\_replica) | Utilizado para definir se irá criar uma replica da stack do vault em outra região. | `bool` | `true` | no |
| <a name="vpc_id"></a> [vpc_id](#input\_vpc\_id) | Utilizado se for utilizar uma VPC já existente quando é definido `false` na variavel `create_replica`. | `string` | `""` | no |
| <a name="subnet_public_id "></a> [subnet_public_id ](#input\_subnet\_public\_id ) | Utilizado se for utilizar uma subnet já existente quando é definido `false` na variavel  `create_replica`. | `string` | `""` | no |
| <a name="subnet_private_id"></a> [subnet_private_id](#input\_subnet\_private\_id) | Utilizado se for utilizar uma subnet já existente quando é definido `false` na variavel `create_replica`. | `string` | `""` | no |
| <a name="routes"></a> [routes](#input\_routes) | Utilizado para definir uma rota quando a vpc do vault precisa se comunicar com alguma outra vpc. | `list(object)` | `[]` | no |


## Authors

Module is maintained by [Rafael Vinícius](https://github.com/faelvinicius) with help from [these awesome from Opsteam](https://ops.team/).