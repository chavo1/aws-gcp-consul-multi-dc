module "consul_virginia" {
  source = "git@github.com:chavo1/aws-consul-terraform-multi-region"

  consul_version        = "${var.ami_virginia[var.consul_version]}"
  access_key            = "${var.access_key}"
  secret_key            = "${var.secret_key}"
  region                = "${var.region["virginia"]}"
  instance_type         = "${var.instance_type}"
  key_name              = "${var.key_name}"
  subnet                = "${module.vpc_virginia.subnet[0]}"
  server_count          = "${var.server_count["virginia"]}"
  dc_net                = "${var.dc_net["dc1"]}"
  dcname                = "${var.dcname["dc1"]}"
  vpc_security_group_id = "${module.vpc_virginia.aws_security_group[0]}"
}

output "public_dns_servers_virginia" {
  value = "${module.consul_virginia.public_dns_servers}"
}
