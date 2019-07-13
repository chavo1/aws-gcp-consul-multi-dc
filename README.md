# This repo contains a simple example of Consul cluster in Multi-DC - Multi-Cloud Deployment with AWS client VPN (with mutual authentication) for secure connection to the both DCs.

<img src="screenshot/aws_gcp.jpg" width="754" height="750" />

## AWS VPC

### [This module](https://github.com/chavo1/aws-vpc-terraform) will create VPC in AWS region "us-east-1"

## AWS Client VPN

### [This module](https://github.com/chavo1/client-vpn-aws-terraform) will create AWS Client VPN

## AWS EC2 (Consul servers)

### [This module](https://github.com/chavo1/aws-consul-terraform-multi-region) will create a needed number of Consul server

## AWS IPsec VPN
### [This module](https://cloud.google.com/) will create a VPN connection between AWS and GCP.
- You must add "GCP External IP address - Reserved static address" into the *.tfvars, please check the example.tfvars

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS Account](https://aws.amazon.com/account/)
- Basic [Consul](https://www.consul.io/) knowledge
- [GCP Account](https://aws.amazon.com/account/)

### Prepare you own AWS AMIs with [Packer](https://www.packer.io/)
- AWS [PACKER-CONSUL-SERVER](https://github.com/chavo1/packer-consul-server)
- AWS [PACKER-CONSUL-CLIENT](https://github.com/chavo1/packer-consul-client)

### Prepare you own GCP Image with [Packer](https://www.packer.io/)
- GCP [PACKER-CONSUL-SERVER](https://github.com/chavo1/packer-consul-server-gcp)

### Clone the repo
```
git clone https://github.com/chavo1/aws-gcp-consul-multi-dc.git
cd aws-gcp-consul-multi-dc
terraform init
terraform apply
```
- After the deployment Terraform will generate a file into the root directory "config-cvpn.ovpn". So you can use it to connect to the environment in both DCs with [AWS Client VPN](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/what-is.html). 
- VPN client depend on your choice, in my case I use [tunnelblick](https://tunnelblick.net/).
## AWS EC2 (Consul clients) deployment.

### After deploying the Infra and Consul servers is time for Consul clients.
  - | To spin up the client agents we use [Terraform Local Backend](https://www.terraform.io/docs/backends/types/local.html#example-reference) - we just reference the data. 

#### Go to the consul_client_dc1, setup a needed count for the clients in the main.tf file.
```
terraform init
terraform apply 
```
## We can continue with Consul - GCP deployment.
- Go to the "gcp-aws-vpn-servers"
```
terraform init
terraform apply 
```
