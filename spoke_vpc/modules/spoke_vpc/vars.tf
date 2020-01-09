variable "access_key" {}
variable "secret_key" {}

variable "key_path" {
  description = "SSH Public Key path"
  default = "../../key/id_rsa.pub"
}

variable "aws_region" {}

variable "tenancy" {
  default = "default"
}

variable "spokevpc_name" {}
variable "spokevpc_prod_cidr" {}

variable "subnet_test" {}

variable "subnet_fw_outside" {}
variable "subnet_fw_inside" {}
variable "subnet_fw_hb" {}
variable "subnet_fw_mng" {}

variable "access_from" {}


