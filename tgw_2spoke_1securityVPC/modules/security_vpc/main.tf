provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define tgw-security VPC
resource "aws_vpc" "tgw-security" {
  cidr_block       = var.tgw-secvpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.vpc_name
  }
}

# Define management subnet az A
resource "aws_subnet" "mgmt-a" {
  cidr_block = var.mng_subnet_a_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_a

  tags = {
    Name = var.mng_subnet_a_name
  }
}

# Define management subnet az B
resource "aws_subnet" "mgmt-b" {
  cidr_block = var.mng_subnet_b_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_b

  tags = {
    Name = var.mng_subnet_b_name
  }
}

# Define untrust subnet az A
resource "aws_subnet" "untrust-a" {
  cidr_block = var.untrust_subnet_a_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_a

  tags = {
    Name = var.untrust_subnet_a_name
  }
}

# Define untrust subnet az B
resource "aws_subnet" "untrust-b" {
  cidr_block = var.untrust_subnet_b_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_b

  tags = {
    Name = var.untrust_subnet_b_name
  }
}

# Define trust subnet az A
resource "aws_subnet" "trust-a" {
  cidr_block = var.trust_subnet_a_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_a

  tags = {
    Name = var.trust_subnet_a_name
  }
}

# Define trust subnet az B
resource "aws_subnet" "trust-b" {
  cidr_block = var.trust_subnet_b_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_b

  tags = {
    Name = var.trust_subnet_b_name
  }
}

# Define attach subnet az A
resource "aws_subnet" "attach-a" {
  cidr_block = var.tgwattach_a_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_a

  tags = {
    Name = var.tgwattach_a_name
  }
}

# Define attach subnet az B
resource "aws_subnet" "attach-b" {
  cidr_block = var.tgwattach_b_cidr
  vpc_id     = aws_vpc.tgw-security.id
  availability_zone = var.av_zone_b

  tags = {
    Name = var.tgwattach_b_name
  }
}

# Create TGW
resource "aws_ec2_transit_gateway" "tgw" {
  description = "TGW for Security Service insertion"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support = "enable"
  vpn_ecmp_support = "enable"
  auto_accept_shared_attachments = "disable"

  tags = {
    Name = "tgw-security"
  }
}

# Dependency setter when TGW is created
# Unused so far ...
resource "null_resource" "dep_set_tgw_created" {
  depends_on = [
    aws_ec2_transit_gateway.tgw,
  ]
}

# Create Transit Gateway Route Table - Security
resource "aws_ec2_transit_gateway_route_table" rt_tgw_security {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "rtb-security"
  }
}

# Create Transit Gateway Route Table - Spoke
resource "aws_ec2_transit_gateway_route_table" rt_tgw_spoke {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "rtb-spoke"
  }
}

# Attach security VPC to TGW via *tgwattach* networks
resource "aws_ec2_transit_gateway_vpc_attachment" "tgwattach" {
  subnet_ids = [aws_subnet.attach-a.id, aws_subnet.attach-b.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = aws_vpc.tgw-security.id
  dns_support = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "attach-sec"
  }
}

# It allows the route tables in spoke VPCs to be updated once the attachment is created
resource "null_resource" "dep_set_tgw_attachments" {
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.tgwattach,
  ]
}

# It allows the spoke rt to be associated in spoke VPCs once the RT is created
resource "null_resource" "dep_set_rttgw_spoke" {
  depends_on = [
    aws_ec2_transit_gateway_route_table.rt_tgw_spoke,
  ]
}

# It allows the route tables in spoke VPCs to be updated once the attachment is created
resource "null_resource" "dep_set_rttgw_security" {
  depends_on = [
    aws_ec2_transit_gateway_route_table.rt_tgw_security,
  ]
}

# Propagate the rtb-spoke to tgwattach
resource "aws_ec2_transit_gateway_route_table_propagation" "example" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwattach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_spoke.id
}

# Add default route to TGW RT
resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwattach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_spoke.id
}

# Associate the rtb-security table with tgwattach
resource "aws_ec2_transit_gateway_route_table_association" rt_association_security {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwattach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_security.id
}

# Define the internet gateway
resource "aws_internet_gateway" "igw-security" {
  vpc_id = aws_vpc.tgw-security.id
}

# Define the route table to Internet
resource "aws_route_table" "rt-outbound" {
  vpc_id = aws_vpc.tgw-security.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-security.id
  }

  tags = {
    Name = "rt-outbound"
  }
}

# Assign the route table rt-outbound to the untrust subnet
resource "aws_route_table_association" "rt-spoke-assoc-untrust-a" {
  subnet_id = aws_subnet.untrust-a.id
  route_table_id = aws_route_table.rt-outbound.id
}

# Assign the route table rt-outbound to the untrust subnet
resource "aws_route_table_association" "rt-spoke-assoc-untrust-b" {
  subnet_id = aws_subnet.untrust-b.id
  route_table_id = aws_route_table.rt-outbound.id
}

# Assign the route table rt-outbound to the management subnet
resource "aws_route_table_association" "rt-spoke-assoc-mng-a" {
  subnet_id = aws_subnet.mgmt-a.id
  route_table_id = aws_route_table.rt-outbound.id
}

# Assign the route table rt-outbound to the management subnet
resource "aws_route_table_association" "rt-spoke-assoc-mng-b" {
  subnet_id = aws_subnet.mgmt-b.id
  route_table_id = aws_route_table.rt-outbound.id
}

# Create the route table to TGW
resource "aws_route_table" "rt-to-tgw" {
  vpc_id = aws_vpc.tgw-security.id

  tags = {
    Name = "rt-toTGW"
  }
}

# Summary route to all remote VPC added to rt-toTGW table
resource "aws_route" "remote-vpcs" {
  route_table_id          = aws_route_table.rt-to-tgw.id
  destination_cidr_block  = "10.0.0.0/8"
  transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
  depends_on              = [aws_ec2_transit_gateway.tgw]
}

# Assign the route table rt-toTGW to the trust subnet
resource "aws_route_table_association" "rt-spoke-assoc-trust-a" {
  subnet_id = aws_subnet.trust-a.id
  route_table_id = aws_route_table.rt-to-tgw.id
}

# Assign the route table rt-toTGW to the trust subnet
resource "aws_route_table_association" "rt-spoke-assoc-trust-b" {
  subnet_id = aws_subnet.trust-b.id
  route_table_id = aws_route_table.rt-to-tgw.id
}

# Define the route table rt-fromTGW
resource "aws_route_table" "rt-from-tgw" {
  vpc_id = aws_vpc.tgw-security.id

  tags = {
    Name = "rt-fromTGW"
  }
}

# Assign the route table rt-toTGW to the attach-a subnet
resource "aws_route_table_association" "rt-from-tgw-attach-a" {
  subnet_id = aws_subnet.attach-a.id
  route_table_id = aws_route_table.rt-from-tgw.id
}

# Assign the route table rt-toTGW to the attach-b subnet
resource "aws_route_table_association" "rt-from-tgw-attach-b" {
  subnet_id = aws_subnet.attach-b.id
  route_table_id = aws_route_table.rt-from-tgw.id
}

# Wait until the eth2 of the FortiGateVM is created
resource "null_resource" "dep_eth2_created" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependency_eth2_created)}"
  }
}

# Add default route the rt-fromTGW
resource "aws_route" "default-from-tgw" {
  depends_on              = [null_resource.dep_eth2_created]
  network_interface_id    = var.eth2-eni-id
  route_table_id          = aws_route_table.rt-from-tgw.id
  destination_cidr_block  = "0.0.0.0/0"
}



