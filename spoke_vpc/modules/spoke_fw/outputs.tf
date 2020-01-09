output "fw-outisde-ip" {
  value = aws_eip.fgvm-ip-outside.public_ip
}

output "fw-mng-ip" {
  value = aws_eip.fgvm-ip-mng.public_ip
}

output "fw-ec2-instance-id" {
  value = aws_instance.fgvm.id
}