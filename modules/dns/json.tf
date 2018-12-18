locals {
  ips = "${vsphere_virtual_machine.ns.*.default_ip_address}"
  name = "${vsphere_virtual_machine.ns.*.clone.0.customize.0.linux_options.0.host_name}"
}
output "test"{
  value = "${local.ips}"
}
data "template_file" "test"{
  count = "${length(local.ips)}"
  template = "${file("./tpl.json")}"
  vars {
    kips = "${element(local.ips, count.index)}"
    khost = "${element(local.name, count.index)}"
  }
}

data "template_file" "wrapper" {
  template = <<JSON
[
  $${ip_list}
]
JSON
  vars {
    ip_list = "${join(",\n", data.template_file.test.*.rendered)}"
  }
}

resource "null_resource" "export_rendered_template" {
  provisioner "local-exec" {
    command = "cat > test_output.json <<EOL\n${data.template_file.wrapper.rendered}\nEOL"
  }
}
