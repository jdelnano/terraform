# Public route tables
resource aws_route_table public {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_internet_gateway.igw]
}

resource aws_route_table_association public_1 {
  subnet_id      = aws_subnet.subnet[local.public_subnet_1_cidr].id
  route_table_id = aws_route_table.public.id
}

resource aws_route_table_association public_2 {
  subnet_id      = aws_subnet.subnet[local.public_subnet_2_cidr].id
  route_table_id = aws_route_table.public.id
}

# Private route tables
resource aws_route_table private {
  vpc_id = aws_vpc.vpc.id

  # Uncomment if NAT gateway in use
  #route {
  #  cidr_block     = "0.0.0.0/0"
  #  nat_gateway_id = aws_nat_gateway.gw.id
  #}

  #depends_on = [aws_nat_gateway.gw]
}

resource aws_route_table_association private_1 {
  subnet_id      = aws_subnet.subnet[local.private_subnet_1_cidr].id
  route_table_id = aws_route_table.private.id
}

resource aws_route_table_association private_2 {
  subnet_id      = aws_subnet.subnet[local.private_subnet_2_cidr].id
  route_table_id = aws_route_table.private.id
}
