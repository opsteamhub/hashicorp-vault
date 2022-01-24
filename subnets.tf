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


###

resource "aws_subnet" "pub_subnet_a_replica" {
  provider                = aws.replica
  vpc_id                  = aws_vpc.vpc_replica.id
  cidr_block              = "10.0.1.0/24"
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
  cidr_block              = "10.0.2.0/24"
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
  cidr_block              = "10.0.3.0/24"
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
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region_replica}b"

  tags = {
    Name          = "sub-pri-b"
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}