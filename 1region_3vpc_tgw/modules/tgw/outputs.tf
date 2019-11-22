output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw_frankfurt.id
}

output "tgw_completed" {
  value = null_resource.dependency_setter.id
}