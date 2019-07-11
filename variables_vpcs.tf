# variables.tf

variable "vpc_name" {
  type = "list"
}
variable "availabilityZone" {
  type = "list"
}

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = true
}

variable "dnsHostNames" {
  default = true
}

variable "vpcCIDRblock" {
  type = "list"
}

variable "subnetCIDRblock" {
  type = "list"
}

variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "mapPublicIP" {
  default = true
}

# end of variables.tf
