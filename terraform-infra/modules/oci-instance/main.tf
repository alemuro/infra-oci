data "oci_core_images" "ubuntu" {
  compartment_id = var.compartment_id

  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
  shape                    = var.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_network_security_group" "this" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "leonard"
}

resource "oci_core_network_security_group_security_rule" "egress" {
  network_security_group_id = oci_core_network_security_group.this.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination_type          = "CIDR_BLOCK"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "ingress_internal" {
  network_security_group_id = oci_core_network_security_group.this.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source_type               = "CIDR_BLOCK"
  source                    = "10.0.0.0/24"
}

resource "oci_core_network_security_group_security_rule" "ingress" {
  for_each = toset(var.open_ports)

  network_security_group_id = oci_core_network_security_group.this.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      max = tonumber(each.key)
      min = tonumber(each.key)
    }
  }
}

resource "oci_core_instance" "this" {
  availability_domain = "huoP:EU-MARSEILLE-1-AD-1"
  compartment_id      = var.compartment_id
  shape               = var.shape
  display_name        = "leonard"

  create_vnic_details {
    subnet_id = var.subnet_id
    nsg_ids   = [oci_core_network_security_group.this.id]
  }

  shape_config {
    ocpus         = var.cpu
    memory_in_gbs = var.memory
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.public_key
  }
}
