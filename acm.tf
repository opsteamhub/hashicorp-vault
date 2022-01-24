data "aws_acm_certificate" "issued" {
  domain   = var.cert_domain_principal
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "issued_replica" {
  provider = aws.replica
  domain   = var.cert_domain_replica
  statuses = ["ISSUED"]
}