resource "aws_security_group" "ecs_sg" {
  vpc_id      = var.create_vpc == "false" ? var.vpc_id : aws_vpc.vpc[0].id
  name        = join("-", ["SG", local.vault_name])
  description = "Security Group Vault"

  ingress {
    description = "UI Port Vault"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Exporter Port"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"          = join("-", ["SG", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
  depends_on = [aws_vpc.vpc]
}

###

resource "aws_security_group" "ecs_sg_replica" {
  count       = var.create_replica ? 1 : 0
  provider    = aws.replica
  vpc_id      = aws_vpc.vpc_replica[0].id
  name        = join("-", ["SG", local.vault_name])
  description = "Security Group Vault"

  ingress {
    description = "UI Port Vault"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"          = join("-", ["SG", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}