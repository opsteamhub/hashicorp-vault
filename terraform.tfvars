squad                     = "Cross"

image_vault               = "432925404607.dkr.ecr.us-east-1.amazonaws.com/vault:14"

certificate               = "arn:aws:acm:us-east-1:432925404607:certificate/5574581a-680e-489b-aa6b-e3cd4b233a33"
private_lb                = false

environment               = "prd"
subnet_tag_priv           = "priv"
subnet_tag_pub            = "pub"

dynamodb_table            = "vault-opsteam"