provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.vsphere_server}"

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template_centos" {
  name          = "${var.template_centos}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template_ubuntu" {
  name          = "${var.template_ubuntu}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "node_vm" {
  count = "${var.vm_numbers}"
  name             = "${var.name}-${count.index+1}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.template_centos.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template_centos.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template_centos.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template_centos.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template_centos.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template_centos.disks.0.thin_provisioned}"
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template_centos.id}"
    customize {
      linux_options {
        host_name = "${var.name}${count.index+1}"
        domain    = "${var.virtual_machine_domain}"
      }

      network_interface {
        ipv4_address = "${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start + count.index+3)}"
        ipv4_netmask = "${element(split("/", var.virtual_machine_network_address), 1)}"
      }

      ipv4_gateway    = "${var.virtual_machine_network_gateway}"
      dns_suffix_list = ["${var.virtual_machine_domain}"]
      dns_server_list = ["${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start+1)}",
                         "${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start+2)}"]
    }
  }
}

resource "vsphere_virtual_machine" "master" {
  count = "1"
  name             = "${var.name}-master"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 16384
  guest_id = "${data.vsphere_virtual_machine.template_centos.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template_centos.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template_centos.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template_centos.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template_centos.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template_centos.disks.0.thin_provisioned}"
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template_centos.id}"
    customize {
      linux_options {
        host_name = "${var.name}master"
        domain    = "${var.virtual_machine_domain}"
      }

      network_interface {
        ipv4_address = "${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start + count.index)}"
        ipv4_netmask = "${element(split("/", var.virtual_machine_network_address), 1)}"
      }

      ipv4_gateway    = "${var.virtual_machine_network_gateway}"
      dns_suffix_list = ["${var.virtual_machine_domain}"]
      dns_server_list = ["${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start+1)}",
                         "${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start+2)}"]
    }
  }
}

resource "vsphere_virtual_machine" "ns" {
  count = "2"
  name             = "${var.name}-ns-${count.index+1}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template_ubuntu.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template_ubuntu.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template_ubuntu.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template_ubuntu.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template_ubuntu.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template_ubuntu.disks.0.thin_provisioned}"
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template_ubuntu.id}"
    customize {
      linux_options {
        host_name = "${var.name}ns${count.index+1}"
        domain    = "localhost"
      }

      network_interface {
        ipv4_address = "${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start + count.index+1)}"
        ipv4_netmask = "${element(split("/", var.virtual_machine_network_address), 1)}"
      }

      ipv4_gateway    = "${var.virtual_machine_network_gateway}"
      dns_server_list = ["8.8.8.8", "8.8.4.4"]
    }
  }
}
