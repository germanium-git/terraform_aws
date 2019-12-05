variable "access_key" {}
variable "secret_key" {}

variable "key_path" {
  description = "SSH Public Key path"
  default = "../../key/id_rsa.pub"
}

variable "aws_region" {
  default = "eu-central-1"
}

/*
# From home 185.230.173.4/32
# From work wo VPN 193.179.215.98/32
# From Fin VPN 131.207.242.5/32
*/

# From Swe VPN
variable "ssh_to_outside" {
  default = "193.15.240.60/32"
}

# From Fin VPN
variable "ssh_to_mng" {
  default = "131.207.242.5/32"
}

