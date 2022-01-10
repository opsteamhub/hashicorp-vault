data "aws_vpc" "vpc_selected" {
  filter {
    name = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc_selected.id

  tags = {
    sub = var.subnet_tag_pub
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc_selected.id

  tags = {
    sub = var.subnet_tag_priv
  }
}