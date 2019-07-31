output "public_ip_gcp" {
  value = "${google_compute_instance.server.*.network_interface.0.access_config.0.nat_ip}"
}

output "private_ip_gcp" {
  value = "${google_compute_instance.server.*.network_interface.0.network_ip}"
}

output "gcp_subnet_id" {
  value = "${google_compute_subnetwork.subnet_vm.*.name}"
}
