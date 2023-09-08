resource "aws_route53_zone" "zone_principal" {
  name = "vault.principal.local"

  vpc {
    vpc_id     = var.create_vpc == "false" ? var.vpc_id : aws_vpc.vpc[0].id
    vpc_region = var.region_principal
  }

  tags = {
    Name          = "vault.principal.local"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
  depends_on = [aws_vpc.vpc]

}

resource "aws_route53_record" "vault_principal" {
  zone_id = aws_route53_zone.zone_principal.zone_id
  name    = "internal"
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.elb_vault.dns_name]
}

resource "aws_route53_record" "vault_cluster_principal" {
  zone_id = aws_route53_zone.zone_principal.zone_id
  name    = "cluster"
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.elb_vault.dns_name]
}
###

resource "aws_route53_zone" "zone_replica" {
  count    = var.create_replica ? 1 : 0
  provider = aws.replica
  name     = "vault.replica.local"

  vpc {
    vpc_id     = aws_vpc.vpc_replica[0].id
    vpc_region = var.region_replica
  }

  tags = {
    Name          = "vault.replica.local"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_route53_record" "vault_replica" {
  count    = var.create_replica ? 1 : 0
  provider = aws.replica
  zone_id  = aws_route53_zone.zone_replica[0].zone_id
  name     = "internal"
  type     = "CNAME"
  ttl      = "30"
  records  = [aws_lb.elb_vault_replica[0].dns_name]
}

resource "aws_route53_record" "vault_cluster_replica" {
  count    = var.create_replica ? 1 : 0
  provider = aws.replica
  zone_id  = aws_route53_zone.zone_replica[0].zone_id
  name     = "cluster"
  type     = "CNAME"
  ttl      = "30"
  records  = [aws_lb.elb_vault_replica[0].dns_name]
}