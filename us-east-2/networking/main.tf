# vpc
resource aws_vpc vpc {
  cidr_block = var.network_cidr

  tags = {
    Name = "joechem"
  }
}

# create two public and two private subnets
resource aws_subnet subnet {
  for_each                = { for subnet in var.subnets : subnet.cidr => subnet }
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = each.value.tag_name
  }
}
