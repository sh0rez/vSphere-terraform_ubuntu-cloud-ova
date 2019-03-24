data "template_file" "ns_domain"{
  template = "${file("${path.module}/resources/tpl2.json")}"
  vars {
    data = "data"
    hosts = "${var.virtual_machine_domain}"
  }
}

data "template_file" "wrapper_domain" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.ns_domain.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template_ns_domain" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/nsdomain.json <<EOL\n${data.template_file.wrapper_domain.rendered}\nEOL"
  }
}
