# Create spoke VPC 1
module "spoke_vpc-a" {
  source                        = "../modules/spoke_vpc"
  aws_region                    = "eu-central-1"
  access_key                    = var.access_key
  secret_key                    = var.secret_key
  spokevpc_cidr                 = "10.1.0.0/16"
  spokevpc_name                 = "tgw-spoke1"
  spoke_subnet_name             = "sn-spoke1-azA"
  spoke_subnet_cidr             = "10.1.1.0/24"
  av_zone                       = "eu-central-1a"
  dependencies_tgw_attachments  = [module.security_vpc.spoke_attached]
  dependencies_rtb_spoke        = [module.security_vpc.rt_spoke_created]
  # The name of the attachment to TGW
  attach-name                   = "attach-spoke1"
  spoke_rt_name                 = "rt-spoke1"
  tgw-id                        = module.security_vpc.tgw_id
  rtb-security-id               = module.security_vpc.rtb-security-id
  rtb-spoke-id                  = module.security_vpc.rtb-spoke-id
  ssh_access_from               = var.ssh_to_outside
}

# Create spoke VPC 2
module "spoke_vpc-b" {
  source                        = "../modules/spoke_vpc"
  aws_region                    = "eu-central-1"
  access_key                    = var.access_key
  secret_key                    = var.secret_key
  spokevpc_cidr                 = "10.2.0.0/16"
  spokevpc_name                 = "tgw-spoke2"
  spoke_subnet_name             = "sn-spoke2-azB"
  spoke_subnet_cidr             = "10.2.1.0/24"
  av_zone                       = "eu-central-1b"
  dependencies_tgw_attachments  = [module.security_vpc.spoke_attached]
  dependencies_rtb_spoke        = [module.security_vpc.rt_spoke_created]
  # The name of the attachment to TGW
  attach-name                   = "attach-spoke2"
  spoke_rt_name                 = "rt-spoke2"
  tgw-id                        = module.security_vpc.tgw_id
  rtb-security-id               = module.security_vpc.rtb-security-id
  rtb-spoke-id                  = module.security_vpc.rtb-spoke-id
  ssh_access_from               = var.ssh_to_outside
}

# Create security VPC
module "security_vpc" {
  source                  = "../modules/security_vpc"
  aws_region              = "eu-central-1"
  access_key              = var.access_key
  secret_key              = var.secret_key
  av_zone_a               = "eu-central-1a"
  av_zone_b               = "eu-central-1b"
  dependency_eth2_created = [module.firewall.eth2_created]
  eth2-eni-id             = module.firewall.eth2-eni-id
}

# Create FortiGateVM
module "firewall" {
  source              = "../modules/firewall"
  aws_region          = "eu-central-1"
  access_key          = var.access_key
  secret_key          = var.secret_key
  av_zone_a           = "eu-central-1a"
  mgmt-subnet-a-id    = module.security_vpc.mgmt-a-subnet-id
  trust-subnet-a-id   = module.security_vpc.trust-a-subnet-id
  untrust-subnet-a-id = module.security_vpc.untrust-a-subnet-id
  security-vpc-id     = module.security_vpc.security-vpc-id
  ssh_access_from     = var.ssh_to_outside
  instance_type       = "t2.small"
  ami_id              = "ami-01ccce1a224948c6f"
  key_id              = module.key.key_id
  access_to_mng       = var.ssh_to_mng
}

# Create SSH key
module "key" {
  source          = "../modules/key"
  aws_region      = "eu-central-1"
  access_key      = var.access_key
  secret_key      = var.secret_key
  key_path        = var.key_path
}

# Create test VM in spoke VPC A
module "test_vm-a" {
  source          = "../modules/test_vm"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1a"
  subnet_id       = module.spoke_vpc-a.spoke-subnet-id
  subnet_cidr     = module.spoke_vpc-a.sppke-subnet-cidr
  vpc_id          = module.spoke_vpc-a.spoke-vpc-id
  ssh_access_from = var.ssh_to_outside
  instance_type   = "t2.micro"
  ami_id          = "ami-0cc0a36f626a4fdf5"
  key_id          = module.key.key_id
  access_key      = var.access_key
  secret_key      = var.secret_key
  vm_name         = "test VM A"
}

# Create test VM in spoke VPC B
module "test_vm-b" {
  source          = "../modules/test_vm"
  aws_region      = "eu-central-1"
  av_zone         = "eu-central-1b"
  subnet_id       = module.spoke_vpc-b.spoke-subnet-id
  subnet_cidr     = module.spoke_vpc-b.sppke-subnet-cidr
  vpc_id          = module.spoke_vpc-b.spoke-vpc-id
  ssh_access_from = var.ssh_to_outside
  instance_type   = "t2.micro"
  ami_id          = "ami-0cc0a36f626a4fdf5"
  key_id          = module.key.key_id
  access_key      = var.access_key
  secret_key      = var.secret_key
  vm_name         = "test VM B"
}
