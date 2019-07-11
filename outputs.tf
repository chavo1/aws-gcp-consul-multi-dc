output "client_vpn_endpoint" {
  depends_on = ["module.vpc_virginia.vpc"]

  value = "${module.cvpn_sofia.client_vpn_endpoint}"
}

output "client_vpn_network_association" {
  value = "${module.cvpn_sofia.client_vpn_network_association}"
}

output "subnet_id_dc1" {
  value = "${module.consul_virginia.subnet_id}"
}

output "instance_type_dc1" {
  value = "${module.consul_virginia.instance_type}"
}

output "availability_zone_dc1" {
  value = "${module.consul_virginia.availability_zone}"
}

output "key_name_dc1" {
  value = "${module.consul_virginia.key_name}"
}

output "aws_iam_instance_profile_dc1" {
  value = "${module.consul_virginia.aws_iam_instance_profile}"
}

output "ami_id_dc1" {
  value = "${module.consul_virginia.ami_id}"
}

output "private_ip_dc1" {
  value = "${module.consul_virginia.private_ip}"
}

output "vpc_virginia_id" {
  value = "${module.vpc_virginia.vpc}"
}
output "aws_security_group_virginia" {
  value = "${module.vpc_virginia.aws_security_group}"
}

output "subnet_virginia" {
  value = "${module.vpc_virginia.subnet}"
}

output "rtb_virginia" {
  value = "${module.vpc_virginia.rtb}"
}
