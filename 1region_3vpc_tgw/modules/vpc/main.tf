provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.name
  }
}


# Define subnet
resource "aws_subnet" "main" {
  cidr_block = var.subnet_cidr
  vpc_id     = var.vpc_id
  availability_zone = var.av_zone

  tags = {
    Name = var.name
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
}

# Define the route table
resource "aws_route_table" "private-rt" {
  depends_on = [null_resource.dependency_getter]
  vpc_id = var.vpc_id

  route {
    cidr_block = var.ssh_access_from
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.tgw_id
  }

}

# Assign the route table to the private subnet
resource "aws_route_table_association" "priv-rt_main" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.private-rt.id
}
