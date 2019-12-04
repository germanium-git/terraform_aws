variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {}

variable "tgw-secvpc_cidr" {
  default = "192.168.0.0/16"
}

variable "tenancy" {
  default = "default"
}

variable "vpc_name" {
  default = "tgw-security"
}

variable "mng_subnet_a_name" {
  default = "sn-sec-mgmtA"
}

variable "mng_subnet_a_cidr" {
  default = "192.168.1.0/24"
}

variable "untrust_subnet_a_name" {
  default = "sn-sec-untrustA"
}

variable "untrust_subnet_a_cidr" {
  default = "192.168.11.0/24"
}

variable "trust_subnet_a_name" {
  default = "sn-sec-trustA"
}

variable "trust_subnet_a_cidr" {
  default = "192.168.21.0/24"
}

variable "tgwattach_a_name" {
  default = "sn-sec-tgwattachA"
}

variable "tgwattach_a_cidr" {
  default = "192.168.31.0/24"
}

variable "mng_subnet_b_name" {
  default = "sn-sec-mgmtB"
}

variable "mng_subnet_b_cidr" {
  default = "192.168.2.0/24"
}

variable "untrust_subnet_b_name" {
  default = "sn-sec-untrustB"
}

variable "untrust_subnet_b_cidr" {
  default = "192.168.12.0/24"
}

variable "trust_subnet_b_name" {
  default = "sn-sec-trustB"
}

variable "trust_subnet_b_cidr" {
  default = "192.168.22.0/24"
}

variable "tgwattach_b_name" {
  default = "sn-sec-tgwattachB"
}

variable "tgwattach_b_cidr" {
  default = "192.168.32.0/24"
}

variable "av_zone_a" {}
variable "av_zone_b" {}


variable "dependency_eth2_created" {}

variable "eth2-eni-id" {}