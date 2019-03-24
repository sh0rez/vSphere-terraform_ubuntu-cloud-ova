locals {
    at_ips = "${var.ns_ip_list[0]}"
    at_hosts = "@"
}

data "template_file" "ns_at"{
  template = "${file("${path.module}/resources/tpl.json")}"
  vars {
    ips = "${local.at_ips}"
    hosts = "${local.at_hosts}"
  }
}

data "template_file" "wrapper2" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.ns_at.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template2" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/ns-2.json <<EOL\n${data.template_file.wrapper2.rendered}\nEOL"
  }
}
