# Setting version 
terraform {
  required_version = "~> 0.12.0"
}
# Referencing data
data "terraform_remote_state" "client" {
  backend = "local"

  config = {
    path = "../gcp-aws-vpn-servers/terraform.tfstate"
  }
}
# Setting the provider
provider "google" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  zone        = "${var.region_zone}"
}
#Create the instances
#------------------------
resource "google_compute_instance" "client" {
  name                      = "client0${count.index}"
  machine_type              = "f1-micro"
  allow_stopping_for_update = true
  tags                      = ["vm-tag", "consul"]
  count                     = 1
  boot_disk {
    initialize_params {
      image = "projects/sup-eng-eu/global/images/packer-1563530504"
    }
  }

  network_interface {
    subnetwork = "${data.terraform_remote_state.client.outputs.gcp_subnet_id[0]}"
    network_ip = "172.31.32.${count.index + 21}"
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
  // Copying needed scripts on the instance 
  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "chavdar.rakov"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = self.network_interface[0].access_config[0].nat_ip // tf12
    }
    source      = "scripts/"
    destination = "/tmp/"
  }

  // This is our provisioning scripts
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "chavdar.rakov"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = self.network_interface[0].access_config[0].nat_ip // tf12
    }
    inline = [
      "sudo bash /tmp/consul.sh gcp_virginia",
      "sudo bash /tmp/kv.sh",
      "sudo bash /tmp/consul-template.sh",
      "sudo bash /tmp/nginx.sh",
      "sudo bash /tmp/dns.sh",
    ]
  }
}
