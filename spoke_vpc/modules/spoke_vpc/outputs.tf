output "vpc_id" {
  value = aws_vpc.spoke-vpc.id
}

output "prod_subnet" {
  value = {
    test_azA_id   = aws_subnet.prod-ec2["test_azA"].id
    test_azA_cidr = aws_subnet.prod-ec2["test_azA"].cidr_block
    test_azB_id   = aws_subnet.prod-ec2["test_azB"].id
    test_azB_cidr = aws_subnet.prod-ec2["test_azB"].cidr_block
    test_azC_id   = aws_subnet.prod-ec2["test_azC"].id
    test_azC_cidr = aws_subnet.prod-ec2["test_azC"].cidr_block
  }
}

output "fw_outside_subnet" {
  value = {
    fw_outside_azA_id = aws_subnet.outside-fw["fw_outside_azA"].id
    fw_outside_azA_cidr = aws_subnet.outside-fw["fw_outside_azA"].cidr_block
    fw_outside_azB_id = aws_subnet.outside-fw["fw_outside_azB"].id
    fw_outside_azB_cidr = aws_subnet.outside-fw["fw_outside_azB"].cidr_block
  }
}

output "fw_inside_subnet" {
  value = {
    fw_inside_azA_id = aws_subnet.inside-fw["fw_inside_azA"].id
    fw_inside_azA_cidr = aws_subnet.inside-fw["fw_inside_azA"].cidr_block
    fw_inside_azB_id = aws_subnet.inside-fw["fw_inside_azB"].id
    fw_inside_azB_cidr = aws_subnet.inside-fw["fw_inside_azB"].cidr_block
  }
}

output "fw_hb_subnet" {
  value = {
    fw_hb_azA_id = aws_subnet.hb-fw["fw_hb_azA"].id
    fw_hb_azA_cidr = aws_subnet.hb-fw["fw_hb_azA"].cidr_block
    fw_hb_azB_id = aws_subnet.hb-fw["fw_hb_azB"].id
    fw_hb_azB_cidr = aws_subnet.hb-fw["fw_hb_azB"].cidr_block
  }
}

output "fw_mng_subnet" {
  value = {
    fw_mng_azA_id = aws_subnet.mng-fw["fw_mng_azA"].id
    fw_mng_azA_cidr = aws_subnet.mng-fw["fw_mng_azA"].cidr_block
    fw_mng_azB_id = aws_subnet.mng-fw["fw_mng_azB"].id
    fw_mng_azB_cidr = aws_subnet.mng-fw["fw_mng_azB"].cidr_block
  }
}


output "sg_prod_id" {
  value = aws_security_group.sgroup_prod.id
}

output "sg_mng_id" {
  value = aws_security_group.sgroup_mng.id
}

output "fg_sgroup_id" {
  value = aws_security_group.fg-sgroup.id
}

