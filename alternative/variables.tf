# General vCenter data
# vCenter / ESXi Username
variable "user" {}

# vCenter / ESXi Password
variable "password" {}

# vCenter / ESXi Endpoint
variable "vsphere_server" {}

# vCenter / ESXi Datacenter
variable "datacenter" {}

# vCenter / ESXi Datastore
variable "datastore" {}

# vCenter / ESXi ResourcePool
variable "resource_pool" {}

# Virtual Machine configuration
# VM Name
variable "name" {}

# Name of OVA template (chosen in import process)
variable "template" {}

# VM Network 
variable "network" {}

# VM Number of CPU's
variable "cpus" {}

# VM Memory in MB
variable "memory" {}
# VM numbers
variable "vm_numbers" {}

// The network address for the virtual machines, in the form of 10.0.0.0/24.
variable "virtual_machine_network_address" {
  type = "string"
}

variable "virtual_machine_network_gateway" {
  type = "string"
}

variable "virtual_machine_domain" {
  type = "string"
}

// The last octect that serves as the start of the IP addresses for the virtual
// machines. Given the default value here of 100, if the network address is
// 10.0.0.0/24, the 3 virtual machines will be assigned addresses 10.0.0.100,
// 10.0.0.101, and 10.0.0.102.
variable "virtual_machine_ip_address_start" {
  type = "string"
}

// The DNS servers for the network the virtual machines reside in.
variable "virtual_machine_dns_servers" {
  type = "list"
}
