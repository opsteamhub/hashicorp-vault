output "lb_vault" {
  value = aws_lb.elb_vault.dns_name
}

output "key_id" {
  value       = join("", aws_kms_key.vault.*.key_id)
  description = "Key ID"
}

#output "dns_vault" {
#  value = aws_route53_record.dns_vault.name
#}