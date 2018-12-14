data "template_file" "network"{
  template = "${file("${path.module}/resources/tpl2.json")}"
  vars {
    data = "data"
    hosts = "${var.network_prefix}"
  }
}

data "template_file" "wrapper_network" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.network.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template_network" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/nsnetwork.json <<EOL\n${data.template_file.wrapper_network.rendered}\nEOL"
  }
}
