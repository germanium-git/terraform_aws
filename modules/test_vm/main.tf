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
    Name = var.vm_name
  }
}

# Resource group + baseline rules
resource "aws_security_group" "sgroup"{
  name = var.vm_name
  description = "Protect the VM"

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [var.subnet_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id

}

# Add Specific rules
resource "aws_security_group_rule" "ingress" {
  for_each          = var.sg_rules
  security_group_id = aws_security_group.sgroup.id
  type              = each.value[0]
  from_port         = each.value[1]
  to_port           = each.value[2]
  protocol          = each.value[3]
  cidr_blocks       = list(each.value[4])
}