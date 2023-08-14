resource oci_core_instance lab_compute {
  display_name               = "${var.lab_name}-compute"
  compartment_id             = oci_identity_compartment.lab_compartment.id
  availability_domain        = local.availability_domain
  shape                      = var.instance_shape
  metadata                   = {
    ssh_authorized_keys        = var.ssh_authorized_keys
    user_data                  = base64encode(data.template_file.cloud_config.rendered)
  }
  agent_config {
    is_management_disabled     = "false"
    is_monitoring_disabled     = "false"
  }
  create_vnic_details {
    subnet_id                  = oci_core_subnet.lab_subnet_pub.id
    display_name               = "${var.lab_name}-compute-vnic"
    assign_public_ip           = "true"
    private_ip                 = "10.0.0.3"
    skip_source_dest_check     = "false"
  }
  source_details {
    source_id                  = data.oci_core_images.image_list.images.0.id
    source_type                = "image"
  }
}

# Create storage
resource "oci_core_volume" "lab_volume" {
  compartment_id      = oci_identity_compartment.lab_compartment.id
  availability_domain = local.availability_domain
  display_name        = var.block_volume_name
  size_in_gbs         = var.block_volume_size
}

# Attach block volume
resource "oci_core_volume_attachment" "createAttachment" {
    attachment_type = "iscsi" #"paravirtualized"
    instance_id     = oci_core_instance.lab_compute.id
    volume_id       = oci_core_volume.lab_volume.id
    device          = var.bv_attachment_name
    display_name    = var.bv_attachment_display_name

    connection {
      type        = "ssh"
      host        = oci_core_instance.lab_compute.*.public_ip
      #host        = data.oci_core_vnic.lab_vnic1.public_ip_address
      agent       = false
      timeout     = "3m"
      user        = "opc"
      private_key = local.private_key
    }

    # register and connect the iSCSI block volume
    provisioner "remote-exec" {
      inline = [
        "sudo iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}",
        "sudo iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic",
        "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l",
      ]
    }

    # initialize partition and file system and mount the partition
    provisioner "remote-exec" {
      inline = [
        "set -x",
        "export DEVICE_ID=$(ls /dev/disk/by-path/ip-${self.ipv4}:${self.port}-iscsi-${self.iqn}-lun-*)",
        "export HAS_PARTITION=$(sudo partprobe -d -s $${DEVICE_ID} | wc -l)",
        "if [ $HAS_PARTITION -eq 0 ] ; then",
        "  (echo g; echo n; echo ''; echo ''; echo ''; echo w) | sudo fdisk $${DEVICE_ID}",
        "  while [[ ! -e $${DEVICE_ID}-part1 ]] ; do sleep 1; done",
        "  sudo mkfs.xfs $${DEVICE_ID}-part1",
        "fi",
        "sudo mkdir -p /oradata",
        "export UUID=$(sudo /usr/sbin/blkid -s UUID -o value $${DEVICE_ID}-part1)",
        "echo 'UUID='$${UUID}' /oradata xfs defaults,_netdev,nofail 0 2' | sudo tee -a /etc/fstab",
        "sudo mount -a",
      ]
    }
}
