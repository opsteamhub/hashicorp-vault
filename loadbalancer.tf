resource "aws_lb_target_group" "tg_vault" {
  name_prefix = local.vault_name
  port        = 8200
  protocol    = "TCP"
  vpc_id      = var.create_vpc == "false" ? var.vpc_id : aws_vpc.vpc[0].id

  health_check {
    port     = 8200
    protocol = "HTTPS"
    path     = "/v1/sys/health"
  }

  tags = {
    Name          = join("-", ["tg", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
  depends_on = [aws_vpc.vpc]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "tg_exporter" {
  name     = join("-", ["tg", local.vault_name, "exporter"])
  port     = 9100
  protocol = "TCP"
  vpc_id   = var.create_vpc == "false" ? var.vpc_id : aws_vpc.vpc[0].id

  health_check {
    port     = 9100
    protocol = "TCP"
  }

  tags = {
    Name          = join("-", ["tg", local.vault_name, "exporter"])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
  depends_on = [aws_vpc.vpc]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb" "elb_vault" {
  name               = join("-", ["lb", local.vault_name])
  internal           = var.private_vault
  load_balancer_type = "network"
  subnets            = var.private_vault == true ? [aws_subnet.pri_subnet_a_principal[0].id, aws_subnet.pri_subnet_b_principal[0].id] : [aws_subnet.pub_subnet_a_principal[0].id, aws_subnet.pub_subnet_b_principal[0].id]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

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
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_vault.arn
  }
}

resource "aws_lb_listener" "listener_exporter" {
  load_balancer_arn = aws_lb.elb_vault.arn
  port              = "9100"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_exporter.arn
  }
}

###

resource "aws_lb_target_group" "tg_vault_replica" {
  count       = var.create_replica ? 1 : 0
  provider    = aws.replica
  name_prefix = local.vault_name
  port        = 8200
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc_replica[0].id

  health_check {
    port     = 8200
    protocol = "HTTPS"
    path     = "/v1/sys/health"
  }

  tags = {
    Name          = join("-", ["tg", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb" "elb_vault_replica" {
  count              = var.create_replica ? 1 : 0
  provider           = aws.replica
  name               = join("-", ["lb", local.vault_name])
  internal           = var.private_vault
  load_balancer_type = "network"
  subnets            = var.private_vault == true ? [aws_subnet.pri_subnet_a_replica[0].id, aws_subnet.pri_subnet_b_replica[0].id] : [aws_subnet.pub_subnet_a_replica[0].id, aws_subnet.pub_subnet_b_replica[0].id]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name          = join("-", ["lb", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_lb_listener" "listener_vault_replica" {
  count             = var.create_replica ? 1 : 0
  provider          = aws.replica
  load_balancer_arn = aws_lb.elb_vault_replica[0].arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued_replica[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_vault_replica[0].arn
  }
}




































