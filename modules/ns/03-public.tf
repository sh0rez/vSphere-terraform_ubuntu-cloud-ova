locals {
    public_ip = "${var.master_ip_list[0]}"
    public_host = "${var.public_hostname}"
}

data "template_file" "public_hostname"{
  template = "${file("${path.module}/resources/tpl.json")}"
  vars {
    ips = "${local.public_ip}"
    hosts = "${local.public_host}"
  }
}

data "template_file" "wrapper3" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.public_hostname.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template3" {
  provisioner "local-exec" {
    command = "cat > ${path.module}/resources/ns3.json <<EOL\n${data.template_file.wrapper3.rendered}\nEOL"
  }
}
