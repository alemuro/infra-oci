variable "instance_name" {}
variable "public_key" {}
variable "cpu" {
  type    = number
  default = 4
}
variable "memory" {
  type    = number
  default = 24
}
variable "open_ports" {
  type    = list(string)
  default = []
}
variable "vcn_id" {}
variable "subnet_id" {}
variable "compartment_id" {}
variable "shape" {
  default = "VM.Standard.A1.Flex"
}
