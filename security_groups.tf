resource "aws_security_group" "ecs_sg" {
    vpc_id              = data.aws_vpc.vpc_selected.id
    name                = join("-", ["SG", local.vault_name])
    description         = "Security Group Vault" 

    ingress {
        description     = "UI Port Vault"
        from_port       = 8200
        to_port         = 8200
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
      "Name"            = join("-", ["SG", local.vault_name])
      "ProvisionedBy"   = local.provisioner
      "Squad"           = local.squad
      "Service"         = local.service      
    }
}