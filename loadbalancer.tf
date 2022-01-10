resource "aws_lb_target_group" "tg_vault" {
  name     = join("-", ["tg", local.vault_name])
  port     = 8200
  protocol = "TCP"
  vpc_id   = data.aws_vpc.vpc_selected.id

  health_check {
    port     = 8200
    protocol = "TCP"
  }

  tags = {
    Name          = join("-", ["tg", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_lb" "elb_vault" {
  name               = join("-", ["lb", local.vault_name])
  internal           = var.private_lb
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.public.ids

  enable_deletion_protection = false

  tags = {
    Name          = join("-", ["lb", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_lb_listener" "listener_vault" {
  load_balancer_arn = aws_lb.elb_vault.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_vault.arn
  }
}


















