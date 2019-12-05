provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create Elastic IP to access FortiGate-VM from the Internet
resource "aws_eip" "fgvm-ip-outside" {
  vpc = true
}

# Assign elastic ip to FortiGate-VM
resource "aws_eip_association" "eip-assoc-ouside" {
  instance_id   = aws_instance.fgvm.id
  allocation_id = aws_eip.fgvm-ip-outside.id
}

# Create FortiGate-VM instance in a specific AZ
resource "aws_instance" "fgvm" {
  ami                         = var.ami_id
  key_name                    = var.key_id
  instance_type               = var.instance_type
  subnet_id                   = var.untrust-subnet-a-id
  private_ip                  = var.untrust-a-priv-ip
  vpc_security_group_ids      = [aws_security_group.fg-sgroup.id]
  associate_public_ip_address = false
  availability_zone           = var.av_zone_a

  tags = {
    Name = "FG-VM"
  }
}

# Create management interface
resource "aws_network_interface" "mgmt-a" {
  subnet_id = var.mgmt-subnet-a-id
  private_ips = var.mgmt-a-priv-ip
  security_groups = [aws_security_group.fg-mng-sgroup.id]

  attachment {
    instance = aws_instance.fgvm.id
    device_index = 1
  }
}

# Create a dedicated management Elastic IP
resource "aws_eip" "fgvm-ip-mng" {
  vpc = true
}

# Assign elastic ip to FortiGate-VM, the instance has multiple interfaces > assignment to network interface
resource "aws_eip_association" "eip-assoc-inside" {
  network_interface_id  = aws_network_interface.mgmt-a.id
  allocation_id = aws_eip.fgvm-ip-mng.id
}

# Create network interface to be connected to trust network
resource "aws_network_interface" "trust-a" {
  subnet_id       = var.trust-subnet-a-id
  private_ips     = var.trust-a-priv-ip
  security_groups = [aws_security_group.fg-sgroup.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.fgvm.id
    device_index = 2
  }
}

# It allows the spoke rt to be associated in spoke VPCs once the RT is created
resource "null_resource" "dep_set_eth2_created" {
  depends_on = [aws_network_interface.trust-a]
}

# Create security group to protect FortiGateVM
resource "aws_security_group" "fg-sgroup"{
  name = "sg_fortigate_vm"
  description = "Allow management traffic to fortigate"
  vpc_id = var.security-vpc-id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ssh_access_from]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.ssh_access_from]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.ssh_access_from]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["10.0.0.0/8"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}


# Create security group to protect management access
resource "aws_security_group" "fg-mng-sgroup"{
  name = "sg_fortigate_mng"
  description = "Allow management traffic to the mng interface"
  vpc_id = var.security-vpc-id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_to_mng]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.access_to_mng]
  }

}

