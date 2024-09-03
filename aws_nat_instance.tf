# Security Group for NAT Instance
resource "aws_security_group" "sg-nat-instance" {
  count       = var.create_nat_instance ? 1 : 0
  name        = join("-", ["SG", "nat-instance", local.vault_name])
  description = "Security Group for NAT instance"
  vpc_id      = var.create_vpc == "false" ? var.vpc_id : aws_vpc.vpc[0].id
  tags = {
    "Name"          = join("-", ["SG", "nat-instance", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
  depends_on = [aws_vpc.vpc]
}

# NAT Instance security group rule to allow all traffic from within the VPC
resource "aws_security_group_rule" "vpc-inbound" {
  count       = var.create_nat_instance ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg-nat-instance[0].id
}

# NAT Instance security group rule to allow outbound traffic
resource "aws_security_group_rule" "outbound-nat-instance" {
  count       = var.create_nat_instance ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg-nat-instance[0].id
}


data "aws_ami" "natinstance_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  } 
}

##ASG
resource "aws_launch_template" "nat_instance" {
  count       = var.create_nat_instance ? 1 : 0
  name_prefix = join("-", ["lt", "nat", local.vault_name])

  disable_api_termination = true

  image_id = data.aws_ami.natinstance_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.medium"

  monitoring {
    enabled = false
  }

  vpc_security_group_ids = [aws_security_group.sg-nat-instance[0].id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = join("-", ["nat-instance", local.vault_name])
    }
  }
}

resource "aws_autoscaling_group" "nat_asg_vault" {
  count       = var.create_nat_instance ? 1 : 0
  name_prefix                = join("-", ["asg", "nat-instance", local.vault_name])
  vpc_zone_identifier = [aws_subnet.pub_subnet_a_principal[0].id, aws_subnet.pub_subnet_b_principal[0].id]
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1

  launch_template {
    id      = aws_launch_template.nat_instance[0].id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = join("-", ["asg", "nat-instance", local.vault_name])
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

data "aws_instances" "nat_instance" {
  filter {
    name   = "tag:Name"
    values = [join("-", ["asg", "nat-instance", local.vault_name])]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_network_interface" "nat_instance_network_interface" {
  count = length(data.aws_instances.nat_instance.ids) > 0 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instances.nat_instance.ids[0]]
  }
}