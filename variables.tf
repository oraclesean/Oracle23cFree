# Terraform variables
variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {
  default = ""
}
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "private_key_password" {
  default = ""
}
variable "ssh_authorized_keys" {
  default = ""
}

# Infrastructure settings
variable "lab_name" {
  default = "ora23c-free"
}
variable "instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}

# Lab configuration variables
variable "authorized_keys" {
  default = ""
}
variable "container_name" {
  default = "ora23cfree"
}
variable "default_user" {
  default = "opc"
}
variable "docker_group" {
  default = "docker"
}
variable "docker_tns_port" {
  type = number
  default = 11521
}
variable "oracle_gid" {
  type = number
  default = 54321
}
variable "oracle_group" {
  default = "dba"
}
variable "oracle_uid" {
  type = number
  default = 54321
}
variable "oracle_user" {
  default = "oracle"
}
variable "oradata_dir" {
  default = "/oradata"
}
variable "block_volume_name" {
  default     = "Upgrade Volume"
}
variable "block_volume_size" {
  default     = 50
}
variable "bv_attachment_name" {
  default     = "/dev/oracleoci/oraclevdb"
}
variable "bv_attachment_display_name" {
  default     = "lab-bv-attachment"
}
