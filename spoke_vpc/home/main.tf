# Create spoke VPC with testing VM & FortiGate-VM
module "spoke_vpc_ireland" {
  source                = "../modules/spoke_vpc"
  aws_region            = "eu-west-1"
  access_key            = var.access_key
  secret_key            = var.secret_key
  spokevpc_prod_cidr    = var.spokevpc_prod_cidr
  spokevpc_name         = "spoke_test"
  subnet_test           = var.subnet_test
  subnet_fw_outside     = var.subnet_fw_outside
  subnet_fw_inside      = var.subnet_fw_inside
  subnet_fw_hb          = var.subnet_fw_hb
  subnet_fw_mng         = var.subnet_fw_mng
  access_from           = var.mng_access_from
}

# Create test VM in zone A
module "test_vm_a" {
  source                = "../modules/spoke_ec2"
  aws_region            = "eu-west-1"
  access_key            = var.access_key
  secret_key            = var.secret_key
  av_zone               = "eu-west-1a"
  prod_subnet_id        = module.spoke_vpc_ireland.prod_subnet["test_azA_id"]
  prod_subnet_cidr      = module.spoke_vpc_ireland.prod_subnet["test_azA_cidr"]
  vm_name               = "vm-a"
  testvm_ami_id         = "ami-02df9ea15c1778c9c"
  key_id                = module.key.key_id
  prod_sec_group_id     = module.spoke_vpc_ireland.sg_prod_id
}

# Create test VM in zone B
module "test_vm_b" {
  source                = "../modules/spoke_ec2"
  aws_region            = "eu-west-1"
  access_key            = var.access_key
  secret_key            = var.secret_key
  av_zone               = "eu-west-1b"
  prod_subnet_id        = module.spoke_vpc_ireland.prod_subnet["test_azB_id"]
  prod_subnet_cidr      = module.spoke_vpc_ireland.prod_subnet["test_azB_cidr"]
  vm_name               = "vm-b"
  testvm_ami_id         = "ami-02df9ea15c1778c9c"
  key_id                = module.key.key_id
  prod_sec_group_id     = module.spoke_vpc_ireland.sg_prod_id
}

# Create test VM in zone C
module "test_vm_c" {
  source                = "../modules/spoke_ec2"
  aws_region            = "eu-west-1"
  access_key            = var.access_key
  secret_key            = var.secret_key
  av_zone               = "eu-west-1c"
  prod_subnet_id        = module.spoke_vpc_ireland.prod_subnet["test_azC_id"]
  prod_subnet_cidr      = module.spoke_vpc_ireland.prod_subnet["test_azC_cidr"]
  vm_name               = "vm-c"
  testvm_ami_id         = "ami-02df9ea15c1778c9c"
  key_id                = module.key.key_id
  prod_sec_group_id     = module.spoke_vpc_ireland.sg_prod_id
}


module "firewall-a" {
  source                = "../modules/spoke_fw"
  aws_region            = "eu-west-1"
  access_key            = var.access_key
  secret_key            = var.secret_key
  vpc_id                = module.spoke_vpc_ireland.vpc_id
  av_zone               = "eu-west-1a"
  vm_tag                = "FGFW-A"
  key_id                = module.key.key_id
  access_from           = var.mng_access_from
  subnet_hb_id          = module.spoke_vpc_ireland.fw_hb_subnet["fw_hb_azA_id"]
  subnet_hb_cidr        = module.spoke_vpc_ireland.fw_hb_subnet["fw_hb_azA_cidr"]
  subnet_inside_id      = module.spoke_vpc_ireland.fw_inside_subnet["fw_inside_azA_id"]
  subnet_inside_cidr    = module.spoke_vpc_ireland.fw_inside_subnet["fw_inside_azA_cidr"]
  subnet_outside_id     = module.spoke_vpc_ireland.fw_outside_subnet["fw_outside_azA_id"]
  subnet_outside_cidr   = module.spoke_vpc_ireland.fw_outside_subnet["fw_outside_azA_cidr"]
  subnet_mng_id         = module.spoke_vpc_ireland.fw_mng_subnet["fw_mng_azA_id"]
  subnet_mng_cidr       = module.spoke_vpc_ireland.fw_mng_subnet["fw_mng_azA_cidr"]
  spokevpc_prod_cidr    = var.spokevpc_prod_cidr
  fg_sgroup_id          = module.spoke_vpc_ireland.fg_sgroup_id
  iam_role              = "NextGenFirewallHA"
}

module "firewall-b" {
  source                = "../modules/spoke_fw"
  aws_region            = "eu-west-1"
  access_key            = var.access_key
  secret_key            = var.secret_key
  vpc_id                = module.spoke_vpc_ireland.vpc_id
  av_zone               = "eu-west-1b"
  vm_tag                = "FGFW-B"
  key_id                = module.key.key_id
  access_from           = var.mng_access_from
  subnet_hb_id          = module.spoke_vpc_ireland.fw_hb_subnet["fw_hb_azB_id"]
  subnet_hb_cidr        = module.spoke_vpc_ireland.fw_hb_subnet["fw_hb_azB_cidr"]
  subnet_inside_id      = module.spoke_vpc_ireland.fw_inside_subnet["fw_inside_azB_id"]
  subnet_inside_cidr    = module.spoke_vpc_ireland.fw_inside_subnet["fw_inside_azB_cidr"]
  subnet_outside_id     = module.spoke_vpc_ireland.fw_outside_subnet["fw_outside_azB_id"]
  subnet_outside_cidr   = module.spoke_vpc_ireland.fw_outside_subnet["fw_outside_azB_cidr"]
  subnet_mng_id         = module.spoke_vpc_ireland.fw_mng_subnet["fw_mng_azB_id"]
  subnet_mng_cidr       = module.spoke_vpc_ireland.fw_mng_subnet["fw_mng_azB_cidr"]
  spokevpc_prod_cidr    = var.spokevpc_prod_cidr
  fg_sgroup_id          = module.spoke_vpc_ireland.fg_sgroup_id
  iam_role              = "NextGenFirewallHA"
}


# Create SSH key
module "key" {
  source          = "../modules/key"
  aws_region      = "eu-west-1"
  access_key      = var.access_key
  secret_key      = var.secret_key
  key_path        = var.key_path
}