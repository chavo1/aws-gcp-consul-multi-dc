variable "vpn_ip_address" {
  description = "GCP External IP address - Reserved static address"
}

variable "vpn_bgp_asn" {
  description = "BPG Autonomous System Number (ASN) of the customer gateway for a dynamically routed VPN connection."
  default     = "65000"
}

variable "zone" {
  description = "availability zone to use."
}

variable "preshared_key" {
  description = "preshared key used for VPNtunnels"
}

variable "gcp_cidr" {
  description = "remote GCP subnet"
}

variable "name_vpn" {
  description = "The name of the VPC."
}