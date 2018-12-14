output "dns_server_ip" {
    value = "${join(",", vsphere_virtual_machine.ns.*.default_ip_address)}"
}
output "master_ip" {
    value = "${vsphere_virtual_machine.master.default_ip_address}"
}
output "node_ip" {
    value = "${join(",", vsphere_virtual_machine.node_vm.*.default_ip_address)}"
}
output "k8s account" {
    value = "root"
}
output "k8s password" {
    value = "abc=123"
}
