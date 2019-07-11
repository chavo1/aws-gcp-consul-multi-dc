module "vpc_virginia" {
  source = "git@github.com:chavo1/aws-vpc-terraform"

  region               = "${var.region["virginia"]}"
  vpc_name             = "${var.vpc_name[0]}"
  subnetCIDRblock      = "${var.subnetCIDRblock[0]}"
  ingressCIDRblock     = "${var.ingressCIDRblock}"
  instanceTenancy      = "${var.instanceTenancy}"
  dnsSupport           = "${var.dnsSupport}"
  vpcCIDRblock         = "${var.vpcCIDRblock[0]}"
  destinationCIDRblock = "${var.destinationCIDRblock}"
  availabilityZone     = "${var.availabilityZone[0]}"
  mapPublicIP          = "${var.mapPublicIP}"

}