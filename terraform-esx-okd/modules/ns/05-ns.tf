locals {
    ns_hosts = "${var.ns_hostname_list}"
}

data "template_file" "ns_host"{
  count = "${length(local.ns_hosts)}"
  template = "${file("${path.module}/resources/tpl2.json")}"
  vars {
    data = "data"
    hosts = "${element(local.ns_hosts, count.index)}"
  }
}

data "template_file" "wrapper_ns" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.ns_host.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template_ns" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/nshosts.json <<EOL\n${data.template_file.wrapper_ns.rendered}\nEOL"
  }
}
