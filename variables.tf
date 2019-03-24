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
