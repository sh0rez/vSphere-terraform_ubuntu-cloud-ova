variable public_hostname{}

variable master_hostname{}

variable master_ip{}

variable node_hostname_list{
  type = "list"
}

variable node_ip_list{
  type = "list"
}

variable node_substring {
  default = "openshift_node_group_name='node-config-compute'"
}
variable domain {}
