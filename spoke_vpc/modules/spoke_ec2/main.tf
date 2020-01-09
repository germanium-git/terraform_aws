provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}


# Create EC2 instance in a specific AZ
resource "aws_instance" "vm-test" {
  ami           = var.testvm_ami_id
  key_name      = var.key_id
  instance_type = var.testvm_instance_type
  subnet_id     = var.prod_subnet_id
  vpc_security_group_ids = [var.prod_sec_group_id]
  associate_public_ip_address = true
  availability_zone = var.av_zone
  private_ip = cidrhost(var.prod_subnet_cidr, 10)

  tags = {
    Name = var.vm_name
  }
}

