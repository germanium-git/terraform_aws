provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}


# IAM role has been created manually in the AWS console
data "aws_iam_role" "example" {
  name = var.iam_role
}


# Create FortiGate-VMa instance in the specified AZ
resource "aws_instance" "fgvm" {
  ami                         = var.fgvm_ami_id
  key_name                    = var.key_id
  instance_type               = var.fw_instance_type
  subnet_id                   = var.subnet_outside_id
  vpc_security_group_ids      = [var.fg_sgroup_id]
  associate_public_ip_address = false
  availability_zone           = var.av_zone
  private_ip                  = cidrhost(var.subnet_outside_cidr, 10)
  iam_instance_profile        = data.aws_iam_role.example.name

  tags = {
    Name = var.vm_tag
  }
}

# Create Elastic IP to access FortiGate-VMa from the Internet
resource "aws_eip" "fgvm-ip-outside" {
  vpc = true
}

# Create Elastic IP to access FortiGate-VMa from the Internet
resource "aws_eip" "fgvm-ip-mng" {
  vpc = true
}

# Assign elastic ip to FortiGate-VM
resource "aws_eip_association" "eip-assoc-ouside" {
  allocation_id = aws_eip.fgvm-ip-outside.id
  network_interface_id  = aws_instance.fgvm.primary_network_interface_id
}

# Assign elastic ip to FortiGate-VM
resource "aws_eip_association" "eip-assoc-mng" {
  allocation_id = aws_eip.fgvm-ip-mng.id
  network_interface_id  = aws_network_interface.mng.id
}


# Create internal interface in FortiGate-VM
resource "aws_network_interface" "trust" {
  subnet_id = var.subnet_inside_id
  security_groups = [var.fg_sgroup_id]
  private_ips = [cidrhost(var.subnet_inside_cidr, 10)]
  source_dest_check = false

  attachment {
    instance = aws_instance.fgvm.id
    device_index = 1
  }
}


# Create HB interface in FortiGate-VM
resource "aws_network_interface" "hb" {
  subnet_id = var.subnet_hb_id
  security_groups = [var.fg_sgroup_id]
  private_ips = [cidrhost(var.subnet_hb_cidr, 10)]

  attachment {
    instance = aws_instance.fgvm.id
    device_index = 2
  }
}


# Create mng interface in FortiGate-VM
resource "aws_network_interface" "mng" {
  subnet_id = var.subnet_mng_id
  security_groups = [var.fg_sgroup_id]
  private_ips = [cidrhost(var.subnet_mng_cidr, 10)]
  source_dest_check = false

  attachment {
    instance = aws_instance.fgvm.id
    device_index = 3
  }
}