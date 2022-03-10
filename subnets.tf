resource "aws_subnet" "pub_subnet_a_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = var.create_vpc == 1 ? var.vpc_id : aws_vpc.vpc[0].id
  cidr_block              = "172.27.18.0/26"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region_principal}a"

  tags = {
    Name          = "sub-pub-a"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_subnet" "pub_subnet_b_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = var.create_vpc == 1 ? var.vpc_id : aws_vpc.vpc[0].id
  cidr_block              = "172.27.18.64/26"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region_principal}b"

  tags = {
    Name          = "sub-pub-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_subnet" "pri_subnet_a_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = var.create_vpc == 1 ? var.vpc_id : aws_vpc.vpc[0].id
  cidr_block              = "172.27.18.128/26"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region_principal}a"

  tags = {
    Name          = "sub-pri-a"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_subnet" "pri_subnet_b_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = var.create_vpc == 1 ? var.vpc_id : aws_vpc.vpc[0].id
  cidr_block              = "172.27.18.192/26"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region_principal}b"

  tags = {
    Name          = "sub-pri-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
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