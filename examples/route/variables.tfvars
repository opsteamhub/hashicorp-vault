project_name          = "stack-name"
aws_account           = "11111111111" #aws_account_id
vault_image           = "vault-image:latest" #image ecr do vault
squad                 = "cross" #tag name squad responsavel
cert_domain_principal = "domain.com.br" #domain name certificado ACM
cert_domain_replica   = "domain.com.br" #domain name certificado ACM
region_principal      = "us-east-1" #definir a região principal para a stack ser provisionada
region_replica        = "eu-west-1" #definir a região replica para a stack ser provisionada

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