resource aws_internet_gateway igw {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "joechem-igw"
  }
}

# these two below will cost me extra $$$
# TODO: uncomment and create
resource aws_eip nat_gw_eip {
  vpc                       = true
  associate_with_private_ip = var.nat_gateway_ip
}
# TODO: uncomment and create
resource aws_nat_gateway gw {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.subnet[local.public_subnet_1_cidr].id

  depends_on = [aws_internet_gateway.igw]
}
