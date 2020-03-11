provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.vpc_name
  }
}

# Define spoke subnet
resource "aws_subnet" "subnet" {
  cidr_block = var.subnet_cidr
  vpc_id     = aws_vpc.vpc.id
  availability_zone = var.av_zone

  tags = {
    Name = var.subnet_name
  }
}


# Define the route table
resource "aws_route_table" "rt-vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_rt_name
  }
}


# Assign the route table to the private subnet
resource "aws_route_table_association" "rt-spoke-assoc" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt-vpc.id
}


# Define the temporary internet gateway to access test VMs
resource "aws_internet_gateway" "igw-spoke" {
  vpc_id = aws_vpc.vpc.id
}


# Add the route for remote management to the Internet
resource "aws_route" "remote_access" {
  for_each = var.mng_access_from
  route_table_id            = aws_route_table.rt-vpc.id
  destination_cidr_block    = each.value
  gateway_id                = aws_internet_gateway.igw-spoke.id
}
