variable "region" {
  default = "us-east4"
}

variable "region_zone" {
  default = "us-east4-a"
}

variable "project_name" {
  default = "sup-eng-eu"
}

variable "credentials_file_path" {
  default = "account.json"
}
variable "dc_net" {
  default = 32
}
variable "server_count" {
  default = 2
}
variable "public_key_path" {
  description = "Path to SSH public key to be attached to cloud instances"
  default     = "~/.ssh/id_rsa.pub"
}

variable "source_service_accounts" {
  description = "GCE service account"
  default     = "service-account-owner@sup-eng-eu.iam.gserviceaccount.com"
}

variable "preshared_key" {
  description = "preshaed key used for tunnels 1 and 2"
  default     = "preshared_key"
}

variable "remote_cidr" {
  description = "remote cidr ranges"
  default     = "172.31.16.0/22"
}
