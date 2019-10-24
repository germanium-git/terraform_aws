output "frankfurt_vm_az1_public_ip" {
  value = module.ec2_frankfurt_az1.ec2_public_ip
}

output "frankfurt_vm_az2_public_ip" {
  value = module.ec2_frankfurt_az2.ec2_public_ip
}

output "frankfurt_vm_az3_public_ip" {
  value = module.ec2_frankfurt_az3.ec2_public_ip
}