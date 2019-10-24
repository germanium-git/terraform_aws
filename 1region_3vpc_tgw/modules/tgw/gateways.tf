provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create TGW
resource "aws_ec2_transit_gateway" "tgw_frankfurt" {
  description = "Central TGW in Frankfurt"
}


# Attach VPC AZ1 to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_vpc_az1" {
  subnet_ids         = [var.subnet_az1_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  vpc_id             = var.vpc_az1_id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

# Attach VPC AZ2 to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_vpc_az2" {
  subnet_ids         = [var.subnet_az2_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  vpc_id             = var.vpc_az2_id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

# Attach VPC AZ3 to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_vpc_az3" {
  subnet_ids         = [var.subnet_az3_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_frankfurt.id
  vpc_id             = var.vpc_az3_id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

