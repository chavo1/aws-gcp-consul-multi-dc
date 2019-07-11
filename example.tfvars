access_key = "< Your aws access key >"
secret_key = "< Your aws secret key >"
key_name   = "id_rsa"

server_count = {
  virginia = 1
  ohio     = 1
}

vpc_name = [
  "virginia",
  "ohio",
]
availabilityZone = [
  "us-east-1a",
  "us-east-2a",
]

subnetCIDRblock = [
  "172.31.16.0/22",
  "172.31.32.0/22",
]

vpcCIDRblock = [
  "172.31.16.0/20",
  "172.31.32.0/20",
]

consul_version = "1.5.1"

dcname = {
  dc1 = "sofia"
  dc2 = "varna"
}

ami_ohio = {
  "1.5.1" = "< Needed AMI >"
  "1.4.4" = "< Needed AMI >"
}

ami_virginia = {
  "1.5.1" = "< Needed AMI >"
  "1.4.4" = "< Needed AMI >"
}

accept_region              = "us-east-2"
server_certificate_arn     = "< server_certificate_arn from your ACM >"
root_certificate_chain_arn = "< root_certificate_arn from your ACM >"
client_cidr_block          = "191.168.0.0/22"
destination_cidr_block     = "172.31.32.0/22"

vpn_ip_address = "< GCP External IP address - Reserved static address >"
zone           = "< AWS availability zone >"
preshared_key  = "< a VPN tunels preshared_key >"
gcp_cidr       = "172.31.32.0/22"
name_vpn       = "< a name of the vpn>"