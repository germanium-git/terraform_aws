provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.vpn_gw_name
  }
}

resource "aws_dx_gateway" "dxgw" {
  name            = var.dx_gw_name
  amazon_side_asn = var.amazon_asn
}

resource "aws_dx_private_virtual_interface" "vif_prim" {
  connection_id    = var.connection_id_prim
  name             = var.vif_prim_name
  vlan             = var.vlan_prim
  address_family   = "ipv4"
  bgp_asn          = var.bgp_peer
  dx_gateway_id    = aws_dx_gateway.dxgw.id
  amazon_address   = var.primary_aws_ip
  customer_address = var.primary_equinix_ip
  bgp_auth_key     = var.bgp_auth_key
}

resource "aws_dx_private_virtual_interface" "vif_sec" {
  connection_id    = var.connection_id_sec
  name             = var.vif_sec_name
  vlan             = var.vlan_sec
  address_family   = "ipv4"
  bgp_asn          = var.bgp_peer
  dx_gateway_id    = aws_dx_gateway.dxgw.id
  amazon_address   = var.secondary_aws_ip
  customer_address = var.secondary_equinix_ip
  bgp_auth_key     = var.bgp_auth_key
}

resource "aws_dx_gateway_association" "example" {
  dx_gateway_id         = aws_dx_gateway.dxgw.id
  associated_gateway_id = aws_vpn_gateway.vpn_gw.id
  allowed_prefixes      = var.advertised_prefixes
}

resource "aws_route" "route" {
  for_each                  = var.routes
  route_table_id            = var.rtable_id
  destination_cidr_block    = each.value
  gateway_id                = aws_vpn_gateway.vpn_gw.id
}
