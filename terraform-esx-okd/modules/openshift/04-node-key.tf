data "template_file" "node_key" {
  count = "${length(var.node_hostname_list)}"
  template = "${file("${path.module}/resources/node_key.tpl")}"
  vars {
    node_hostname = "${element(var.node_hostname_list, count.index)}"
    domain = "${var.domain}"
  }
}
data "template_file" "node_key_wrapper" {
  template = <<EOL
$${node_list}
EOL
  vars {
    node_list = "${join("", data.template_file.node_key.*.rendered)}"
  }
}

resource "null_resource" "export_node_key_tmp"{
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/node_key.tmp <<EOL\n${data.template_file.node_key_wrapper.rendered}\nEOL"
  }
}
