project_name          = "stack-name"
aws_account           = "11111111111" #aws_account_id
vault_image           = "vault-image:latest" #image ecr do vault
squad                 = "cross" #tag name squad responsavel
cert_domain_principal = "domain.com.br" #domain name certificado ACM
private_vault         = "true" #definir true ou false se o alb vai ser privado ou publico
region_principal      = "us-east-1" #definir a região principal para a stack ser provisionada
create_vpc            = "true" #definir true ou false, utilizado para criar uma vpc nova dedicada ao vault ou utilizar uma vpc existente
create_replica        = "false" #definir true ou false, definido para criar uma replica em outra região

routes_principal = [ #caso precise se comunicar com outra vpc existente, após criar o transit gateway ou vpc peering, definir as rotas nesse bloco
           {
               cidr_block = "172.27.18.0/24",
               transit_gateway_id = "tgw-xxxxxxxxxxx"      
            }
]

routes_replica = [
           {
               cidr_block = "172.27.18.0/24",
               transit_gateway_id = "tgw-xxxxxxxxxxx"      
            }
] 