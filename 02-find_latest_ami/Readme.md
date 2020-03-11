# Find the latest AMI
This terraform template doesn't deploy anything but only demonstrates comfortable way of gathering information about the AMIs from a specific region.


## Output
```shell
D:\terraform_aws\02-find_latest_ami>terraform apply
data.aws_ami.latest_ubuntu_16: Refreshing state...
data.aws_ami.latest_ecs: Refreshing state...
data.aws_ami.latest_fortigate_byol: Refreshing state...
data.aws_ami.latest_centos: Refreshing state...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

aws_ecs_image_id = ami-067a0bc8aa37e5843
centos_image_id = ami-067a0bc8aa37e5843
fortigate_image_id = ami-0b32558715c9613fd
ubuntu_16_image_id = ami-03d8059563982d7b0

```

## Caveat

```shell
data "aws_ami" "latest_fortigate_byol" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
      name   = "name"
      values = ["FortiGate-VM64-AWS *"]
  }
}
```

It finds the AMI with the latest release data, for instance ami-0b32558715c9613fd (result from 2020-02-19) which is the FortiGate-VM64-AWS build0335 (6.0.9) released 2020-01-23.
However, the filter used in the template doesn't find the latest version which is FortiGate-VM64-AWS build1066 (6.2.3) with ami-0bde30b21653b5903 that was released on 2019-12-20.


