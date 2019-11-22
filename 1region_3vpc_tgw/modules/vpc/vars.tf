variable "vpc_cidr" {}

variable "aws_region" {}

variable "tenancy" {
  default = "dedicated"
}
variable "vpc_id" {}
variable "subnet_cidr" {}
variable "access_key" {}
variable "secret_key" {}

variable "ssh_access_from" {}

variable "av_zone" {}
variable "name" {}

variable "tgw_id" {}

variable "dependencies" {
  type    = "list"
  default = []
}