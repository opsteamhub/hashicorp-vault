data "aws_acm_certificate" "issued" {
  domain   = var.cert_domain_principal
  statuses = ["ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "issued_replica" {
  provider = aws.replica
  domain   = var.cert_domain_replica
  statuses = ["ISSUED"]
  most_recent = true
}