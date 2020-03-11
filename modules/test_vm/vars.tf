variable "aws_region" {}

variable "ami_id" {}
variable "key_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {}
variable "subnet_cidr" {}
variable "av_zone" {}
variable "vpc_id" {}
variable "sg_rules" {
  type = map(list(string))
}

variable "access_key" {}
variable "secret_key" {}

variable "vm_name" {}