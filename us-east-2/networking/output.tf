output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1_id" {
  value = aws_subnet.subnet[local.public_subnet_1_cidr].id
}

output "public_subnet_2_id" {
  value = aws_subnet.subnet[local.public_subnet_2_cidr].id
}

output "private_subnet_1_id" {
  value = aws_subnet.subnet[local.private_subnet_1_cidr].id
}

output "private_subnet_2_id" {
  value = aws_subnet.subnet[local.private_subnet_2_cidr].id
}
