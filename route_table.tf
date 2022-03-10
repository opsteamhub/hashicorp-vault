resource "aws_route_table" "public_principal" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_principal[0].id
  }

  tags = {
    Name          = join("-", ["route-pub", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_route_table_association" "route_table_association_pub_a_principal" {
  count          = var.create_vpc ? 1 : 0
  subnet_id      = aws_subnet.pub_subnet_a_principal[0].id
  route_table_id = aws_route_table.public_principal[0].id
}

resource "aws_route_table_association" "route_table_association_pub_b_principal" {
  count          = var.create_vpc ? 1 : 0
  subnet_id      = aws_subnet.pub_subnet_b_principal[0].id
  route_table_id = aws_route_table.public_principal[0].id
}


resource "aws_route_table" "private_principal" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_pub_a_principal[0].id
  }

  tags = {
    Name          = join("-", ["route-pri", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_route_table_association" "route_table_association_pri_a_principal" {
  count          = var.create_vpc ? 1 : 0
  subnet_id      = aws_subnet.pri_subnet_a_principal[0].id
  route_table_id = aws_route_table.private_principal[0].id
}

resource "aws_route_table_association" "route_table_association_pri_b_principal" {
  count          = var.create_vpc ? 1 : 0
  subnet_id      = aws_subnet.pri_subnet_b_principal[0].id
  route_table_id = aws_route_table.private_principal[0].id
}


######


resource "aws_route_table" "public_replica" {
  provider = aws.replica
  vpc_id   = aws_vpc.vpc_replica.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_replica.id
  }

  tags = {
    Name          = join("-", ["route-pub", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_route_table_association" "route_table_association_pub_a_replica" {
  provider       = aws.replica
  subnet_id      = aws_subnet.pub_subnet_a_replica.id
  route_table_id = aws_route_table.public_replica.id
}

resource "aws_route_table_association" "route_table_association_pub_b_replica" {
  provider       = aws.replica
  subnet_id      = aws_subnet.pub_subnet_b_replica.id
  route_table_id = aws_route_table.public_replica.id
}


resource "aws_route_table" "private_replica" {
  provider = aws.replica
  vpc_id   = aws_vpc.vpc_replica.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_pub_a_replica.id
  }

  tags = {
    Name          = join("-", ["route-pri", local.vault_name])
    ProvisionedBy = local.provisioner
    Squad         = local.squad
    Service       = local.service
  }
}

resource "aws_route_table_association" "route_table_association_pri_a_replica" {
  provider       = aws.replica
  subnet_id      = aws_subnet.pri_subnet_a_replica.id
  route_table_id = aws_route_table.private_replica.id
}

resource "aws_route_table_association" "route_table_association_pri_b_replica" {
  provider       = aws.replica
  subnet_id      = aws_subnet.pri_subnet_b_replica.id
  route_table_id = aws_route_table.private_replica.id
}
