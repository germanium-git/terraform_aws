variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}

variable "vpc_id" {}

variable "connection_id_prim" {}
variable "connection_id_sec" {}

variable "rtable_id" {}

variable "bgp_auth_key" {}

variable "vpn_gw_name" {}
variable "dx_gw_name" {}

variable "amazon_asn" {}
variable "vlan_prim" {}
variable "vlan_sec" {}
variable "bgp_peer" {}
variable "primary_aws_ip" {}
variable "primary_equinix_ip" {}
variable "secondary_aws_ip" {}
variable "secondary_equinix_ip" {}
variable "vif_prim_name" {}
variable "vif_sec_name" {}

variable "advertised_prefixes" {
  type = list(string)
}

variable "routes" {
  type = map(string)
}