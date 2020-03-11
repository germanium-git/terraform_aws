provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

data "aws_ami" "latest_ubuntu_16" {
    most_recent = true
    owners = ["099720109477"] # Canonical

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}


data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = ["591542846629"] # AWS

  filter {
      name   = "name"
      values = ["*amazon-ecs-optimized"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

data "aws_ami" "latest_centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}


data "aws_ami" "latest_fortigate_byol" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
      name   = "name"
      values = ["FortiGate-VM64-AWS *"]
  }
}


output "ubuntu_16_image_id" {
    value = data.aws_ami.latest_ubuntu_16.id
}

output "aws_ecs_image_id" {
    value = data.aws_ami.latest_ecs.id
}

output "centos_image_id" {
    value = data.aws_ami.latest_ecs.id
}

output "fortigate_image_id" {
    value = data.aws_ami.latest_fortigate_byol.id
}