resource "aws_subnet" "pub_subnet_a_principal" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = var.create_vpc == 1 ? var.vpc_id : aws_vpc.vpc[0].id
  cidr_block              = join(".",[regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_principal}"), "0/26"])
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
  cidr_block              = join(".",[regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_principal}"), "64/26"])
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
  cidr_block              = join(".",[regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_principal}"), "128/26"])
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
  cidr_block              = join(".",[regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_principal}"), "192/26"])
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
  count                   = var.create_replica ? 1 : 0
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica[0].id
  cidr_block              = join(".",[regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_replica}"), "0/26"])
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
  count                   = var.create_replica ? 1 : 0
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica[0].id
  cidr_block              = join(".",[regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_replica}"), "64/26"])
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
  count                   = var.create_replica ? 1 : 0
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica[0].id
  cidr_block              = join(".", [regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_replica}"), "128/26"])
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
  count                   = var.create_replica ? 1 : 0
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica[0].id
  cidr_block              = join(".",[regex("^[0-9]+.[0-9]+.[0-9]+", "${var.cidr_block_replica}"), "192/26"])
  map_public_ip_on_launch = false
  availability_zone       = "${var.region_replica}b"

  tags = {
    Name          = "sub-pri-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}