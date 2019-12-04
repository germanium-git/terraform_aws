variable "access_key" {}
variable "secret_key" {}

variable "aws_region" {}

variable "tenancy" {
  default = "default"
}

variable "spokevpc_name" {}
variable "spokevpc_cidr" {}
variable "spoke_subnet_name" {}
variable "spoke_subnet_cidr" {}
variable "av_zone" {}

variable "dependencies_tgw_attachments" {
  type    = "list"
  default = []
}

variable "dependencies_rtb_spoke" {
  type    = "list"
  default = []
}

variable "dependencies_rtb_security" {
  type    = "list"
  default = []
}


# Id of the TGW created in the module security_vpc
variable "tgw-id" {}

# Name of the attachment i.e. attach-spoke1, attach-spoke2
variable "attach-name" {}

# Id of the TGW security RT created in the module security_vpc
variable "rtb-security-id" {}

# Id of the TGW spoke RT created in the module security_vpc
variable "rtb-spoke-id" {}


variable "spoke_rt_name" {}

variable "ssh_access_from" {}
