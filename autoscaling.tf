locals {
  user_data_vault = templatefile(
    ".terraform/modules/hashicorp-vault/templates/user_data.tpl",
    {
      cluster_vault = local.vault_name
  })
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "aws_ami" "amazon_linux_ecs_replica" {
  provider    = aws.replica
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_launch_configuration" "ecs_launch_config_vault" {
  image_id             = data.aws_ami.amazon_linux_ecs.id
  name_prefix          = join("-", ["lc", local.vault_name])
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data            = local.user_data_vault
  instance_type        = var.instance_type_vault

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg_vault" {
  name                 = join("-", ["asg", local.vault_name])
  vpc_zone_identifier  = [aws_subnet.pri_subnet_a_principal[0].id, aws_subnet.pri_subnet_b_principal[0].id]
  launch_configuration = aws_launch_configuration.ecs_launch_config_vault.name
  target_group_arns    = [aws_lb_target_group.tg_vault.arn]
  health_check_type    = "ELB"

  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = join("-", ["ecs", local.vault_name])
    propagate_at_launch = true
  }

  tag {
    key                 = "ProvisionedBy"
    value               = local.provisioner
    propagate_at_launch = true
  }

  tag {
    key                 = "Squad"
    value               = local.squad
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = local.service
    propagate_at_launch = true
  }
}

####

resource "aws_launch_configuration" "ecs_launch_config_vault_replica" {
  count                = var.create_replica ? 1 : 0
  provider             = aws.replica
  image_id             = data.aws_ami.amazon_linux_ecs_replica.id
  name_prefix          = join("-", ["lc", local.vault_name])
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg_replica[0].id]
  user_data            = local.user_data_vault
  instance_type        = var.instance_type_vault

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg_vault_replica" {
  count                = var.create_replica ? 1 : 0
  provider             = aws.replica
  name                 = join("-", ["asg", local.vault_name])
  vpc_zone_identifier  = [aws_subnet.pri_subnet_a_replica[0].id, aws_subnet.pri_subnet_b_replica[0].id]
  launch_configuration = aws_launch_configuration.ecs_launch_config_vault_replica[0].name
  target_group_arns    = [aws_lb_target_group.tg_vault_replica[0].arn]
  health_check_type    = "ELB"

  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = join("-", ["ecs", local.vault_name])
    propagate_at_launch = true
  }

  tag {
    key                 = "ProvisionedBy"
    value               = local.provisioner
    propagate_at_launch = true
  }

  tag {
    key                 = "Squad"
    value               = local.squad
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = local.service
    propagate_at_launch = true
  }

}
