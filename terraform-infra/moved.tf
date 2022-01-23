moved {
  from = oci_core_network_security_group.leonard
  to   = module.leonard.oci_core_network_security_group.this
}
moved {
  from = oci_core_network_security_group_security_rule.leonard_egress
  to   = module.leonard.oci_core_network_security_group_security_rule.egress
}
moved {
  from = oci_core_network_security_group_security_rule.leonard_ingress_internal
  to   = module.leonard.oci_core_network_security_group_security_rule.ingress_internal
}
moved {
  from = oci_core_network_security_group_security_rule.leonard_ingress
  to   = module.leonard.oci_core_network_security_group_security_rule.ingress
}
moved {
  from = oci_core_instance.leonard
  to   = module.leonard.oci_core_instance.this
}
