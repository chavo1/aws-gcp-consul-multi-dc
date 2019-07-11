terraform {
  required_version = "~> 0.12.0"
}

provider "google" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  zone        = "${var.region_zone}"
}

# remote state file for aws containing tunnel 1 and
# tunnel 2 aws vpn addresses needed for the gcp
# tunnel configuration
#---------------------------------------------
data "terraform_remote_state" "aws_data" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}

# Get the static ip address reserved on gcp console
# to be used for the gcp vpn gateway
data "google_compute_address" "vpn_gw_ip" {
  name = "vpn-gw-ip"
}

# Create VPC
#--------------------------------------
resource "google_compute_network" "vpc_demo" {
  name                    = "vpc-demo"
  auto_create_subnetworks = "false"
}

# Create Subnet
#--------------------------------------
resource "google_compute_subnetwork" "subnet_vm" {
  name          = "subnet-vm"
  ip_cidr_range = "172.31.32.0/22"
  network       = "${google_compute_network.vpc_demo.self_link}"
  region        = "${var.region}"
}

#Create the instances
#------------------------
resource "google_compute_instance" "server" {
  name                      = "server0${count.index}"
  machine_type              = "f1-micro"
  allow_stopping_for_update = true
  tags                      = ["vm-tag", "consul"]
  count                     = "${var.server_count}"
  boot_disk {
    initialize_params {
      image = "projects/sup-eng-eu/global/images/packer-1562591073"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet_vm.name}"
    network_ip = "172.31.${var.dc_net}.${count.index + 11}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "kayode:${file("${var.public_key_path}")}"
  }

  metadata_startup_script = "${file("scripts/consul.sh")}"

  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
}

# Create firewall rules
#--------------------------------------

# FW rule to allow all TCP connections in the vpc
# FW rule uses service accounts of all vpc instances
# FW rule uses service accounts for rule target
resource "google_compute_firewall" "allow_internal_consul" {
  name    = "allow-internal-consul"
  network = "${google_compute_network.vpc_demo.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["8600", "8500", "21000-21255", "8300-8302"]
  }
  source_ranges = ["172.31.32.0/22"]
  target_tags   = ["consul"]
}

# FW rule to allow external SSH
resource "google_compute_firewall" "allow_external_ssh" {
  name    = "allow-external-ssh"
  network = "${google_compute_network.vpc_demo.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vm-tag"]
}

resource "google_compute_firewall" "allow_external_https" {
  name    = "allow-external-https"
  network = "${google_compute_network.vpc_demo.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vm-tag"]
}

resource "google_compute_firewall" "allow_external_consul_ui" {
  name    = "allow-external-consul-ui"
  network = "${google_compute_network.vpc_demo.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["8500"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vm-tag"]
}

resource "google_compute_firewall" "allow_vpn_ssh" {
  name    = "allow-vpn-ssh"
  network = "${google_compute_network.vpc_demo.self_link}"
  allow {
    protocol = "all"
  }
  source_ranges = ["${var.remote_cidr}"]
  target_tags   = ["vm-tag"]
}


#VPN CONFIGURATION
#===================================

# Attach a VPN gateway to the VPC.
resource "google_compute_vpn_gateway" "target_gateway" {
  name    = "vpn-gateway"
  network = "${google_compute_network.vpc_demo.self_link}"
  region  = "${var.region}"
}

# Forward IPSec traffic coming into our static IP to our VPN gateway.
resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  region      = "${var.region}"
  ip_protocol = "ESP"
  ip_address  = "${data.google_compute_address.vpn_gw_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
}

# The following two sets of forwarding rules are used as a part of the IPSec
# protocol
resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  region      = "${var.region}"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = "${data.google_compute_address.vpn_gw_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  region      = "${var.region}"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = "${data.google_compute_address.vpn_gw_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
}

# Each tunnel is responsible for encrypting and decrypting traffic exiting
# and leaving its associated gateway
# We will create 2 tunnels to aws on same GCP VPN gateway
resource "google_compute_vpn_tunnel" "tunnel1" {
  name               = "aws-tunnel1"
  region             = "${var.region}"
  peer_ip            = "${data.terraform_remote_state.aws_data.outputs.vpn_connection_tunnel1_address}"
  ike_version        = "1"
  shared_secret      = "${var.preshared_key}"
  target_vpn_gateway = "${google_compute_vpn_gateway.target_gateway.self_link}"

  local_traffic_selector = [
    "${google_compute_subnetwork.subnet_vm.ip_cidr_range}",
    "${google_compute_subnetwork.subnet_vm.ip_cidr_range}"
  ]
  remote_traffic_selector = [
    "${var.remote_cidr}"
  ]

  depends_on = ["google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
    "google_compute_forwarding_rule.fr_esp",
  ]
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name               = "aws-tunnel2"
  region             = "${var.region}"
  peer_ip            = "${data.terraform_remote_state.aws_data.outputs.vpn_connection_tunnel2_address}"
  ike_version        = "1"
  shared_secret      = "${var.preshared_key}"
  target_vpn_gateway = "${google_compute_vpn_gateway.target_gateway.self_link}"

  local_traffic_selector = [
    "${google_compute_subnetwork.subnet_vm.ip_cidr_range}",
    "${google_compute_subnetwork.subnet_vm.ip_cidr_range}"
  ]
  remote_traffic_selector = [
    "${var.remote_cidr}"
  ]

  depends_on = ["google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
    "google_compute_forwarding_rule.fr_esp",
  ]
}

# Create GCE route to AWS network via the VPN tunnel1
# Two routes are created - one for each of the vpn tunnels
# to the 2 AWS headends

# route through tunnel 1 takes precedence with lower priority
resource "google_compute_route" "aws_tunnel1_route" {
  name                = "aws-tunnel1-route"
  dest_range          = "172.31.16.0/22"
  network             = "${google_compute_network.vpc_demo.self_link}"
  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.tunnel1.self_link}"
  priority            = 90
}

resource "google_compute_route" "aws_tunnel2_route" {
  name                = "aws-tunnel2-route"
  dest_range          = "172.31.16.0/22"
  network             = "${google_compute_network.vpc_demo.self_link}"
  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.tunnel2.self_link}"
  priority            = 100
}
