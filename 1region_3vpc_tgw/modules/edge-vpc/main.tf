provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define edge VPC
resource "aws_vpc" "edge-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.vpc-name
  }
}


# Define public subnet in AZ1
resource "aws_subnet" "public-fortigate" {
  cidr_block = var.public_subnet_cidr_az1
  vpc_id     = aws_vpc.edge-vpc.id
  availability_zone = var.av_zone_1

  tags = {
    Name = var.public_nw_name_az1
  }
}


# Define private subnet in AZ1
resource "aws_subnet" "private-fortigate" {
  cidr_block = var.private_subnet_cidr_az1
  vpc_id     = aws_vpc.edge-vpc.id
  availability_zone = var.av_zone_1

  tags = {
    Name = var.private_nw_name_az1
  }
}


# Define the internet gateway
resource "aws_internet_gateway" "edge-gw" {
  vpc_id = aws_vpc.edge-vpc.id
}


# Define the public route table
resource "aws_route_table" "fg-public-rt" {
  vpc_id = aws_vpc.edge-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.edge-gw.id
  }
}

# Assign the route table to the public subnet
resource "aws_route_table_association" "priv-rt_main" {
  subnet_id = aws_subnet.public-fortigate.id
  route_table_id = aws_route_table.fg-public-rt.id
}


# Create Elastic IP to access FortiGate-VM from the Internet
resource "aws_eip" "fgvm-ip" {
  vpc = true
}


# Assign elastic ip to FortiGate-VM
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.fgvm.id
  allocation_id = aws_eip.fgvm-ip.id
}


# Create FortiGate-VM instance in a specific AZ
resource "aws_instance" "fgvm" {
  ami           = var.ami_id
  key_name      = var.key_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-fortigate.id
  vpc_security_group_ids = [
     aws_security_group.sgroup.id]
  associate_public_ip_address = false
  availability_zone = var.av_zone_1

  tags = {
    Name = "FG-VM"
  }
}


resource "aws_network_interface" "fg-private" {
  subnet_id       = aws_subnet.private-fortigate.id
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.sgroup.id]

  attachment {
    instance     = aws_instance.fgvm.id
    device_index = 1
  }
}


resource "aws_security_group" "sgroup"{
  name = "sg_fortigate_vm"
  description = "Allow management traffic to fortigate"
  vpc_id = aws_vpc.edge-vpc.id

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

}
