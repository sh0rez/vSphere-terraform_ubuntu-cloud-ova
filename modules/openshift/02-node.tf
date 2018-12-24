data "template_file" "node" {
  count = "${length(var.node_hostname_list)}"
  template = "${file("${path.module}/resources/node.tpl")}"
  vars {
    node_hostname = "${element(var.node_hostname_list, count.index)}"
  }
}
data "template_file" "node_wrapper" {
  template = <<EOL
$${node_list}
EOL
  vars {
    node_list = "${join("", data.template_file.node.*.rendered)}"
  }
}

resource "null_resource" "export_node_tmp"{
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/node.tmp <<EOL\n${data.template_file.node_wrapper.rendered}\nEOL"
  }
}
