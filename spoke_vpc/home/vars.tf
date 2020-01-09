variable "access_key" {}
variable "secret_key" {}

variable "key_path" {
  description = "SSH Public Key path"
  default = "../../key/id_rsa.pub"
}

variable "mng_access_from" {
  default = "193.15.240.60/32"
}

/*
# From Swe VPN "193.15.240.60/32"
# From Fin VPN "131.207.242.5/32"
*/

variable "spokevpc_prod_cidr" {
  default = "10.3.0.0/16"
}

variable "subnet_test" {
  description = "Production networks for ec2"
  type = map(list(string))

  default = {
    test_azA = ["10.3.10.0/24", "eu-west-1a"]
    test_azB = ["10.3.11.0/24", "eu-west-1b"]
    test_azC = ["10.3.12.0/24", "eu-west-1c"]
  }
}


variable "subnet_fw_outside" {
  description = "Firewall outside networks"
  type = map(list(string))

  default = {
    fw_outside_azA = ["10.3.0.0/24", "eu-west-1a"]
    fw_outside_azB = ["10.3.1.0/24", "eu-west-1b"]

  }
}

variable "subnet_fw_inside" {
  description = "Firewall inside networks"
  type = map(list(string))

  default = {
    fw_inside_azA = ["10.3.4.0/24", "eu-west-1a"]
    fw_inside_azB = ["10.3.5.0/24", "eu-west-1b"]

  }
}

variable "subnet_fw_hb" {
  description = "Firewall HB networks"
  type = map(list(string))

  default = {
    fw_hb_azA = ["10.3.2.0/24", "eu-west-1a"]
    fw_hb_azB = ["10.3.3.0/24", "eu-west-1b"]

  }
}

variable "subnet_fw_mng" {
  description = "Firewall management networks"
  type = map(list(string))

  default = {
    fw_mng_azA = ["10.3.6.0/24", "eu-west-1a"]
    fw_mng_azB = ["10.3.7.0/24", "eu-west-1b"]

  }
}