variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {}

variable "tenancy" {
  default = "default"
}

variable "vpc_name" {}
variable "vpc_cidr" {}
variable "vpc_rt_name" {}
variable "subnet_name" {}
variable "subnet_cidr" {}
variable "av_zone" {}


variable "mng_access_from" {
    type = map(string)
}
