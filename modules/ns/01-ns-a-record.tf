locals {
    ips = "${concat(var.ns_ip_list, var.master_ip_list, var.node_ip_list)}"
    hosts = "${concat(var.ns_hostname_list, var.master_hostname_list,var.node_hostname_list)}"
}

data "template_file" "ns"{
  count = "${length(local.ips)}"
  template = "${file("${path.module}/resources/tpl.json")}"
  vars {
    ips = "${element(local.ips, count.index)}"
    hosts = "${element(local.hosts, count.index)}"
  }
}

data "template_file" "wrapper" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.ns.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/ns-1.json <<EOL\n${data.template_file.wrapper.rendered}\nEOL"
  }
}
