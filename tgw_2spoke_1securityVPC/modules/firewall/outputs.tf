# Print FortGateVM outside IP
output "fg_public_ip" {
  value = aws_eip.fgvm-ip-outside.public_ip
}

# Print FortGateVM management IP
output "fg_mng_ip" {
  value = aws_eip.fgvm-ip-mng.public_ip
}

# Print FortGateVM instance ID
output "fg_instance_id" {
  value = aws_instance.fgvm.id
}

# eth2 eni is needed to configure route in the rt-fromTGW
output "eth2-eni-id" {
  value = aws_network_interface.trust-a.id
}

# Dependency setter for eth2 created
output "eth2_created" {
  value = null_resource.dep_set_eth2_created.id
}
