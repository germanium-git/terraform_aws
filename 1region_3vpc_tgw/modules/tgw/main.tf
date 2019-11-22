provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create TGW
resource "aws_ec2_transit_gateway" "tgw_frankfurt" {
  description = "Central TGW in Frankfurt"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

# Create individual routing tables for each TGW attachment
resource "aws_ec2_transit_gateway_route_table" rt_tgw_az1 {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  tags = {
    Name = "rt_tgw_az1"
  }
}

resource "aws_ec2_transit_gateway_route_table" rt_tgw_az2 {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  tags = {
    Name = "rt_tgw_az2"
  }
}

resource "aws_ec2_transit_gateway_route_table" rt_tgw_az3 {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  tags = {
    Name = "rt_tgw_az3"
  }
}


# Attach VPC AZ1 to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_vpc_az1" {
  subnet_ids = [
    var.subnet_az1_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  vpc_id = var.vpc_az1_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "to vpc AZ1"
  }
}


# Attach VPC AZ2 to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_vpc_az2" {
  subnet_ids         = [var.subnet_az2_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  vpc_id             = var.vpc_az2_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "to vpc AZ2"
  }
}


# Attach VPC AZ3 to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_vpc_az3" {
  subnet_ids         = [var.subnet_az3_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  vpc_id             = var.vpc_az3_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "to vpc AZ3"
  }
}


# Associate RTs with attachments
resource "aws_ec2_transit_gateway_route_table_association" rt_association_az1 {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_az1.id
}

# Add routes to respective TGW routing tables
resource "aws_ec2_transit_gateway_route" "vpc-az1" {
  destination_cidr_block         = "10.1.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_az1.id
}

resource "aws_ec2_transit_gateway_route_table_association" rt_association_az2 {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_az2.id
}

resource "aws_ec2_transit_gateway_route" "vpc-az2" {
  destination_cidr_block         = "10.2.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_az2.id
}

resource "aws_ec2_transit_gateway_route_table_association" rt_association_az3 {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_az3.id
}

resource "aws_ec2_transit_gateway_route" "vpc-az3" {
  destination_cidr_block         = "10.3.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_tgw_az3.id
}

# It allows the route tables in VPCs to be updated once attachments are created
resource "null_resource" "dependency_setter" {
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az1,
    aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az2,
    aws_ec2_transit_gateway_vpc_attachment.attach_vpc_az3
  ]
}
