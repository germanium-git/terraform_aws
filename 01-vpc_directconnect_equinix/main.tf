# Create VPC
module "vpc-a" {
  source                = "../modules/vpc"
  aws_region            = var.aws_region
  access_key            = var.access_key
  secret_key            = var.secret_key
  vpc_cidr              = "10.1.0.0/16"
  vpc_name              = "vpc-a"
  subnet_name           = "test-01"
  subnet_cidr           = "10.1.1.0/24"
  av_zone               = "eu-central-1a"
  vpc_rt_name           = "eqx-poc-rt"
  mng_access_from       = var.mng_access_from
}

# Create SSH key
module "key" {
  source                = "../modules/key"
  aws_region            = var.aws_region
  access_key            = var.access_key
  secret_key            = var.secret_key
  key_path              = var.key_path
}

# Create DX with DXGW and VGW
module "dx-frankfurt" {
  source                = "../modules/direct_connect_vgw"
  aws_region            = var.aws_region
  access_key            = var.access_key
  secret_key            = var.secret_key
  vpc_id                = module.vpc-a.vpc-id
  connection_id_prim    = "dxcon-ffossz04"
  connection_id_sec     = "dxcon-fh1j4q9f"
  rtable_id             = module.vpc-a.rtable-id
  bgp_auth_key          = "AWS123"
  vpn_gw_name           = "VGW-EQX"
  dx_gw_name            = "EQX-POC-GW1"
  amazon_asn            = "65200"
  vlan_prim             = 343
  vlan_sec              = 303
  bgp_peer              = 64521
  primary_aws_ip        = "10.255.0.10/30"
  primary_equinix_ip    = "10.255.0.9/30"
  secondary_aws_ip      = "10.255.0.14/30"
  secondary_equinix_ip  = "10.255.0.13/30"
  vif_prim_name         = "VIF-Eqx-Frankfurt-prim"
  vif_sec_name          = "VIF-Eqx-Frankfurt-sec"
  advertised_prefixes   = ["10.1.0.0/16",]
  routes                = var.routes
}

# Create test VM-A
module "test_vm-a" {
  source                = "../modules/test_vm"
  aws_region            = var.aws_region
  av_zone               = "eu-central-1a"
  subnet_id             = module.vpc-a.subnet-id
  subnet_cidr           = "10.1.1.0/24"
  vpc_id                = module.vpc-a.vpc-id
  sg_rules              = var.secgr_rules
  instance_type         = "t3a.micro"
  ami_id                = "ami-0cc0a36f626a4fdf5"
  key_id                = module.key.key_id
  access_key            = var.access_key
  secret_key            = var.secret_key
  vm_name               = "test_VM-A"
}





