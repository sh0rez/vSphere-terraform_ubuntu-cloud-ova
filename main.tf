
module "infra" {
  source          = "./modules/infra"
  memory          = "${var.memory}"
  cpus            = "${var.cpus}"
  name            = "${var.name}"
  datastore       = "${var.datastore}"
  resource_pool   = "${var.resource_pool}"
  vsphere_server  = "${var.vsphere_server}"
  user            = "${var.user}"
  template_centos = "${var.template_centos}"
  template_ubuntu = "${var.template_ubuntu}"
  vm_numbers      = "${var.nodes}"
  password        = "${var.password}"
  datacenter      = "${var.datacenter}"
  network         = "${var.network}"
  virtual_machine_network_address  = "${var.virtual_machine_network_address}"
  virtual_machine_ip_address_start = "${var.virtual_machine_ip_address_start}"
  virtual_machine_network_gateway  = "${var.virtual_machine_network_gateway}"
  virtual_machine_domain           = "${var.virtual_machine_domain}"
}

module "ns" {
  source                = "./modules/ns"
  ns_ip_list            = "${module.infra.ns_ip_list}"
  ns_hostname_list      = "${module.infra.ns_hostname_list}"
  master_ip_list        = "${module.infra.master_ip_list}"
  master_hostname_list  = "${module.infra.master_hostname_list}"
  node_ip_list          = "${module.infra.node_ip_list}"
  node_hostname_list    = "${module.infra.node_hostname_list}"
  virtual_machine_domain= "${var.virtual_machine_domain}"
  public_hostname       = "${var.name}"
  network_prefix        = "${var.virtual_machine_network}"
}

module "openshift" {
  source                = "./modules/openshift"
  public_hostname       = "${var.name}"
  master_hostname       = "${module.infra.master_hostname_list[0]}"
  master_ip             = "${module.infra.master_ip_list[0]}"
  node_hostname_list    = "${module.infra.node_hostname_list}"
  node_ip_list          = "${module.infra.node_ip_list}"
  domain                = "${var.virtual_machine_domain}"


}

output "dns_server_ip" {
    value = "${module.infra.dns_server_ip}"
}
output "master_ip" {
    value = "${module.infra.master_ip}"
}
output "node_ip" {
    value = "${module.infra.node_ip}"
}
output "console address" {
    value = "https://${var.name}.${var.virtual_machine_domain}:8443"
}
