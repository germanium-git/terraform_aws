output "subnet-id" {
  value = aws_subnet.subnet.id
}

output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "rtable-id" {
  value = aws_route_table.rt-vpc.id
}