variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {}

variable "key_id" {}
variable "vm_name" {}
variable "av_zone" {}

variable "testvm_ami_id" {}

variable "testvm_instance_type" {
  default = "t2.micro"
}
variable "prod_subnet_id" {}
variable "prod_subnet_cidr" {}
variable "prod_sec_group_id" {}








