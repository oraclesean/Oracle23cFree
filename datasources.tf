# Get tenancy details
data "oci_identity_tenancy" "tenant_details" {
  tenancy_id                 = var.tenancy_ocid
}

# List availability domains
data "oci_identity_availability_domains" "ad_list" {
  compartment_id             = oci_identity_compartment.lab_compartment.id
}

data "oci_core_images" "image_list" {
  compartment_id             = oci_identity_compartment.lab_compartment.id
  operating_system           = "Oracle Linux"
  operating_system_version   = "8"
  shape                      = var.instance_shape
  sort_by                    = "TIMECREATED"
}

data template_file "cloud_config" {
  template                   = file("${path.module}/templates/cloud_config.yaml")
  vars                       = {
    container_name             = var.container_name
    default_user               = var.default_user
    docker_group               = var.docker_group
    docker_tns_port            = var.docker_tns_port
    oracle_uid                 = var.oracle_uid
    oracle_user                = var.oracle_user
    oracle_gid                 = var.oracle_gid
    oracle_group               = var.oracle_group
    oradata_dir                = var.oradata_dir
  }
}
