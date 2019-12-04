output "spoke-subnet-id" {
  value = aws_subnet.sn-spokex-azx.id
}

output "spoke-vpc-id" {
  value = aws_vpc.spoke-vpc.id
}

output "sppke-subnet-cidr" {
  value = aws_subnet.sn-spokex-azx.cidr_block
}