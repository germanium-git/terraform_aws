provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create EC2 instance in a specific AZ
resource "aws_instance" "vm" {
  ami           = var.ami_id
  key_name      = var.key_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [
     aws_security_group.sgroup.id]
  associate_public_ip_address = true
  availability_zone = var.av_zone

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "sgroup"{
  name = "sg_test_vm"
  description = "Allow traffic from private subnet"

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [var.subnet_cidr]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ssh_access_from]
  }

  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  vpc_id = var.vpc_id

}