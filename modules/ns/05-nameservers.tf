locals {
    wildcard_ip = "${var.master_ip_list[0]}"
    wildcard_host = "*.${var.public_hostname}"
}

data "template_file" "wildcard_hostname"{
  template = "${file("${path.module}/resources/tpl.json")}"
  vars {
    ips = "${local.wildcard_ip}"
    hosts = "${local.wildcard_host}"
  }
}

data "template_file" "wrapper4" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.wildcard_hostname.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template4" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/ns4.json <<EOL\n${data.template_file.wrapper4.rendered}\nEOL"
  }
}
