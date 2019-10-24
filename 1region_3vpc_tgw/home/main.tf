module "key" {
  source          = "../modules/key"
  aws_region      = "eu-central-1"
  access_key      = var.access_key
  secret_key      = var.secret_key
  key_path        = var.key_path
}

# Create VPC and one subnet in AZ1 in Frankfurt
module "vpc_frankfurt_az1" {
  source          = "../modules/vpc"
  name            = "vpc_az1"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1a"
  vpc_cidr        = "10.1.0.0/16"
  tenancy         = "default"
  vpc_id          = module.vpc_frankfurt_az1.vpc_id
  subnet_cidr     = "10.1.1.0/24"
  access_key      = var.access_key
  secret_key      = var.secret_key
  ssh_access_from = var.ssh_access_from
  tgw_id          = module.tgw_frankfurt.tgw_id
}

# Create VPC and one subnet in AZ2 in Frankfurt
module "vpc_frankfurt_az2" {
  source          = "../modules/vpc"
  name            = "vpc_az2"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1b"
  vpc_cidr        = "10.2.0.0/16"
  tenancy         = "default"
  vpc_id          = module.vpc_frankfurt_az2.vpc_id
  subnet_cidr     = "10.2.1.0/24"
  access_key      = var.access_key
  secret_key      = var.secret_key
  ssh_access_from = var.ssh_access_from
  tgw_id          = module.tgw_frankfurt.tgw_id
}


# Create VPC and one subnet in AZ3 in Frankfurt
module "vpc_frankfurt_az3" {
  source          = "../modules/vpc"
  name            = "vpc_az3"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1c"
  vpc_cidr        = "10.3.0.0/16"
  tenancy         = "default"
  vpc_id          = module.vpc_frankfurt_az3.vpc_id
  subnet_cidr     = "10.3.1.0/24"
  access_key      = var.access_key
  secret_key      = var.secret_key
  ssh_access_from = var.ssh_access_from
  tgw_id          = module.tgw_frankfurt.tgw_id
}

# Create EC2 in Frankfurt in zone 1A
module "ec2_frankfurt_az1" {
  source          = "../modules/ec2"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1a"
  subnet_id       = module.vpc_frankfurt_az1.subnet_id
  subnet_cidr     = module.vpc_frankfurt_az1.subnet_cidr
  vpc_id          = module.vpc_frankfurt_az1.vpc_id
  ssh_access_from = var.ssh_access_from
  instance_type   = "t2.micro"
  ami_id          = "ami-0cc0a36f626a4fdf5"
  key_id          = module.key.key_id
  access_key      = var.access_key
  secret_key      = var.secret_key
}

# Create EC2 in Frankfurt in zone 1B
module "ec2_frankfurt_az2" {
  source          = "../modules/ec2"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1b"
  subnet_id       = module.vpc_frankfurt_az2.subnet_id
  subnet_cidr     = module.vpc_frankfurt_az2.subnet_cidr
  vpc_id          = module.vpc_frankfurt_az2.vpc_id
  ssh_access_from = var.ssh_access_from
  instance_type   = "t2.micro"
  ami_id          = "ami-0cc0a36f626a4fdf5"
  key_id          = module.key.key_id
  access_key      = var.access_key
  secret_key      = var.secret_key
}

# Create EC2 in Frankfurt in zone 1C
module "ec2_frankfurt_az3" {
  source          = "../modules/ec2"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1c"
  subnet_id       = module.vpc_frankfurt_az3.subnet_id
  subnet_cidr     = module.vpc_frankfurt_az3.subnet_cidr
  vpc_id          = module.vpc_frankfurt_az3.vpc_id
  ssh_access_from = var.ssh_access_from
  instance_type   = "t2.micro"
  ami_id          = "ami-0cc0a36f626a4fdf5"
  key_id          = module.key.key_id
  access_key      = var.access_key
  secret_key      = var.secret_key
}
# Create Transit Gateway
module "tgw_frankfurt" {
  source = "../modules/tgw"
  aws_region      = "eu-central-1"
  access_key      = var.access_key
  secret_key      = var.secret_key
  subnet_az1_id   = module.vpc_frankfurt_az1.subnet_id
  subnet_az2_id   = module.vpc_frankfurt_az2.subnet_id
  subnet_az3_id   = module.vpc_frankfurt_az3.subnet_id
  vpc_az1_id      = module.vpc_frankfurt_az1.vpc_id
  vpc_az2_id      = module.vpc_frankfurt_az2.vpc_id
  vpc_az3_id      = module.vpc_frankfurt_az3.vpc_id
}