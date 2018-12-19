data "vsphere_virtual_machine" "template_centos" {
  name          = "${var.template_centos}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template_ubuntu" {
  name          = "${var.template_ubuntu}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
