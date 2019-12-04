output "security-vpc-id" {
  value = aws_vpc.tgw-security.id
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "spoke_attached" {
  value = null_resource.dep_set_tgw_attachments.id
}

output "dep_set_tgw_created" {
  value = null_resource.dep_set_tgw_created.id
}

output "rtb-spoke-id" {
  value = aws_ec2_transit_gateway_route_table.rt_tgw_spoke.id
}

output "rt_spoke_created" {
  value = null_resource.dep_set_rttgw_spoke.id
}

output "rtb-security-id" {
  value = aws_ec2_transit_gateway_route_table.rt_tgw_security.id
}

output "rt_security_created" {
  value = null_resource.dep_set_rttgw_security.id
}

output "mgmt-a-subnet-id" {
  value = aws_subnet.mgmt-a.id
}

output "mgmt-b-subnet-id" {
  value = aws_subnet.mgmt-b.id
}

output "untrust-a-subnet-id" {
  value = aws_subnet.untrust-a.id
}

output "untrust-b-subnet-id" {
  value = aws_subnet.untrust-b.id
}

output "trust-a-subnet-id" {
  value = aws_subnet.trust-a.id
}

output "trust-b-subnet-id" {
  value = aws_subnet.trust-b.id
}