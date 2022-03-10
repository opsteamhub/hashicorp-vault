resource "aws_route53_zone" "zone_principal" {
  name = "vault.local"

  vpc {
    vpc_id = var.create_vpc == "false" ? var.vpc_id : aws_vpc.vpc[0].id
  }

  tags = {
    Name          = "vault.local"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
  depends_on = [aws_vpc.vpc]

}

resource "aws_route53_record" "vault_principal" {
  zone_id = aws_route53_zone.zone_principal.zone_id
  name    = "vault"
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.elb_vault.dns_name]
}

###

resource "aws_route53_zone" "zone_replica" {
  provider = aws.replica
  name     = "vault.local"

  vpc {
    vpc_id = aws_vpc.vpc_replica.id
  }

  tags = {
    Name          = "vault.local"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_route53_record" "vault_replica" {
  provider = aws.replica
  zone_id  = aws_route53_zone.zone_replica.zone_id
  name     = "vault-replica"
  type     = "CNAME"
  ttl      = "30"
  records  = [aws_lb.elb_vault_replica.dns_name]
}