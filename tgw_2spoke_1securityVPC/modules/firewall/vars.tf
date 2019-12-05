variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}

variable "av_zone_a" {}

variable "ami_id" {}
variable "key_id" {}
variable "instance_type" {
  default = "t2.micro"
}

# It defines the source IP allowed to access outside interface
variable "ssh_access_from" {}

# It defines the source IP allowed to access management interface
variable "access_to_mng" {}

variable "untrust-subnet-a-id" {}
variable "mgmt-subnet-a-id" {}
variable "trust-subnet-a-id" {}
variable "security-vpc-id" {}

variable "mgmt-a-priv-ip" {
  type    = "list"
  default = ["192.168.1.10"]
}
variable "untrust-a-priv-ip" {
  default = "192.168.11.10"
}
variable "trust-a-priv-ip" {
  type    = "list"
  default = ["192.168.21.10"]
}


