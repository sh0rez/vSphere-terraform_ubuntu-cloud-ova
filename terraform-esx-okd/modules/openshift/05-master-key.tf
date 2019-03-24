data "template_file" "master_key" {
  template = "${file("${path.module}/resources/install_key.sh.tpl")}"
  vars {
    master_hostname = "${var.master_hostname}"
    domain = "${var.domain}"
  }
}

resource "null_resource" "export_master_key"{
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/install_key.sh <<EOL\n${data.template_file.master_key.rendered}\nEOL"
  }
}
