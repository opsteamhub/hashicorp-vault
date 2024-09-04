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
  count             = var.create_nat_instance ? 1 : 0
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
  count             = var.create_nat_instance ? 1 : 0
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

  image_id = data.aws_ami.natinstance_ami.id

  instance_type = "t3.medium"

  network_interfaces {
    network_interface_id = aws_network_interface.nat_instance_network_interface[0].id
    device_index         = 0
  }

  monitoring {
    enabled = false
  }
  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = join("-", ["nat-instance", local.vault_name])
    }
  }
}

resource "aws_autoscaling_group" "nat_asg_vault" {
  count       = var.create_nat_instance ? 1 : 0
  name_prefix = join("-", ["asg", "nat-instance", local.vault_name])
  #vpc_zone_identifier = [aws_subnet.pub_subnet_a_principal[0].id]
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  min_size           = 1
  max_size           = 1

  launch_template {
    id      = aws_launch_template.nat_instance[0].id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
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

resource "aws_network_interface" "nat_instance_network_interface" {
  count             = var.create_nat_instance ? 1 : 0
  subnet_id         = aws_subnet.pub_subnet_a_principal[0].id
  security_groups   = [aws_security_group.sg-nat-instance[0].id]
  source_dest_check = false

  tags = {
    Name          = join("-", ["eni", "nat-instance", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_eip" "nat_instance_eip" {
  count = var.create_nat_instance ? 1 : 0
  vpc   = true

  tags = {
    "Name"          = join("-", ["eip", "nat-instance", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}

resource "aws_eip_association" "nat_instance_eip_assoc" {
  count                = var.create_nat_instance && length(aws_network_interface.nat_instance_network_interface.*.id) > 0 ? 1 : 0
  network_interface_id = aws_network_interface.nat_instance_network_interface[0].id
  allocation_id        = aws_eip.nat_instance_eip[0].id
}

resource "aws_network_interface_attachment" "nat_instance_attachment" {
  count = var.create_nat_instance && length(data.aws_instances.nat_instance.ids) > 0 ? 1 : 0

  instance_id          = data.aws_instances.nat_instance.ids[0]
  network_interface_id = aws_network_interface.nat_instance_network_interface[0].id
  device_index         = 0 # Você pode alterar este valor conforme necessário

  lifecycle {
    ignore_changes = [
      network_interface_id
    ]
  }  
}



#### REPLICA ###

# Security Group for NAT Instance
resource "aws_security_group" "sg-nat-instance_replica" {
  count       = var.create_nat_instance && var.create_replica ? 1 : 0
  provider = aws.replica
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
resource "aws_security_group_rule" "vpc-inbound_replica" {
  count             = var.create_nat_instance && var.create_replica ? 1 : 0
  provider = aws.replica
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg-nat-instance_replica[0].id
}

# NAT Instance security group rule to allow outbound traffic
resource "aws_security_group_rule" "outbound-nat-instance_replica" {
  count             = var.create_nat_instance && var.create_replica ? 1 : 0
  provider = aws.replica
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg-nat-instance_replica[0].id
}


data "aws_ami" "natinstance_ami_replica" {
  provider = aws.replica
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }
}

##ASG
resource "aws_launch_template" "nat_instance_replica" {
  count       = var.create_nat_instance && var.create_replica ? 1 : 0
  provider = aws.replica
  name_prefix = join("-", ["lt", "nat", local.vault_name])

  image_id = data.aws_ami.natinstance_ami_replica.id

  instance_type = "t3.medium"

  network_interfaces {
    network_interface_id = aws_network_interface.nat_instance_network_interface_replica[0].id
    device_index         = 0
  }

  monitoring {
    enabled = false
  }
  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = join("-", ["nat-instance", local.vault_name])
    }
  }
}

resource "aws_autoscaling_group" "nat_asg_vault_replica" {
  count       = var.create_nat_instance && var.create_replica ? 1 : 0
  provider = aws.replica
  name_prefix = join("-", ["asg", "nat-instance", local.vault_name])
  #vpc_zone_identifier = [aws_subnet.pub_subnet_a_principal[0].id]
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  min_size           = 1
  max_size           = 1

  launch_template {
    id      = aws_launch_template.nat_instance_replica[0].id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
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

data "aws_instances" "nat_instance_replica" {
  provider = aws.replica
  filter {
    name   = "tag:Name"
    values = [join("-", ["asg", "nat-instance", local.vault_name])]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

resource "aws_network_interface" "nat_instance_network_interface_replica" {
  count       = var.create_nat_instance && var.create_replica ? 1 : 0
  provider = aws.replica
  subnet_id         = aws_subnet.pub_subnet_a_replica[0].id
  security_groups   = [aws_security_group.sg-nat-instance_replica[0].id]
  source_dest_check = false

  tags = {
    Name          = join("-", ["eni", "nat-instance", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_eip" "nat_instance_eip_replica" {
  count       = var.create_nat_instance && var.create_replica ? 1 : 0
  provider = aws.replica
  vpc   = true

  tags = {
    "Name"          = join("-", ["eip", "nat-instance", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}

resource "aws_eip_association" "nat_instance_eip_assoc_replica" {
  count                = var.create_nat_instance && var.create_replica && length(aws_network_interface.nat_instance_network_interface_replica.*.id) > 0 ? 1 : 0
  provider = aws.replica
  network_interface_id = aws_network_interface.nat_instance_network_interface_replica[0].id
  allocation_id        = aws_eip.nat_instance_eip_replica[0].id
}

resource "aws_network_interface_attachment" "nat_instance_attachment_replica" {
  count = var.create_nat_instance && var.create_replica && length(data.aws_instances.nat_instance_replica.ids) > 0 ? 1 : 0
  provider = aws.replica
  
  instance_id          = data.aws_instances.nat_instance_replica.ids[0]
  network_interface_id = aws_network_interface.nat_instance_network_interface_replica[0].id
  device_index         = 0 # Você pode alterar este valor conforme necessário

  lifecycle {
    ignore_changes = [
      network_interface_id
    ]
  }

}