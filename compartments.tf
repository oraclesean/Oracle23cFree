resource "oci_identity_compartment" "lab_compartment" {
  name                       = "${var.lab_name}-compartment"
  description                = "Compartment for ${var.lab_name} resources"
  compartment_id             = var.tenancy_ocid
}
