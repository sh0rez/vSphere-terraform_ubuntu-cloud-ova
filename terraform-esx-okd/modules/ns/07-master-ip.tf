data "template_file" "master_ip"{
  template = "${file("${path.module}/resources/tpl2.json")}"
  vars {
    data = "data"
    hosts = "${var.ns_ip_list[0]}"
  }
}

data "template_file" "wrapper_master_ip" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.master_ip.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template_master_ip" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/nsip.json <<EOL\n${data.template_file.wrapper_master_ip.rendered}\nEOL"
  }
}
