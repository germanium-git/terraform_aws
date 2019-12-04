provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define tgw-spoke VPC
resource "aws_vpc" "spoke-vpc" {
  cidr_block       = var.spokevpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.spoke_subnet_name
  }
}

# Define spoke subnet
resource "aws_subnet" "sn-spokex-azx" {
  cidr_block = var.spoke_subnet_cidr
  vpc_id     = aws_vpc.spoke-vpc.id
  availability_zone = var.av_zone

  tags = {
    Name = var.spoke_subnet_name
  }
}

# Wait until the attachement to security VPC is created ~ TGW is created in the module security_vpc
resource "null_resource" "dep_tgw_attachments_created" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies_tgw_attachments)}"
  }
}

# Attach spoke VPC to TGW via *tgwattach* networks
resource "aws_ec2_transit_gateway_vpc_attachment" "spokeattach" {
  depends_on = [null_resource.dep_tgw_attachments_created]
  subnet_ids = [aws_subnet.sn-spokex-azx.id,]
  transit_gateway_id = var.tgw-id
  vpc_id = aws_vpc.spoke-vpc.id
  dns_support = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = var.attach-name
  }
}

# Wait until the RT for security attachment is created in the module security_vpc
resource "null_resource" "dep_rtb-security_created" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies_rtb_security)}"
  }
}

# Wait until the RT for security attachment is created in the module security_vpc
resource "null_resource" "dep_rtb-spoke_created" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies_rtb_spoke)}"
  }
}

# Associate the rtb-spoke table created in module security_vpc with spoke attachment
resource "aws_ec2_transit_gateway_route_table_association" rt_association_spoke {
  depends_on = [null_resource.dep_rtb-spoke_created]
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.spokeattach.id
  transit_gateway_route_table_id = var.rtb-spoke-id
}

# Add VPC CIDR to the security tgw routing table
resource "aws_ec2_transit_gateway_route" "vpc_cidr" {
  destination_cidr_block         = var.spokevpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spokeattach.id
  transit_gateway_route_table_id = var.rtb-security-id
}

# Propagate the rtb-security to tgwattach
resource "aws_ec2_transit_gateway_route_table_propagation" "example" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spokeattach.id
  transit_gateway_route_table_id = var.rtb-security-id
}

# Define the route table
resource "aws_route_table" "rt-spoke" {
  depends_on = [null_resource.dep_tgw_attachments_created]
  vpc_id = aws_vpc.spoke-vpc.id

  tags = {
    Name = var.spoke_rt_name
  }
}

# Assign the route table to the private subnet
resource "aws_route_table_association" "rt-spoke-assoc" {
  subnet_id = aws_subnet.sn-spokex-azx.id
  route_table_id = aws_route_table.rt-spoke.id
}

# Add the default route to routing table. If the route was added as part of the routing table then the apply failed
resource "aws_route" "default" {
  route_table_id            = aws_route_table.rt-spoke.id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = var.tgw-id
  depends_on                = [null_resource.dep_tgw_attachments_created]
}

# Define the temporary internet gateway to access test VMs
resource "aws_internet_gateway" "igw-spoke" {
  vpc_id = aws_vpc.spoke-vpc.id
}

# Add the default route to routing table. If the route was added as part of the routing table then the apply failed
resource "aws_route" "remote_access" {
  route_table_id            = aws_route_table.rt-spoke.id
  destination_cidr_block    = var.ssh_access_from
  gateway_id                = aws_internet_gateway.igw-spoke.id
}
