data "terraform_remote_state" "client" {
  backend = "local"

  config = {
    path = "../terraform.tfstate.d/kitchen-terraform-default-terraform/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Terraform <= 0.11
resource "aws_instance" "client" {
  ami                         = "ami-05f215452e3f43edc"
  count                       = 1
  subnet_id                   = "${data.terraform_remote_state.client.outputs.subnet_id_dc1[0]}"
  instance_type               = "${data.terraform_remote_state.client.outputs.instance_type_dc1[0]}"
  private_ip                  = "172.31.16.${count.index + 21}"
  key_name                    = "${data.terraform_remote_state.client.outputs.key_name_dc1[0]}"
  iam_instance_profile        = "${data.terraform_remote_state.client.outputs.aws_iam_instance_profile_dc1[0]}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${data.terraform_remote_state.client.outputs.aws_security_group_virginia[0]}"]

  // consul tag consul = "app" is important for AWS Consul Auto-Join
  tags = {
    Name   = "consul-client0${count.index + 1}"
    consul = "app"
  }

  // Our private key needed for connection to the clients 
  connection {
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = self.public_ip // tf12
  }

  // Copying needed scripts on the instance 
  provisioner "file" {
    source      = "scripts/"
    destination = "/tmp/"
  }

  // This is our provisioning scripts
  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/consul.sh virginia",
      "sudo bash /tmp/kv.sh",
      "sudo bash /tmp/consul-template.sh",
      "sudo bash /tmp/nginx.sh",
      "sudo bash /tmp/dns.sh",
    ]
  }
}

output "public_dns_clients_virginia" {
  value = "${aws_instance.client.*.public_dns}"
}
