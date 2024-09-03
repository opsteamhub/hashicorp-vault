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
  cidr_blocks       = [var.cidr_block_principal]
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
  security_group_id = aws_security_group.sg-nat-instance[0].id
}


data "aws_ami" "natinstance_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }
}


# Build the NAT Instance
resource "aws_instance" "nat-instance" {
  count       = var.create_nat_instance ? 1 : 0
  ami                         = data.aws_ami.natinstance_ami.id
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.pub_subnet_a_principal[0].id
  vpc_security_group_ids      = [aws_security_group.sg-nat-instance[0].id]
  associate_public_ip_address = true
  source_dest_check           = false

  # Root disk for NAT instance 
  root_block_device {
    volume_size = "2"
    volume_type = "gp3"
    encrypted   = true
  }
  tags = {
    "Name"          = join("-", ["nat-instance", local.vault_name])
    "ProvisionedBy" = local.provisioner
    "Squad"         = local.squad
    "Service"       = local.service
  }
}

