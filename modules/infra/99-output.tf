output "dns_server_ip" {
    value = "${join(",", vsphere_virtual_machine.ns.*.default_ip_address)}"
}
output "master_ip" {
    value = "${vsphere_virtual_machine.master.default_ip_address}"
}
output "node_ip" {
    value = "${join(",", vsphere_virtual_machine.node_vm.*.default_ip_address)}"
}

output "ns_ip_list" {
    value = "${vsphere_virtual_machine.ns.*.default_ip_address}"
}

output "master_ip_list" {
    value = "${vsphere_virtual_machine.master.*.default_ip_address}"
}

output "node_ip_list" {
    value = "${vsphere_virtual_machine.node_vm.*.default_ip_address}"
}

output "ns_hostname_list" {
    value = "${vsphere_virtual_machine.ns.*.clone.0.customize.0.linux_options.0.host_name}"
}
output "master_hostname_list" {
    value = "${vsphere_virtual_machine.master.*.clone.0.customize.0.linux_options.0.host_name}"
}
output "node_hostname_list" {
    value = "${vsphere_virtual_machine.node_vm.*.clone.0.customize.0.linux_options.0.host_name}"
}
