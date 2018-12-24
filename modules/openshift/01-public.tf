data "template_file" "hostname" {
  template = "${file("${path.module}/resources/inventory.tpl")}"
  vars {
    public_hostname = "${var.public_hostname}"
    master_hostname = "${var.master_hostname}"
  }
}

resource "null_resource" "export_hostname_inventory"{
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/inventory.ini <<EOL\n${data.template_file.hostname.rendered}\nEOL"
  }
}
