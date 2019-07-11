module "cvpn_sofia" {
  source = "git@github.com:chavo1/client-vpn-aws-terraform"

  access_key                 = "${var.access_key}"
  secret_key                 = "${var.secret_key}"
  server_certificate_arn     = "${var.server_certificate_arn}"
  client_cidr_block          = "${var.client_cidr_block}"
  root_certificate_chain_arn = "${var.root_certificate_chain_arn}"
  vpc_subnet                 = "${module.vpc_virginia.subnet[0]}"
  region                     = "${var.region["virginia"]}"
  destination_cidr_block     = "${var.destination_cidr_block}"
  destination_subnet         = "${module.vpc_virginia.subnet[0]}"
}
