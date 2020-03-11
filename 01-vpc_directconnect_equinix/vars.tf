variable "access_key" {}
variable "secret_key" {}

variable "key_path" {
  description = "SSH Public Key path"
  default = "../key/id_rsa.pub"
}

/*
# From Swe VPN "193.15.240.60/32"
# From Fin VPN "131.207.242.5/32"
*/

/*
variable "mng_access_from" {
  default = "193.15.240.60/32"
}
*/

# Routes pointing to IGW
variable "mng_access_from" {
  description = "Backdoor MNG access"
  type = map(string)

  default = {
    swe_vpn = "193.15.240.60/32"
    fin_vpn = "131.207.242.5/32"
    }
}

variable "secgr_rules" {
  description = "Ingress SG rules"
  type = map(list(string))

  # Structure
  # direction, from_port, to_port, protocol, cidr_blocks
  default = {
    vpc     = ["ingress", -1, -1, "icmp", "10.0.0.0/8"]
    swe_vpn = ["ingress", 0, 22, "tcp", "193.15.240.60/32"]
    fin_vpn = ["ingress", 0, 22, "tcp", "131.207.242.5/32"]
    }
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "routes" {
  description = "Routes to Direct Connect"
  type = map(string)

  default = {
    azure   = "10.0.0.0/16"
    loopback = "1.1.1.1/32"
    }
}
