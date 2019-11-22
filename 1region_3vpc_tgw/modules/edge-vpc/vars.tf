variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}

variable "vpc-name" {}
variable "vpc_cidr" {}

variable "av_zone_1" {}
variable "av_zone_2" {}

variable "public_nw_name_az1" {}
variable "private_nw_name_az1" {}

variable "public_nw_name_az2" {}
variable "private_nw_name_az2" {}

variable "public_subnet_cidr_az1" {}
variable "private_subnet_cidr_az1" {}

variable "public_subnet_cidr_az2" {}
variable "private_subnet_cidr_az2" {}

variable "tenancy" {
  default = "default"
}

variable "ami_id" {}
variable "key_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_access_from" {}