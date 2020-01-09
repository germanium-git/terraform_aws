output "test-vm-a-ip" {
  value = module.test_vm_a.vm_public_ip
}

output "test-vm-b-ip" {
  value = module.test_vm_b.vm_public_ip
}

output "test-vm-c-ip" {
  value = module.test_vm_c.vm_public_ip
}

output "fortigate-a-outside-ip" {
  value = module.firewall-a.fw-outisde-ip
}

output "fortigate-b-outside-ip" {
  value = module.firewall-b.fw-outisde-ip
}

output "fortigate-a-mng-ip" {
  value = module.firewall-a.fw-mng-ip
}

output "fortigate-b-mng-ip" {
  value = module.firewall-b.fw-mng-ip
}

output "fortigate-a-ec2-id" {
  value = module.firewall-a.fw-ec2-instance-id
}

output "fortigate-b-ec2-id" {
  value = module.firewall-b.fw-ec2-instance-id
}