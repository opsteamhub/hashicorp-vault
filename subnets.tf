data "aws_vpc" "vpc_selected" {
  filter {
    name   = "tag:vpc_tag"
    values = [var.vpc_tag]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc_selected.id

  tags = {
    sub = var.public_subnet
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc_selected.id

  tags = {
    sub = var.private_subnet
  }
}

resource "aws_subnet" "pub_subnet_a_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.27.18.0/26"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name          = "sub-pub-a"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
    sub           = var.public_subnet
  }
}

resource "aws_subnet" "pub_subnet_b_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.27.18.64/26"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"

  tags = {
    Name          = "sub-pub-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
    sub           = var.public_subnet
  }
}

resource "aws_subnet" "pri_subnet_a_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.27.18.128/26"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}a"

  tags = {
    Name          = "sub-pri-a"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
    sub           = var.private_subnet
  }
}

resource "aws_subnet" "pri_subnet_b_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.27.18.192/26"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}b"

  tags = {
    Name          = "sub-pri-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
    sub           = var.private_subnet
  }
}



######

resource "aws_subnet" "pub_subnet_a_replica" {
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica.id
  cidr_block              = "10.10.20.0/26"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region_replica}a"

  tags = {
    Name          = "sub-pub-a"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_subnet" "pub_subnet_b_replica" {
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica.id
  cidr_block              = "10.10.20.64/26"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region_replica}b"

  tags = {
    Name          = "sub-pub-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_subnet" "pri_subnet_a_replica" {
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica.id
  cidr_block              = "10.10.20.128/26"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region_replica}a"

  tags = {
    Name          = "sub-pri-a"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_subnet" "pri_subnet_b_replica" {
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica.id
  cidr_block              = "10.10.20.192/26"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region_replica}b"

  tags = {
    Name          = "sub-pri-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}