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
# From home
variable "ssh_access_from" {
  default = "185.230.173.4/32"
}
*/

# From Swe VPN
variable "ssh_access_from" {
  default = "193.15.240.60/32"
}