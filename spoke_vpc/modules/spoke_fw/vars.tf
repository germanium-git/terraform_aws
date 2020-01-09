variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {}

variable "key_id" {}
variable "av_zone" {}

variable "vpc_id" {}

# FortiGate-Vm instance type
variable "fw_instance_type" {
  default = "t3.xlarge"
}

variable "vm_tag" {}

variable "fgvm_ami_id" {
  default = "ami-06eaa811c36add9d8"
}

variable "access_from" {}
variable "spokevpc_prod_cidr" {}

variable "subnet_outside_id" {}
variable "subnet_outside_cidr" {}
variable "subnet_hb_id" {}
variable "subnet_hb_cidr" {}
variable "subnet_inside_id" {}
variable "subnet_inside_cidr" {}
variable "subnet_mng_id" {}
variable "subnet_mng_cidr" {}

variable "fg_sgroup_id" {}

variable "iam_role" {}
