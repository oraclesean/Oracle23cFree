resource oci_core_security_list lab_pub_subnet_sl {
  display_name               = "${var.lab_name}-sn-public-sl"
  compartment_id             = oci_identity_compartment.lab_compartment.id
  vcn_id                     = oci_core_vcn.lab_vcn.id
  egress_security_rules {
    destination                = "0.0.0.0/0"
    destination_type           = "CIDR_BLOCK"
    protocol                   = "all"
    stateless                  = "false"
  }
  ingress_security_rules {
    protocol                   = "1"
    source                     = "0.0.0.0/0"
    source_type                = "CIDR_BLOCK"
    stateless                  = "false"
    icmp_options {
      code                       = "4"
      type                       = "3"
    }
  }
  ingress_security_rules {
    protocol                   = "1"
    source                     = "10.0.0.0/16"
    source_type                = "CIDR_BLOCK"
    stateless                  = "false"
    icmp_options {
      code                       = "-1"
      type                       = "3"
    }
  }
  ingress_security_rules {
    protocol                   = "6"
    source                     = "0.0.0.0/0"
    source_type                = "CIDR_BLOCK"
    stateless                  = "false"
    tcp_options {
      max                        = "22"
      min                        = "22"
    }
  }
  ingress_security_rules {
    protocol                   = "6"
    source                     = "0.0.0.0/0"
    source_type                = "CIDR_BLOCK"
    stateless                  = "false"
    tcp_options {
      max                        = var.docker_tns_port
      min                        = var.docker_tns_port
    }
  }
}

resource oci_core_security_list lab_prv_subnet_sl {
  display_name               = "${var.lab_name}-sn-private-sl"
  compartment_id             = oci_identity_compartment.lab_compartment.id
  vcn_id                     = oci_core_vcn.lab_vcn.id
  egress_security_rules {
    destination                = "0.0.0.0/0"
    destination_type           = "CIDR_BLOCK"
    protocol                   = "all"
    stateless                  = "false"
  }
  ingress_security_rules {
    protocol                   = "1"
    source                     = "0.0.0.0/0"
    source_type                = "CIDR_BLOCK"
    stateless                  = "false"
    icmp_options {
      code                       = "4"
      type                       = "3"
    }
  }
  ingress_security_rules {
    protocol                   = "6"
    source                     = "10.0.0.0/16"
    source_type                = "CIDR_BLOCK"
    stateless                  = "false"
    tcp_options {
      max                        = "22"
      min                        = "22"
    }
  }
  ingress_security_rules {
    protocol                   = "1"
    source                     = "10.0.0.0/16"
    source_type                = "CIDR_BLOCK"
    stateless                  = "false"
    icmp_options {
      code                       = "-1"
      type                       = "3"
    }
  }
}

resource oci_core_default_security_list lab_vcn_sl {
  display_name               = "${var.lab_name}-vcn-sl"
  compartment_id             = oci_identity_compartment.lab_compartment.id
  manage_default_resource_id = oci_core_vcn.lab_vcn.default_security_list_id
}
