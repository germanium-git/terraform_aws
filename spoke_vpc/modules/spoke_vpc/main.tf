provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define spoke VPC
resource "aws_vpc" "spoke-vpc" {
  cidr_block       = var.spokevpc_prod_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.spokevpc_name
  }
}



# Define internal spoke ec2  production subnets
resource "aws_subnet" "prod-ec2" {
  for_each = var.subnet_test
  cidr_block = each.value[0]
  vpc_id = aws_vpc.spoke-vpc.id
  availability_zone = each.value[1]
  tags = {
    Name = each.key
  }
}


# Define firewall outside subnet
resource "aws_subnet" "outside-fw" {
  for_each = var.subnet_fw_outside
  cidr_block = each.value[0]
  vpc_id = aws_vpc.spoke-vpc.id
  availability_zone = each.value[1]
  tags = {
    Name = each.key
  }
}


# Define firewall inside subnet
resource "aws_subnet" "inside-fw" {
  for_each = var.subnet_fw_inside
  cidr_block = each.value[0]
  vpc_id = aws_vpc.spoke-vpc.id
  availability_zone = each.value[1]
  tags = {
    Name = each.key
  }
}

# Define firewall HB subnet
resource "aws_subnet" "hb-fw" {
  for_each = var.subnet_fw_hb
  cidr_block = each.value[0]
  vpc_id = aws_vpc.spoke-vpc.id
  availability_zone = each.value[1]
  tags = {
    Name = each.key
  }
}


# Define firewall MNG subnet
resource "aws_subnet" "mng-fw" {
  for_each = var.subnet_fw_mng
  cidr_block = each.value[0]
  vpc_id = aws_vpc.spoke-vpc.id
  availability_zone = each.value[1]
  tags = {
    Name = each.key
  }
}


# Create Security Group to protect test VMs - production vnic
resource "aws_security_group" "sgroup_prod"{
  name = "sg_test_vm_prod"
  description = "Allow traffic from private subnet"

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [var.spokevpc_prod_cidr]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_from]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.spoke-vpc.id

}


# Create Security Group to protect test VMs - management vnic
resource "aws_security_group" "sgroup_mng"{
  name = "sg_test_vm_mng"
  description = "Allow traffic from management subnet"

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [var.spokevpc_prod_cidr]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_from]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.spoke-vpc.id

}


# Create security group to protect FortiGateVM
resource "aws_security_group" "fg-sgroup"{
  name = "sg_fortigate_vm"
  description = "Allow management traffic to fortigate"
  vpc_id = aws_vpc.spoke-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_from]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.access_from]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.access_from]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.spokevpc_prod_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}



/*
# Add the default route to the internal routing table.
resource "aws_route" "default-inside" {
  route_table_id            = aws_route_table.rt-inside.id
  destination_cidr_block    = "0.0.0.0/0"
  network_interface_id      = aws_network_interface.trust-a.id
}

*/

# Define the internal VPC route table
resource "aws_route_table" "rt-inside" {
  vpc_id = aws_vpc.spoke-vpc.id

  tags = {
    Name = "rt-inside"
  }
}



# Assign the route table to the private subnet
resource "aws_route_table_association" "rt-inside" {
  for_each = aws_subnet.prod-ec2
  subnet_id = each.value.id
  route_table_id = aws_route_table.rt-inside.id
}



# Allow temporary management through SSH to test VMs
resource "aws_route" "tmp-mng-inside" {
  route_table_id            = aws_route_table.rt-inside.id
  destination_cidr_block    = var.access_from
  gateway_id                = aws_internet_gateway.igw-spoke.id
}

# Define the temporary internet gateway to access test VMs
resource "aws_internet_gateway" "igw-spoke" {
  vpc_id = aws_vpc.spoke-vpc.id
}


# Define the external VPC route table
resource "aws_route_table" "rt-outside" {
  vpc_id = aws_vpc.spoke-vpc.id

  tags = {
    Name = "rt-outside"
  }
}


# Assign the route table to the outside subnets
resource "aws_route_table_association" "rt-outside" {
  for_each = aws_subnet.outside-fw
  subnet_id = each.value.id
  route_table_id = aws_route_table.rt-outside.id
}

# Assign the route table to the mng subnets
resource "aws_route_table_association" "rt-mng" {
  for_each = aws_subnet.mng-fw
  subnet_id = each.value.id
  route_table_id = aws_route_table.rt-outside.id
}


# Add the default route pointing to IGW to the external routing table.
resource "aws_route" "default-outside" {
  route_table_id            = aws_route_table.rt-outside.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw-spoke.id
}