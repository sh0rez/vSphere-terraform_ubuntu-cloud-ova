data "template_file" "install_ansible"{
  template = "${file("${path.module}/resources/install_ansible.sh.tpl")}"
  vars {
    ns1 = "${var.ns_ip_list[0]}"
    ns2 = "${var.ns_ip_list[1]}"
  }
}

resource "null_resource" "export_rendered_template_install_ansible" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/install_ansible.sh<<EOL\n${data.template_file.install_ansible.rendered}\nEOL"
  }
}
