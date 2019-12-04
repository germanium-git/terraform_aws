output "tgw_id" {
  value = module.security_vpc.tgw_id
}

# Display FortiGate VM outside IP
output "fortigate_public_ip" {
  value = module.firewall.fg_public_ip
}


# Display FortiGate VM management IP
output "fortigate_management_ip" {
  value = module.firewall.fg_mng_ip
}


# Display instance Id to log in and reset password
output "fortigate_instance_id" {
  value = module.firewall.fg_instance_id
}