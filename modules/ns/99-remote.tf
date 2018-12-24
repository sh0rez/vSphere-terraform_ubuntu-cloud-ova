resource "null_resource" "master"{
  provisioner "file"{
    source  = "${path.module}/resources"
    destination = "~/"
  }
  provisioner "remote-exec"{
    inline = [
      "chmod +x resources/install_ansible.sh",
      "bash -x resources/install_ansible.sh",
      "sleep 1",
      "chmod +x resources/install_ns.sh",
      "bash -x resources/install_ns.sh",
      "sleep 1",
    ]
  }
  connection {
    type = "ssh"
    user = "elsvent"
    password = "password"
    host = "${var.ns_ip_list[0]}"
  }
}

