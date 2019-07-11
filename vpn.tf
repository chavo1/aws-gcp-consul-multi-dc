module "vpn_virginia" {
  source = "git@github.com:chavo1/aws-vpn-terraform"

  route_table_id = module.vpc_virginia.rtb[0]
  vpc_id         = module.vpc_virginia.vpc[0]
  zone           = var.zone
  vpn_bgp_asn    = var.vpn_bgp_asn
  preshared_key  = var.preshared_key
  gcp_cidr       = var.gcp_cidr
  name           = var.name_vpn
  vpn_ip_address = var.vpn_ip_address
}