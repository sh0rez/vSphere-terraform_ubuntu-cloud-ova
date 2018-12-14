
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
  vm_numbers      = "${var.vm_numbers}"
  password        = "${var.password}"
  datacenter      = "${var.datacenter}"
  network         = "${var.network}"
  virtual_machine_network_address  = "${var.virtual_machine_network_address}"
  virtual_machine_ip_address_start = "${var.virtual_machine_ip_address_start}"
  virtual_machine_network_gateway  = "${var.virtual_machine_network_gateway}"
  virtual_machine_domain           = "${var.virtual_machine_domain}"
}

