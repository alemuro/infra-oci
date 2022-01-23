locals {
  compartment_id = var.oracle_tenancy_ocid
  open_ports     = [] # ["22", "80", "443"]
}

variable "oracle_tenancy_ocid" {}
variable "oracle_user_ocid" {}
variable "oracle_private_key" {}
variable "oracle_fingerprint" {}
variable "oracle_region" {}
variable "public_ssh_key" {}
variable "base_domain" {}

provider "oci" {
  tenancy_ocid = var.oracle_tenancy_ocid
  user_ocid    = var.oracle_user_ocid
  private_key  = var.oracle_private_key
  fingerprint  = var.oracle_fingerprint
  region       = var.oracle_region
}

data "cloudflare_zones" "aleix_cloud" {
  filter {
    name        = var.base_domain
    lookup_type = "exact"
    status      = "active"
  }
}

/* Virtual Network */

resource "oci_core_vcn" "main" {
  compartment_id = local.compartment_id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "production"
}

/* Main subnet (regional) */

resource "oci_core_subnet" "main" {
  cidr_block     = "10.0.0.0/24"
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "production"
}

/* Network security list */

resource "oci_core_security_list" "main" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "main"
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "main"
}

resource "oci_core_route_table" "main" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "main"

  route_rules {
    network_entity_id = oci_core_internet_gateway.main.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

/* Instances */

module "leonard" {
  source = "./modules/oci-instance"

  instance_name = "leonard"
  public_key    = var.public_ssh_key
  cpu           = 4
  memory        = 24
  open_ports    = local.open_ports
  subnet_id     = oci_core_subnet.main.id

  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
}

resource "cloudflare_record" "leonard" {
  zone_id = data.cloudflare_zones.aleix_cloud.zones[0].id
  name    = "leonard.sys.${var.base_domain}"
  # value   = module.leonard.public_ip
  value   = "100.97.0.84" # tailscale
  type    = "A"
  ttl     = 300
  proxied = false
}

resource "cloudflare_record" "oci_leonard" {
  zone_id = data.cloudflare_zones.aleix_cloud.zones[0].id
  name    = "*.oci.${var.base_domain}"
  value   = "leonard.sys.${var.base_domain}"
  type    = "CNAME"
  ttl     = 300
  proxied = false
}
