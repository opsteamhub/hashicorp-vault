project_name          = "stack-name"
aws_account           = "11111111111" #aws_account_id
vault_image           = "vault-image:latest" #image ecr do vault
squad                 = "cross" #tag name squad responsavel
cert_domain_principal = "domain.com.br" #domain name certificado ACM
region_principal      = "us-east-1" #definir a região principal para a stack ser provisionada
create_replica        = false #definir true ou false, definido para criar uma replica em outra região

