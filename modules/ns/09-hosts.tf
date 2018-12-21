data "template_file" "hosts_master"{
  template = "${file("${path.module}/resources/hosts.tpl")}"
  vars {
    dummy = "${var.ns_ip_list[0]}"
  }
}

resource "null_resource" "export_rendered_template_hosts_master" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/hosts.master <<EOL\n${data.template_file.hosts_master.rendered}\nEOL"
  }
}
